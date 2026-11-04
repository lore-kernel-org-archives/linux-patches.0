Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828850;
	b=mnZM7q/FBNAaKQRsVTnOLQHHQq21keEDn82hq6HRUbkgC8ltPFJKaw9y3d3FAz2cSGbh
	 p3jTptwG53cFSTxOspZNzZ5otC90C7EPIldV87E2Lmhz1K0MBb5QnJ7jWso221ClVKzfG
	 RgAMg6F8BKQe+2kgLqpxfVLnp5abJJWaFZwTT+NUmG9PcvVjqfqDuoISygsr+ybv4ShGD
	 Y+8ciSmMpdXV3xRNqBTDsP4ODvXRvbS+por2fXSNzU/RGHCiYyI1ZAfO/TYnLRPfAJnXu
	 lgtWnC7MWmXPlyRbMIePII3GksT2nn33rQfQjDd4eUgZuWaMfHMbtzzZS/CrXDZWkAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828850;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tJDCEn1i23eN2lLMkC6QsqASGv6nPjaKV0TVsf8smxc=;
	b=uVqf33odIAm4bztIEadtRlL9m5lRIK+hj9uS6zg5gTbxEJ8OsSmyYYbRCh6VWggxbTt1
	 OCizwY9zf4AQmtoCBEWOpyZGvHFLS6TJn1wc6zcEhQ7rQdiLMHJZXvFxVw8VL3u5kgWbp
	 Q1pw4MsSGgvxiDMOa9WjeX5uUN+J8HVaAVfe2AhXfHJh1Dk5csmM8YwuytNXatqFDkku6
	 KYqVerm/fPljumHxylHVnN8L/t/TYdXSIfH2TZjfgxgXMUVcqFZvpz5ef7AOV0+NWBIBZ
	 DBAGI7Tf3jrNARcC/0VWvAj0QZAstoW+GkQQdU5bi5fp0/EBXzDLCXqSi64BjNYYpsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XPBq4/CX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85AA5606A32D;
	Wed,  4 Nov 2026 21:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XPBq4/CX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47191F000C1;
	Wed,  4 Nov 2026 21:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828850;
	bh=tJDCEn1i23eN2lLMkC6QsqASGv6nPjaKV0TVsf8smxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XPBq4/CX7graWI8/umZsoldcneff7U8mH2whcdCXcz9o9RJ6ul9JMucSMcxHED85v
	 KdkvVOyjpiRmtIwx3h/0Jx+y7CB0I53sLLnkXm5Ve8RU6uEWNJSPhBMP6pu3dHD/fM
	 HaMMSFPHpiBU2LeRlSFY1uw8wl0LKBFMxwjGw/Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5c3ed2a0de3270efc921@syzkaller.appspotmail.com,
	syzbot+c2ec61adfbcb24e5ec20@syzkaller.appspotmail.com,
	Eduard Zateev <hackerowskiy@gmail.com>,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 7.3 280/547] smb: client: hold server info until cifsd exits
Date: Wed,  4 Nov 2026 16:07:44 -0500
Message-ID: <20261104211046.156838099@linuxfoundation.org>
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

From: Eduard Zateev <hackerowskiy@gmail.com>

commit 482c117c6dbeee382790168af10959810450ab09 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsglob.h |    2 ++
 fs/smb/client/connect.c  |   33 +++++++++++++++++++++------------
 2 files changed, 23 insertions(+), 12 deletions(-)

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
@@ -679,6 +680,7 @@ struct TCP_Server_Info {
 	spinlock_t srv_lock;  /* protect anything here that is not protected */
 	__u64 conn_id; /* connection identifier (useful for debugging) */
 	int srv_count; /* reference counter */
+	refcount_t obj_refs; /* struct lifetime: srv_count users + cifsd */
 	int rfc1001_sessinit; /* whether to estasblish netbios session */
 	bool with_rfc1001; /* if netbios session is used */
 	/* 15 character server name + 0x20 16th byte indicating type = srv */
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1062,6 +1062,19 @@ cifs_enable_signing(struct TCP_Server_In
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
@@ -1147,14 +1160,11 @@ clean_demultiplex_info(struct TCP_Server
 		 */
 	}
 
-	put_net(cifs_net_ns(server));
-	kfree(server->leaf_fullpath);
-	kfree(server->hostname);
-	kfree_sensitive(server);
-
 	length = atomic_dec_return(&tcpSesAllocCount);
 	if (length > 0)
 		mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
+
+	cifs_tcp_server_put(server);
 }
 
 static int
@@ -1731,7 +1741,7 @@ cifs_put_tcp_session(struct TCP_Server_I
 	else
 		cancel_delayed_work_sync(&server->reconnect);
 
-	/* For secondary channels, we pick up ref-count on the primary server */
+	/* For secondary channels, drop the reference on the primary server */
 	if (SERVER_IS_CHAN(server))
 		cifs_put_tcp_session(server->primary_server, from_reconnect);
 
@@ -1739,15 +1749,11 @@ cifs_put_tcp_session(struct TCP_Server_I
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
@@ -1769,6 +1775,7 @@ cifs_get_tcp_session(struct smb3_fs_cont
 		rc = -ENOMEM;
 		goto out_err;
 	}
+	refcount_set(&tcp_ses->obj_refs, 1);
 
 	tcp_ses->hostname = kstrdup(ctx->server_hostname, GFP_KERNEL);
 	if (!tcp_ses->hostname) {
@@ -1907,6 +1914,8 @@ smbd_connected:
 		module_put(THIS_MODULE);
 		goto out_err_crypto_release;
 	}
+	/* Keep the server alive until the demultiplex thread has exited */
+	refcount_inc(&tcp_ses->obj_refs);
 	/* thread created, put it on the list */
 	spin_lock(&cifs_tcp_ses_lock);
 	list_add(&tcp_ses->tcp_ses_list, &cifs_tcp_ses_list);


