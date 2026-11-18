Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024828;
	b=ayhyUkH+C3LjdCAQxjy8TfJpoS5asVqO/cR81+HOIV1ygrUSmHl+HJuapR6h/cVxh9yw
	 53Spyc4515PP+y89Bkc2HwzcJi3VfMimUbJJ/RCalOC6W1HOI7V4G6GxS4iI2ToOT9TBQ
	 VAmlLmd79aEwqHNd8VEUz/kKZlKVX2+VXk75b0OLgKHb9H3NmlP1wRtJU0el+c6ZjrP9L
	 f71SmN2K5u2r0HzzzJRP+QH6JS1XtrDc5kRnnK8Jmx//ridn22EDyiM+fItOXHKSRoPM3
	 n5L7xJqHcn+zU3tZQA3qNvQK8kyWCwKYeBScNnyfe2RIj7pXlhbcqBpcQ2y1DituZ/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DH33r/CN6COFjLFqwJ2fCram3zOblF62oog2XwjN2bY=;
	b=EqYVU5njLMjbIuXKDew4QqSXZe3eIy2FXNJSPXtyBzUnUW4UiGMpD+guPT8jAhJJFwbe
	 NXUjCoANDqbbdke7Vx7IEkrRheTJs9gxEPpbfokOEMFxSAHac2IhwFtBlUkvG7lu+9HnY
	 coeKrMwgdmHyPYKCIuJBFblavzJuP0dZldK0HwJwxPlhSR5Jax7nv/8WNOywfZIudAPpM
	 ybAj+if9k63uMcRvE9d6qamnUKOjPTX47MUJYQ84Y/WRc/KdMftq577KzW9njpwkNKwBs
	 iOfsmjbSRfsPTfrnSFl+FSCduHWrXfqGBX8JLiSYu7Ws5/AKr71LDkzTKxrr+VFI29Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2eCYaaoR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F55606A334;
	Wed, 18 Nov 2026 18:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2eCYaaoR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768771F000C5;
	Wed, 18 Nov 2026 18:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024828;
	bh=DH33r/CN6COFjLFqwJ2fCram3zOblF62oog2XwjN2bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2eCYaaoRnF/kHyScxvlDFLwUV6qE/aCE04R/yAr+InrhfQZ4XZWaPJlsIsqqcs311
	 y8TDGC8jVYjKNb7Qz2HRYC/LwDqLDSAVNT1Xfi1ptFu01KvboiyVepFpCAwLZxDOvA
	 xl768QFZzUjvTv4ie9/In4ibKeShrrdebqbMEtq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0861/2151] RDMA/bnxt_re: Fix the PD and DPI table size
Date: Wed, 18 Nov 2026 15:43:16 +0100
Message-ID: <20261118150153.595973800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit aa6c2ef821a6ba7f3fd58cfcc031b2d16f3811c6 ]

The PD and DPI bitmaps were sized as max >> 3 (bytes),
but bitmap ops (set_bit(), clear_bit(), find_first_bit(),
test_and_set_bit()) operate on whole unsigned long words,
so whenever max isn't a multiple of BITS_PER_LONG,
the buffer under-allocates and the top word's bitops
read/write past the end of the kmalloc()'d buffer.
Most exposed on the DPI table, since dpit->max comes from the
firmware-reported dev_attr->max_dpi with no alignment guarantee.

Fix the size of both allocations with
BITS_TO_LONGS(max) * sizeof(unsigned long).

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index 0fcea79eb110d..d92db77e7ed50 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -45,6 +45,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/if_vlan.h>
 #include <linux/vmalloc.h>
+#include <linux/bitops.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/iter.h>
 
@@ -668,9 +669,9 @@ static int bnxt_qplib_alloc_pd_tbl(struct bnxt_qplib_res *res,
 {
 	u32 bytes;
 
-	bytes = max >> 3;
+	bytes = BITS_TO_LONGS(max) * sizeof(unsigned long);
 	if (!bytes)
-		bytes = 1;
+		bytes = sizeof(unsigned long);
 	pdt->tbl = kmalloc(bytes, GFP_KERNEL);
 	if (!pdt->tbl)
 		return -ENOMEM;
@@ -805,9 +806,9 @@ static int bnxt_qplib_alloc_dpi_tbl(struct bnxt_qplib_res *res,
 	if (!dpit->app_tbl)
 		return -ENOMEM;
 
-	bytes = dpit->max >> 3;
+	bytes = BITS_TO_LONGS(dpit->max) * sizeof(unsigned long);
 	if (!bytes)
-		bytes = 1;
+		bytes = sizeof(unsigned long);
 
 	dpit->tbl = kmalloc(bytes, GFP_KERNEL);
 	if (!dpit->tbl) {
-- 
2.53.0



