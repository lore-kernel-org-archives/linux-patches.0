Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE4429E100
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 11:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750849920; cv=none; b=rphMVtLRAEdyowApIfkEsyy2nmhmz+LNyzGpopVuDdnIZLWtHDstRz3KHAgo6VncHnX76IcgH5dqniqLSEpgr2Mi+ABFVPs6m9wwL4U2j33+qbPjGbrTCXUfkVzyUWrTFe3E6xdP3TRECV/5TM9t8DPHsQwqRM1mAg30QSqYJC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750849920; c=relaxed/simple;
	bh=jHR0bPaYIi58VgUeOdBsTdTI1oZUfYjXFb+y4BCL5Nk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Kk+eeucAUcjOvY29uxLwMuBkOEIrKbGh/k7glhW6Kwp2aUhWCqr/BER0kdMYN1DSEihGWwdxosM4Ru1Dvciii8okCbpG5BXf+pydboR2K0QvUiYlANp1u6WavgjsJi0qsQlra3VGC50Qb1XG/yfL8K2aN7yzpL8XFRITXlyUJr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DOdJoRWh; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DOdJoRWh"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-748e81d37a7so783454b3a.1
        for <patches@lists.linux.dev>; Wed, 25 Jun 2025 04:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750849917; x=1751454717; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=L2SqXIiCaVImBouPqYt5Pcr5G1n4XvOv6tRKQ2x6qxk=;
        b=DOdJoRWhfSCgigwvxm300hiPHqfzuDtcZIdTKWN4/bM+Po+hDR4/fQZ9X8RBCzsVq2
         bxmjTPhx5x4gsoaoH4VPqja1+17y7lvJoVOnwo26G/ZyRQF55uDoqgFayE1MJPBFlE64
         IjRpam1BLh9i/+WpWN5y+7b1itNWHM3O5PJMW3yiZw+RLR7TpZqmBkJ7MuiyAjXMAyCo
         1/Hx9soHFIzug6/86idtYVGvsbGB5nEPM+oQXV5UIZ50orBPvWiHxgr0H/0ZcIE8bN32
         Kb5oqhuCZGy8J9R8mHkmHFUynd8oIlvcLEHeWcGAI1QE1u7yq78dTj4gMKvUt54uAaLv
         jt0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750849917; x=1751454717;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L2SqXIiCaVImBouPqYt5Pcr5G1n4XvOv6tRKQ2x6qxk=;
        b=MwY0Le0VXR1/f8rV83G0mZethwboZZLFcJMppczuflD5kZL/TSWmLH5FR6mZstdsFK
         xA1UvKI6SITSChtE7jtCRHb4E5oy6QRnCAmuFddEWxoRBZwtn8q8iNTTtCHgcbZDoByB
         ADgHSyksyc16GIMd1860aJjFxSgWBAwZDJMPVilXs0etRk6sujNvygLFgPnTHAzhl3zl
         NPeeQnYguatXyvlpj8K5R6gtDCf9NTTlPeMtNL/UPfnigYLNWmgnxrcb739WmxWRQ/pi
         k62WY4ts0mImIhAiA1Ss8u1rwsx9mzf9lGryqIyCB+43QRHUe97PQEg9mdzOm+UVC0Mb
         m4FQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhtvEk+TJoNHj9d23zgJq/zPlcaGf9WEI6VuK1KetaraA2iqlzkkGWOoj7AAZIE1agT0DQBBZm@lists.linux.dev
X-Gm-Message-State: AOJu0YwYpST5fz4T8jjUXHUzxr/YzrDDotRjheI+yLW0pSgCMjUd+pMk
	zIRzVSguRa9LrIJOvw7g/GghDQPx53lBy/oGAqekwwK+Oj0JP8LdhFHw
X-Gm-Gg: ASbGncsyBXHd7SYj/QwsNBVc+CYQtvDlqV3bfooNYpPY6/iOpeWGRJZpC+Oiort2gRv
	YoFBihha1nxooRs4Az1kYdnMcDtnp/J//WwXg2h6iSRFwL5jwSAqHTfwaa8Khw3P3HYbbnOXajA
	mOD16RiEjnpYuyP3BjIuOkvft9O5WSj+JNUvjV/8vNHJ4xgOiQIL5m9kETRKkYPBEcPj43dSzVR
	14Q2cKf9SmDguAwtxRcePUI3Q2eT4avapOw9eQcLSXU40rNVONCy16Y/qP/jqpF4tABK5pVQ04j
	G4IutA+G7nZh7TyY8YPUxeIvMqnRFg1/mX+SilQQG+XXXgi6kJ11MYnUiMFln8mC+LQzLs7sci0
	IVJ+R
X-Google-Smtp-Source: AGHT+IEt9pRkhmBu+/7O4yXM8DWTP8mMPoKirlHTiHDNGGoTSyB/gIGQ3q9P82PCR7W0FP9OSQNOQA==
X-Received: by 2002:a05:6a20:748f:b0:220:105b:46dd with SMTP id adf61e73a8af0-2207f2fb655mr4957531637.36.1750849917189;
        Wed, 25 Jun 2025 04:11:57 -0700 (PDT)
Received: from shankari-IdeaPad.. ([2409:4080:10:4ef8:7bae:5763:c10a:8810])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34aabc3842sm2561417a12.50.2025.06.25.04.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 04:11:56 -0700 (PDT)
From: Shankari Anand <shankari.ak0208@gmail.com>
To: linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	patches@lists.linux.dev
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Shankari Anand <shankari.ak0208@gmail.com>
Subject: [PATCH v2 1/2] rust: move ARef and AlwaysRefCounted to sync::aref
Date: Wed, 25 Jun 2025 16:41:32 +0530
Message-Id: <20250625111133.698481-1-shankari.ak0208@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Move the definitions of `ARef` and `AlwaysRefCounted` from `types.rs`
to a new file `sync/aref.rs`.
Define the corresponding `aref` module under `rust/kernel/sync.rs`.
These types are better grouped in `sync`.

To avoid breaking existing imports, they are re-exported from `types.rs`.
Drop unused imports `mem::ManuallyDrop`, `ptr::NonNull` from `types.rs`,
they are now only used in `sync/aref.rs`, where they are already imported.

Suggested-by: Benno Lossin <lossin@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/1173
Signed-off-by: Shankari Anand <shankari.ak0208@gmail.com>
---
v1 -> v2 : Added git base commit id
Rebased the repository to the recent HEAD in the rust-next. Solved the conflict (a commit adding a module to sync.rs).
Changed the in-file reference of {ARef, AlwaysRefCounted}. Rest remains unchanged.
---
 rust/kernel/sync.rs      |   1 +
 rust/kernel/sync/aref.rs | 170 +++++++++++++++++++++++++++++++++++++++
 rust/kernel/types.rs     | 154 +----------------------------------
 3 files changed, 174 insertions(+), 151 deletions(-)
 create mode 100644 rust/kernel/sync/aref.rs

diff --git a/rust/kernel/sync.rs b/rust/kernel/sync.rs
index 63c99e015ad6..8fd126788e02 100644
--- a/rust/kernel/sync.rs
+++ b/rust/kernel/sync.rs
@@ -10,6 +10,7 @@
 use pin_init;
 
 mod arc;
+pub mod aref;
 pub mod completion;
 mod condvar;
 pub mod lock;
diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
new file mode 100644
index 000000000000..93a23b493e21
--- /dev/null
+++ b/rust/kernel/sync/aref.rs
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Atomic reference-counted pointer abstraction.
+//!
+//! This module provides [`ARef<T>`], an owned reference to a value that implements
+//! [`AlwaysRefCounted`] — an unsafe trait for types that manage their own reference count.
+//!
+//! It is based on the Linux kernel's manual reference counting model and is typically used
+//! with C types that implement reference counting (e.g., via `refcount_t` or `kref`).
+//!
+//! For Rust-managed objects, prefer using [`Arc`](crate::sync::Arc) instead.
+
+use core::{
+    marker::PhantomData,
+    mem::ManuallyDrop,
+    ops::Deref,
+    ptr::NonNull,
+};
+
+/// Trait for types that are _always_ reference-counted.
+///
+/// This trait allows types to define custom reference increment and decrement logic.
+/// It enables safe conversion from a shared reference `&T` to an owned [`ARef<T>`].
+///
+/// This is usually implemented by wrappers around C types with manual refcounting.
+///
+/// For purely Rust-managed memory, consider using [`Arc`](crate::sync::Arc) instead.
+///
+/// # Safety
+///
+/// Implementers must ensure that:
+///
+/// - Calling [`AlwaysRefCounted::inc_ref`] keeps the object alive in memory until a matching [`AlwaysRefCounted::dec_ref`] is called.
+/// - The object is always managed by a reference count; it must never be stack-allocated or
+///   otherwise untracked.
+/// - When the count reaches zero in [`AlwaysRefCounted::dec_ref`], the object is properly freed and no further
+///   access occurs.
+///
+/// Failure to follow these rules may lead to use-after-free or memory corruption.
+
+pub unsafe trait AlwaysRefCounted {
+    /// Increments the reference count on the object.
+    fn inc_ref(&self);
+
+    /// Decrements the reference count on the object.
+    ///
+    /// Frees the object when the count reaches zero.
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that there was a previous matching increment to the reference count,
+    /// and that the object is no longer used after its reference count is decremented (as it may
+    /// result in the object being freed), unless the caller owns another increment on the refcount
+    /// (e.g., it calls [`AlwaysRefCounted::inc_ref`] twice, then calls
+    /// [`AlwaysRefCounted::dec_ref`] once).
+    unsafe fn dec_ref(obj: NonNull<Self>);
+}
+
+/// An owned reference to an always-reference-counted object.
+///
+/// The object's reference count is automatically decremented when an instance of [`ARef`] is
+/// dropped. It is also automatically incremented when a new instance is created via
+/// [`ARef::clone`].
+///
+/// # Invariants
+///
+/// The pointer stored in `ptr` is non-null and valid for the lifetime of the [`ARef`] instance. In
+/// particular, the [`ARef`] instance owns an increment on the underlying object's reference count.
+pub struct ARef<T: AlwaysRefCounted> {
+    ptr: NonNull<T>,
+    _p: PhantomData<T>,
+}
+
+// SAFETY: It is safe to send `ARef<T>` to another thread when the underlying `T` is `Sync` because
+// it effectively means sharing `&T` (which is safe because `T` is `Sync`); additionally, it needs
+// `T` to be `Send` because any thread that has an `ARef<T>` may ultimately access `T` using a
+// mutable reference, for example, when the reference count reaches zero and `T` is dropped.
+unsafe impl<T: AlwaysRefCounted + Sync + Send> Send for ARef<T> {}
+
+// SAFETY: It is safe to send `&ARef<T>` to another thread when the underlying `T` is `Sync`
+// because it effectively means sharing `&T` (which is safe because `T` is `Sync`); additionally,
+// it needs `T` to be `Send` because any thread that has a `&ARef<T>` may clone it and get an
+// `ARef<T>` on that thread, so the thread may ultimately access `T` using a mutable reference, for
+// example, when the reference count reaches zero and `T` is dropped.
+unsafe impl<T: AlwaysRefCounted + Sync + Send> Sync for ARef<T> {}
+
+impl<T: AlwaysRefCounted> ARef<T> {
+    /// Creates a new instance of [`ARef`].
+    ///
+    /// It takes over an increment of the reference count on the underlying object.
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that the reference count was incremented at least once, and that they
+    /// are properly relinquishing one increment. That is, if there is only one increment, callers
+    /// must not use the underlying object anymore -- it is only safe to do so via the newly
+    /// created [`ARef`].
+    pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
+        // INVARIANT: The safety requirements guarantee that the new instance now owns the
+        // increment on the refcount.
+        Self {
+            ptr,
+            _p: PhantomData,
+        }
+    }
+
+    /// Consumes the `ARef`, returning a raw pointer.
+    ///
+    /// This function does not change the refcount. After calling this function, the caller is
+    /// responsible for the refcount previously managed by the `ARef`.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// use core::ptr::NonNull;
+    /// use kernel::sync::aref::{ARef, AlwaysRefCounted};
+    ///
+    /// struct Empty {}
+    ///
+    /// # // SAFETY: TODO.
+    /// unsafe impl AlwaysRefCounted for Empty {
+    ///     fn inc_ref(&self) {}
+    ///     unsafe fn dec_ref(_obj: NonNull<Self>) {}
+    /// }
+    ///
+    /// let mut data = Empty {};
+    /// let ptr = NonNull::<Empty>::new(&mut data).unwrap();
+    /// # // SAFETY: TODO.
+    /// let data_ref: ARef<Empty> = unsafe { ARef::from_raw(ptr) };
+    /// let raw_ptr: NonNull<Empty> = ARef::into_raw(data_ref);
+    ///
+    /// assert_eq!(ptr, raw_ptr);
+    /// ```
+    pub fn into_raw(me: Self) -> NonNull<T> {
+        ManuallyDrop::new(me).ptr
+    }
+}
+
+impl<T: AlwaysRefCounted> Clone for ARef<T> {
+    fn clone(&self) -> Self {
+        self.inc_ref();
+        // SAFETY: We just incremented the refcount above.
+        unsafe { Self::from_raw(self.ptr) }
+    }
+}
+
+impl<T: AlwaysRefCounted> Deref for ARef<T> {
+    type Target = T;
+
+    fn deref(&self) -> &Self::Target {
+        // SAFETY: The type invariants guarantee that the object is valid.
+        unsafe { self.ptr.as_ref() }
+    }
+}
+
+impl<T: AlwaysRefCounted> From<&T> for ARef<T> {
+    fn from(b: &T) -> Self {
+        b.inc_ref();
+        // SAFETY: We just incremented the refcount above.
+        unsafe { Self::from_raw(NonNull::from(b)) }
+    }
+}
+
+impl<T: AlwaysRefCounted> Drop for ARef<T> {
+    fn drop(&mut self) {
+        // SAFETY: The type invariants guarantee that the `ARef` owns the reference we're about to
+        // decrement.
+        unsafe { T::dec_ref(self.ptr) };
+    }
+}
diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
index 22985b6f6982..60cb48285630 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -5,12 +5,13 @@
 use core::{
     cell::UnsafeCell,
     marker::{PhantomData, PhantomPinned},
-    mem::{ManuallyDrop, MaybeUninit},
+    mem::MaybeUninit,
     ops::{Deref, DerefMut},
-    ptr::NonNull,
 };
 use pin_init::{PinInit, Zeroable};
 
+pub use crate::sync::aref::{ARef, AlwaysRefCounted};
+
 /// Used to transfer ownership to and from foreign (non-Rust) languages.
 ///
 /// Ownership is transferred from Rust to a foreign language by calling [`Self::into_foreign`] and
@@ -415,155 +416,6 @@ pub const fn raw_get(this: *const Self) -> *mut T {
     }
 }
 
-/// Types that are _always_ reference counted.
-///
-/// It allows such types to define their own custom ref increment and decrement functions.
-/// Additionally, it allows users to convert from a shared reference `&T` to an owned reference
-/// [`ARef<T>`].
-///
-/// This is usually implemented by wrappers to existing structures on the C side of the code. For
-/// Rust code, the recommendation is to use [`Arc`](crate::sync::Arc) to create reference-counted
-/// instances of a type.
-///
-/// # Safety
-///
-/// Implementers must ensure that increments to the reference count keep the object alive in memory
-/// at least until matching decrements are performed.
-///
-/// Implementers must also ensure that all instances are reference-counted. (Otherwise they
-/// won't be able to honour the requirement that [`AlwaysRefCounted::inc_ref`] keep the object
-/// alive.)
-pub unsafe trait AlwaysRefCounted {
-    /// Increments the reference count on the object.
-    fn inc_ref(&self);
-
-    /// Decrements the reference count on the object.
-    ///
-    /// Frees the object when the count reaches zero.
-    ///
-    /// # Safety
-    ///
-    /// Callers must ensure that there was a previous matching increment to the reference count,
-    /// and that the object is no longer used after its reference count is decremented (as it may
-    /// result in the object being freed), unless the caller owns another increment on the refcount
-    /// (e.g., it calls [`AlwaysRefCounted::inc_ref`] twice, then calls
-    /// [`AlwaysRefCounted::dec_ref`] once).
-    unsafe fn dec_ref(obj: NonNull<Self>);
-}
-
-/// An owned reference to an always-reference-counted object.
-///
-/// The object's reference count is automatically decremented when an instance of [`ARef`] is
-/// dropped. It is also automatically incremented when a new instance is created via
-/// [`ARef::clone`].
-///
-/// # Invariants
-///
-/// The pointer stored in `ptr` is non-null and valid for the lifetime of the [`ARef`] instance. In
-/// particular, the [`ARef`] instance owns an increment on the underlying object's reference count.
-pub struct ARef<T: AlwaysRefCounted> {
-    ptr: NonNull<T>,
-    _p: PhantomData<T>,
-}
-
-// SAFETY: It is safe to send `ARef<T>` to another thread when the underlying `T` is `Sync` because
-// it effectively means sharing `&T` (which is safe because `T` is `Sync`); additionally, it needs
-// `T` to be `Send` because any thread that has an `ARef<T>` may ultimately access `T` using a
-// mutable reference, for example, when the reference count reaches zero and `T` is dropped.
-unsafe impl<T: AlwaysRefCounted + Sync + Send> Send for ARef<T> {}
-
-// SAFETY: It is safe to send `&ARef<T>` to another thread when the underlying `T` is `Sync`
-// because it effectively means sharing `&T` (which is safe because `T` is `Sync`); additionally,
-// it needs `T` to be `Send` because any thread that has a `&ARef<T>` may clone it and get an
-// `ARef<T>` on that thread, so the thread may ultimately access `T` using a mutable reference, for
-// example, when the reference count reaches zero and `T` is dropped.
-unsafe impl<T: AlwaysRefCounted + Sync + Send> Sync for ARef<T> {}
-
-impl<T: AlwaysRefCounted> ARef<T> {
-    /// Creates a new instance of [`ARef`].
-    ///
-    /// It takes over an increment of the reference count on the underlying object.
-    ///
-    /// # Safety
-    ///
-    /// Callers must ensure that the reference count was incremented at least once, and that they
-    /// are properly relinquishing one increment. That is, if there is only one increment, callers
-    /// must not use the underlying object anymore -- it is only safe to do so via the newly
-    /// created [`ARef`].
-    pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
-        // INVARIANT: The safety requirements guarantee that the new instance now owns the
-        // increment on the refcount.
-        Self {
-            ptr,
-            _p: PhantomData,
-        }
-    }
-
-    /// Consumes the `ARef`, returning a raw pointer.
-    ///
-    /// This function does not change the refcount. After calling this function, the caller is
-    /// responsible for the refcount previously managed by the `ARef`.
-    ///
-    /// # Examples
-    ///
-    /// ```
-    /// use core::ptr::NonNull;
-    /// use kernel::types::{ARef, AlwaysRefCounted};
-    ///
-    /// struct Empty {}
-    ///
-    /// # // SAFETY: TODO.
-    /// unsafe impl AlwaysRefCounted for Empty {
-    ///     fn inc_ref(&self) {}
-    ///     unsafe fn dec_ref(_obj: NonNull<Self>) {}
-    /// }
-    ///
-    /// let mut data = Empty {};
-    /// let ptr = NonNull::<Empty>::new(&mut data).unwrap();
-    /// # // SAFETY: TODO.
-    /// let data_ref: ARef<Empty> = unsafe { ARef::from_raw(ptr) };
-    /// let raw_ptr: NonNull<Empty> = ARef::into_raw(data_ref);
-    ///
-    /// assert_eq!(ptr, raw_ptr);
-    /// ```
-    pub fn into_raw(me: Self) -> NonNull<T> {
-        ManuallyDrop::new(me).ptr
-    }
-}
-
-impl<T: AlwaysRefCounted> Clone for ARef<T> {
-    fn clone(&self) -> Self {
-        self.inc_ref();
-        // SAFETY: We just incremented the refcount above.
-        unsafe { Self::from_raw(self.ptr) }
-    }
-}
-
-impl<T: AlwaysRefCounted> Deref for ARef<T> {
-    type Target = T;
-
-    fn deref(&self) -> &Self::Target {
-        // SAFETY: The type invariants guarantee that the object is valid.
-        unsafe { self.ptr.as_ref() }
-    }
-}
-
-impl<T: AlwaysRefCounted> From<&T> for ARef<T> {
-    fn from(b: &T) -> Self {
-        b.inc_ref();
-        // SAFETY: We just incremented the refcount above.
-        unsafe { Self::from_raw(NonNull::from(b)) }
-    }
-}
-
-impl<T: AlwaysRefCounted> Drop for ARef<T> {
-    fn drop(&mut self) {
-        // SAFETY: The type invariants guarantee that the `ARef` owns the reference we're about to
-        // decrement.
-        unsafe { T::dec_ref(self.ptr) };
-    }
-}
-
 /// A sum type that always holds either a value of type `L` or `R`.
 ///
 /// # Examples

base-commit: 0303584766b7bdb6564c7e8f13e0b59b6ef44984
-- 
2.34.1

