Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829089;
	b=VgGD50PjGdOEs5+3eMTyeATUX+6uSpxuf2jpKcSqmekyWHJJv6TwvryADAhd4gcZKAB6
	 RgdWIO6nx/on+toujkKGHQHKv5z106JucG2k46ZhFxRuXVSvf34VUNw6RzREXtjJUzN4O
	 UYBWpp6t3j6r+m5wBhWmpLs0B6daWX0W45RCs1jpX1D0yV+Pel3Ddx1uT5KZb8ddPDMXc
	 emaC8O7JQY/GJgGu1qSPvz3JF7qbzKPXRHMt25y89gZ1wnX8a0cEdvVZuuPhhkKswZDBJ
	 9fF7wePfp4kpC8az/IMn7D7G9dEJNNVkjJCGZFSpS3iOSmxPkxzZd5TnMcsDbF0WPkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zz9Xo1Z92bknVKt4uReSUS8dISfTPwMGYj6WlaT7uaM=;
	b=HOPXSJ6w0lm7CiPOvJxIWBKOu3LTrpDajUgfcfXqzRzXFnYGXW5/OU8E+208zS4pm4TW
	 KemGMYWolGmZMoTgd+W/Ws3nPJMTRB37dxAPwhfl1rdpj+J/jagWlT478d/DQSfRlN7jG
	 TqIhcg7N9cDk702SPXRhLRuBTKQvFEd8kWA5RDUsFTxiagPx74ZrR8MRSpdu8rWfIwFwn
	 r0IRg83lyGRT5sTu6nyzCRFRlE/JB/9suOTTLIGaaU/dU6XtdcxxDqxG6hGMeKVBV/Hmj
	 ZIkPgOrrbY7h8OhB3Equoq+FYSas2o+xgPrZzSzoPmkLkRNOu7wv+fYju9XfR4qHktA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PtFMGNE2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9A66072FA7;
	Wed,  4 Nov 2026 21:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PtFMGNE2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC2C1F000C1;
	Wed,  4 Nov 2026 21:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829089;
	bh=Zz9Xo1Z92bknVKt4uReSUS8dISfTPwMGYj6WlaT7uaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PtFMGNE2xkug2V44Rit0i2W/aKj0RyMogoEsoHQuyNFfJ5W29JfFH2gX0Xa8Wk2bj
	 u99WYq5dzrv0Tw1Hj/z4C3id/jN3J1P7z7AQHQJZQOlDI9Ycgu87dxNuiVdIof80dL
	 /aFdCffq6Oq2t1fafRXBJp53bQn1DQQIn3XQHKFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 431/547] NFSD: Set nn->cld_net before registering the cld pipe
Date: Wed,  4 Nov 2026 16:10:15 -0500
Message-ID: <20261104211050.592116661@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

commit 14996e662f3b734427e2d645cacffc27b779f7d1 upstream.

rpc_mkpipe_dentry() instantiates the pipe's dentry before it returns,
so the cld pipe can be opened as soon as nfsd4_cld_register_net() has
run. __nfsd4_init_cld_pipe() does not store the new cld_net in
nn->cld_net until after that call. cld_pipe_downcall() reaches the
cld_net only through that pointer and takes cn_lock without checking
it, so a write() that lands in the window oopses.

Store nn->cld_net once @cn is fully initialized and before the pipe is
registered, and clear it again when registration fails.

Fixes: f3f8014862d8 ("nfsd: add the infrastructure to handle the cld upcall")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260901-alemi-v2-6-e163f94a3a6e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4recover.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -937,18 +937,24 @@ __nfsd4_init_cld_pipe(struct net *net)
 	}
 	spin_lock_init(&cn->cn_lock);
 	INIT_LIST_HEAD(&cn->cn_list);
+#ifdef CONFIG_NFSD_LEGACY_CLIENT_TRACKING
+	cn->cn_has_legacy = false;
+#endif
+
+	/*
+	 * The pipe's methods reach @cn through nn->cld_net, so set
+	 * it before the pipe can be opened.
+	 */
+	nn->cld_net = cn;
 
 	ret = nfsd4_cld_register_net(net, cn->cn_pipe);
 	if (unlikely(ret))
 		goto err_destroy_data;
 
-#ifdef CONFIG_NFSD_LEGACY_CLIENT_TRACKING
-	cn->cn_has_legacy = false;
-#endif
-	nn->cld_net = cn;
 	return 0;
 
 err_destroy_data:
+	nn->cld_net = NULL;
 	rpc_destroy_pipe_data(cn->cn_pipe);
 err:
 	kfree(cn);


