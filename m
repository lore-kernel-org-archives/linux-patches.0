Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042501;
	b=1M5i8kR939VDq9N+LRZqMP+nIVJC1eDhwCcYtZ8C804cGK/iS7dTLBXHDD2xDtAtuNvr
	 fvNAGKV6ed1GMz+c44kKCfJB5BdW5D0iK0BirVJ+rNfRNcp7kMeLnLmsiTHOsC2tj6ZJc
	 RPOnJfrcyqXFq8kOQwZNnpbnCnAtz+BC5J4Jm9VX/8/SrZw0vXHDCOPSQgg6HYf/RVpF5
	 Voc1nPQwF3ch8eGwwvlRmNgVwcznbpyMwH4ecPhw2lmTDHJN3VZpi9ROcex2poyPaSOQV
	 gHGTRvCCnLas++rTM9iDkCLTLFXxs79mzk4F/eFG7fRPFTuIr67FnJMKUEBi6+KckbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y1VMofRLn0BjYhax8TpLSvcMzfIBBqDysasgIpNOWtc=;
	b=zd5FdAt2Btgmy8PMPx4A9Rl1oNCyCbu1xlpK2x0SslW1ML51UdRlFv8lvjHyUWbT+9GK
	 FiIdG42WtMNqC+/1w5h6Rm3O9iDlSyU9L2Bc7oJ61zTncd8ZS2pnL5nQvMDqx9uboKoGD
	 KJH4Lxu1xNsCkCvha/04g+ncDWI5IBYRc4bUFRZzVTbDrsPtVzSZNqTREG6iWLPVIW0PK
	 8+U45lj5ATr701rr0Q5GB3yeINEKR+OKdm2u0ZQM9wPd54x81KCFlosk4W/SSWDYfRlww
	 4XCyAvDqtGY9d+59eqXGPFjPopNY1tJsM4nrVbEiOO9gg+6fttVzPU2Ij6LTSDImMmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMnzv7rd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804C9606A320;
	Wed, 18 Nov 2026 22:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMnzv7rd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2EC1F000C4;
	Wed, 18 Nov 2026 22:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042501;
	bh=Y1VMofRLn0BjYhax8TpLSvcMzfIBBqDysasgIpNOWtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mMnzv7rdMAV1SxCR66NNMWTYqkswM31rbF0MHLdSCOGYXB5N7Qdo3oOsrZSq0ZSZp
	 5VY5+r4Z9fq2fdgtl1JoV63rUm8f/5T52p3OExHtW4ogbnFXsnhrcoex41XInk+WAD
	 xloTrnhkWPEnev1KwVrntSHRYLBU/5lQr83y/ksk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Allison Henderson <allison.henderson@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3192/3318] rds:Simplify the allocation of slab caches
Date: Wed, 18 Nov 2026 16:03:34 +0100
Message-ID: <20261118150455.539164992@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongfu Li <lihongfu@kylinos.cn>

[ Upstream commit 9f1f70dd850038b37e8b103ef0cc6f5eaeb6a8fc ]

Use the new KMEM_CACHE() macro instead of direct kmem_cache_create
to simplify the creation of SLAB caches.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ffbbc315b8b8 ("net/rds: do not initialize transports after rds_init() failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/tcp.c      | 4 +---
 net/rds/tcp_recv.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 637359a334502..fb6234748c582 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -820,9 +820,7 @@ static int __init rds_tcp_init(void)
 {
 	int ret;
 
-	rds_tcp_conn_slab = kmem_cache_create("rds_tcp_connection",
-					      sizeof(struct rds_tcp_connection),
-					      0, 0, NULL);
+	rds_tcp_conn_slab = KMEM_CACHE(rds_tcp_connection, 0);
 	if (!rds_tcp_conn_slab) {
 		ret = -ENOMEM;
 		goto out;
diff --git a/net/rds/tcp_recv.c b/net/rds/tcp_recv.c
index c00f04a1a5347..7997a19d1da30 100644
--- a/net/rds/tcp_recv.c
+++ b/net/rds/tcp_recv.c
@@ -337,9 +337,7 @@ void rds_tcp_data_ready(struct sock *sk)
 
 int rds_tcp_recv_init(void)
 {
-	rds_tcp_incoming_slab = kmem_cache_create("rds_tcp_incoming",
-					sizeof(struct rds_tcp_incoming),
-					0, 0, NULL);
+	rds_tcp_incoming_slab = KMEM_CACHE(rds_tcp_incoming, 0);
 	if (!rds_tcp_incoming_slab)
 		return -ENOMEM;
 	return 0;
-- 
2.53.0



