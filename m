Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021361;
	b=0CNmERXs8BIFzIMA3vKhEVcJyyKhV9TsiXmb/ARWXQGk0tu4e0hfhR2Zg7STzA29OdbO
	 sMgqLjZp3tdr1ctXdGJFwTKOwhk1/4/yysooqvl3gr8rtYHQlnZZQp6SzE2strL8oF/Am
	 1KpyHjuXpVB+PhbXha0fQNs5Lcz4WBs5r2MUSbWxskE/FJcBztzVH4euYCjZx3vX2ccZG
	 PhZNju6+O/NPsGOQTuxH8Rjgtn+96s0wnhS+uHlcEZQL5wTMrXNyYnP6RMdAjL/8qbLo2
	 qfuF4CdF8RpVpzuKCHlBYoe0gD7aqtjiTdSc7NsTW0DJhjrCZHeVWhIwryngKNFu/eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=GKw2xKZFagOA21bbudXOrR3piqcrcijT1xD+DkYuhHc=;
	b=EmiPrDX2vKyMOtEZVZPD/ieGelGpsiF6Enc4UL0XRO2ONVCQ5j/LPLrzRtNNUUKrFWNO
	 z5qGx2GDoyxZfRPe/R5DFK152qkWZfwXgOKQoS5lloCh+kVZOALML30yzXl01X8njO/kA
	 DGr7F8v3JlbRZibl0DdUwYA8mXyudNw7etlhTVjGs7HrMk+9b8h2UbHGhX1QDOdAPFRYz
	 rBI+uBnNjCQvjdHuU/MAKYjoQjDS+jBjC6Q3jCBC1m2iVgFOikypa8e3VOxkbVsixztR5
	 1sq4IHZMLlrW5jUyH5yaoMwx2DktF0EVCnc19EToBx5tLZJv2IARvZHYGBBBzL2SnNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o0F3v5Cb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2347606A339;
	Wed, 18 Nov 2026 17:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o0F3v5Cb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033191F000C4;
	Wed, 18 Nov 2026 17:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021361;
	bh=GKw2xKZFagOA21bbudXOrR3piqcrcijT1xD+DkYuhHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o0F3v5CbbDgDRAbq7oDnw/7ZpMaUgNs1b1qIU4+Ab6Rtg/DDz+/APh1mizLacfmpj
	 1g5kQCJkNuia/UAQICd3E2lwNB5SF7fzn36FHqxdut66aHwxCbiuo6LDFefSVku3GA
	 ZNBK83VIYKJQhtbmXlItNaAZC/S5JAhsoZ12uaJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Boqun Feng <boqun@kernel.org>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2281/2651] rust: workqueue: replace deprecated system_wq with system_{percpu,dfl}_wq
Date: Wed, 18 Nov 2026 15:58:41 +0100
Message-ID: <20261118150407.426652412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 10ff62c6bb0baf9c2f77f92d2bcdaf6566c31191 ]

system_wq is deprecated and triggers a runtime warning:

	[    0.857414] workqueue: work func ...WorkItemPointerKy0_E3runB7_ enqueued on deprecated workqueue. Use system_{percpu|dfl}_wq instead.

Replace system() with system_percpu() and system_dfl(), to match the
previous behavior of the deprecated system() and convert doc examples
and tests to system_dfl().

system_unbound_wq is deprecated in the same way, in favor of
system_dfl_wq. Since system_unbound() has no users, just remove it as
well.

Fixes: 64d8eae3f895 ("workqueue: Add warnings and fallback if system_{unbound}_wq is used")
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Reviewed-by: Boqun Feng <boqun@kernel.org>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Acked-by: Marco Crivellari <marco.crivellari@suse.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261014-rust-workqueue-system-fix-v2-1-c018b8f870f9@google.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/rust/testing.rst                |  2 +-
 .../translations/zh_CN/rust/testing.rst       |  2 +-
 drivers/android/binder/process.rs             |  4 +-
 rust/kernel/sync/completion.rs                |  2 +-
 rust/kernel/sync/lock/spinlock.rs             |  2 +-
 rust/kernel/workqueue.rs                      | 52 ++++++++++---------
 6 files changed, 33 insertions(+), 31 deletions(-)

diff --git a/Documentation/rust/testing.rst b/Documentation/rust/testing.rst
index e3943aceceb94..73046523a9a27 100644
--- a/Documentation/rust/testing.rst
+++ b/Documentation/rust/testing.rst
@@ -97,7 +97,7 @@ operator are also supported as usual, e.g.:
 
 	/// ```
 	/// # use kernel::{spawn_work_item, workqueue};
-	/// spawn_work_item!(workqueue::system(), || pr_info!("x\n"))?;
+	/// spawn_work_item!(workqueue::system_dfl(), || pr_info!("x\n"))?;
 	/// # Ok::<(), Error>(())
 	/// ```
 
diff --git a/Documentation/translations/zh_CN/rust/testing.rst b/Documentation/translations/zh_CN/rust/testing.rst
index 6747d00129915..fdd88fa2fe40a 100644
--- a/Documentation/translations/zh_CN/rust/testing.rst
+++ b/Documentation/translations/zh_CN/rust/testing.rst
@@ -93,7 +93,7 @@ KUnit 测试即文档测试
 
 	/// ```
 	/// # use kernel::{spawn_work_item, workqueue};
-	/// spawn_work_item!(workqueue::system(), || pr_info!("x\n"))?;
+	/// spawn_work_item!(workqueue::system_dfl(), || pr_info!("x\n"))?;
 	/// # Ok::<(), Error>(())
 	/// ```
 
diff --git a/drivers/android/binder/process.rs b/drivers/android/binder/process.rs
index 5372bfbd93b35..de5bca7f9fc74 100644
--- a/drivers/android/binder/process.rs
+++ b/drivers/android/binder/process.rs
@@ -1728,7 +1728,7 @@ pub(crate) fn release(this: Arc<Process>, _file: &File) {
         if should_schedule {
             // Ignore failures to schedule to the workqueue. Those just mean that we're already
             // scheduled for execution.
-            let _ = workqueue::system().enqueue(this);
+            let _ = workqueue::system_percpu().enqueue(this);
         }
 
         drop(binderfs_file);
@@ -1745,7 +1745,7 @@ pub(crate) fn flush(this: ArcBorrow<'_, Process>) -> Result {
         if should_schedule {
             // Ignore failures to schedule to the workqueue. Those just mean that we're already
             // scheduled for execution.
-            let _ = workqueue::system().enqueue(Arc::from(this));
+            let _ = workqueue::system_percpu().enqueue(Arc::from(this));
         }
         Ok(())
     }
diff --git a/rust/kernel/sync/completion.rs b/rust/kernel/sync/completion.rs
index 35ff049ff0783..1771bfc0ade28 100644
--- a/rust/kernel/sync/completion.rs
+++ b/rust/kernel/sync/completion.rs
@@ -38,7 +38,7 @@
 ///             done <- Completion::new(),
 ///         }), GFP_KERNEL)?;
 ///
-///         let _ = workqueue::system().enqueue(this.clone());
+///         let _ = workqueue::system_dfl().enqueue(this.clone());
 ///
 ///         Ok(this)
 ///     }
diff --git a/rust/kernel/sync/lock/spinlock.rs b/rust/kernel/sync/lock/spinlock.rs
index aafc80125f591..92ad133262b62 100644
--- a/rust/kernel/sync/lock/spinlock.rs
+++ b/rust/kernel/sync/lock/spinlock.rs
@@ -450,7 +450,7 @@ fn run(this: Arc<Self>) {
     fn spinlock_irq_condvar() -> Result {
         let testdata = Test::new()?;
 
-        let _ = workqueue::system().enqueue(testdata.clone());
+        let _ = workqueue::system_dfl().enqueue(testdata.clone());
 
         // Let the updater know when we're ready to wait
         let mut state = testdata.state.lock();
diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
index 7e253b6f299ce..a872f9fffb902 100644
--- a/rust/kernel/workqueue.rs
+++ b/rust/kernel/workqueue.rs
@@ -67,7 +67,7 @@
 //! /// This method will enqueue the struct for execution on the system workqueue, where its value
 //! /// will be printed.
 //! fn print_later(val: Arc<MyStruct>) {
-//!     let _ = workqueue::system().enqueue(val);
+//!     let _ = workqueue::system_dfl().enqueue(val);
 //! }
 //! # print_later(MyStruct::new(42).unwrap());
 //! ```
@@ -121,11 +121,11 @@
 //! }
 //!
 //! fn print_1_later(val: Arc<MyStruct>) {
-//!     let _ = workqueue::system().enqueue::<Arc<MyStruct>, 1>(val);
+//!     let _ = workqueue::system_dfl().enqueue::<Arc<MyStruct>, 1>(val);
 //! }
 //!
 //! fn print_2_later(val: Arc<MyStruct>) {
-//!     let _ = workqueue::system().enqueue::<Arc<MyStruct>, 2>(val);
+//!     let _ = workqueue::system_dfl().enqueue::<Arc<MyStruct>, 2>(val);
 //! }
 //! # print_1_later(MyStruct::new(24, 25).unwrap());
 //! # print_2_later(MyStruct::new(41, 42).unwrap());
@@ -171,13 +171,13 @@
 //! /// This method will enqueue the struct for execution on the system workqueue, where its value
 //! /// will be printed 12 jiffies later.
 //! fn print_later(val: Arc<MyStruct>) {
-//!     let _ = workqueue::system().enqueue_delayed(val, 12);
+//!     let _ = workqueue::system_dfl().enqueue_delayed(val, 12);
 //! }
 //!
 //! /// It is also possible to use the ordinary `enqueue` method together with `DelayedWork`. This
 //! /// is equivalent to calling `enqueue_delayed` with a delay of zero.
 //! fn print_now(val: Arc<MyStruct>) {
-//!     let _ = workqueue::system().enqueue(val);
+//!     let _ = workqueue::system_dfl().enqueue(val);
 //! }
 //! # print_later(MyStruct::new(42).unwrap());
 //! # print_now(MyStruct::new(42).unwrap());
@@ -1024,20 +1024,32 @@ unsafe impl<T, const ID: u64> RawDelayedWorkItem<ID> for ARef<T>
 {
 }
 
-/// Returns the system work queue (`system_wq`).
+/// Returns the system per-cpu work queue (`system_percpu_wq`).
 ///
 /// It is the one used by `schedule[_delayed]_work[_on]()`. Multi-CPU multi-threaded. There are
 /// users which expect relatively short queue flush time.
 ///
 /// Callers shouldn't queue work items which can run for too long.
-pub fn system() -> &'static Queue {
-    // SAFETY: `system_wq` is a C global, always available.
-    unsafe { Queue::from_raw(bindings::system_wq) }
+#[inline]
+pub fn system_percpu() -> &'static Queue {
+    // SAFETY: `system_percpu_wq` is a C global, always available.
+    unsafe { Queue::from_raw(bindings::system_percpu_wq) }
+}
+
+/// Returns the system default (unbound) work queue (`system_dfl_wq`).
+///
+/// Workers are not bound to any specific CPU, not concurrency managed, and all queued work items
+/// are executed immediately as long as `max_active` limit is not reached and resources are
+/// available.
+#[inline]
+pub fn system_dfl() -> &'static Queue {
+    // SAFETY: `system_dfl_wq` is a C global, always available.
+    unsafe { Queue::from_raw(bindings::system_dfl_wq) }
 }
 
 /// Returns the system high-priority work queue (`system_highpri_wq`).
 ///
-/// It is similar to the one returned by [`system`] but for work items which require higher
+/// It is similar to the one returned by [`system_percpu`] but for work items which require higher
 /// scheduling priority.
 pub fn system_highpri() -> &'static Queue {
     // SAFETY: `system_highpri_wq` is a C global, always available.
@@ -1046,26 +1058,16 @@ pub fn system_highpri() -> &'static Queue {
 
 /// Returns the system work queue for potentially long-running work items (`system_long_wq`).
 ///
-/// It is similar to the one returned by [`system`] but may host long running work items. Queue
-/// flushing might take relatively long.
+/// It is similar to the one returned by [`system_percpu`] but may host long running work items.
+/// Queue flushing might take relatively long.
 pub fn system_long() -> &'static Queue {
     // SAFETY: `system_long_wq` is a C global, always available.
     unsafe { Queue::from_raw(bindings::system_long_wq) }
 }
 
-/// Returns the system unbound work queue (`system_unbound_wq`).
-///
-/// Workers are not bound to any specific CPU, not concurrency managed, and all queued work items
-/// are executed immediately as long as `max_active` limit is not reached and resources are
-/// available.
-pub fn system_unbound() -> &'static Queue {
-    // SAFETY: `system_unbound_wq` is a C global, always available.
-    unsafe { Queue::from_raw(bindings::system_unbound_wq) }
-}
-
 /// Returns the system freezable work queue (`system_freezable_wq`).
 ///
-/// It is equivalent to the one returned by [`system`] except that it's freezable.
+/// It is equivalent to the one returned by [`system_percpu`] except that it's freezable.
 ///
 /// A freezable workqueue participates in the freeze phase of the system suspend operations. Work
 /// items on the workqueue are drained and no new work item starts execution until thawed.
@@ -1078,7 +1080,7 @@ pub fn system_freezable() -> &'static Queue {
 ///
 /// It is inclined towards saving power and is converted to "unbound" variants if the
 /// `workqueue.power_efficient` kernel parameter is specified; otherwise, it is similar to the one
-/// returned by [`system`].
+/// returned by [`system_percpu`].
 pub fn system_power_efficient() -> &'static Queue {
     // SAFETY: `system_power_efficient_wq` is a C global, always available.
     unsafe { Queue::from_raw(bindings::system_power_efficient_wq) }
@@ -1097,7 +1099,7 @@ pub fn system_freezable_power_efficient() -> &'static Queue {
 
 /// Returns the system bottom halves work queue (`system_bh_wq`).
 ///
-/// It is similar to the one returned by [`system`] but for work items which
+/// It is similar to the one returned by [`system_percpu`] but for work items which
 /// need to run from a softirq context.
 pub fn system_bh() -> &'static Queue {
     // SAFETY: `system_bh_wq` is a C global, always available.
-- 
2.53.0



