Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056858;
	b=wM+fKr8o4imFaDEWz+CVhKEiG23KgCN0wxdQLdqSXrlc5TWGQ6lCuCaiR8vbn8QnGAr2
	 76dc2Po9NLnlw8ajikd6aIcE9fBNNLTpUMY1CDAVMolyXwN4Nw+yugClI9/C0Z5JkV1qh
	 epgoYSlCCrBnmDuoCycpoVUk4RRCcLxqm224VdHx83+JjxVap8UKXkSn/zpbAO6dV0fso
	 FmW11ltk/XiX9rQfOQQj4d0R6N3jT8t0kRXG+wk48umxTebPTKNkTLDRO6N7XeXNN239v
	 YpCuDgESsfwUPpHLf7r83Kv8iYKQc1YlSfgnkieKuKBZlc+sVfxBEt3IO1aviuc0RMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+0FpjjdmnfRqqFy8EyVXOVAoVVNe48RycoQDU2i7VEg=;
	b=qqC/6r8ffDMwI1T9Ayypi2enFKipsBptsXUfkslWODyddwn9nfXNwrrKQhqi1bOgFPm6
	 AcT2bLaBgYeSYwTbrDcxe5rinjhjoQEq3NKvqEANkLZUKNfSILsZfvIwNBODpJYMRWSdv
	 lmez0RYUWbPYzoo16+aGGlmqaAhO28Bga6CzmgjUSzEW5qMK2OHrLfm8xdzacov9j4O15
	 vRoxyiecTw4sKXn36SbLd8qzZvJ9f3uRqQKWu15kbwTypfR1b+OctwnoSLkNhoyRHhS/z
	 vehmPjGSqRa05cWaNQuYSSLUWo+nIrC7YbIeUEYRp0wq1iZcfg4jOVobHKc33//eGuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ya3A2HnU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBED0606A325;
	Thu, 19 Nov 2026 02:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ya3A2HnU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454241F000C4;
	Thu, 19 Nov 2026 02:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056857;
	bh=+0FpjjdmnfRqqFy8EyVXOVAoVVNe48RycoQDU2i7VEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ya3A2HnUJJdxBc8oHfMO5PDxBXKIlWs+jrmqBKdPn1HbFWfhFXMoeYIyXRWZlpVx9
	 61WP7MhOH2BlcHN3NZ/LJoeYevL80noJA90hW0N0960gk1ogdc4hJEg7VSJkbsmqK1
	 Xe83i545XPDUpkYPdN7eFqZOqJW+9+ZJFkMGadew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2138/2214] net: rds: add missing __init/__exit annotations to module init/exit funcs
Date: Wed, 18 Nov 2026 16:03:34 +0100
Message-ID: <20261118150136.041075690@linuxfoundation.org>
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
index 3f7da1d7ad18b..7be38be1228ec 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -321,7 +321,7 @@ static void rds_rdma_listen_stop(void)
 #endif
 }
 
-static int rds_rdma_init(void)
+static int __init rds_rdma_init(void)
 {
 	int ret;
 
@@ -337,7 +337,7 @@ static int rds_rdma_init(void)
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



