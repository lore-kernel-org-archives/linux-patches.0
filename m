Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FE23C1F45;
	Sat, 17 Oct 2026 17:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259766; cv=none; b=K6lrUd7tQ9U5na+riua5JklR9pKlbEOgQpHdz5G+FOlV5nno4imXKseyoJmeSmNlzjdm9FLMTDEV1C0l5n7xuKz4bqfdppuGY7LXJe5vsYgUmXbkXcwCvbYI4Z5u4VDIfH06jNxI3G2z5vwfgXFussaxoA42RC4KpQH2SNhSAJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259766; c=relaxed/simple;
	bh=SEXdIC84xFu4zTi9XPZ1TCnCifmvVgTjzQmbmvPT16s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4mjMj1O2VeheRHCf08n9dEfq/WL2dJJW6hTKASwjRsX5Xpr7GDFwiuVXoRrQ9Esnvoq6+TzPrK8udsSJ7t6GAb7M9bDdebgj0zXbjCOgz25sZbh1FR1tR4bLZU5w+rVgQHEsKzL22RA3wLdRk2Pli8zNS+Hnc3LbweBQwF9Hmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sz9wKgN0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sz9wKgN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815221F000C4;
	Sat, 17 Oct 2026 17:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259763;
	bh=ebLo/OlRW7Pify0Rpc7VLWGOi7JTvhlwKtqLnSwjio4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sz9wKgN0LpmRWbe70JMM0Ox0kw6Tm5uV1+il8plYKRfTZRPNFRfXk9hlB1uN24gHG
	 9iRQmHJ14FIJoKzS/EZR9fZq15aMRysMQbCK006sEaMCO3T0+5NQ0BxH7jDAVtaK3/
	 vWw1rW5nt4CkoDnd2inPavOA4hd92LitUCn385Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yan Zhen <yanzhen@vivo.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1282/1674] sunrpc: xprtrdma: Use ERR_CAST() to return
Date: Sat, 17 Oct 2026 17:59:14 +0200
Message-ID: <20261017160504.047944398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yan Zhen <yanzhen@vivo.com>

[ Upstream commit aeddf8e6c5662d60d434ce59f7e08ea020162323 ]

Using ERR_CAST() is more reasonable and safer, When it is necessary
to convert the type of an error pointer and return it.

Signed-off-by: Yan Zhen <yanzhen@vivo.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: e346ef7bcb13 ("svcrdma: Use svc_xprt_put to free listener on create failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index c01685223973c..dc7e02ed8894f 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -349,7 +349,7 @@ static struct svc_xprt *svc_rdma_create(struct svc_serv *serv,
 	listen_id = svc_rdma_create_listen_id(net, sa, cma_xprt);
 	if (IS_ERR(listen_id)) {
 		kfree(cma_xprt);
-		return (struct svc_xprt *)listen_id;
+		return ERR_CAST(listen_id);
 	}
 	cma_xprt->sc_cm_id = listen_id;
 
-- 
2.53.0



