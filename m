Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213960;
	b=GCz6v2eMQIcfz9ntZJCAHPvchudhw7nmc1N/KBGxywXxMilPuiRugjfJx3pMog2VT+1q
	 mX+UHxFm2rjQSEq67FewfWGIKLv4q/tS7JSviLmt+nxaDCjd2cb8HtmrTOMLg/OYN0HUM
	 g7Hh9FlseIvbi+lfFb8k0gl00LVg7Mdt0DypVq6B4+Y9Gc+aSIG+C/wCkQASg1O95MZs1
	 4BMM3vkd6YA30l5Y6mFLk8pHA/PhPAe926+8HjzgENU9sj5xACm78E9wo4EqUylZ3Cu1t
	 uE5tCh7KsSHLbor0PZ6RFTmq4DVv5fjpM5msWYCh6QTBBQkX+TACnlfGRU0p+O2s3lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HBnYQ3/59Or5Yk8e1zxFt9m5i/MNiRVfb7JWWI2Mino=;
	b=jGYAHBzQzp5Y/UBoX+wjkgbun0v69W6YRF3JXs5NrDsfB1NslBnKx9sWDbx8a2Y3jvwl
	 aDiFtAFW5KxUnKQ+ZN4BjWzB3gcuGsBbER5MNwWmfR8BthbNHpWApIela4FyBpfKovs9/
	 BqxsfcfhVNYq4CAf35nhrOZ1jP7NHAUpmPVr7t7N2CQcgL9XsPGoXqp2r7nJnvBxhxhEY
	 26hpDyM+KF69Bi0IzPSd2tZrbTqDHr1GjICGCn0cRi/ty4Qdtqhwm369B/yMiF+rM6TpK
	 Eau5cVFqQXi8OLe99EZuuTMFbZDg4r1Curtf7X3o+geELpdVgBq1MSiRugq5nfGUM8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p6XFD7lS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0A7606A31A;
	Wed, 28 Oct 2026 18:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p6XFD7lS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2B81F01825;
	Wed, 28 Oct 2026 18:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213959;
	bh=HBnYQ3/59Or5Yk8e1zxFt9m5i/MNiRVfb7JWWI2Mino=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p6XFD7lSYhBxtsvXWr14VnVBsxcyJdMHIlHNmiXbubOu1GyigHGELyQAxuq5krizB
	 q5TFhLdHCgCEvBjdInU9dMb+JPg1/kh2V2Oql97CnAGmT9h/NSLYtZsItKldhu3+PW
	 h7zLvcrORBqLO2oCuCf5IqCW5lFcAS3+uU8Halnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0690/1887] afs: Fix lock recursion
Date: Wed, 28 Oct 2026 17:46:26 +0100
Message-ID: <20261028170515.114466619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 610a79ffea02102899a1373fe226d949944a7ed6 ]

afs_wake_up_async_call() can incur lock recursion.  The problem is that it
is called from AF_RXRPC whilst holding the ->notify_lock, but it tries to
take a ref on the afs_call struct in order to pass it to a work queue - but
if the afs_call is already queued, we then have an extraneous ref that must
be put... calling afs_put_call() may call back down into AF_RXRPC through
rxrpc_kernel_shutdown_call(), however, which might try taking the
->notify_lock again.

This case isn't very common, however, so defer it to a workqueue.  The oops
looks something like:

  BUG: spinlock recursion on CPU#0, krxrpcio/7001/1646
   lock: 0xffff888141399b30, .magic: dead4ead, .owner: krxrpcio/7001/1646, .owner_cpu: 0
  CPU: 0 UID: 0 PID: 1646 Comm: krxrpcio/7001 Not tainted 6.12.0-rc2-build3+ #4351
  Hardware name: ASUS All Series/H97-PLUS, BIOS 2306 10/09/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x47/0x70
   do_raw_spin_lock+0x3c/0x90
   rxrpc_kernel_shutdown_call+0x83/0xb0
   afs_put_call+0xd7/0x180
   rxrpc_notify_socket+0xa0/0x190
   rxrpc_input_split_jumbo+0x198/0x1d0
   rxrpc_input_data+0x14b/0x1e0
   ? rxrpc_input_call_packet+0xc2/0x1f0
   rxrpc_input_call_event+0xad/0x6b0
   rxrpc_input_packet_on_conn+0x1e1/0x210
   rxrpc_input_packet+0x3f2/0x4d0
   rxrpc_io_thread+0x243/0x410
   ? __pfx_rxrpc_io_thread+0x10/0x10
   kthread+0xcf/0xe0
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x24/0x40
   ? __pfx_kthread+0x10/0x10
   ret_from_fork_asm+0x1a/0x30
   </TASK>

Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/r/1394602.1729162732@warthog.procyon.org.uk
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/internal.h |  2 ++
 fs/afs/rxrpc.c    | 79 ++++++++++++++++++++++++++++++++++-------------
 2 files changed, 59 insertions(+), 22 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index fd4310272ccc1..325be1d29a71e 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -99,6 +99,7 @@ struct afs_call {
 	wait_queue_head_t	waitq;		/* processes awaiting completion */
 	struct work_struct	async_work;	/* async I/O processor */
 	struct work_struct	work;		/* actual work processor */
+	struct work_struct	free_work;	/* Deferred free processor */
 	struct rxrpc_call	*rxcall;	/* RxRPC call handle */
 	struct key		*key;		/* security for this call */
 	struct afs_net		*net;		/* The network namespace */
@@ -1283,6 +1284,7 @@ extern int __net_init afs_open_socket(struct afs_net *);
 extern void __net_exit afs_close_socket(struct afs_net *);
 extern void afs_charge_preallocation(struct work_struct *);
 extern void afs_put_call(struct afs_call *);
+void afs_deferred_put_call(struct afs_call *call);
 extern void afs_make_call(struct afs_addr_cursor *, struct afs_call *, gfp_t);
 extern long afs_wait_for_call_to_complete(struct afs_call *, struct afs_addr_cursor *);
 extern struct afs_call *afs_alloc_flat_call(struct afs_net *,
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index a0715e5dc38d5..0658523bd7865 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -16,6 +16,7 @@
 
 struct workqueue_struct *afs_async_calls;
 
+static void afs_deferred_free_worker(struct work_struct *work);
 static void afs_wake_up_call_waiter(struct sock *, struct rxrpc_call *, unsigned long);
 static void afs_wake_up_async_call(struct sock *, struct rxrpc_call *, unsigned long);
 static void afs_process_async_call(struct work_struct *);
@@ -153,6 +154,7 @@ static struct afs_call *afs_alloc_call(struct afs_net *net,
 	call->debug_id = atomic_inc_return(&rxrpc_debug_id);
 	refcount_set(&call->ref, 1);
 	INIT_WORK(&call->async_work, afs_process_async_call);
+	INIT_WORK(&call->free_work, afs_deferred_free_worker);
 	init_waitqueue_head(&call->waitq);
 	spin_lock_init(&call->state_lock);
 	call->iter = &call->def_iter;
@@ -163,6 +165,34 @@ static struct afs_call *afs_alloc_call(struct afs_net *net,
 	return call;
 }
 
+static void afs_free_call(struct afs_call *call)
+{
+	struct afs_net *net = call->net;
+	int o;
+
+	ASSERT(!work_pending(&call->async_work));
+
+	if (call->rxcall) {
+		rxrpc_kernel_end_call(net->socket, call->rxcall);
+		call->rxcall = NULL;
+	}
+	if (call->type->destructor)
+		call->type->destructor(call);
+
+	afs_unuse_server_notime(call->net, call->server, afs_server_trace_put_call);
+	afs_put_addrlist(call->alist);
+	kfree(call->request);
+
+	o = atomic_read(&net->nr_outstanding_calls);
+	trace_afs_call(call->debug_id, afs_call_trace_free, 0, o,
+		       __builtin_return_address(0));
+	kfree(call);
+
+	o = atomic_dec_return(&net->nr_outstanding_calls);
+	if (o == 0)
+		wake_up_var(&net->nr_outstanding_calls);
+}
+
 /*
  * Dispose of a reference on a call.
  */
@@ -177,30 +207,34 @@ void afs_put_call(struct afs_call *call)
 	o = atomic_read(&net->nr_outstanding_calls);
 	trace_afs_call(debug_id, afs_call_trace_put, r - 1, o,
 		       __builtin_return_address(0));
+	if (zero)
+		afs_free_call(call);
+}
 
-	if (zero) {
-		ASSERT(!work_pending(&call->async_work));
-		ASSERT(call->type->name != NULL);
-
-		if (call->rxcall) {
-			rxrpc_kernel_end_call(net->socket, call->rxcall);
-			call->rxcall = NULL;
-		}
-		if (call->type->destructor)
-			call->type->destructor(call);
+static void afs_deferred_free_worker(struct work_struct *work)
+{
+	struct afs_call *call = container_of(work, struct afs_call, free_work);
 
-		afs_unuse_server_notime(call->net, call->server, afs_server_trace_put_call);
-		afs_put_addrlist(call->alist);
-		kfree(call->request);
+	afs_free_call(call);
+}
 
-		trace_afs_call(call->debug_id, afs_call_trace_free, 0, o,
-			       __builtin_return_address(0));
-		kfree(call);
+/*
+ * Dispose of a reference on a call, deferring the cleanup to a workqueue
+ * to avoid lock recursion.
+ */
+void afs_deferred_put_call(struct afs_call *call)
+{
+	struct afs_net *net = call->net;
+	unsigned int debug_id = call->debug_id;
+	bool zero;
+	int r, o;
 
-		o = atomic_dec_return(&net->nr_outstanding_calls);
-		if (o == 0)
-			wake_up_var(&net->nr_outstanding_calls);
-	}
+	zero = __refcount_dec_and_test(&call->ref, &r);
+	o = atomic_read(&net->nr_outstanding_calls);
+	trace_afs_call(debug_id, afs_call_trace_put, r - 1, o,
+		       __builtin_return_address(0));
+	if (zero)
+		schedule_work(&call->free_work);
 }
 
 static struct afs_call *afs_get_call(struct afs_call *call,
@@ -667,7 +701,8 @@ static void afs_wake_up_call_waiter(struct sock *sk, struct rxrpc_call *rxcall,
 }
 
 /*
- * wake up an asynchronous call
+ * Wake up an asynchronous call.  The caller is holding the call notify
+ * spinlock around this, so we can't call afs_put_call().
  */
 static void afs_wake_up_async_call(struct sock *sk, struct rxrpc_call *rxcall,
 				   unsigned long call_user_ID)
@@ -684,7 +719,7 @@ static void afs_wake_up_async_call(struct sock *sk, struct rxrpc_call *rxcall,
 			       __builtin_return_address(0));
 
 		if (!queue_work(afs_async_calls, &call->async_work))
-			afs_put_call(call);
+			afs_deferred_put_call(call);
 	}
 }
 
-- 
2.53.0



