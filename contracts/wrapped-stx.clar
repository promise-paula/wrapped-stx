;; title: wrapped-stx
;; version:
;; summary:
;; description:

;; Music Royalty Distribution Smart Contract

(define-constant ERR-UNAUTHORIZED-ACCESS (err u100))
(define-constant ERR-INVALID-ROYALTY-PERCENTAGE (err u101))
(define-constant ERR-DUPLICATE-SONG-ENTRY (err u102))
(define-constant ERR-SONG-NOT-FOUND (err u103))
(define-constant ERR-INSUFFICIENT-PAYMENT (err u104))
(define-constant ERR-INVALID-RECIPIENT (err u105))
(define-constant ERR-PAYMENT-DISTRIBUTION-FAILED (err u106))
(define-constant ERR-INVALID-STRING-LENGTH (err u107))
(define-constant ERR-INVALID-SONG-TITLE (err u108))
(define-constant ERR-INVALID-PARTICIPANT-ROLE (err u109))
(define-constant ERR-INVALID-ARTIST (err u110))
(define-constant ERR-INVALID-ADMIN (err u111))

;; Data Structures for Music Rights Management
(define-map music-catalog
  { song-id: uint }
  {
    title: (string-ascii 50),
    primary-artist: principal,
    total-revenue: uint,
    release-date: uint,
    is-active: bool,
  }
)

(define-map royalty-allocations
  {
    song-id: uint,
    rights-holder: principal,
  }
  {
    percentage: uint,
    role: (string-ascii 20),
    earned-royalties: uint,
  }
)

;; Contract State Variables
(define-data-var total-registered-tracks uint u0)
(define-data-var contract-owner principal tx-sender)

;; Validation Helpers
(define-private (is-valid-royalty-share (share {
  percentage: uint,
  role: (string-ascii 20),
  earned-royalties: uint,
}))
  (> (get percentage share) u0)
)

(define-private (is-contract-owner)
  (is-eq tx-sender (var-get contract-owner))
)

(define-private (validate-royalty-percentage (percentage uint))
  (and (>= percentage u0) (<= percentage u100))
)

(define-private (validate-ascii-string (input (string-ascii 50)))
  (let ((length (len input)))
    (and (> length u0) (<= length u50))
  )
)

(define-private (validate-participant-role (role (string-ascii 20)))
  (let ((length (len role)))
    (and (> length u0) (<= length u20))
  )
)

(define-private (validate-rights-holder (holder principal))
  (and
    (not (is-eq holder tx-sender))
    (not (is-eq holder (var-get contract-owner)))
  )
)

;; Read-Only Query Functions
(define-read-only (get-track-details (song-id uint))
  (map-get? music-catalog { song-id: song-id })
)

(define-read-only (get-royalty-details
    (song-id uint)
    (rights-holder principal)
  )
  (map-get? royalty-allocations {
    song-id: song-id,
    rights-holder: rights-holder,
  })
)

(define-read-only (get-total-tracks)
  (var-get total-registered-tracks)
)

(define-read-only (get-track-royalty-shares (song-id uint))
  (let (
      (track-info (get-track-details song-id))
      (primary-artist (match track-info
        record (get primary-artist record)
        tx-sender
      ))
    )
    (let ((distribution (get-royalty-details song-id primary-artist)))
      (match distribution
        share (list {
          rights-holder: primary-artist,
          percentage: (get percentage share),
        })
        (list)
      )
    )
  )
)