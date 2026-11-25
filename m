Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624775;
	b=cR/JAnBIqrjG9MmkS0ruUNXbpBewPHhkAQLb9PyGnMcGq+nZuauQ32UQVHMJvqS2OBiE
	 J0SdhSaddurOAjLYQh10+J9SEF/nTt+8HDRZMQjZY/yuUvOEkPerdNYiII2rnFGTrc2hE
	 c+D8qIpUjbBVKJDhZuc7bHAUD346f+qU+2e+/0+rvyjEkfiu8WAkJdpmLFETB3l8YSUNv
	 WiKGsIkfb2rZBBcyByKhYIZtcBepZ2QsolJYO7HFpw53AXHPiGV6mozcofLjo67UJdbUY
	 klYWqLNPMGHiOTpNKybjIeeYD8ecYzo4dFd16KT2O5si5cxR12hlCSKW7J11HbMmYeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sPGHMfPKCIYnrG/tlDtSfe77TkaBu6wmCbANbgsAUe4=;
	b=pVODECEKYhsq9uRGu/ZyLCCiguDpmNGe5AhtxQro7WfdKXwVmEWdXn5of+SA7CU5YFag
	 jeqh7Kywr/eY2ufFwhKf2PyDKmwG/jltGxbOz5XwecTSebJDySjA95/OHR6TNwYmHYrQm
	 BTRZpQjuH2yMnGxtDD7fkUt+3wh/D59MGk+RkFCmhACLzIifhltjAH+gRziBslRa0jxbQ
	 xT5goNqolutBLMLeoZFWQUYMOc/Bil5GVgUmvUD75eFz5kkY8N6e47vYN8t9lJqvzApo5
	 G9NKCsme9Th7X4bZ4ezNzoXBr4QNht06dICwVnfbHWAxAwovxYMO64s+CU3/J8/e4rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e7wij9FZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA449606A33B;
	Wed, 25 Nov 2026 16:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e7wij9FZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22FF1F000C4;
	Wed, 25 Nov 2026 16:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624774;
	bh=sPGHMfPKCIYnrG/tlDtSfe77TkaBu6wmCbANbgsAUe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7wij9FZnGThUrgM0FLwnHw0TEMgF4rjwPABf2AAmCJQ1/DF3lhFwjNWgHV89XhLv
	 muO3iiYhP9CzGRr1oWGv45rbhY1cW8fbCQhht8FURlt5aV9reJOrHw00pjpZTjNk4w
	 IMOnliyO++3kG9wFKG6kKD56GpdBtZCmJjygn+Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 302/816] SUNRPC: preserve transport security policy when cloning clients
Date: Wed, 25 Nov 2026 15:30:50 +0100
Message-ID: <20261125143856.195293999@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 7783534ce5fee57adf1b9025745c9af2e1ce2ccd ]

RPC client cloning does not copy the parent's transport security
policy into the new client. Clones consequently lose their TLS
policy and certificate/key serials, even though the shared
transport remains protected.

When NFSv4 migration replaces a cloned client's TLS transport, the
missing security policy causes xs_setup_tcp_tls() to return -EACCES.

Copy the parent's cl_xprtsec into the clone arguments before
creating the new client.

Fixes: 500053191297 ("SUNRPC: Plumb an API for setting transport layer security")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index bda5f8331b9fb..80a4e2ca323c5 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -651,6 +651,7 @@ static struct rpc_clnt *__rpc_clone_client(struct rpc_create_args *args,
 	}
 	args->servername = xprt->servername;
 	args->nodename = clnt->cl_nodename;
+	args->xprtsec = clnt->cl_xprtsec;
 	if (!args->timeout)
 		args->timeout = clnt->cl_timeout;
 
-- 
2.53.0



