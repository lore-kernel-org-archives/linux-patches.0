Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043732;
	b=3/W8WT7qtVaOljY2yZvaQTtxQe0LawMK+f5FXsrPkdUBkP22vmI+Z9J6hrKqMsaBIAw8
	 TATDCFIiz5PHf/PqKPReDze8WNsXGvA+rhvCqrw5AAVu0bNk7yb8Q4u12NhCb+ci44X38
	 YmBw+ivfIrPSUvLnDIqIXeyCn4wV9xJ9eVqj0DX8WbGzLYhS0N1vG5CjZoL+26LLwpnRj
	 quuJc+WSL4H7rlgF5Bq1Lh4Dgz29suLmp3VF2/rdf+iRFJ1qS0vMxM3zKCJFODfR7kGt3
	 ObAydQjWHZQnFAjK3YCtv1e/ST4kEc9H0a5ig8zTbvjqgdMoiQAPQNpK067j5oAec9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BKDhUcQf9Swm65JdrfwAoD1R996QRQPNujAGtWWCzhs=;
	b=oo/FYjfLr7yY4Y4e9GLP2cVcI9v73i7mhnnYcIwGvFRc4qRiROWZGPmH7ODqmBhQdy7T
	 5LgXX/Ov4xnVXwHt+AtzuvdICtcXO0bbYy1KXvh/3hv4p2e7qaa5qiqcqTxAR3HXPpEmt
	 3+s6w1i58tOE2BLdvVfsJAz/jG35AdTuLoGVkftUaH35+IHCnIj0V9REaMEKBsgTUnhJA
	 0fgyy4E77pi4l3nhXC9uXo8GL+PfynGSLIM6/HhdzLxFWTfgQDNr9l7C7r924DCDiUPCl
	 IMqQaOTkQvXufrOlkHL1YRhBqMVK9EM7vuwoZ5EKcBSMnTqWWyairi4JhHwOsUlbWeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DDTk1bOM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1754606A32A;
	Wed, 18 Nov 2026 23:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DDTk1bOM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8321F000C4;
	Wed, 18 Nov 2026 23:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043732;
	bh=BKDhUcQf9Swm65JdrfwAoD1R996QRQPNujAGtWWCzhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DDTk1bOMlqYzumT/NPhkrq3NbItM7MrGfF51RGry8GyI4ijtNn2D93gSTOMf39kIa
	 r/5udcSYfMirRob+VjLiRnOgUh0OD+m1f0ch220kutFwSvsBx8SLKSz6X3CN3P+Mk9
	 7IfzncDQrbJ37bYI3sOL9v2AzgT/5KiGsQ6y6Jvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	jjzuming@gmail.com
Subject: [PATCH 6.1 0314/2857] ocfs2/dlm: drain join handlers before releasing module text
Date: Wed, 18 Nov 2026 15:22:28 +0100
Message-ID: <20261118150212.748243451@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

commit 28f366d84023651e50e32e29931401ba0df3e679 upstream.

The code for a registered DLM handler must remain resident until its
last invocation finishes. dlm_unregister_net_handlers() only removes
dlm_join_handlers from the o2net registry. o2net_handler_get() takes a
kref on the wrapper, but that reference does not pin ocfs2_dlm text.
o2net_process_message() calls nh_func after dropping o2net_handler_lock.

With CONFIG_OCFS2_FS_O2CB=m, ocfs2_dlm can be loaded independently of
ocfs2_stack_o2cb while nodemanager continues handling messages from a
configured, heartbeating peer. If no dependent module or module reference
prevents normal unload, the following ordering is possible:

  Receive worker                       Module unload
  --------------                       -------------
  o2net_handler_get()
    take wrapper kref
    drop handler lock
  <preempted>
                                       dlm_exit()
                                         unregister handlers
                                       release DLM module text
  call saved nh_func
    in released module text

Use o2net_unregister_and_flush_handler_list() in the shared DLM
unregister helper. It first prevents new lookups, then waits for the
ordered o2net workqueue to drain, including a concurrent destruction of
that queue. The acquired invocation therefore finishes before dlm_exit()
returns and the loader releases the callback code. The same helper
covers partial registration and dlm_init() error unwind before module
memory is released.

Skip the drain when the private join-handler list is empty. Early
dlm_init() failures can reach this helper before any handler has been
published. Partial-registration failure also reaches it a second time
after the first call has already unregistered and drained the list.
Neither case needs to take o2net_wq_mutex or drain unrelated work.
The list is changed only by serialized module init/exit paths; a
nonempty list still uses the full unregister-and-flush helper.

Oops report as below:

    Oops: int3: 0000 [#1] SMP KASAN NOPTI
    CPU: 2 UID: 0 PID: 54 Comm: kworker/u16:3 Not tainted 7.3.0-rc4-next-20260921-pmb-ocfs2-functional-v1+ #1 PREEMPT(lazy)

Hardware identification omitted.

    Workqueue: o2net o2net_rx_until_empty [ocfs2_nodemanager]
    RIP: 0010:0xffffffffc0423871
    [Instruction byte dump omitted.]

Register dump omitted.

    Call Trace:
     <TASK>
     ? o2net_rx_until_empty+0x19b1/0x3300 [ocfs2_nodemanager]
     ? __pfx_o2net_rx_until_empty+0x10/0x10 [ocfs2_nodemanager]
     ? lock_acquire+0x190/0x300
     ? process_one_work+0x935/0x1b40
     ? process_one_work+0x834/0x1b40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x290
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? process_one_work+0x9a8/0x1b40
     ? __pfx_process_one_work+0x10/0x10
     ? lock_acquire+0x190/0x300
     ? lock_is_held_type+0x8f/0x100
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? worker_thread+0x65c/0xe40
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __kthread_parkme+0x177/0x220
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_worker_thread+0x10/0x10
     ? kthread+0x351/0x460
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_kthread+0x10/0x10
     ? ret_from_fork+0x659/0x940
     ? __pfx_ret_from_fork+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __switch_to+0x74f/0xf70
     ? __pfx_kthread+0x10/0x10
     ? ret_from_fork_asm+0x1a/0x30
     </TASK>
    Modules linked in: ocfs2_nodemanager [last unloaded: ocfs2_dlm]
    ---[ end trace 0000000000000000 ]---

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0076-v6-12de5f4628f57fba3be3@gmail.com
Fixes: 6714d8e86bf4 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/dlm/dlmdomain.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -2217,7 +2217,8 @@ static LIST_HEAD(dlm_join_handlers);
 
 static void dlm_unregister_net_handlers(void)
 {
-	o2net_unregister_handler_list(&dlm_join_handlers);
+	if (!list_empty(&dlm_join_handlers))
+		o2net_unregister_and_flush_handler_list(&dlm_join_handlers);
 }
 
 static int dlm_register_net_handlers(void)


