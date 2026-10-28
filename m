Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214074;
	b=0/neqsiG8J2JjeDqVEilBI4h1NE95Bo6gMpgfkt7Zce+xWtTxuZu4QWWqRiO7U6O8x5a
	 c46CvJBMThFAORiBNO6bCGQPeDxTVJseUEy35AnxiMN3XLRZ2OXd6KN3icIvC5/565e4m
	 XP27l/xmgtm7KJZOLknpgpzqzESbq2YOUS/71yYwcrY/+Etpmpt6XxdkQS1S1ZkGmcWni
	 6aIGrKngbF0rlI2oBQWmcMXYjmkJGEkDwQdisGp7RjfH9v15eL0Uybrqnph2NyHmQ37hn
	 R/5hvzPdYukfqGqQt+jqT7grFcxYSTaXoShn9uzQYiqQzXOdaZZiV0L0EWWkGk7+MRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0F7JBM0u7CatxOEnBO6qcNI0ggYkrb3k1bw7X9QXN1g=;
	b=cvqMnzsftQ4CxkvWY8kiBNxykbu63tx6xMB2xqIv9MFWI/GaURBbOquY1aA0Clb+DP1m
	 QD/5T4V2xgZDgh9e/vUP1Zs+ss/LtNPJ0R8bUIWTWbmrKUNNa6/2UO8uV0YohE257+46I
	 2ID++SrJJCjzNkQIKpap5TMUtbMndamGujWYZQtfX3tc5Lh/t4gY99FO+e+v3iNnX67aJ
	 cXv0rxbDVMas9XKH16rPHJnE9vGRaCTKjzKa1D/g1Iaz/8pk1isEynkDHycaaJhdHMxzO
	 fxPDRNmmYhH9knjTFp2uXG8cqzwlUs1SGgA6DPjUtKSml/deZmUpdjzhj1iAjJ2I83w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hsvy5+U1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB18606A31D;
	Wed, 28 Oct 2026 19:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hsvy5+U1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0201F01825;
	Wed, 28 Oct 2026 19:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214073;
	bh=0F7JBM0u7CatxOEnBO6qcNI0ggYkrb3k1bw7X9QXN1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hsvy5+U1TH889geHu5hF9Q6nGZON8gqxVBWlbk/DTv4yeYZYH10qrhqLK1k0HPrKI
	 vcZ6uAIrmkucha+yEUStcew5ZE/22Egby4HhGRsnjZKrx3DFXAa5GR5iw1eC88ma5L
	 Rebm5SmVyq3Kf9RkYBxMUG2qHJTTJijZ3qqktlu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Shin <jaeshin@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0731/1887] smb: client: fix double free of TCP_Server_Info::hostname
Date: Wed, 28 Oct 2026 17:47:07 +0100
Message-ID: <20261028170516.084331142@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit fa2f9906a7b333ba757a7dbae0713d8a5396186e ]

When shutting down the server in cifs_put_tcp_session(), cifsd thread
might be reconnecting to multiple DFS targets before it realizes it
should exit the loop, so @server->hostname can't be freed as long as
cifsd thread isn't done.  Otherwise the following can happen:

  RIP: 0010:__slab_free+0x223/0x3c0
  Code: 5e 41 5f c3 cc cc cc cc 4c 89 de 4c 89 cf 44 89 44 24 08 4c 89
  1c 24 e8 fb cf 8e 00 44 8b 44 24 08 4c 8b 1c 24 e9 5f fe ff ff <0f>
  0b 41 f7 45 08 00 0d 21 00 0f 85 2d ff ff ff e9 1f ff ff ff 80
  RSP: 0018:ffffb26180dbfd08 EFLAGS: 00010246
  RAX: ffff8ea34728e510 RBX: ffff8ea34728e500 RCX: 0000000000800068
  RDX: 0000000000800068 RSI: 0000000000000000 RDI: ffff8ea340042400
  RBP: ffffe112041ca380 R08: 0000000000000001 R09: 0000000000000000
  R10: 6170732e31303000 R11: 70726f632e786563 R12: ffff8ea34728e500
  R13: ffff8ea340042400 R14: ffff8ea34728e500 R15: 0000000000800068
  FS: 0000000000000000(0000) GS:ffff8ea66fd80000(0000)
  000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007ffc25376080 CR3: 000000012a2ba001 CR4:
  PKRU: 55555554
  Call Trace:
   <TASK>
   ? show_trace_log_lvl+0x1c4/0x2df
   ? show_trace_log_lvl+0x1c4/0x2df
   ? __reconnect_target_unlocked+0x3e/0x160 [cifs]
   ? __die_body.cold+0x8/0xd
   ? die+0x2b/0x50
   ? do_trap+0xce/0x120
   ? __slab_free+0x223/0x3c0
   ? do_error_trap+0x65/0x80
   ? __slab_free+0x223/0x3c0
   ? exc_invalid_op+0x4e/0x70
   ? __slab_free+0x223/0x3c0
   ? asm_exc_invalid_op+0x16/0x20
   ? __slab_free+0x223/0x3c0
   ? extract_hostname+0x5c/0xa0 [cifs]
   ? extract_hostname+0x5c/0xa0 [cifs]
   ? __kmalloc+0x4b/0x140
   __reconnect_target_unlocked+0x3e/0x160 [cifs]
   reconnect_dfs_server+0x145/0x430 [cifs]
   cifs_handle_standard+0x1ad/0x1d0 [cifs]
   cifs_demultiplex_thread+0x592/0x730 [cifs]
   ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
   kthread+0xdd/0x100
   ? __pfx_kthread+0x10/0x10
   ret_from_fork+0x29/0x50
   </TASK>

Fixes: 7be3248f3139 ("cifs: To match file servers, make sure the server hostname matches")
Reported-by: Jay Shin <jaeshin@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/connect.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 1661f6135e417..9172b4136a925 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1088,6 +1088,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 	kfree(server->origin_fullpath);
 	kfree(server->leaf_fullpath);
 #endif
+	kfree(server->hostname);
 	kfree(server);
 
 	length = atomic_dec_return(&tcpSesAllocCount);
@@ -1708,8 +1709,6 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 	kfree_sensitive(server->session_key.response);
 	server->session_key.response = NULL;
 	server->session_key.len = 0;
-	kfree(server->hostname);
-	server->hostname = NULL;
 
 	task = xchg(&server->tsk, NULL);
 	if (task)
-- 
2.53.0



