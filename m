Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590848;
	b=fTdsZg7bK0g49FnjRSO4YkUBIyoTAUrLsgpZ0D4WZq2DsCyoH9c5wR3r5/sDQViTy8+z
	 GmDZbcofyDbzVFArOKyDSPFypvgEQcrvscoit9GoMSWClpiyctxQ8dLmnP6ieTtHGsEnF
	 B1BAm7y5+urZdf54LHgFKv7zh3sXvGueHBbxg+Y4UZ0L3AF532nhMq1XBVaq+JGyb9eSn
	 TXHpuwLAchmcV77PFD6uC6JcEYRyGQyszh5av/z7XTSSiC6/jrWkzhlaUK2lXh60cO+zq
	 J60Io3qrLtEYqJzAJQS+r+or2bdMjIqKKcp8B+ZZAiFGpONA60TIsiecftC6x0n3yTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FGrUuiFkxPn9kRFeIL3ct/k1OjrNRryaDQocvYRo8DQ=;
	b=rniyG747lockd3gYnrp/P3eiKyq2rMtrkkmpv5S/wFuW+IUku6UzMxh2BFJGpeO8XS6h
	 AtsYeGA+ZB5BEsg37hs2YHbXEYljDa0dqvo+/gLRd+VVr6Q/ovY3QzKDViOTcSqoaffh4
	 NMHUJUGP490YnhJ3ooqXRfI9S9Grei6Rbq3xBJzfQp2IrNzATzoIYBjXVBvdB2qLGo8zL
	 UPzUvjMJJMX8ChZlHN42CNsfkWQMY1N8MXo2z4aA7DBFGntTXXygRgHqfAzDFOUZ3TNos
	 xcMyzv2MPVMx5TljraDBDenEQ249gI647Frlmafoj43WS2eJh/dH7ABk6hGMJyA2amw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pp1CSA5b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0A4606D482;
	Fri, 13 Nov 2026 17:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pp1CSA5b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30341F000C4;
	Fri, 13 Nov 2026 17:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590848;
	bh=FGrUuiFkxPn9kRFeIL3ct/k1OjrNRryaDQocvYRo8DQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pp1CSA5b+bSOF1EXxHgajJDHnCRweyXgAFsjK4hSTAnb4tXEc8GB/1/kAodbNHQZG
	 iNPobSFsgEc8kisDxPCV289e4yI7M3U3mhh2Xxf0ICtnSfb0JJalG1YZNEizebofRs
	 Jis9v4vXY99F95PIrocRLFeYc5PfLXzdLplnef1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5c3ed2a0de3270efc921@syzkaller.appspotmail.com,
	syzbot+c2ec61adfbcb24e5ec20@syzkaller.appspotmail.com,
	Eduard Zateev <hackerowskiy@gmail.com>,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/670] smb: client: hold server info until cifsd exits
Date: Fri, 13 Nov 2026 10:42:56 -0500
Message-ID: <20261113153811.601112649@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zateev <hackerowskiy@gmail.com>

[ Upstream commit 482c117c6dbeee382790168af10959810450ab09 ]

The last session reference can be dropped while the cifsd demultiplex
thread is still running clean_demultiplex_info(). That thread frees
TCP_Server_Info there, racing with cifs_put_tcp_session() as it releases
the server crypto state. syzbot reported a KASAN use-after-free in
cifs_crypto_secmech_release().

Keep an object reference for the cifsd thread. Defer final crypto,
session-key, network namespace, string, and structure cleanup until both
the last session reference and the thread reference are dropped. Drop the
thread reference after clean_demultiplex_info() has finished using the
server.

Build-tested with ARCH=arm64 and W=1 for
fs/smb/client/connect.o. The KASAN reproducer was not run on the patched
kernel.

Fixes: a5c3e1c725af ("Revert "cifs: No need to send SIGKILL to demux_thread during umount"")
Reported-by: syzbot+5c3ed2a0de3270efc921@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5c3ed2a0de3270efc921
Reported-by: syzbot+c2ec61adfbcb24e5ec20@syzkaller.appspotmail.com
Closes: https://syzbot.org/bug?extid=c2ec61adfbcb24e5ec20
Assisted-by: LLM OpenAI Codex
Signed-off-by: Eduard Zateev <hackerowskiy@gmail.com>
Cc: stable@vger.kernel.org
Tested-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ sashal: Adjusted patch context for missing NetBIOS fields and existing kfree() cleanup instead of kfree_sensitive(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h |  2 ++
 fs/smb/client/connect.c  | 33 +++++++++++++++++++++------------
 2 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index f5ca2cd653e95..8ffc8b2ab6db4 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -16,6 +16,7 @@
 #include <linux/scatterlist.h>
 #include <linux/mm.h>
 #include <linux/mempool.h>
+#include <linux/refcount.h>
 #include <linux/workqueue.h>
 #include <linux/utsname.h>
 #include <linux/sched/mm.h>
@@ -647,6 +648,7 @@ struct TCP_Server_Info {
 	spinlock_t srv_lock;  /* protect anything here that is not protected */
 	__u64 conn_id; /* connection identifier (useful for debugging) */
 	int srv_count; /* reference counter */
+	refcount_t obj_refs; /* struct lifetime: srv_count users + cifsd */
 	/* 15 character server name + 0x20 16th byte indicating type = srv */
 	char server_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
 	struct smb_version_operations	*ops;
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index eace4d1a3dce7..82a70370a60f8 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -977,6 +977,19 @@ cifs_enable_signing(struct TCP_Server_Info *server, bool mnt_sign_required)
 	return 0;
 }
 
+static void cifs_tcp_server_put(struct TCP_Server_Info *server)
+{
+	if (!refcount_dec_and_test(&server->obj_refs))
+		return;
+
+	cifs_crypto_secmech_release(server);
+	kfree_sensitive(server->session_key.response);
+	put_net(cifs_net_ns(server));
+	kfree(server->leaf_fullpath);
+	kfree(server->hostname);
+	kfree_sensitive(server);
+}
+
 static noinline_for_stack void
 clean_demultiplex_info(struct TCP_Server_Info *server)
 {
@@ -1062,14 +1075,11 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 		 */
 	}
 
-	put_net(cifs_net_ns(server));
-	kfree(server->leaf_fullpath);
-	kfree(server->hostname);
-	kfree(server);
-
 	length = atomic_dec_return(&tcpSesAllocCount);
 	if (length > 0)
 		mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
+
+	cifs_tcp_server_put(server);
 }
 
 static int
@@ -1680,7 +1690,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	else
 		cancel_delayed_work_sync(&server->reconnect);
 
-	/* For secondary channels, we pick up ref-count on the primary server */
+	/* For secondary channels, drop the reference on the primary server */
 	if (SERVER_IS_CHAN(server))
 		cifs_put_tcp_session(server->primary_server, from_reconnect);
 
@@ -1688,15 +1698,11 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	server->tcpStatus = CifsExiting;
 	spin_unlock(&server->srv_lock);
 
-	cifs_crypto_secmech_release(server);
-
-	kfree_sensitive(server->session_key.response);
-	server->session_key.response = NULL;
-	server->session_key.len = 0;
-
 	task = xchg(&server->tsk, NULL);
 	if (task)
 		send_sig(SIGKILL, task, 1);
+
+	cifs_tcp_server_put(server);
 }
 
 struct TCP_Server_Info *
@@ -1718,6 +1724,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 		rc = -ENOMEM;
 		goto out_err;
 	}
+	refcount_set(&tcp_ses->obj_refs, 1);
 
 	tcp_ses->hostname = kstrdup(ctx->server_hostname, GFP_KERNEL);
 	if (!tcp_ses->hostname) {
@@ -1858,6 +1865,8 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 		module_put(THIS_MODULE);
 		goto out_err_crypto_release;
 	}
+	/* Keep the server alive until the demultiplex thread has exited */
+	refcount_inc(&tcp_ses->obj_refs);
 	/* thread created, put it on the list */
 	spin_lock(&cifs_tcp_ses_lock);
 	list_add(&tcp_ses->tcp_ses_list, &cifs_tcp_ses_list);
-- 
2.53.0



