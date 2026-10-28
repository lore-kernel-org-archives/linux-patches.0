Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215968;
	b=IZZln8fFab4HnvkbLF+we/6wnDEj/o5qaJDI7bbvAZ1FkUN5Lu0d/Fi5Z+2pqc9YEW11
	 lbh9eyX/rNfoF81zd2bB2ZzKNAPIExsjKWDi3UHzyCsVfDFjpp1MxeROzh68ft+BqHt+j
	 YJ6LgVCHSD8EYWMpscbevqvw2OHy70jHnlKHSKbqVUbP7x4kldILOfTE8kkEDGsF1Tfoi
	 UV6LG9M9Z8nsZc3ooZsgT4M4/xBnWCJ/SYURpbg7bEcZGpbcXFDAtL0B9llL9nWltWF3d
	 hQcGd8uYUrHoVvZyAv//41z21VcIba5m0HGrpU3x0aVby9UI4gZTMLXN4BZEYpUk10g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N1DZZq7J2rKYbpT3PPL4JV3hEDnMAShWv8BEdG4uRMU=;
	b=PbZvN+uGT2HkfkU0wELNIhgRXAUoEB6kin5CGVnzgkwjIVoAv9lBQK26urjoUYVMK+Kr
	 ZqUwp+W8xZv+7vUiXykk8Oa9VNoaq9s3pOOYDQh5XqnW7W7uIrhU3zead4qq63htdd5Yl
	 Xv7DlfDx5gA8J+UnVb4y78sdTGHCFRKuE6SUahbh+CH0/jrF/kJT/Zf8lHJQ9H+877ObA
	 2AbfsWlhk4dY+s+O3ot5nuajNAy8IKFPbpjISIXh92BB2muejXG/rAZH9tJE0lM7WBATO
	 YvwqBZYUgu4L1e4/YQeUsxbRri4nz41EVY1/wTXip7oUbIp9GGXEeHxT3BXCsiTOCiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GVE5kq3a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549EE606A31E;
	Wed, 28 Oct 2026 19:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GVE5kq3a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FE41F01825;
	Wed, 28 Oct 2026 19:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215968;
	bh=N1DZZq7J2rKYbpT3PPL4JV3hEDnMAShWv8BEdG4uRMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GVE5kq3aQLQBBAbBoqsciClVGit8UIAQTaCE4eNfbdKNF5KrQ0y+HOBzsSPOeVhx8
	 z2wnU4Rfcbv9R1XYd9IhLlheowEEIxgHzkS4vN5lKFBV7BvIyZPEEGKbJYY8y9vir/
	 o/e6zVL1oR69dS9Qv/qBR/szr+0g3LHJoaGwcqBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yan Zhen <yanzhen@vivo.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1394/1887] sunrpc: xprtrdma: Use ERR_CAST() to return
Date: Wed, 28 Oct 2026 17:58:10 +0100
Message-ID: <20261028170531.173574824@linuxfoundation.org>
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
index c84343fbf2d2f..ae15c2ed2f12c 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -351,7 +351,7 @@ static struct svc_xprt *svc_rdma_create(struct svc_serv *serv,
 	listen_id = svc_rdma_create_listen_id(net, sa, cma_xprt);
 	if (IS_ERR(listen_id)) {
 		kfree(cma_xprt);
-		return (struct svc_xprt *)listen_id;
+		return ERR_CAST(listen_id);
 	}
 	cma_xprt->sc_cm_id = listen_id;
 
-- 
2.53.0



