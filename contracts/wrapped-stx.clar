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