Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829255;
	b=j2WLNpniaS5OUz8WtZKEVP2K9OIz8Sq/ggflCRRcYxx4nCrhW1SDzGUlytLyE3C/dhuC
	 7Y2UYcasKSy8e4eTHmFV82pyNTtnVAax+Rw8tHqDHcIsh251sKTD06E/qaoKU5rQKzwHO
	 m3X/2MZThav5dJqWrvEcCzTC/oF2JBlef/vlmx9Lo9h5CP0K8+QYIT6hr7HUVtdntuZAY
	 rUFaErxOWMGxXn3cclUw88qul4At7rbVmMTgWjvJe5fMBSsSmfoOY+09R/TNJvgmH0qoo
	 xZDEP4BEjeIHCsmqCDC/hlBCZS0ABjenXc9fw2/gITLq3iHGK+NY+xS7Hfsy1uzJhAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a2vR7iTrenYGvJV6yNbn0WVMu8pJ3+/YekoEV15Xei0=;
	b=ixE+LUm0ZdugQK2X23ZjTEoJCxs3i8WsmCSCOgdGBrZOYQUiuUv3Vu/TPZkc6hfE/0i1
	 yFWuG2pWO1I6hl5IKjFDMQ5RHCZWeDC7tjJ4u/YeS8IzfxnUCYAal+J4NfuG7/6ZYUsyi
	 egFfr8NzfrSa+qS+Iso4FA3eY6C0wYGNt3p8VCC/lgvYE7NAg0m6Kw03gUp6GwLxUTKuj
	 HcHrVC7urQ7t3+3avgbPhbkTMB1jNJmlpCiKGtH9qXp4SV9+XpNHrtX/ZedlltcD3pI17
	 8jCZY64vOfEt57uMXU8m9ZKwd1Xoj9GsxjusC+SHyLAVTHlO3ZJLHMimIsJPwZHJyZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zS0g3Vc8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6108F606EE81;
	Wed,  4 Nov 2026 21:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zS0g3Vc8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030D31F000C1;
	Wed,  4 Nov 2026 21:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829255;
	bh=a2vR7iTrenYGvJV6yNbn0WVMu8pJ3+/YekoEV15Xei0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zS0g3Vc8ixQLgXV+VYTtfZRWG7I0Ig/56t8ydmX4lIVKktpkuIeL2OhGiV4XNsWh1
	 ziugmnzJRh4W2IE4jAKMSe/JDAn746b+bgjUucYCA8B/ixuCm+6ywpPqMQyWKblw8f
	 VAmjJ0h1NLCV2dXC6jy5dKr1iZ+6GfUYU1m5kke8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Poil Zero <poilandgginchi@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 545/547] rust_binder: wake epoll on self-work queued to poll thread
Date: Wed,  4 Nov 2026 16:12:09 -0500
Message-ID: <20261104211053.889978551@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

[ Upstream commit 985955d8e6b2b15cfd65b7ac6893e3a5a90c5870 ]

When a thread pushes work to its own todo list, InnerThread::push_work()
returns PushWorkRes::OkNotifyPoll if the thread uses epoll, but four
call sites in thread.rs discard this return value. As a result, a
non-blocking BC_* write that enqueues work onto the calling thread's
todo list without also reading will not wake epoll. Check the return
value and call self.process.notify_poll(false) when
PushWorkRes::OkNotifyPoll is returned.

This is similar to commit 97830f3c3088 ("binder: signal epoll threads of
self-work"), but in C Binder pending thread work also prevented
subsequent process work from waking epoll, causing a permanent hang,
which is not the case in Rust Binder. This means that in practice, it
merely delays notifications rather than completely failing to send them.

Cc: stable@kernel.org
Fixes: dbb17c9ea756 ("rust_binder: move (e)poll wait queue to Process")
Reported-by: Poil Zero <poilandgginchi@gmail.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20261016-binder-poll-self-work-v1-1-c29c87d99abb@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: adapted reply_inner() to unconditional immediate completion because TransactionFlag::DeferComplete is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder/thread.rs |   38 +++++++++++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 11 deletions(-)

--- a/drivers/android/binder/thread.rs
+++ b/drivers/android/binder/thread.rs
@@ -344,13 +344,13 @@ impl InnerThread {
         }
     }
 
-    fn push_return_work(&mut self, reply: u32) {
+    fn push_return_work(&mut self, reply: u32) -> PushWorkRes {
         if let Ok(work) = ListArc::try_from_arc(self.return_work.clone()) {
             work.set_error_code(reply);
-            // Not notifying: Reply to current thread.
-            let _ = self.push_work(work);
+            self.push_work(work)
         } else {
             pr_warn!("Thread return work is already in use.");
+            PushWorkRes::Ok
         }
     }
 
@@ -669,8 +669,12 @@ impl Thread {
     pub(crate) fn push_work_if_looper(&self, work: DLArc<dyn DeliverToRead>) -> BinderResult {
         let mut inner = self.inner.lock();
         if inner.is_looper() && !inner.is_dead {
-            // Not notifying: Reply to current thread.
-            let _ = inner.push_work(work);
+            // Not notifying work_condvar: Reply to current thread.
+            let res = inner.push_work(work);
+            drop(inner);
+            if matches!(res, PushWorkRes::OkNotifyPoll) {
+                self.process.notify_poll(false);
+            }
             Ok(())
         } else {
             drop(inner);
@@ -683,7 +687,11 @@ impl Thread {
     }
 
     pub(crate) fn push_return_work(&self, reply: u32) {
-        self.inner.lock().push_return_work(reply);
+        // Not notifying work_condvar: Reply to current thread.
+        let res = self.inner.lock().push_return_work(reply);
+        if matches!(res, PushWorkRes::OkNotifyPoll) {
+            self.process.notify_poll(false);
+        }
     }
 
     pub(crate) fn pop_work_even_if_deferred(&self) -> Option<DLArc<dyn DeliverToRead>> {
@@ -1416,8 +1424,11 @@ impl Thread {
             let process = orig.from.process.clone();
             let allow_fds = orig.flags.contains(TransactionFlag::AcceptFds);
             let reply = Transaction::new_reply(self, process, info, allow_fds)?;
-            // Not notifying: Reply to current thread.
-            let _ = self.inner.lock().push_work(completion);
+            // Not notifying work_condvar: Reply to current thread.
+            let res = self.inner.lock().push_work(completion);
+            if matches!(res, PushWorkRes::OkNotifyPoll) {
+                self.process.notify_poll(false);
+            }
             orig.from.deliver_reply(Ok(reply), &orig, None);
             Ok(())
         })()
@@ -1456,10 +1467,15 @@ impl Thread {
         let list_completion =
             DTRWrap::arc_try_new(DeliverCode::new(code, self.process.task.pid()))?;
         let completion = list_completion.clone_arc();
-        // Not notifying: Reply to current thread.
-        let _ = self.inner.lock().push_work(list_completion);
+        // Not notifying work_condvar: Reply to current thread.
+        let res = self.inner.lock().push_work(list_completion);
         match transaction.submit(info) {
-            Ok(()) => Ok(()),
+            Ok(()) => {
+                if matches!(res, PushWorkRes::OkNotifyPoll) {
+                    self.process.notify_poll(false);
+                }
+                Ok(())
+            }
             Err(err) => {
                 completion.skip();
                 Err(err)


