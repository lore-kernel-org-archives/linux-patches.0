Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052980;
	b=QvtRZkRWPpwdyXiyZI51tm6btL2TQLrgLC0HesXx6dlXACzD1Gfee0FdmgJOrQXFnsiP
	 W3rB5nrA48mc+4UUZFIkULHqwHoi+VsVcTpCUceKoRqjd95Bdt7stWfnkZeJzTkXGG/3f
	 44eHLqVzExUG1G0N8rUQWeH87aIEKaP7NZTMUCifCSU/WwAkIGZQa75/Ci5vy8aV1UHNI
	 p9DLhT8QxiBGNZqkViVaJ4728HeRoztz/8JeSS/CFTrPa7uKfssqmlIZXwWQmUbJ40iLb
	 KPlc1DF4uCFqJ9sHiMpARZluhNhGWZ1+zhcj6aecbaNECV4kItmEZMB/GQr6qm4K6xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=71l4f1TFIFEK/zOEqZjrio/ZacahnuThU9EdhJTkjug=;
	b=uK7PCziIHUsogrSYTWwZKXZHDVIglwWIOUdpFnyiSeThT8IfyU1yLPvA4dOqr5vfbttT
	 +Xa5XWY3FwDAu7pNK/aBaNnkOHfvrqFq3Hyarz9+ghgqSOOvm8Qc8zVbjLiZpndXUOK9X
	 4guu6TDOSzMNwlmMB1p8wL1CHXKOhsmJL/o9291uWpRC+g6U17Jl0JcEp29k+F1ieKlQs
	 KBxXBP/RkJqsCj7CM8A8gncccATmFvhVl1SROZm7mlHXqTNUgWLDbG7jKB1Bmc2ZtCWDN
	 2N7/jBWHPznftB21iDc+0cIXxkknc1iLXf/BFazWs+mOkPOoa4IWTmKN+tWqObZcGtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YiJ97Ynq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0DBE606A31C;
	Thu, 19 Nov 2026 01:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YiJ97Ynq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBBA1F000C4;
	Thu, 19 Nov 2026 01:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052979;
	bh=71l4f1TFIFEK/zOEqZjrio/ZacahnuThU9EdhJTkjug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YiJ97YnqmJMzYNnPaws1FFEf+odXoZJWRld/VEEh+m0myI+c0ehLr2mitktplmoUN
	 ObN+XKLz/+HXqp8XfwA6H7ZaFqliSt6vXTRfP3xp2MunCxg0hSzeSMYebxsRgYeOqB
	 8SHik1qcrvnQ8Y7KGZmcd8ULzXCKaOLCNZITJPj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0756/2214] NFSD: Set nn->cld_net before registering the cld pipe
Date: Wed, 18 Nov 2026 15:40:32 +0100
Message-ID: <20261118150041.981632372@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 14996e662f3b734427e2d645cacffc27b779f7d1 ]

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
[ sashal: adjusted context around dentry-based pipe registration where cn_has_legacy is initialized unconditionally ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4recover.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index e0cb4856ca565..21917c024fb20 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -1014,6 +1014,13 @@ __nfsd4_init_cld_pipe(struct net *net)
 	}
 	spin_lock_init(&cn->cn_lock);
 	INIT_LIST_HEAD(&cn->cn_list);
+	cn->cn_has_legacy = false;
+
+	/*
+	 * The pipe's methods reach @cn through nn->cld_net, so set
+	 * it before the pipe can be opened.
+	 */
+	nn->cld_net = cn;
 
 	dentry = nfsd4_cld_register_net(net, cn->cn_pipe);
 	if (IS_ERR(dentry)) {
@@ -1022,11 +1029,10 @@ __nfsd4_init_cld_pipe(struct net *net)
 	}
 
 	cn->cn_pipe->dentry = dentry;
-	cn->cn_has_legacy = false;
-	nn->cld_net = cn;
 	return 0;
 
 err_destroy_data:
+	nn->cld_net = NULL;
 	rpc_destroy_pipe_data(cn->cn_pipe);
 err:
 	kfree(cn);
-- 
2.53.0



