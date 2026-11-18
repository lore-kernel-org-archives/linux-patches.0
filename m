Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059174;
	b=DcEh2IBAWJ8w6Pz+ieGL4Cbfj6PvQGrkkOtByOeUsRpF8E83kLXLZU//MZRegYz355nN
	 E1ixSS6qVRJ5yF9il8P2ZBU+jcXhKXGgKTR1gi+998mzOlQkMVdF9O+6v/D7VpVvzFPOD
	 FnPBOa3am67ySjyFg/jEXZD6UeC7tYC7pooB6nVuFwUMAKx6HNMkDY/QtgG7WN4+N2BBV
	 Ankz9YdkUebxIo6N4sQ/boN19CQ3oM9PCN0dyMMyFoN8Hp4H9Xy9yiQMZMCtqIEvV6Qf3
	 orS0rnwjj46QKEGCaOgYAv/mQ1M6TLAqDPVURtZiYQsIuwxAylWjB71DIySB8z6lSFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ceNVYRvHw0ULzpCgOsbhDInxQ1g4L740tp4Sl6k8Fuw=;
	b=dFmqbXoTouc2WNdUJhKu3Pi6ataPJmQ+Ez6kP0aTJEWgMJuFekEic/kfGTmWjElLHjGK
	 ipeUY7P6ElWmHLwNoGanTe9ItS4pLlxLU419scxO57AIT1kWlrr4c4eKfJFAxVvu5fbVb
	 HGjbqab/8zgfQVMGOn7E3klYdnmV5mepxIdczkRmsnVCXLw4bLA1h0ePr866Qb+5IrEzd
	 v5nipoyxKbgQK41khDl5/G5GugUCHqCnsZ3kDF388CXI7TF//kKVGIXo33L9MUUNTIR4h
	 mVTE0xzWFVHpWPQ5t/MPgwK6L6r+GFy7X+ljcVmx18VP47Wc149o9gQ9Kkr2oY8wHvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y0zWhrd4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60093606A33D;
	Thu, 19 Nov 2026 03:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y0zWhrd4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAED1F000C4;
	Thu, 19 Nov 2026 03:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059174;
	bh=ceNVYRvHw0ULzpCgOsbhDInxQ1g4L740tp4Sl6k8Fuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y0zWhrd4nLU12lgtrul+g7zI/6D7fhU44s8s0w7QnUkrR2Y+nGUDV3+XvfA8u/2gu
	 r2BUud94aKIHH3ERO21TOIrklrzFnYqv5XKle7iR2QpX1mwTYgIq72+Ax4bvnu7c/Q
	 ndDWUGTXlvI/C3WxPNzgDKxeCdI0XDCc8uKcEJIw=
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
	jjzuming@gmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0711/1848] ocfs2: keep locking_state within the cluster connection lifetime
Date: Wed, 18 Nov 2026 15:45:49 +0100
Message-ID: <20261118145945.644944390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 5bdef466851e39ba752634cbea68e5ea24ccfb24 ]

The locking_state reader calls ocfs2_dlm_lvb() through the selected
cluster stack.  Its debug-object reference keeps the tracking list alive,
but does not keep that stack selected without a cluster connection.

DLM initialization publishes the file before establishing its connection,
and DLM shutdown drops the connection while the file still exists.  Both
the mount error unwind in ocfs2_mount_volume() and ocfs2_dismount_volume()
remove the debugfs subtree only after ocfs2_dlm_shutdown() has returned.
Whenever the disconnect releases the last stack reference, which is the
case for a failed mount and for any unmount without a pending hangup, a
concurrent reader dereferences a NULL active_stack:

  Mount error unwind                  Debugfs reader
  ------------------                  --------------
  ocfs2_mount_volume(): out_dlm
    ocfs2_dlm_shutdown()
      disconnect last cluster
        clear active_stack
                                      read locking_state
                                        ocfs2_dlm_seq_show()
                                          ocfs2_dlm_lvb()
                                            dereference active_stack
  fill_super(): out_debugfs
    remove debugfs subtree

Publish the debug files only after the connection and the mount lock
resources are initialized, so a failed DLM initialization has no debug
reference to drop.  Remove them again in the common DLM shutdown helper
before the connection is dropped: debugfs removal waits for readers that
are inside the file operations, and the parent directory is still present
at that point in every caller.  This covers the mount error unwind, the
ocfs2_fill_super() failures after a successful mount that dismount with
mnt_err set, and unmounts whose disconnect releases the stack directly.

Only the relevant frames of the report are kept:

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
RIP: 0010:ocfs2_dlm_lvb+0x38/0xf0
Call Trace:
 <TASK>
 ocfs2_dlm_seq_show+0x36a/0xb70
 seq_read_iter+0x480/0x1110
 seq_read+0x362/0x5a0
 full_proxy_read+0x11f/0x180
 vfs_read+0x1a0/0xc20
 ksys_read+0x111/0x200
 </TASK>

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0011-v7-61e3ef8b1ad44ac2e817@gmail.com
Fixes: 286eaa95c5c5 ("ocfs2: Break out stackglue into modules.")
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/dlmglue.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index a8ec22045ccaa..63c5312a5ed58 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3330,6 +3330,14 @@ static void ocfs2_dlm_shutdown_debug(struct ocfs2_super *osb)
 {
 	struct ocfs2_dlm_debug *dlm_debug = osb->osb_dlm_debug;
 
+	/*
+	 * Drain the readers before the cluster stack goes away: the
+	 * locking_state reader resolves ocfs2_dlm_lvb() through the
+	 * stack. Every caller removes the parent directory later.
+	 */
+	debugfs_lookup_and_remove("locking_state", osb->osb_debug_root);
+	debugfs_lookup_and_remove("locking_filter", osb->osb_debug_root);
+
 	if (dlm_debug)
 		ocfs2_put_dlm_debug(dlm_debug);
 }
@@ -3344,8 +3352,6 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 		goto local;
 	}
 
-	ocfs2_dlm_init_debug(osb);
-
 	/* launch downconvert thread */
 	osb->dc_task = kthread_run(ocfs2_downconvert_thread, osb, "ocfs2dc-%s",
 			osb->uuid_str);
@@ -3385,9 +3391,10 @@ int ocfs2_dlm_init(struct ocfs2_super *osb)
 	ocfs2_orphan_scan_lock_res_init(&osb->osb_orphan_scan.os_lockres, osb);
 
 	osb->cconn = conn;
+	if (conn)
+		ocfs2_dlm_init_debug(osb);
 bail:
 	if (status < 0) {
-		ocfs2_dlm_shutdown_debug(osb);
 		if (osb->dc_task)
 			kthread_stop(osb->dc_task);
 	}
@@ -3417,10 +3424,11 @@ void ocfs2_dlm_shutdown(struct ocfs2_super *osb,
 	ocfs2_lock_res_free(&osb->osb_orphan_scan.os_lockres);
 
 	if (osb->cconn) {
+		/* The disconnect below may release the selected stack. */
+		ocfs2_dlm_shutdown_debug(osb);
+
 		ocfs2_cluster_disconnect(osb->cconn, hangup_pending);
 		osb->cconn = NULL;
-
-		ocfs2_dlm_shutdown_debug(osb);
 	}
 }
 
-- 
2.53.0



