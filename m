Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831434;
	b=EmPxbv+n3MhN2kxWi9oGe/OvYaZ9KZEtkyGgwcAtc6UeSytB0wG01N2Dws8yrkuzOFfw
	 1d3daylBx48KqOHBeC0MLBlt7vB0vQLJjGWI6GExJHWcDa02Y93qN1mWj2kTLfCK9qjJY
	 xliVRWR35p7/nq8u79i+2l/y8+D6wpwvR4HCBhr/3mLZPv1Uxc2dVyGc5Oalm6thSL/mK
	 Eo9mJ8Qa/2JB43+M2wbMLocgUYJN6jkhnwmbed+oeVYuNgI6bNM97ANo1FSEAv9cJ2mO9
	 DKpwWhJ7PRmF9AXHHvGhMQsTbY208/4N7ect3PkRCGSi1Hst5zNmlDGGnhwcFJszJHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yRdvlLni88mPAoEwL1h9M9I2N/+agT7BePwRIzZe5HQ=;
	b=MEODPTf7wKEgitCTeOCKiuAmU2VskP/cHoNbaQHr7VVb+O9ZLMJMsegLRXD0i1Y99cLU
	 sTmSIkj1Gev1PURE6EAyBAFlz2AFXKke8ec1FevUHzkphr5xIWwyU8h59hZfuyu9kRxs1
	 GXuqr2INd5jcXjtFF5olPnZTOwj5/JD+E5njHqixiMChaOXtAVP7GuhDwACmkqutUABXL
	 cDiVLK1XYaeTrfHansBa/TEhJvi7v5v9MX9+4ZIKvPpWqXQ+L2Q9TnTwXsTFmTkG7vT7r
	 88+5UBA+e//xzp4xgvkf4iuRiHXAK7q2r9yftHA6GrhGqROSdmijZHyCeuoeUzBoxng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KzjY7x4G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05046606B38E;
	Wed,  4 Nov 2026 22:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KzjY7x4G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E73E1F0093A;
	Wed,  4 Nov 2026 22:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831433;
	bh=yRdvlLni88mPAoEwL1h9M9I2N/+agT7BePwRIzZe5HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KzjY7x4GCjdEpiROM5DEcudj+HmYDU83FRuav2xMWM4luYeCiyLuB4tOcI4Kh5SYS
	 1PQnsjQsVXapQdl0j9p1+sypF0t50Kvzvsr9oyEqcm3dMwn2ZWdfwfTwUFDQ4wH/69
	 gdRzHN9Z6cx0GoqnWRXgrIAWSESdgcLDrmnj0AuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yury Norov <ynorov@nvidia.com>,
	Burak Emir <burak.emir@gmail.com>,
	Eliot Courtney <ecourtney@nvidia.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 0699/1005] rust: bitmap: restrict bitmap length to at most i32::MAX
Date: Wed,  4 Nov 2026 16:07:12 -0500
Message-ID: <20261104211103.174756107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliot Courtney <ecourtney@nvidia.com>

commit 931790a91378f6513ba82730eb5607479c3184a0 upstream.

It is currently possible to construct a non-`BitmapVec` backed `Bitmap`
using `Bitmap::from_raw` that is larger than `i32::MAX`, and it is not
part of the unsafe requirements. Restricting all bitmaps (even
non-`BitmapVec` backed ones) to a maximum size of `i32::MAX` simplifies
a few things and matches `BitmapVec::MAX_LEN`. For example,
`copy_and_extend` truncates `len` to u32, which is wrong for > u32::MAX
size. `__bitmap_set` and `__bitmap_clear` need i32 for `size` and u32
for `start` - so they can't be run on a `Bitmap` with a > i32::MAX size.
Rather than adding runtime checks to account for the case of a non
`BitmapVec` backed `Bitmap`, just include that in the requirements for
`Bitmap`.

Add that requirement to the unsafe requirements on `Bitmap::from_raw`
and `Bitmap::from_raw_mut`, and to the invariants on `Bitmap`.

This also fixes u32 casts truncating in `copy_and_extend`, which could
otherwise lead to OOB writes.

Fixes: 11eca92a2cae ("rust: add bitmap API.")
Link: https://lore.kernel.org/DKG0U8RLO7LZ.2I1AIH0S38PAP@nvidia.com
Reviewed-by: Yury Norov <ynorov@nvidia.com>
Reviewed-by: Burak Emir <burak.emir@gmail.com>
Signed-off-by: Eliot Courtney <ecourtney@nvidia.com>
Link: https://patch.msgid.link/20260930-chid-v9-2-0d6cca376cff@nvidia.com
Cc: stable@vger.kernel.org
[ Added a few intra-doc links. Added backticks to C types. Capitalize
  tagged comments. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/bitmap.rs |   70 +++++++++++++++++++++++++++++++++++---------------
 1 file changed, 49 insertions(+), 21 deletions(-)

--- a/rust/kernel/bitmap.rs
+++ b/rust/kernel/bitmap.rs
@@ -19,24 +19,59 @@ const BITS_PER_LONG: usize = bindings::B
 /// # Invariants
 ///
 /// Must reference a `[c_ulong]` long enough to fit `data.len()` bits.
+/// Must not be longer than [`i32::MAX`] bits, so offsets and lengths used with
+/// [`Bitmap`] functions fit in the `int` and `unsigned int` arguments of the C bitmap API.
+/// This also matches [`BitmapVec::MAX_LEN`].
 #[cfg_attr(CONFIG_64BIT, repr(align(8)))]
 #[cfg_attr(not(CONFIG_64BIT), repr(align(4)))]
 pub struct Bitmap {
     data: [()],
 }
 
+macro_rules! bitmap_assert {
+    ($cond:expr, $($arg:tt)+) => {
+        #[cfg(CONFIG_RUST_BITMAP_HARDENED)]
+        assert!($cond, $($arg)*);
+    }
+}
+
+macro_rules! bitmap_assert_return {
+    ($cond:expr, $($arg:tt)+) => {
+        #[cfg(CONFIG_RUST_BITMAP_HARDENED)]
+        assert!($cond, $($arg)*);
+
+        #[cfg(not(CONFIG_RUST_BITMAP_HARDENED))]
+        if !($cond) {
+            pr_err!($($arg)*);
+            return
+        }
+    }
+}
+
 impl Bitmap {
     /// Borrows a C bitmap.
     ///
+    /// # Panics
+    ///
+    /// Panics if CONFIG_RUST_BITMAP_HARDENED is enabled and `nbits` exceeds [`i32::MAX`].
+    ///
     /// # Safety
     ///
     /// * `ptr` holds a non-null address of an initialized array of `unsigned long`
     ///   that is large enough to hold `nbits` bits.
+    /// * `nbits` must not exceed [`i32::MAX`].
     /// * the array must not be freed for the lifetime of this [`Bitmap`]
     /// * concurrent access only happens through atomic operations
     pub unsafe fn from_raw<'a>(ptr: *const usize, nbits: usize) -> &'a Bitmap {
+        bitmap_assert!(
+            nbits <= i32::MAX as usize,
+            "`nbits` must be <= {}, was {}",
+            i32::MAX,
+            nbits
+        );
         let data: *const [()] = core::ptr::slice_from_raw_parts(ptr.cast(), nbits);
         // INVARIANT: `data` references an initialized array that can hold `nbits` bits.
+        // INVARIANT: The caller guarantees that `nbits` does not exceed `i32::MAX`.
         // SAFETY:
         // The caller guarantees that `data` (derived from `ptr` and `nbits`)
         // points to a valid, initialized, and appropriately sized memory region
@@ -53,15 +88,27 @@ impl Bitmap {
 
     /// Borrows a C bitmap exclusively.
     ///
+    /// # Panics
+    ///
+    /// Panics if CONFIG_RUST_BITMAP_HARDENED is enabled and `nbits` exceeds [`i32::MAX`].
+    ///
     /// # Safety
     ///
     /// * `ptr` holds a non-null address of an initialized array of `unsigned long`
     ///   that is large enough to hold `nbits` bits.
+    /// * `nbits` must not exceed [`i32::MAX`].
     /// * the array must not be freed for the lifetime of this [`Bitmap`]
     /// * no concurrent access may happen.
     pub unsafe fn from_raw_mut<'a>(ptr: *mut usize, nbits: usize) -> &'a mut Bitmap {
+        bitmap_assert!(
+            nbits <= i32::MAX as usize,
+            "`nbits` must be <= {}, was {}",
+            i32::MAX,
+            nbits
+        );
         let data: *mut [()] = core::ptr::slice_from_raw_parts_mut(ptr.cast(), nbits);
         // INVARIANT: `data` references an initialized array that can hold `nbits` bits.
+        // INVARIANT: The caller guarantees that `nbits` does not exceed `i32::MAX`.
         // SAFETY:
         // The caller guarantees that `data` (derived from `ptr` and `nbits`)
         // points to a valid, initialized, and appropriately sized memory region
@@ -98,26 +145,6 @@ union BitmapRepr {
     ptr: NonNull<usize>,
 }
 
-macro_rules! bitmap_assert {
-    ($cond:expr, $($arg:tt)+) => {
-        #[cfg(CONFIG_RUST_BITMAP_HARDENED)]
-        assert!($cond, $($arg)*);
-    }
-}
-
-macro_rules! bitmap_assert_return {
-    ($cond:expr, $($arg:tt)+) => {
-        #[cfg(CONFIG_RUST_BITMAP_HARDENED)]
-        assert!($cond, $($arg)*);
-
-        #[cfg(not(CONFIG_RUST_BITMAP_HARDENED))]
-        if !($cond) {
-            pr_err!($($arg)*);
-            return
-        }
-    }
-}
-
 /// Represents an owned bitmap.
 ///
 /// Wraps underlying C bitmap API. See [`Bitmap`] for available
@@ -401,7 +428,8 @@ impl Bitmap {
     #[inline]
     pub fn copy_and_extend(&mut self, src: &Bitmap) {
         let len = core::cmp::min(src.len(), self.len());
-        // SAFETY: access to `self` and `src` is within bounds.
+        // SAFETY: Access to `self` and `src` is within bounds. Both lengths fit in `u32`
+        // because a `Bitmap` is at most `i32::MAX` bits, so the casts are lossless.
         unsafe {
             bindings::bitmap_copy_and_extend(
                 self.as_mut_ptr(),


