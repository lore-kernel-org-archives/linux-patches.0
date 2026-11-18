Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024676;
	b=H0IxxuCcsojdl0DgcIkQy1zgPeAmLSHniqjCP397tSSPv1CI0/CSfgJfmhQMjSCVOJZR
	 zfZpLuhKmqxYDiMLZJNPvbUMOo5RdXepJtN4YBLmE5JdZRI1c7iaHMuYCAMGhMmOYZv6r
	 dd/0766SO0a/GVGEKpXyzhIWBXwtLZD9LD3i/ged7uYuM4+G4LXa8Nlndv860TtC8BmrS
	 M0m6kHaWusV5OX/0cPVmpcjvhF9tyrGY97F5QgKgNJBsE0p2nrkz6vumwAn8EHsdXPniN
	 7OcxBTZB9JmoP7vPQUZT5CnGLifa7EmzkLWyBYJtFb5zJsBF+kUMv4o3egemkuxjBIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zm3t7cgn7OnE7+/iteZ5NYWdTUzR3gw17QJqJvGit3c=;
	b=qJJvQymjgkV4kRfNoxT/pz3o9M21bsGdlTNNgGusDCwxOlIHeMUDRXbWR6dngFsE31dR
	 BIYDit+Utv1KwbSDtP3mZWRN9yfgyLQMVS/+nHXEay2WQQoYYhWMeU+mRbES8m7vXiPfI
	 6cxURyMhDIl/IPbUvRdMxjwPABSyECmJtP2QYX/Il4acW6fYDYnis1j3gotM+xRXZPKUz
	 r+V2VfdsedNq650RDfNIvckhUsINi2EF55nuD3Nw1PGwAmmU5AlnxXdJtSYy15YtAqHCp
	 Ap007gRaIcT3YLYHzCFoR9NUahdU7ENe8qOWKmlCvpjTTF61RUx0MBjiXRjRVn0i5Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2Ww9z/mv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2AF606A31C;
	Wed, 18 Nov 2026 17:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Ww9z/mv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B1D1F000C9;
	Wed, 18 Nov 2026 17:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024676;
	bh=Zm3t7cgn7OnE7+/iteZ5NYWdTUzR3gw17QJqJvGit3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Ww9z/mv/CPyikv0aVj8hY06w/bmWsuaNcM6CvItj1p5FVnTznkm7tSUqnwEBcq2C
	 QQsBLgmurTD9Xg4IOuvv1Q2qCGRoSuqWL4csS3j40im5wDUNVNWPonC+AVk5ZS4SVB
	 vh8Q2JIVFo/H+BsmG1DDmBnlDWefwMkOAo0Wn488=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yilin Chen <1479826151@qq.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0809/2151] rust: configfs: require thread-safe callback data
Date: Wed, 18 Nov 2026 15:42:24 +0100
Message-ID: <20261118150151.516177981@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Yilin Chen <1479826151@qq.com>

[ Upstream commit ec27f3b700010d2ebae1cde2df0246197689d159 ]

The Rust configfs abstractions do not fully constrain callback data for
cross-thread use. Add the missing `Send` and `Sync` requirements.

Specifically, make the following changes:

1. Require `Data: Send` when implementing `Send` for `Subsystem<Data>`,
   since the subsystem stores its data by value.
2. Make `GroupOperations` a `Sync` supertrait because `make_group` and
   `drop_item` receive `&self` from foreign threads. Require `Child: Send`
   because configfs may release child groups on an arbitrary thread.
3. Require `AttributeOperations::Data: Sync` because its callbacks receive
   `&Data` from foreign threads.
4. Update the safety comments in FFI callbacks that call `get_group_data`
   to cite these bounds as justification for sharing the returned
   references with the callback thread.
5. Remove redundant `Child: 'static` bounds from `GroupOperationsVTable`
   and `new_with_child_ctor`.

Fixes: 446cafc295bf ("rust: configfs: introduce rust support for configfs")
Link: https://rust-for-linux.zulipchat.com/#narrow/channel/288089-General/topic/Should.20add.20Data.3A.20Send.2FSync.20bounds.20in.20configfs.3A.3ASubsystem.3F/with/623719979
Assisted-by: Gpt-5.6 Sol
Signed-off-by: Yilin Chen <1479826151@qq.com>
Link: https://msgid.link/tencent_5449081195EDDF5726C709CF648DD4044A08@qq.com
[ Andreas: Add Send/Sync bounds for `Group<Data>`, add `Send` bounds to
`GroupOperationsVTable`, `ItemOperationsVTable` and `ItemType` macro
implementation. ]
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/configfs.rs | 63 ++++++++++++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 19 deletions(-)

diff --git a/rust/kernel/configfs.rs b/rust/kernel/configfs.rs
index 002de999ff23f..967d852677c17 100644
--- a/rust/kernel/configfs.rs
+++ b/rust/kernel/configfs.rs
@@ -136,8 +136,9 @@ pub struct Subsystem<Data> {
 // SAFETY: We do not provide any operations on `Subsystem`.
 unsafe impl<Data> Sync for Subsystem<Data> {}
 
-// SAFETY: Ownership of `Subsystem` can safely be transferred to other threads.
-unsafe impl<Data> Send for Subsystem<Data> {}
+// SAFETY: Ownership of `Subsystem` can safely be transferred to other threads
+// if its data can be transferred as well.
+unsafe impl<Data: Send> Send for Subsystem<Data> {}
 
 impl<Data> Subsystem<Data> {
     /// Create an initializer for a [`Subsystem`].
@@ -250,6 +251,13 @@ pub struct Group<Data> {
     data: Data,
 }
 
+// SAFETY: We do not provide any operations on `Group`.
+unsafe impl<Data> Sync for Group<Data> {}
+
+// SAFETY: Ownership of `Group` can safely be transferred to other threads if
+// its data can be transferred as well.
+unsafe impl<Data: Send> Send for Group<Data> {}
+
 impl<Data> Group<Data> {
     /// Create an initializer for a new group.
     ///
@@ -339,7 +347,9 @@ unsafe fn get_group_data<'a, Parent>(this: *mut bindings::config_group) -> &'a P
 impl<Parent, Child> GroupOperationsVTable<Parent, Child>
 where
     Parent: GroupOperations<Child = Child>,
-    Child: 'static,
+    // We transfer `Arc<Group<Data>>` across a thread boundary in `make_group`
+    // and `drop_item`.
+    Arc<Group<Child>>: Send,
 {
     /// # Safety
     ///
@@ -358,8 +368,9 @@ impl<Parent, Child> GroupOperationsVTable<Parent, Child>
         this: *mut bindings::config_group,
         name: *const kernel::ffi::c_char,
     ) -> *mut bindings::config_group {
-        // SAFETY: By function safety requirements of this function, this call
-        // is safe.
+        // SAFETY: By function safety requirements, `this` points to a configfs
+        // group containing `Parent`. The `GroupOperations` bound guarantees
+        // that `Parent: Sync`, so it is safe to share it with this thread.
         let parent_data = unsafe { get_group_data(this) };
 
         let group_init = match Parent::make_group(
@@ -404,8 +415,9 @@ impl<Parent, Child> GroupOperationsVTable<Parent, Child>
         this: *mut bindings::config_group,
         item: *mut bindings::config_item,
     ) {
-        // SAFETY: By function safety requirements of this function, this call
-        // is safe.
+        // SAFETY: By function safety requirements, `this` points to a configfs
+        // group containing `Parent`. The `GroupOperations` bound guarantees
+        // that `Parent: Sync`, so it is safe to share it with this thread.
         let parent_data = unsafe { get_group_data(this) };
 
         // SAFETY: By function safety requirements, `item` is embedded in a
@@ -417,7 +429,9 @@ impl<Parent, Child> GroupOperationsVTable<Parent, Child>
 
         if Parent::HAS_DROP_ITEM {
             // SAFETY: We called `into_raw` to produce `r_child_group_ptr` in
-            // `make_group`.
+            // `make_group`. This function may be executing on a different
+            // thread than `into_raw`. As `Arc<Group<Child>>: Send` this
+            // ownership transfer is safe.
             let arc: Arc<Group<Child>> = unsafe { Arc::from_raw(r_child_group_ptr.cast_mut()) };
 
             Parent::drop_item(parent_data, arc.as_arc_borrow());
@@ -448,6 +462,8 @@ const fn vtable_ptr() -> *const bindings::configfs_group_operations {
 impl<Data> ItemOperationsVTable<Group<Data>, Data>
 where
     Data: 'static,
+    // We transfer `Arc<Group<Data>>` across a thread boundary in `release`.
+    Arc<Group<Data>>: Send,
 {
     /// # Safety
     ///
@@ -464,8 +480,9 @@ impl<Data> ItemOperationsVTable<Group<Data>, Data>
         // embedded within a `Group<Data>`.
         let r_group_ptr = unsafe { Group::<Data>::container_of(c_group_ptr) };
 
-        // SAFETY: We called `into_raw` on `r_group_ptr` in
-        // `make_group`.
+        // SAFETY: We called `into_raw` on `r_group_ptr` in `make_group`. This
+        // function may be running on a different thread than the thread that
+        // called `into_raw`. As `Arc<Group<Data>>: Send`, this is safe.
         let pin_self: Arc<Group<Data>> = unsafe { Arc::from_raw(r_group_ptr.cast_mut()) };
         drop(pin_self);
     }
@@ -497,12 +514,12 @@ const fn vtable_ptr() -> *const bindings::configfs_item_operations {
 ///
 /// Implement this trait on structs that embed a [`Subsystem`] or a [`Group`].
 #[vtable]
-pub trait GroupOperations {
+pub trait GroupOperations: Sync {
     /// The child data object type.
     ///
     /// This group will create subgroups (subdirectories) backed by this kind of
     /// object.
-    type Child: 'static;
+    type Child: 'static + Send;
 
     /// Creates a new subgroup.
     ///
@@ -569,8 +586,10 @@ impl<const ID: u64, O, Data> Attribute<ID, O, Data>
             // `config_group`.
             unsafe { container_of!(item, bindings::config_group, cg_item) };
 
-        // SAFETY: The function safety requirements for this function satisfy
-        // the conditions for this call.
+        // SAFETY: By function safety requirements, `c_group` points to a
+        // configfs group containing `Data`. The `AttributeOperations` bound
+        // guarantees that `Data: Sync`, so it is safe to share it with this
+        // thread.
         let data: &Data = unsafe { get_group_data(c_group) };
 
         // SAFETY: By function safety requirements, `page` is writable for `PAGE_SIZE`.
@@ -603,8 +622,10 @@ impl<const ID: u64, O, Data> Attribute<ID, O, Data>
         // `config_group`.
             unsafe { container_of!(item, bindings::config_group, cg_item) };
 
-        // SAFETY: The function safety requirements for this function satisfy
-        // the conditions for this call.
+        // SAFETY: By function safety requirements, `c_group` points to a
+        // configfs group containing `Data`. The `AttributeOperations` bound
+        // guarantees that `Data: Sync`, so it is safe to share it with this
+        // thread.
         let data: &Data = unsafe { get_group_data(c_group) };
 
         let ret = O::store(
@@ -657,7 +678,7 @@ pub const fn new(name: &'static CStr) -> Self {
 pub trait AttributeOperations<const ID: u64 = 0> {
     /// The type of the object that contains the field that is backing the
     /// attribute for this operation.
-    type Data;
+    type Data: Sync;
 
     /// Renders the value of an attribute.
     ///
@@ -763,7 +784,8 @@ pub const fn new_with_child_ctor<const N: usize, Child>(
             ) -> Self
             where
                 Data: GroupOperations<Child = Child>,
-                Child: 'static,
+                Arc<Group<Child>>: Send,
+                Arc<Group<Data>>: Send,
             {
                 Self {
                     item_type: Opaque::new(bindings::config_item_type {
@@ -781,7 +803,10 @@ pub const fn new_with_child_ctor<const N: usize, Child>(
             pub const fn new<const N: usize>(
                 owner: &'static ThisModule,
                 attributes: &'static AttributeList<N, Data>,
-            ) -> Self {
+            ) -> Self
+            where
+                Arc<Group<Data>>: Send,
+            {
                 Self {
                     item_type: Opaque::new(bindings::config_item_type {
                         ct_owner: owner.as_ptr(),
-- 
2.53.0



