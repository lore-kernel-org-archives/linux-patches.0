Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052999;
	b=F9ICt7j0OEDc3EcjrbXtFCJ0dX1Zv20m/N14VgR4JcrShlMX6yL/B4anEe1DTfgGqbW0
	 C5kKmCL9uMrO2dwJPPPYiPgV9o+D4cd608nDVmOPS0vSsfDYK1z8ZXVDGxg+n4RTPc1tx
	 lR56SeGkozrArxHohdPjfjVDz+Auf17LGFtT1YLobMcf/lE/tbzivy13Kgo5GQ9vNX2jo
	 dKQ9SR4bhARs9TEW/dhmZFerFQeBLPEjtc0UhcrzFaMtp3JnS3YZvdrdVfTuIru00dijx
	 /cb16hCgXnGZjH7aDN/XzuIiG2aniwAPbcVC1vZEikR2V34xnh+2nCwZnpvDNhF97OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052999;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c5c/BrENJy/ksT4NLBDbYqrIFxHCwLzR1R8w4gmtC04=;
	b=dIM5K8CTbmcf8q5pChwKfY8pUwJWBgowp5yFpPyQRNxCVTMCje3/LygsaNS4c/0t4yiY
	 zz2xVSR/5USIH23GaGru4M55gOhyeZHWZYFWRauV1vY06nd4Q1WtmxAmp2CwWcNYjj2S+
	 Va4aHMg6O6drxLa3XOZgL2kWSTb0/aRsSMrB7SedpgE0tIA6UjpqlQWazqIMrEvXnMq0V
	 xZP+6FtapkFHNwuc+MZ3sPoYT8OdtE1lHuCDjKQ/RAehTP7umBamkLUssT5bCKIkP7QAS
	 41oJObjqj+y6lBjsvNZblvN1XkcbpgmpfIHNnmCefJMrUW/A1mXxsA2BjLH7W0MkIqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2QaH+3S2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7902606A31C;
	Thu, 19 Nov 2026 01:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2QaH+3S2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498621F000C4;
	Thu, 19 Nov 2026 01:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052998;
	bh=c5c/BrENJy/ksT4NLBDbYqrIFxHCwLzR1R8w4gmtC04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2QaH+3S2JlD1dnvUZpbBCK2wGpZfVcf8PgZf3xRRLzLuS24+Mu2fixmsOoZdZ1UpV
	 2/7tHtmZAafItSvMTk2AFUgesbyioFuKoUyb8FP+CPFnJeEKWVCT3QN7MRtWPrGfA4
	 2blZ6R4Pah9t7oBUgKBla90/kXm8PrXDVUTm5bkQ=
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
Subject: [PATCH 5.15 0762/2214] smb: client: hold server info until cifsd exits
Date: Wed, 18 Nov 2026 15:40:38 +0100
Message-ID: <20261118150042.201973128@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: moved thread reference acquisition before kthread_run() to accommodate immediate thread startup ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/cifsglob.h |  2 ++
 fs/cifs/connect.c  | 38 +++++++++++++++++++++++---------------
 2 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index be53b788ea4ff..23bfe72ebbdc6 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -16,6 +16,7 @@
 #include <linux/scatterlist.h>
 #include <linux/mm.h>
 #include <linux/mempool.h>
+#include <linux/refcount.h>
 #include <linux/workqueue.h>
 #include "cifs_fs_sb.h"
 #include "cifsacl.h"
@@ -578,6 +579,7 @@ struct TCP_Server_Info {
 	struct list_head smb_ses_list;
 	__u64 conn_id; /* connection identifier (useful for debugging) */
 	int srv_count; /* reference counter */
+	refcount_t obj_refs; /* struct lifetime: srv_count users + cifsd */
 	/* 15 character server name + 0x20 16th byte indicating type = srv */
 	char server_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
 	struct smb_version_operations	*ops;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 98a3e25c107db..cf3d7eb1db506 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -754,6 +754,22 @@ handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 	dequeue_mid(mid, malformed);
 }
 
+static void cifs_tcp_server_put(struct TCP_Server_Info *server)
+{
+	if (!refcount_dec_and_test(&server->obj_refs))
+		return;
+
+	cifs_crypto_secmech_release(server);
+	kfree_sensitive(server->session_key.response);
+	put_net(cifs_net_ns(server));
+#ifdef CONFIG_CIFS_DFS_UPCALL
+	kfree(server->origin_fullpath);
+	kfree(server->leaf_fullpath);
+#endif
+	kfree(server->hostname);
+	kfree_sensitive(server);
+}
+
 static void clean_demultiplex_info(struct TCP_Server_Info *server)
 {
 	int length;
@@ -839,15 +855,11 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 		 */
 	}
 
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	kfree(server->origin_fullpath);
-	kfree(server->leaf_fullpath);
-#endif
-	kfree(server);
-
 	length = atomic_dec_return(&tcpSesAllocCount);
 	if (length > 0)
 		mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
+
+	cifs_tcp_server_put(server);
 }
 
 static int
@@ -1374,8 +1386,6 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	/* srv_count can never go negative */
 	WARN_ON(server->srv_count < 0);
 
-	put_net(cifs_net_ns(server));
-
 	list_del_init(&server->tcp_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
 
@@ -1397,18 +1407,13 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	server->tcpStatus = CifsExiting;
 	spin_unlock(&GlobalMid_Lock);
 
-	cifs_crypto_secmech_release(server);
 	cifs_fscache_release_client_cookie(server);
 
-	kfree(server->session_key.response);
-	server->session_key.response = NULL;
-	server->session_key.len = 0;
-	kfree(server->hostname);
-	server->hostname = NULL;
-
 	task = xchg(&server->tsk, NULL);
 	if (task)
 		send_sig(SIGKILL, task, 1);
+
+	cifs_tcp_server_put(server);
 }
 
 struct TCP_Server_Info *
@@ -1429,6 +1434,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx)
 		rc = -ENOMEM;
 		goto out_err;
 	}
+	refcount_set(&tcp_ses->obj_refs, 1);
 
 	tcp_ses->hostname = kstrdup(ctx->server_hostname, GFP_KERNEL);
 	if (!tcp_ses->hostname) {
@@ -1525,6 +1531,8 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx)
 	 * this will succeed. No need for try_module_get().
 	 */
 	__module_get(THIS_MODULE);
+	/* Keep the server alive until the demultiplex thread has exited */
+	refcount_inc(&tcp_ses->obj_refs);
 	tcp_ses->tsk = kthread_run(cifs_demultiplex_thread,
 				  tcp_ses, "cifsd");
 	if (IS_ERR(tcp_ses->tsk)) {
-- 
2.53.0



