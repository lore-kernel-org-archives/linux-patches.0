Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEBC1B0F18;
	Sun,  9 Mar 2025 09:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741513849; cv=none; b=pEblZMK9iSHY0qgNIyzHN4YXxBN8UCwQOhCQO4LvJpGnlW/wyjQuyzjeB/hhJ/Ug6xJQ4mgyXM+fuVWfBZWiAhHVLGkMk49pNN4Rcz7y0EJzZ0BSDuKxUdukbsPzkpBz9HSaZOOa/9a2Ch0AasTbz/9DRVo+SyjMAz0x9JUSv0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741513849; c=relaxed/simple;
	bh=fTNqqwxos0gFZ88wwSIhqiuL4wnBmC9aioiMJnR5MGA=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=Rs01Yc8r/FNqI8a3OfY2GuQEEPcpJMsfhaIgPkGp+dTKh6PTYpVYhZrA7TD9Ng00Mz4vaZxq22azE2M5WtbvJ717VSch0bijc7gGZHbxxylqXFlQNy3Jn5cab5+vvQHZO5wRl1+tyJTbyqyuzoIL48rea3ljnDq1GCkbiqznqe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8PA9+VW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8PA9+VW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F27C4CEE5;
	Sun,  9 Mar 2025 09:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741513849;
	bh=fTNqqwxos0gFZ88wwSIhqiuL4wnBmC9aioiMJnR5MGA=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=F8PA9+VWtwiLcFavjE9JvWTtLzvD0+7LPOslQru+swtUHrBCa3QPsQBQiLQWySiv7
	 dFvSKgJg6auozhGcyUReG4N4z3yErZj0S47nbh1FY+YlmWiDe2BpGo2MXnWxRr56nf
	 RhQW86d/7seTYlDdJu4kGl8aw4il34nisdT3sHNk=
Subject: Patch "rust: treewide: switch to our kernel `Box` type" has been added to the 6.12-stable tree
To: aliceryhl@google.com,benno.lossin@proton.me,dakr@kernel.org,gary@garyguo.net,gregkh@linuxfoundation.org,hi@alyssa.is,noisycoil@disroot.org,ojeda@kernel.org,patches@lists.linux.dev,sashal@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Sun, 09 Mar 2025 10:46:52 +0100
In-Reply-To: <20250307225008.779961-32-ojeda@kernel.org>
Message-ID: <2025030952-snore-whiff-f7f1@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore


This is a note to let you know that I've just added the patch titled

    rust: treewide: switch to our kernel `Box` type

to the 6.12-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     rust-treewide-switch-to-our-kernel-box-type.patch
and it can be found in the queue-6.12 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-121486-greg=kroah.com@vger.kernel.org Fri Mar  7 23:52:11 2025
From: Miguel Ojeda <ojeda@kernel.org>
Date: Fri,  7 Mar 2025 23:49:38 +0100
Subject: rust: treewide: switch to our kernel `Box` type
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Alyssa Ross <hi@alyssa.is>, NoisyCoil <noisycoil@disroot.org>, patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>
Message-ID: <20250307225008.779961-32-ojeda@kernel.org>

From: Danilo Krummrich <dakr@kernel.org>

commit 8373147ce4961665c5700016b1c76299e962d077 upstream.

Now that we got the kernel `Box` type in place, convert all existing
`Box` users to make use of it.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-13-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rnull.rs            |    4 +-
 rust/kernel/init.rs               |   51 +++++++++++++++++++-------------------
 rust/kernel/init/__internal.rs    |    2 -
 rust/kernel/rbtree.rs             |   49 ++++++++++++++++++++----------------
 rust/kernel/sync/arc.rs           |   17 +++++-------
 rust/kernel/sync/condvar.rs       |    4 +-
 rust/kernel/sync/lock/mutex.rs    |    2 -
 rust/kernel/sync/lock/spinlock.rs |    2 -
 rust/kernel/workqueue.rs          |   20 +++++++-------
 rust/macros/lib.rs                |    6 ++--
 10 files changed, 81 insertions(+), 76 deletions(-)

--- a/drivers/block/rnull.rs
+++ b/drivers/block/rnull.rs
@@ -32,7 +32,7 @@ module! {
 }
 
 struct NullBlkModule {
-    _disk: Pin<Box<Mutex<GenDisk<NullBlkDevice>>>>,
+    _disk: Pin<KBox<Mutex<GenDisk<NullBlkDevice>>>>,
 }
 
 impl kernel::Module for NullBlkModule {
@@ -47,7 +47,7 @@ impl kernel::Module for NullBlkModule {
             .rotational(false)
             .build(format_args!("rnullb{}", 0), tagset)?;
 
-        let disk = Box::pin_init(new_mutex!(disk, "nullb:disk"), flags::GFP_KERNEL)?;
+        let disk = KBox::pin_init(new_mutex!(disk, "nullb:disk"), flags::GFP_KERNEL)?;
 
         Ok(Self { _disk: disk })
     }
--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -13,7 +13,7 @@
 //! To initialize a `struct` with an in-place constructor you will need two things:
 //! - an in-place constructor,
 //! - a memory location that can hold your `struct` (this can be the [stack], an [`Arc<T>`],
-//!   [`UniqueArc<T>`], [`Box<T>`] or any other smart pointer that implements [`InPlaceInit`]).
+//!   [`UniqueArc<T>`], [`KBox<T>`] or any other smart pointer that implements [`InPlaceInit`]).
 //!
 //! To get an in-place constructor there are generally three options:
 //! - directly creating an in-place constructor using the [`pin_init!`] macro,
@@ -68,7 +68,7 @@
 //! #     a <- new_mutex!(42, "Foo::a"),
 //! #     b: 24,
 //! # });
-//! let foo: Result<Pin<Box<Foo>>> = Box::pin_init(foo, GFP_KERNEL);
+//! let foo: Result<Pin<KBox<Foo>>> = KBox::pin_init(foo, GFP_KERNEL);
 //! ```
 //!
 //! For more information see the [`pin_init!`] macro.
@@ -92,14 +92,14 @@
 //! struct DriverData {
 //!     #[pin]
 //!     status: Mutex<i32>,
-//!     buffer: Box<[u8; 1_000_000]>,
+//!     buffer: KBox<[u8; 1_000_000]>,
 //! }
 //!
 //! impl DriverData {
 //!     fn new() -> impl PinInit<Self, Error> {
 //!         try_pin_init!(Self {
 //!             status <- new_mutex!(0, "DriverData::status"),
-//!             buffer: Box::init(kernel::init::zeroed(), GFP_KERNEL)?,
+//!             buffer: KBox::init(kernel::init::zeroed(), GFP_KERNEL)?,
 //!         })
 //!     }
 //! }
@@ -211,7 +211,7 @@
 //! [`pin_init!`]: crate::pin_init!
 
 use crate::{
-    alloc::{box_ext::BoxExt, AllocError, Flags},
+    alloc::{box_ext::BoxExt, AllocError, Flags, KBox},
     error::{self, Error},
     sync::Arc,
     sync::UniqueArc,
@@ -298,7 +298,7 @@ macro_rules! stack_pin_init {
 /// struct Foo {
 ///     #[pin]
 ///     a: Mutex<usize>,
-///     b: Box<Bar>,
+///     b: KBox<Bar>,
 /// }
 ///
 /// struct Bar {
@@ -307,7 +307,7 @@ macro_rules! stack_pin_init {
 ///
 /// stack_try_pin_init!(let foo: Result<Pin<&mut Foo>, AllocError> = pin_init!(Foo {
 ///     a <- new_mutex!(42),
-///     b: Box::new(Bar {
+///     b: KBox::new(Bar {
 ///         x: 64,
 ///     }, GFP_KERNEL)?,
 /// }));
@@ -324,7 +324,7 @@ macro_rules! stack_pin_init {
 /// struct Foo {
 ///     #[pin]
 ///     a: Mutex<usize>,
-///     b: Box<Bar>,
+///     b: KBox<Bar>,
 /// }
 ///
 /// struct Bar {
@@ -333,7 +333,7 @@ macro_rules! stack_pin_init {
 ///
 /// stack_try_pin_init!(let foo: Pin<&mut Foo> =? pin_init!(Foo {
 ///     a <- new_mutex!(42),
-///     b: Box::new(Bar {
+///     b: KBox::new(Bar {
 ///         x: 64,
 ///     }, GFP_KERNEL)?,
 /// }));
@@ -391,7 +391,7 @@ macro_rules! stack_try_pin_init {
 ///     },
 /// });
 /// # initializer }
-/// # Box::pin_init(demo(), GFP_KERNEL).unwrap();
+/// # KBox::pin_init(demo(), GFP_KERNEL).unwrap();
 /// ```
 ///
 /// Arbitrary Rust expressions can be used to set the value of a variable.
@@ -460,7 +460,7 @@ macro_rules! stack_try_pin_init {
 /// #         })
 /// #     }
 /// # }
-/// let foo = Box::pin_init(Foo::new(), GFP_KERNEL);
+/// let foo = KBox::pin_init(Foo::new(), GFP_KERNEL);
 /// ```
 ///
 /// They can also easily embed it into their own `struct`s:
@@ -592,7 +592,7 @@ macro_rules! pin_init {
 /// use kernel::{init::{self, PinInit}, error::Error};
 /// #[pin_data]
 /// struct BigBuf {
-///     big: Box<[u8; 1024 * 1024 * 1024]>,
+///     big: KBox<[u8; 1024 * 1024 * 1024]>,
 ///     small: [u8; 1024 * 1024],
 ///     ptr: *mut u8,
 /// }
@@ -600,7 +600,7 @@ macro_rules! pin_init {
 /// impl BigBuf {
 ///     fn new() -> impl PinInit<Self, Error> {
 ///         try_pin_init!(Self {
-///             big: Box::init(init::zeroed(), GFP_KERNEL)?,
+///             big: KBox::init(init::zeroed(), GFP_KERNEL)?,
 ///             small: [0; 1024 * 1024],
 ///             ptr: core::ptr::null_mut(),
 ///         }? Error)
@@ -692,16 +692,16 @@ macro_rules! init {
 /// # Examples
 ///
 /// ```rust
-/// use kernel::{init::{PinInit, zeroed}, error::Error};
+/// use kernel::{alloc::KBox, init::{PinInit, zeroed}, error::Error};
 /// struct BigBuf {
-///     big: Box<[u8; 1024 * 1024 * 1024]>,
+///     big: KBox<[u8; 1024 * 1024 * 1024]>,
 ///     small: [u8; 1024 * 1024],
 /// }
 ///
 /// impl BigBuf {
 ///     fn new() -> impl Init<Self, Error> {
 ///         try_init!(Self {
-///             big: Box::init(zeroed(), GFP_KERNEL)?,
+///             big: KBox::init(zeroed(), GFP_KERNEL)?,
 ///             small: [0; 1024 * 1024],
 ///         }? Error)
 ///     }
@@ -812,8 +812,8 @@ macro_rules! assert_pinned {
 /// A pin-initializer for the type `T`.
 ///
 /// To use this initializer, you will need a suitable memory location that can hold a `T`. This can
-/// be [`Box<T>`], [`Arc<T>`], [`UniqueArc<T>`] or even the stack (see [`stack_pin_init!`]). Use the
-/// [`InPlaceInit::pin_init`] function of a smart pointer like [`Arc<T>`] on this.
+/// be [`KBox<T>`], [`Arc<T>`], [`UniqueArc<T>`] or even the stack (see [`stack_pin_init!`]). Use
+/// the [`InPlaceInit::pin_init`] function of a smart pointer like [`Arc<T>`] on this.
 ///
 /// Also see the [module description](self).
 ///
@@ -893,7 +893,7 @@ pub unsafe trait PinInit<T: ?Sized, E =
 }
 
 /// An initializer returned by [`PinInit::pin_chain`].
-pub struct ChainPinInit<I, F, T: ?Sized, E>(I, F, __internal::Invariant<(E, Box<T>)>);
+pub struct ChainPinInit<I, F, T: ?Sized, E>(I, F, __internal::Invariant<(E, KBox<T>)>);
 
 // SAFETY: The `__pinned_init` function is implemented such that it
 // - returns `Ok(())` on successful initialization,
@@ -919,8 +919,8 @@ where
 /// An initializer for `T`.
 ///
 /// To use this initializer, you will need a suitable memory location that can hold a `T`. This can
-/// be [`Box<T>`], [`Arc<T>`], [`UniqueArc<T>`] or even the stack (see [`stack_pin_init!`]). Use the
-/// [`InPlaceInit::init`] function of a smart pointer like [`Arc<T>`] on this. Because
+/// be [`KBox<T>`], [`Arc<T>`], [`UniqueArc<T>`] or even the stack (see [`stack_pin_init!`]). Use
+/// the [`InPlaceInit::init`] function of a smart pointer like [`Arc<T>`] on this. Because
 /// [`PinInit<T, E>`] is a super trait, you can use every function that takes it as well.
 ///
 /// Also see the [module description](self).
@@ -992,7 +992,7 @@ pub unsafe trait Init<T: ?Sized, E = Inf
 }
 
 /// An initializer returned by [`Init::chain`].
-pub struct ChainInit<I, F, T: ?Sized, E>(I, F, __internal::Invariant<(E, Box<T>)>);
+pub struct ChainInit<I, F, T: ?Sized, E>(I, F, __internal::Invariant<(E, KBox<T>)>);
 
 // SAFETY: The `__init` function is implemented such that it
 // - returns `Ok(())` on successful initialization,
@@ -1076,8 +1076,9 @@ pub fn uninit<T, E>() -> impl Init<Maybe
 /// # Examples
 ///
 /// ```rust
-/// use kernel::{error::Error, init::init_array_from_fn};
-/// let array: Box<[usize; 1_000]> = Box::init::<Error>(init_array_from_fn(|i| i), GFP_KERNEL).unwrap();
+/// use kernel::{alloc::KBox, error::Error, init::init_array_from_fn};
+/// let array: KBox<[usize; 1_000]> =
+///     KBox::init::<Error>(init_array_from_fn(|i| i), GFP_KERNEL).unwrap();
 /// assert_eq!(array.len(), 1_000);
 /// ```
 pub fn init_array_from_fn<I, const N: usize, T, E>(
@@ -1453,7 +1454,7 @@ impl_zeroable! {
     //
     // In this case we are allowed to use `T: ?Sized`, since all zeros is the `None` variant.
     {<T: ?Sized>} Option<NonNull<T>>,
-    {<T: ?Sized>} Option<Box<T>>,
+    {<T: ?Sized>} Option<KBox<T>>,
 
     // SAFETY: `null` pointer is valid.
     //
--- a/rust/kernel/init/__internal.rs
+++ b/rust/kernel/init/__internal.rs
@@ -105,7 +105,7 @@ pub unsafe trait InitData: Copy {
     }
 }
 
-pub struct AllData<T: ?Sized>(PhantomData<fn(Box<T>) -> Box<T>>);
+pub struct AllData<T: ?Sized>(PhantomData<fn(KBox<T>) -> KBox<T>>);
 
 impl<T: ?Sized> Clone for AllData<T> {
     fn clone(&self) -> Self {
--- a/rust/kernel/rbtree.rs
+++ b/rust/kernel/rbtree.rs
@@ -7,7 +7,6 @@
 //! Reference: <https://docs.kernel.org/core-api/rbtree.html>
 
 use crate::{alloc::Flags, bindings, container_of, error::Result, prelude::*};
-use alloc::boxed::Box;
 use core::{
     cmp::{Ord, Ordering},
     marker::PhantomData,
@@ -497,7 +496,7 @@ impl<K, V> Drop for RBTree<K, V> {
             // but it is not observable. The loop invariant is still maintained.
 
             // SAFETY: `this` is valid per the loop invariant.
-            unsafe { drop(Box::from_raw(this.cast_mut())) };
+            unsafe { drop(KBox::from_raw(this.cast_mut())) };
         }
     }
 }
@@ -764,7 +763,7 @@ impl<'a, K, V> Cursor<'a, K, V> {
         // point to the links field of `Node<K, V>` objects.
         let this = unsafe { container_of!(self.current.as_ptr(), Node<K, V>, links) }.cast_mut();
         // SAFETY: `this` is valid by the type invariants as described above.
-        let node = unsafe { Box::from_raw(this) };
+        let node = unsafe { KBox::from_raw(this) };
         let node = RBTreeNode { node };
         // SAFETY: The reference to the tree used to create the cursor outlives the cursor, so
         // the tree cannot change. By the tree invariant, all nodes are valid.
@@ -809,7 +808,7 @@ impl<'a, K, V> Cursor<'a, K, V> {
             // point to the links field of `Node<K, V>` objects.
             let this = unsafe { container_of!(neighbor, Node<K, V>, links) }.cast_mut();
             // SAFETY: `this` is valid by the type invariants as described above.
-            let node = unsafe { Box::from_raw(this) };
+            let node = unsafe { KBox::from_raw(this) };
             return Some(RBTreeNode { node });
         }
         None
@@ -1038,7 +1037,7 @@ impl<K, V> Iterator for IterRaw<K, V> {
 /// It contains the memory needed to hold a node that can be inserted into a red-black tree. One
 /// can be obtained by directly allocating it ([`RBTreeNodeReservation::new`]).
 pub struct RBTreeNodeReservation<K, V> {
-    node: Box<MaybeUninit<Node<K, V>>>,
+    node: KBox<MaybeUninit<Node<K, V>>>,
 }
 
 impl<K, V> RBTreeNodeReservation<K, V> {
@@ -1046,7 +1045,7 @@ impl<K, V> RBTreeNodeReservation<K, V> {
     /// call to [`RBTree::insert`].
     pub fn new(flags: Flags) -> Result<RBTreeNodeReservation<K, V>> {
         Ok(RBTreeNodeReservation {
-            node: <Box<_> as BoxExt<_>>::new_uninit(flags)?,
+            node: KBox::new_uninit(flags)?,
         })
     }
 }
@@ -1062,14 +1061,15 @@ impl<K, V> RBTreeNodeReservation<K, V> {
     /// Initialises a node reservation.
     ///
     /// It then becomes an [`RBTreeNode`] that can be inserted into a tree.
-    pub fn into_node(mut self, key: K, value: V) -> RBTreeNode<K, V> {
-        self.node.write(Node {
-            key,
-            value,
-            links: bindings::rb_node::default(),
-        });
-        // SAFETY: We just wrote to it.
-        let node = unsafe { self.node.assume_init() };
+    pub fn into_node(self, key: K, value: V) -> RBTreeNode<K, V> {
+        let node = KBox::write(
+            self.node,
+            Node {
+                key,
+                value,
+                links: bindings::rb_node::default(),
+            },
+        );
         RBTreeNode { node }
     }
 }
@@ -1079,7 +1079,7 @@ impl<K, V> RBTreeNodeReservation<K, V> {
 /// The node is fully initialised (with key and value) and can be inserted into a tree without any
 /// extra allocations or failure paths.
 pub struct RBTreeNode<K, V> {
-    node: Box<Node<K, V>>,
+    node: KBox<Node<K, V>>,
 }
 
 impl<K, V> RBTreeNode<K, V> {
@@ -1091,7 +1091,9 @@ impl<K, V> RBTreeNode<K, V> {
 
     /// Get the key and value from inside the node.
     pub fn to_key_value(self) -> (K, V) {
-        (self.node.key, self.node.value)
+        let node = KBox::into_inner(self.node);
+
+        (node.key, node.value)
     }
 }
 
@@ -1113,7 +1115,7 @@ impl<K, V> RBTreeNode<K, V> {
     /// may be freed (but only for the key/value; memory for the node itself is kept for reuse).
     pub fn into_reservation(self) -> RBTreeNodeReservation<K, V> {
         RBTreeNodeReservation {
-            node: Box::drop_contents(self.node),
+            node: KBox::drop_contents(self.node),
         }
     }
 }
@@ -1164,7 +1166,7 @@ impl<'a, K, V> RawVacantEntry<'a, K, V>
     /// The `node` must have a key such that inserting it here does not break the ordering of this
     /// [`RBTree`].
     fn insert(self, node: RBTreeNode<K, V>) -> &'a mut V {
-        let node = Box::into_raw(node.node);
+        let node = KBox::into_raw(node.node);
 
         // SAFETY: `node` is valid at least until we call `Box::from_raw`, which only happens when
         // the node is removed or replaced.
@@ -1238,21 +1240,24 @@ impl<'a, K, V> OccupiedEntry<'a, K, V> {
             // SAFETY: The node was a node in the tree, but we removed it, so we can convert it
             // back into a box.
             node: unsafe {
-                Box::from_raw(container_of!(self.node_links, Node<K, V>, links).cast_mut())
+                KBox::from_raw(container_of!(self.node_links, Node<K, V>, links).cast_mut())
             },
         }
     }
 
     /// Takes the value of the entry out of the map, and returns it.
     pub fn remove(self) -> V {
-        self.remove_node().node.value
+        let rb_node = self.remove_node();
+        let node = KBox::into_inner(rb_node.node);
+
+        node.value
     }
 
     /// Swap the current node for the provided node.
     ///
     /// The key of both nodes must be equal.
     fn replace(self, node: RBTreeNode<K, V>) -> RBTreeNode<K, V> {
-        let node = Box::into_raw(node.node);
+        let node = KBox::into_raw(node.node);
 
         // SAFETY: `node` is valid at least until we call `Box::from_raw`, which only happens when
         // the node is removed or replaced.
@@ -1268,7 +1273,7 @@ impl<'a, K, V> OccupiedEntry<'a, K, V> {
         // - `self.node_ptr` produces a valid pointer to a node in the tree.
         // - Now that we removed this entry from the tree, we can convert the node to a box.
         let old_node =
-            unsafe { Box::from_raw(container_of!(self.node_links, Node<K, V>, links).cast_mut()) };
+            unsafe { KBox::from_raw(container_of!(self.node_links, Node<K, V>, links).cast_mut()) };
 
         RBTreeNode { node: old_node }
     }
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -17,13 +17,12 @@
 //! [`Arc`]: https://doc.rust-lang.org/std/sync/struct.Arc.html
 
 use crate::{
-    alloc::{box_ext::BoxExt, AllocError, Flags},
+    alloc::{AllocError, Flags, KBox},
     bindings,
     init::{self, InPlaceInit, Init, PinInit},
     try_init,
     types::{ForeignOwnable, Opaque},
 };
-use alloc::boxed::Box;
 use core::{
     alloc::Layout,
     fmt,
@@ -201,11 +200,11 @@ impl<T> Arc<T> {
             data: contents,
         };
 
-        let inner = <Box<_> as BoxExt<_>>::new(value, flags)?;
+        let inner = KBox::new(value, flags)?;
 
         // SAFETY: We just created `inner` with a reference count of 1, which is owned by the new
         // `Arc` object.
-        Ok(unsafe { Self::from_inner(Box::leak(inner).into()) })
+        Ok(unsafe { Self::from_inner(KBox::leak(inner).into()) })
     }
 }
 
@@ -398,8 +397,8 @@ impl<T: ?Sized> Drop for Arc<T> {
         if is_zero {
             // The count reached zero, we must free the memory.
             //
-            // SAFETY: The pointer was initialised from the result of `Box::leak`.
-            unsafe { drop(Box::from_raw(self.ptr.as_ptr())) };
+            // SAFETY: The pointer was initialised from the result of `KBox::leak`.
+            unsafe { drop(KBox::from_raw(self.ptr.as_ptr())) };
         }
     }
 }
@@ -641,7 +640,7 @@ impl<T> UniqueArc<T> {
     /// Tries to allocate a new [`UniqueArc`] instance whose contents are not initialised yet.
     pub fn new_uninit(flags: Flags) -> Result<UniqueArc<MaybeUninit<T>>, AllocError> {
         // INVARIANT: The refcount is initialised to a non-zero value.
-        let inner = Box::try_init::<AllocError>(
+        let inner = KBox::try_init::<AllocError>(
             try_init!(ArcInner {
                 // SAFETY: There are no safety requirements for this FFI call.
                 refcount: Opaque::new(unsafe { bindings::REFCOUNT_INIT(1) }),
@@ -651,8 +650,8 @@ impl<T> UniqueArc<T> {
         )?;
         Ok(UniqueArc {
             // INVARIANT: The newly-created object has a refcount of 1.
-            // SAFETY: The pointer from the `Box` is valid.
-            inner: unsafe { Arc::from_inner(Box::leak(inner).into()) },
+            // SAFETY: The pointer from the `KBox` is valid.
+            inner: unsafe { Arc::from_inner(KBox::leak(inner).into()) },
         })
     }
 }
--- a/rust/kernel/sync/condvar.rs
+++ b/rust/kernel/sync/condvar.rs
@@ -70,8 +70,8 @@ pub use new_condvar;
 /// }
 ///
 /// /// Allocates a new boxed `Example`.
-/// fn new_example() -> Result<Pin<Box<Example>>> {
-///     Box::pin_init(pin_init!(Example {
+/// fn new_example() -> Result<Pin<KBox<Example>>> {
+///     KBox::pin_init(pin_init!(Example {
 ///         value <- new_mutex!(0),
 ///         value_changed <- new_condvar!(),
 ///     }), GFP_KERNEL)
--- a/rust/kernel/sync/lock/mutex.rs
+++ b/rust/kernel/sync/lock/mutex.rs
@@ -58,7 +58,7 @@ pub use new_mutex;
 /// }
 ///
 /// // Allocate a boxed `Example`.
-/// let e = Box::pin_init(Example::new(), GFP_KERNEL)?;
+/// let e = KBox::pin_init(Example::new(), GFP_KERNEL)?;
 /// assert_eq!(e.c, 10);
 /// assert_eq!(e.d.lock().a, 20);
 /// assert_eq!(e.d.lock().b, 30);
--- a/rust/kernel/sync/lock/spinlock.rs
+++ b/rust/kernel/sync/lock/spinlock.rs
@@ -56,7 +56,7 @@ pub use new_spinlock;
 /// }
 ///
 /// // Allocate a boxed `Example`.
-/// let e = Box::pin_init(Example::new(), GFP_KERNEL)?;
+/// let e = KBox::pin_init(Example::new(), GFP_KERNEL)?;
 /// assert_eq!(e.c, 10);
 /// assert_eq!(e.d.lock().a, 20);
 /// assert_eq!(e.d.lock().b, 30);
--- a/rust/kernel/workqueue.rs
+++ b/rust/kernel/workqueue.rs
@@ -216,7 +216,7 @@ impl Queue {
             func: Some(func),
         });
 
-        self.enqueue(Box::pin_init(init, flags).map_err(|_| AllocError)?);
+        self.enqueue(KBox::pin_init(init, flags).map_err(|_| AllocError)?);
         Ok(())
     }
 }
@@ -239,9 +239,9 @@ impl<T> ClosureWork<T> {
 }
 
 impl<T: FnOnce()> WorkItem for ClosureWork<T> {
-    type Pointer = Pin<Box<Self>>;
+    type Pointer = Pin<KBox<Self>>;
 
-    fn run(mut this: Pin<Box<Self>>) {
+    fn run(mut this: Pin<KBox<Self>>) {
         if let Some(func) = this.as_mut().project().take() {
             (func)()
         }
@@ -297,7 +297,7 @@ pub unsafe trait RawWorkItem<const ID: u
 
 /// Defines the method that should be called directly when a work item is executed.
 ///
-/// This trait is implemented by `Pin<Box<T>>` and [`Arc<T>`], and is mainly intended to be
+/// This trait is implemented by `Pin<KBox<T>>` and [`Arc<T>`], and is mainly intended to be
 /// implemented for smart pointer types. For your own structs, you would implement [`WorkItem`]
 /// instead. The [`run`] method on this trait will usually just perform the appropriate
 /// `container_of` translation and then call into the [`run`][WorkItem::run] method from the
@@ -329,7 +329,7 @@ pub unsafe trait WorkItemPointer<const I
 /// This trait is used when the `work_struct` field is defined using the [`Work`] helper.
 pub trait WorkItem<const ID: u64 = 0> {
     /// The pointer type that this struct is wrapped in. This will typically be `Arc<Self>` or
-    /// `Pin<Box<Self>>`.
+    /// `Pin<KBox<Self>>`.
     type Pointer: WorkItemPointer<ID>;
 
     /// The method that should be called when this work item is executed.
@@ -567,7 +567,7 @@ where
 }
 
 // SAFETY: TODO.
-unsafe impl<T, const ID: u64> WorkItemPointer<ID> for Pin<Box<T>>
+unsafe impl<T, const ID: u64> WorkItemPointer<ID> for Pin<KBox<T>>
 where
     T: WorkItem<ID, Pointer = Self>,
     T: HasWork<T, ID>,
@@ -578,7 +578,7 @@ where
         // SAFETY: This computes the pointer that `__enqueue` got from `Arc::into_raw`.
         let ptr = unsafe { T::work_container_of(ptr) };
         // SAFETY: This pointer comes from `Arc::into_raw` and we've been given back ownership.
-        let boxed = unsafe { Box::from_raw(ptr) };
+        let boxed = unsafe { KBox::from_raw(ptr) };
         // SAFETY: The box was already pinned when it was enqueued.
         let pinned = unsafe { Pin::new_unchecked(boxed) };
 
@@ -587,7 +587,7 @@ where
 }
 
 // SAFETY: TODO.
-unsafe impl<T, const ID: u64> RawWorkItem<ID> for Pin<Box<T>>
+unsafe impl<T, const ID: u64> RawWorkItem<ID> for Pin<KBox<T>>
 where
     T: WorkItem<ID, Pointer = Self>,
     T: HasWork<T, ID>,
@@ -601,9 +601,9 @@ where
         // SAFETY: We're not going to move `self` or any of its fields, so its okay to temporarily
         // remove the `Pin` wrapper.
         let boxed = unsafe { Pin::into_inner_unchecked(self) };
-        let ptr = Box::into_raw(boxed);
+        let ptr = KBox::into_raw(boxed);
 
-        // SAFETY: Pointers into a `Box` point at a valid value.
+        // SAFETY: Pointers into a `KBox` point at a valid value.
         let work_ptr = unsafe { T::raw_get_work(ptr) };
         // SAFETY: `raw_get_work` returns a pointer to a valid value.
         let work_ptr = unsafe { Work::raw_get(work_ptr) };
--- a/rust/macros/lib.rs
+++ b/rust/macros/lib.rs
@@ -243,7 +243,7 @@ pub fn concat_idents(ts: TokenStream) ->
 /// struct DriverData {
 ///     #[pin]
 ///     queue: Mutex<Vec<Command>>,
-///     buf: Box<[u8; 1024 * 1024]>,
+///     buf: KBox<[u8; 1024 * 1024]>,
 /// }
 /// ```
 ///
@@ -252,7 +252,7 @@ pub fn concat_idents(ts: TokenStream) ->
 /// struct DriverData {
 ///     #[pin]
 ///     queue: Mutex<Vec<Command>>,
-///     buf: Box<[u8; 1024 * 1024]>,
+///     buf: KBox<[u8; 1024 * 1024]>,
 ///     raw_info: *mut Info,
 /// }
 ///
@@ -282,7 +282,7 @@ pub fn pin_data(inner: TokenStream, item
 /// struct DriverData {
 ///     #[pin]
 ///     queue: Mutex<Vec<Command>>,
-///     buf: Box<[u8; 1024 * 1024]>,
+///     buf: KBox<[u8; 1024 * 1024]>,
 ///     raw_info: *mut Info,
 /// }
 ///


Patches currently in stable-queue which might be from ojeda@kernel.org are

queue-6.12/drm-panic-avoid-reimplementing-iterator-find.patch
queue-6.12/documentation-rust-add-coding-guidelines-on-lints.patch
queue-6.12/rust-provide-proper-code-documentation-titles.patch
queue-6.12/rust-alloc-make-allocator-module-public.patch
queue-6.12/rust-alloc-remove-vecext-extension.patch
queue-6.12/rust-alloc-implement-reallocfunc.patch
queue-6.12/rust-alloc-separate-aligned_size-from-krealloc_aligned.patch
queue-6.12/rust-enable-clippy-unnecessary_safety_comment-lint.patch
queue-6.12/rust-alloc-update-module-comment-of-alloc.rs.patch
queue-6.12/rust-kbuild-expand-rusttest-target-for-macros.patch
queue-6.12/rust-error-use-core-alloc-layouterror.patch
queue-6.12/rust-str-test-replace-alloc-format.patch
queue-6.12/loongarch-use-asm_reachable.patch
queue-6.12/rust-alloc-implement-allocator-for-kmalloc.patch
queue-6.12/rust-alloc-implement-collect-for-intoiter.patch
queue-6.12/rust-alloc-introduce-arraylayout.patch
queue-6.12/rust-alloc-implement-vmalloc-allocator.patch
queue-6.12/documentation-rust-discuss-in-the-guidelines.patch
queue-6.12/rust-error-check-for-config-test-in-error-name.patch
queue-6.12/rust-enable-clippy-ignored_unit_patterns-lint.patch
queue-6.12/rust-enable-clippy-unnecessary_safety_doc-lint.patch
queue-6.12/rust-alloc-add-box-to-prelude.patch
queue-6.12/kbuild-rust-remove-the-alloc-crate-and-globalalloc.patch
queue-6.12/rust-alloc-add-allocator-trait.patch
queue-6.12/rust-treewide-switch-to-our-kernel-box-type.patch
queue-6.12/rust-introduce-.clippy.toml.patch
queue-6.12/rust-alloc-rename-kernelallocator-to-kmalloc.patch
queue-6.12/rust-alloc-implement-cmalloc-in-module-allocator_test.patch
queue-6.12/drm-panic-allow-verbose-version-check.patch
queue-6.12/rust-map-__kernel_size_t-and-friends-also-to-usize-isize.patch
queue-6.12/rust-alloc-add-module-allocator_test.patch
queue-6.12/rust-replace-clippy-dbg_macro-with-disallowed_macros.patch
queue-6.12/rust-alloc-add-__gfp_nowarn-to-flags.patch
queue-6.12/rust-enable-clippy-s-check-private-items.patch
queue-6.12/rust-error-make-conversion-functions-public.patch
queue-6.12/rust-sort-global-rust-flags.patch
queue-6.12/rust-alloc-implement-contains-for-flags.patch
queue-6.12/rust-init-remove-unneeded.patch
queue-6.12/rust-use-custom-ffi-integer-types.patch
queue-6.12/rust-sync-remove-unneeded.patch
queue-6.12/rust-treewide-switch-to-the-kernel-vec-type.patch
queue-6.12/rust-alloc-implement-kvmalloc-allocator.patch
queue-6.12/drm-panic-correctly-indent-continuation-of-line-in-list-item.patch
queue-6.12/rust-alloc-implement-kernel-vec-type.patch
queue-6.12/rust-workqueue-remove-unneeded.patch
queue-6.12/rust-error-optimize-error-type-to-use-nonzero.patch
queue-6.12/drm-panic-remove-unnecessary-borrow-in-alignment_pattern.patch
queue-6.12/rust-alloc-remove-extension-of-std-s-box.patch
queue-6.12/rust-block-fix-formatting-in-gendisk-doc.patch
queue-6.12/rust-enable-rustdoc-unescaped_backticks-lint.patch
queue-6.12/rust-fix-size_t-in-bindgen-prototypes-of-c-builtins.patch
queue-6.12/rust-enable-clippy-undocumented_unsafe_blocks-lint.patch
queue-6.12/rust-alloc-add-vec-to-prelude.patch
queue-6.12/rust-alloc-implement-intoiterator-for-vec.patch
queue-6.12/rust-alloc-implement-kernel-box.patch
queue-6.12/drm-panic-remove-redundant-field-when-assigning-value.patch
queue-6.12/rust-types-avoid-repetition-in-as-from-bytes-impls.patch
queue-6.12/rust-start-using-the-attribute.patch
queue-6.12/drm-panic-allow-verbose-boolean-for-clarity.patch
queue-6.12/maintainers-add-entry-for-the-rust-alloc-module.patch
queue-6.12/rust-alloc-fix-arraylayout-allocations.patch
queue-6.12/drm-panic-prefer-eliding-lifetimes.patch
