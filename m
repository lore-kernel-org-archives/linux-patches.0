Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB66256C93;
	Fri,  7 Mar 2025 22:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387942; cv=none; b=khuIf56yRaQIZ6s7nNyBZu13+2kQ4ZeTWj/LGZi3BBgKipbMCc4oBzfwTI26YitnuaWzy6EhxORCwILdwzpoTfG0i6yuprAzdZiXsZkk2g4zOKU+wN8c5kbLDmbvS0WFO5bt8fBUTZ7eQ+JiffrN1jTP/n4DQjhY2YHw1eyiaSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387942; c=relaxed/simple;
	bh=ASScEvi20oB6SPEtyA/iFzgEj8nt9j6ACdo2ieFyDRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlmhE3M5Q2mWq/rc2gc+h9XVPbaoazyz6SrkeSFPMk1mauhBLcHpT/yTbEWUIab5YOoxCzcuVcyrZMzUatlbpFGNYBfewLyktY1w5iS5fOHdTDxjIUStafxxwwIsQhkAFn2V1o89cshZWl6KyYU1h0wWvL+TatqyQ4rZOWybneA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LvKJSuw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LvKJSuw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF83C4CED1;
	Fri,  7 Mar 2025 22:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387942;
	bh=ASScEvi20oB6SPEtyA/iFzgEj8nt9j6ACdo2ieFyDRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvKJSuw1VuyEN2v7AEaC42Yx7O9jk3wbQAJHK6C0pPCXN98EzsiDfBTK53t/TAmQo
	 ymAaqIQV4lgXdnSQIHElgyI6HQhGhANXl0ibiUUDMwZJZFVlloDT8n8ednZW3kEWBp
	 4MRucS+wyv5OBvd3ZRhsbN+Pr5LyloGqpVo0580WMm+o06aYjwmj/M9gyxF83SwAa+
	 Q1cft5AdRRO8Q3o7FsPW1OY6H+XA2J4vdeCK1yMOanUz8q++ZNP3Y/HWVjsS7rkb5W
	 ywDzqa3XslLJYrB4l960VcHJQnG9tWJHTu3AsPAG4ejWttZeObJAZtVdJDyZhdRWy1
	 2fqCSLloQKVVw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 39/60] rust: alloc: remove `VecExt` extension
Date: Fri,  7 Mar 2025 23:49:46 +0100
Message-ID: <20250307225008.779961-40-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Danilo Krummrich <dakr@kernel.org>

commit 405966efc789888c3e1a53cd09d2c2b338064438 upstream.

Now that all existing `Vec` users were moved to the kernel `Vec` type,
remove the `VecExt` extension.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-21-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/alloc.rs         |   1 -
 rust/kernel/alloc/vec_ext.rs | 185 -----------------------------------
 rust/kernel/prelude.rs       |   5 +-
 3 files changed, 1 insertion(+), 190 deletions(-)
 delete mode 100644 rust/kernel/alloc/vec_ext.rs

diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
index 86d2077a8e64..7fc2e404e594 100644
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -7,7 +7,6 @@
 pub mod kbox;
 pub mod kvec;
 pub mod layout;
-pub mod vec_ext;
 
 #[cfg(any(test, testlib))]
 pub mod allocator_test;
diff --git a/rust/kernel/alloc/vec_ext.rs b/rust/kernel/alloc/vec_ext.rs
deleted file mode 100644
index 1297a4be32e8..000000000000
--- a/rust/kernel/alloc/vec_ext.rs
+++ /dev/null
@@ -1,185 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-//! Extensions to [`Vec`] for fallible allocations.
-
-use super::{AllocError, Flags};
-use alloc::vec::Vec;
-
-/// Extensions to [`Vec`].
-pub trait VecExt<T>: Sized {
-    /// Creates a new [`Vec`] instance with at least the given capacity.
-    ///
-    /// # Examples
-    ///
-    /// ```
-    /// let v = Vec::<u32>::with_capacity(20, GFP_KERNEL)?;
-    ///
-    /// assert!(v.capacity() >= 20);
-    /// # Ok::<(), Error>(())
-    /// ```
-    fn with_capacity(capacity: usize, flags: Flags) -> Result<Self, AllocError>;
-
-    /// Appends an element to the back of the [`Vec`] instance.
-    ///
-    /// # Examples
-    ///
-    /// ```
-    /// let mut v = Vec::new();
-    /// v.push(1, GFP_KERNEL)?;
-    /// assert_eq!(&v, &[1]);
-    ///
-    /// v.push(2, GFP_KERNEL)?;
-    /// assert_eq!(&v, &[1, 2]);
-    /// # Ok::<(), Error>(())
-    /// ```
-    fn push(&mut self, v: T, flags: Flags) -> Result<(), AllocError>;
-
-    /// Pushes clones of the elements of slice into the [`Vec`] instance.
-    ///
-    /// # Examples
-    ///
-    /// ```
-    /// let mut v = Vec::new();
-    /// v.push(1, GFP_KERNEL)?;
-    ///
-    /// v.extend_from_slice(&[20, 30, 40], GFP_KERNEL)?;
-    /// assert_eq!(&v, &[1, 20, 30, 40]);
-    ///
-    /// v.extend_from_slice(&[50, 60], GFP_KERNEL)?;
-    /// assert_eq!(&v, &[1, 20, 30, 40, 50, 60]);
-    /// # Ok::<(), Error>(())
-    /// ```
-    fn extend_from_slice(&mut self, other: &[T], flags: Flags) -> Result<(), AllocError>
-    where
-        T: Clone;
-
-    /// Ensures that the capacity exceeds the length by at least `additional` elements.
-    ///
-    /// # Examples
-    ///
-    /// ```
-    /// let mut v = Vec::new();
-    /// v.push(1, GFP_KERNEL)?;
-    ///
-    /// v.reserve(10, GFP_KERNEL)?;
-    /// let cap = v.capacity();
-    /// assert!(cap >= 10);
-    ///
-    /// v.reserve(10, GFP_KERNEL)?;
-    /// let new_cap = v.capacity();
-    /// assert_eq!(new_cap, cap);
-    ///
-    /// # Ok::<(), Error>(())
-    /// ```
-    fn reserve(&mut self, additional: usize, flags: Flags) -> Result<(), AllocError>;
-}
-
-impl<T> VecExt<T> for Vec<T> {
-    fn with_capacity(capacity: usize, flags: Flags) -> Result<Self, AllocError> {
-        let mut v = Vec::new();
-        <Self as VecExt<_>>::reserve(&mut v, capacity, flags)?;
-        Ok(v)
-    }
-
-    fn push(&mut self, v: T, flags: Flags) -> Result<(), AllocError> {
-        <Self as VecExt<_>>::reserve(self, 1, flags)?;
-        let s = self.spare_capacity_mut();
-        s[0].write(v);
-
-        // SAFETY: We just initialised the first spare entry, so it is safe to increase the length
-        // by 1. We also know that the new length is <= capacity because of the previous call to
-        // `reserve` above.
-        unsafe { self.set_len(self.len() + 1) };
-        Ok(())
-    }
-
-    fn extend_from_slice(&mut self, other: &[T], flags: Flags) -> Result<(), AllocError>
-    where
-        T: Clone,
-    {
-        <Self as VecExt<_>>::reserve(self, other.len(), flags)?;
-        for (slot, item) in core::iter::zip(self.spare_capacity_mut(), other) {
-            slot.write(item.clone());
-        }
-
-        // SAFETY: We just initialised the `other.len()` spare entries, so it is safe to increase
-        // the length by the same amount. We also know that the new length is <= capacity because
-        // of the previous call to `reserve` above.
-        unsafe { self.set_len(self.len() + other.len()) };
-        Ok(())
-    }
-
-    #[cfg(any(test, testlib))]
-    fn reserve(&mut self, additional: usize, _flags: Flags) -> Result<(), AllocError> {
-        Vec::reserve(self, additional);
-        Ok(())
-    }
-
-    #[cfg(not(any(test, testlib)))]
-    fn reserve(&mut self, additional: usize, flags: Flags) -> Result<(), AllocError> {
-        let len = self.len();
-        let cap = self.capacity();
-
-        if cap - len >= additional {
-            return Ok(());
-        }
-
-        if core::mem::size_of::<T>() == 0 {
-            // The capacity is already `usize::MAX` for SZTs, we can't go higher.
-            return Err(AllocError);
-        }
-
-        // We know cap is <= `isize::MAX` because `Layout::array` fails if the resulting byte size
-        // is greater than `isize::MAX`. So the multiplication by two won't overflow.
-        let new_cap = core::cmp::max(cap * 2, len.checked_add(additional).ok_or(AllocError)?);
-        let layout = core::alloc::Layout::array::<T>(new_cap).map_err(|_| AllocError)?;
-
-        let (old_ptr, len, cap) = destructure(self);
-
-        // We need to make sure that `ptr` is either NULL or comes from a previous call to
-        // `krealloc_aligned`. A `Vec<T>`'s `ptr` value is not guaranteed to be NULL and might be
-        // dangling after being created with `Vec::new`. Instead, we can rely on `Vec<T>`'s capacity
-        // to be zero if no memory has been allocated yet.
-        let ptr = if cap == 0 {
-            core::ptr::null_mut()
-        } else {
-            old_ptr
-        };
-
-        // SAFETY: `ptr` is valid because it's either NULL or comes from a previous call to
-        // `krealloc_aligned`. We also verified that the type is not a ZST.
-        let new_ptr = unsafe { super::allocator::krealloc_aligned(ptr.cast(), layout, flags) };
-        if new_ptr.is_null() {
-            // SAFETY: We are just rebuilding the existing `Vec` with no changes.
-            unsafe { rebuild(self, old_ptr, len, cap) };
-            Err(AllocError)
-        } else {
-            // SAFETY: `ptr` has been reallocated with the layout for `new_cap` elements. New cap
-            // is greater than `cap`, so it continues to be >= `len`.
-            unsafe { rebuild(self, new_ptr.cast::<T>(), len, new_cap) };
-            Ok(())
-        }
-    }
-}
-
-#[cfg(not(any(test, testlib)))]
-fn destructure<T>(v: &mut Vec<T>) -> (*mut T, usize, usize) {
-    let mut tmp = Vec::new();
-    core::mem::swap(&mut tmp, v);
-    let mut tmp = core::mem::ManuallyDrop::new(tmp);
-    let len = tmp.len();
-    let cap = tmp.capacity();
-    (tmp.as_mut_ptr(), len, cap)
-}
-
-/// Rebuilds a `Vec` from a pointer, length, and capacity.
-///
-/// # Safety
-///
-/// The same as [`Vec::from_raw_parts`].
-#[cfg(not(any(test, testlib)))]
-unsafe fn rebuild<T>(v: &mut Vec<T>, ptr: *mut T, len: usize, cap: usize) {
-    // SAFETY: The safety requirements from this function satisfy those of `from_raw_parts`.
-    let mut tmp = unsafe { Vec::from_raw_parts(ptr, len, cap) };
-    core::mem::swap(&mut tmp, v);
-}
diff --git a/rust/kernel/prelude.rs b/rust/kernel/prelude.rs
index 80223cdaa485..07daccf6ca8e 100644
--- a/rust/kernel/prelude.rs
+++ b/rust/kernel/prelude.rs
@@ -14,10 +14,7 @@
 #[doc(no_inline)]
 pub use core::pin::Pin;
 
-pub use crate::alloc::{flags::*, vec_ext::VecExt, Box, KBox, KVBox, KVVec, KVec, VBox, VVec};
-
-#[doc(no_inline)]
-pub use alloc::vec::Vec;
+pub use crate::alloc::{flags::*, Box, KBox, KVBox, KVVec, KVec, VBox, VVec};
 
 #[doc(no_inline)]
 pub use macros::{module, pin_data, pinned_drop, vtable, Zeroable};
-- 
2.48.1

