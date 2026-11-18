Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050562;
	b=qA+IJd2pRlfyvqU01SsuyyANBL38leN9w+d1ssAjcOTm2DWaSVfyCyIWf0BM9evTA0E+
	 lBCsJUtAXZnb8wIv60v8k5e5488KAj8Ab2Ocade26fLC3x34d42Q9XsYZvg547iv0NB8n
	 wGIBSdwM2stNeTGuzXATXHpAC/hRsg+YQUPKtYWs8l9IljXqb5cZH4LsKDJRsycutjPeP
	 Tzc0BcQi2/diOqNyFfSZD0T7XJY3U/J9APN79R0l6+u1hWoikbhd574LYgU9i4XKMCq8t
	 j+nKF+3yRmxv5WBaYs/ShgATScQrmc4BV6mYn7xG8LeI7e457ie+kbwcMV3vR4mr/Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QJOHccbY4lk3Nch9z7sbdClmAhNPtCHSUsmKX1vBz5o=;
	b=m6RED6bb4kK+5L/hk/teTMF4FWd0qfrALubDC4k3tPtMmm06ThOvP7SaeeWjRj2BntMA
	 32v5nPk3xWDgJK655X1cKNhY06uBNjfxB/RB/Plym5jLhMcOZ9px24sBHhVrftWrG2AuU
	 UJLQwHPNhkPA5BrXkR1o2txOdtEMS25CWEGnr4w96ePkPGWddy0ZZJrDzEdDS+Pr8rkLZ
	 qTlP5ifY2FHZveElMdnsGkiMKcpdbjW+oFkrIfLHjz6wchfDX3Gm4E08ahvq2+S8GeE7j
	 +0xsaKrJ/ArUatgR1KzCLpee6/AdPZDDbPG0uL5t8lhqVM/hYE873n2mb5jsPXFYaaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uich7tW9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B45D606A320;
	Thu, 19 Nov 2026 01:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uich7tW9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6491F000C4;
	Thu, 19 Nov 2026 01:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050562;
	bh=QJOHccbY4lk3Nch9z7sbdClmAhNPtCHSUsmKX1vBz5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uich7tW95LvSsByf7Jp2Z7ZCW/0b+pRhaynAlExrYE6SrjJJdHclrvY4HJhVhMsDk
	 czHn2yLwp7+JOJmTiTBW0gyB3deJTgKjrSnfvh83/xmyyIXUvOsD7Qd5CykYmvjGVs
	 0+gb1KtZtENt8jXXl2751N1lerh6/JZt98xX16yI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Allison Henderson <allison.henderson@oracle.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2750/2857] rds:Simplify the allocation of slab caches
Date: Wed, 18 Nov 2026 16:03:04 +0100
Message-ID: <20261118150340.629305613@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 0967540f90f6b..b0cb3ef9f0659 100644
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
index f4ee13da90c70..dac500fd2bc84 100644
--- a/net/rds/tcp_recv.c
+++ b/net/rds/tcp_recv.c
@@ -335,9 +335,7 @@ void rds_tcp_data_ready(struct sock *sk)
 
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



