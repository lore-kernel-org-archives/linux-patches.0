Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062091;
	b=kDmBTavufOG1j0u4bBT3+/MngFZCz7qaEqB0lBkRHHFtvfo64NrcYMDr+U5jCOHdEJo7
	 Wm8SaO194ikCJua/+8CAfPlrmb9pOBbBWNJPAbdJmFdxEpHIWBcqAtlGajx1Wf6bRWBcD
	 ch3UFVFwQSXbmVPIC9Oi4Wz5IqnQutcG+5Vbit0/3gyrTH/XDl7F8vrAnolcMAbWPK5WZ
	 pvmf62GiznteoxSNFCO6wLmEv1Yyj/1y8AQ1V+vcfSa39/xY6pFozwG85TWp6lleOMIoF
	 Pc8skskQ8tYQR8khmz8B0Z+/KPZ+cXcAhLwvMKQeWDZk6DLw0wcXn20I51Ajbh8rwng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1ahPj0Mff8rinF+A7PuZmgVFas3pQmt8io9EX+Z6lK0=;
	b=z1sQzAfn0xgDOWCixFHgqYt8aPmnN+MOmzrN8+hqDzd4P4wrNNrfqE8kWwmjPZwaVZJf
	 fFaWrq/ZOBje/NMPaps6E4R08OSEW9sllR9J2JSAXN3AiQ133m+PDwSL6eShdrkFhOmRE
	 pd01gj67mV9vimmf/gvrBsaC7uDAj+YakKiK3UtydMmJ+dpsf2NtUx13dhoXZLfCbmPTo
	 Ua8E6kPc+VOFh8n+k2+icxPotNIxpECVDn1lDaM22P1j2rF4IsPWk/b7QDhiEQB12Y4tk
	 ohStUlbtR1qP/pk2b1rkA/TcuyZtaGtH8YGbARQQ+Ozqant8MPuR50bfgsOkIkS8ohg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kx5kg8N4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4244E606A320;
	Thu, 19 Nov 2026 04:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kx5kg8N4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931F31F000C4;
	Thu, 19 Nov 2026 04:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062091;
	bh=1ahPj0Mff8rinF+A7PuZmgVFas3pQmt8io9EX+Z6lK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kx5kg8N40jyhTo2YIKnrHCXrZT6SZsW60N9yqaCtSijC7l1UnLaOtU89MUg/z9Xw6
	 158zCiFc3arBTVgMzZhJjosZK6BDUk3YSp/K9yOaCzR11n60BtR24LB6KpPWuGa89M
	 zl8ZRIoBWxcXr5Ycs7mUe/W2ecFFLC4MIxlvB1vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1787/1848] net: rds: add missing __init/__exit annotations to module init/exit funcs
Date: Wed, 18 Nov 2026 16:03:45 +0100
Message-ID: <20261118150034.126247093@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit f0bd32c833826ba666c30af0bae78fc5ca598138 ]

Add missing __init/__exit annotations to module init/exit funcs.

Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Link: https://lore.kernel.org/r/20220909091840.247946-1-xiujianfeng@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ffbbc315b8b8 ("net/rds: do not initialize transports after rds_init() failed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/af_rds.c         | 2 +-
 net/rds/rdma_transport.c | 4 ++--
 net/rds/tcp.c            | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/rds/af_rds.c b/net/rds/af_rds.c
index 6b4182b3f7f48..00f6d3d6e242f 100644
--- a/net/rds/af_rds.c
+++ b/net/rds/af_rds.c
@@ -944,7 +944,7 @@ module_exit(rds_exit);
 
 u32 rds_gen_num;
 
-static int rds_init(void)
+static int __init rds_init(void)
 {
 	int ret;
 
diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index 407f577b24313..17231a109240b 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -310,7 +310,7 @@ static void rds_rdma_listen_stop(void)
 #endif
 }
 
-static int rds_rdma_init(void)
+static int __init rds_rdma_init(void)
 {
 	int ret;
 
@@ -326,7 +326,7 @@ static int rds_rdma_init(void)
 }
 module_init(rds_rdma_init);
 
-static void rds_rdma_exit(void)
+static void __exit rds_rdma_exit(void)
 {
 	/* stop listening first to ensure no new connections are attempted */
 	rds_rdma_listen_stop();
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index f8bf7356f78dc..1d3fc063465bf 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -771,7 +771,7 @@ static void rds_tcp_exit(void)
 }
 module_exit(rds_tcp_exit);
 
-static int rds_tcp_init(void)
+static int __init rds_tcp_init(void)
 {
 	int ret;
 
-- 
2.53.0



