Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061735;
	b=FfxcuTgUyBDoYEdH9dGLTECm71D22WdCrjKIAn9KDHyhPKt7TzlKdyOy4N1hpLHPKs86
	 nDPgytjAVHRSm3/goz52BmP2o76q9Bmm6sWUXQLmUBlB+uv6CmvANLMsGN7uUwtzl4iiS
	 xRcy79CRtYPh1V7UyOu36rGFbJpmhOzkjxc815sdAa8B319hzVB0eBikrd5rg3TRz1+V9
	 mRlSobOzplZRZE7WiGEF0LoZgglLFnFyNW+FZw3cF3e1dXuzzjeSjROs7wFvCHUerwbEd
	 A9gW0CXFqAY1uyCxnukhvw9Mm+ff9fuiupZ5iCGB/pzeyrFMyEzRigU1Ty3R0HKrchA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jwbo9oTnqqJT78J3qkBFdg/dXXIIjpTQ16pTVkAR804=;
	b=a+0xb9lzRpjfiyfE438xcOPa7gpFQGXhAOPyblTxO0iwaf5l2/qhufV0WoU9GoOpv+vS
	 9WNlAY0gokGe5NvQsOVGz/pmIRUfTnEmlG4anaxRg89uuMwk1Q6NMkA6ZQQNM4+5c6kAR
	 4SKx80CjRXG6SG4BdjG/fZ9+je1p3kgigQwPgMWpcM3VTVwRD8O/JdgOC/RbfEjsP+2+L
	 w/j25cDck9TXDWp1UIoYHvZ0bgdOSZaPjeePDnYtD18xxpGk3hfgso8TBrdZ1P+TEyv0m
	 jpIpy1ulbElpz7heOvitC1BnVjLQbV4AMAFN+HqQ2Cjrt6FEr41hZYYg8MZnFlW1P5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r3lrB0PZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA09606A326;
	Sat,  7 Nov 2026 14:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r3lrB0PZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077F31F0089F;
	Sat,  7 Nov 2026 14:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061735;
	bh=Jwbo9oTnqqJT78J3qkBFdg/dXXIIjpTQ16pTVkAR804=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r3lrB0PZywmv1lsGy1xz3+3CUOBb0+7x85HLI0RugufFbj9IJtJz5YCG1+/Efcby2
	 Eb8d21DhlPX06qfdzA24cjrY01VFUEa/8SAHw1g//SAk1g2WEqJjBKk8zR7FcqHbo4
	 N1jWq8ZYGMqhDgb/QQTJBn3x1h5li6HmOlxQBIVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0776/1536] NFSD: Set nn->cld_net before registering the cld pipe
Date: Sat,  7 Nov 2026 08:46:32 -0500
Message-ID: <20261107135019.327365905@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
@@ -1025,18 +1025,24 @@ __nfsd4_init_cld_pipe(struct net *net)
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


