Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035587;
	b=x/oncLGNfiNCxTkNE2XFP+GVSBXgV2+BeH7xAUmJ/UewxfZNp3UROKm/0SAVNgTZX5bd
	 DVr7g300dRgF4HN+tdIUmZkEwomifhVsg+l2z/fogCqGhIq5QuHnBb70cmeZia/GUip05
	 tMPG/pXDjiu1+4w8nyqt/msu256fwYwtadXDc2qd1k7qH2N2yCMfDJeKIx8fWkXT1AIVU
	 N5mvYreRCDC4blHc4YTtEZ1wNzklEor6SynDwPLMy2y3OOPFb2NI776mvX21m4Svj98ao
	 S1U+iQK9+SKTOK+O/ooWgGo60pGaJwwL1F42B0wp7BHn8tzOphXEyNbEbTA1ZwdFU2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a8CCAO6YErk4CvVbxTrydE8UiK7M/lU8xDvYZ9EtSKs=;
	b=5evC8fIi1FkzQYiIYcjiy9x3qVB/TuHnYi5//oj5fisSCUAWDp+EZvyrNRKAGwSsI3c4
	 +VgenmTf4QRUFjEPPqoIBnH6DhEq63PSqAEUmDaEuAn131iMixWtFiIhHCr1G3SlA7ymV
	 FYWlN138yYjqFSjVvxZWT97fXcmtu3d52XE7fG4gKx1Pfpb3OupSMOiJZZtCGq60yObin
	 gfWHpfyayVTBaIujt39sr7uaot6GfgYvWskGgklIAOXaBL2NJeDNQZN9KarOkR3Bhtuqy
	 m99xyqNRaBDXOVuoPV1Z2FgELNv8snBdhs/GqxRVHiOopafQEJjm7cwV+wqK6Tahfaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D0Cg5QVh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E548606A31C;
	Wed, 18 Nov 2026 20:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D0Cg5QVh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E5BE1F000C4;
	Wed, 18 Nov 2026 20:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035586;
	bh=a8CCAO6YErk4CvVbxTrydE8UiK7M/lU8xDvYZ9EtSKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D0Cg5QVhuII1fS2t+wsEZZ0imPkqlCu/w1VB7rWRFUJBpcV7CIqg5cb5aEAqftrLp
	 8cHkFIz68FdCu/8kpxyD+xjWMnDPuI5CUZ0CIl5mRhCZkozQ7tAZ5wYIRXsVAO+I5E
	 rF6ditci8J3HXHH8/RlzXxQJ4xQ5VJ5TT1JDTMUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <fredric.cover.lkernel@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0758/3318] smb: client: fix early procfs exposure race
Date: Wed, 18 Nov 2026 15:23:00 +0100
Message-ID: <20261118150341.430212614@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fredric Cover <fredric.cover.lkernel@gmail.com>

[ Upstream commit 7b1afb631395c958993cda4631002258ef4151ea ]

Currently, init_cifs() calls cifs_proc_init() near the beginning of
the function, before INIT_LIST_HEAD, leading to a momentarily
uninitialized, but exposed, procfs. If a userspace process reads this
empty procfs, iterating over a zeroed list_head leads to a NULL
pointer dereference and a kernel oops/panic.

For example, if a delay is added between cifs_proc_init() and
INIT_LIST_HEAD, and a userspace process is polling
/proc/fs/cifs/DebugData, the following oops occurs:

BUG: kernel NULL pointer dereference, address: 0000000000000608
Oops: Oops: 0000 [#1] SMP PTI
CPU: 0 UID: 0 PID: 3477 Comm: cat Not tainted
7.3.0-02212-g4df4d2a577db-dirty #6 PREEMPT(lazy)
RIP: 0010:cifs_debug_data_proc_show+0x103/0xd80 [cifs]
Call Trace:
<TASK>
 ? seq_read_iter+0x86/0x400
 ? seq_read_iter+0x86/0x400
 seq_read_iter+0x183/0x400
 proc_reg_read_iter+0x62/0x90
 copy_splice_read+0x215/0x310
 splice_file_to_pipe+0xec/0x1c0
 do_splice+0x4b8/0x780
 __se_sys_splice+0x18f/0x250
 do_syscall_64+0x109/0x330
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
</TASK>

Fix this by moving cifs_proc_init() down in init_cifs(), ensuring it runs
only after all internal lists, locks, counters, and workqueues are fully
ready, but before registering the filesystem. Update the error cleanup
ladder and exit_cifs() to maintain proper LIFO order.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ sashal: adjusted init_cifs() context for different initialization code and workqueue allocation without WQ_PERCPU ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 700dd3005ba89..fb7ae74bf0d51 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1859,7 +1859,6 @@ static int __init
 init_cifs(void)
 {
 	int rc = 0;
-	cifs_proc_init();
 	INIT_LIST_HEAD(&cifs_tcp_ses_list);
 /*
  *  Initialize Global counters
@@ -1908,10 +1907,8 @@ init_cifs(void)
 	}
 
 	cifsiod_wq = alloc_workqueue("cifsiod", WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
-	if (!cifsiod_wq) {
-		rc = -ENOMEM;
-		goto out_clean_proc;
-	}
+	if (!cifsiod_wq)
+		return -ENOMEM;
 
 	/*
 	 * Consider in future setting limit!=0 maybe to min(num_of_cores - 1, 3)
@@ -1994,19 +1991,22 @@ init_cifs(void)
 	if (rc)
 		goto out_cifs_swn_init;
 
+	cifs_proc_init();
+
 	rc = register_filesystem(&cifs_fs_type);
 	if (rc)
-		goto out_init_cifs_idmap;
+		goto out_clean_proc;
 
 	rc = register_filesystem(&smb3_fs_type);
 	if (rc) {
 		unregister_filesystem(&cifs_fs_type);
-		goto out_init_cifs_idmap;
+		goto out_clean_proc;
 	}
 
 	return 0;
 
-out_init_cifs_idmap:
+out_clean_proc:
+	cifs_proc_clean();
 	exit_cifs_idmap();
 out_cifs_swn_init:
 #ifdef CONFIG_CIFS_SWN_UPCALL
@@ -2040,8 +2040,6 @@ init_cifs(void)
 	destroy_workqueue(decrypt_wq);
 out_destroy_cifsiod_wq:
 	destroy_workqueue(cifsiod_wq);
-out_clean_proc:
-	cifs_proc_clean();
 	return rc;
 }
 
@@ -2051,6 +2049,7 @@ exit_cifs(void)
 	cifs_dbg(NOISY, "exit_smb3\n");
 	unregister_filesystem(&cifs_fs_type);
 	unregister_filesystem(&smb3_fs_type);
+	cifs_proc_clean();
 	cifs_release_automount_timer();
 	exit_cifs_idmap();
 #ifdef CONFIG_CIFS_SWN_UPCALL
@@ -2072,7 +2071,6 @@ exit_cifs(void)
 	destroy_workqueue(serverclose_wq);
 	destroy_workqueue(cfid_put_wq);
 	destroy_workqueue(cifsiod_wq);
-	cifs_proc_clean();
 }
 
 MODULE_AUTHOR("Steve French");
-- 
2.53.0



