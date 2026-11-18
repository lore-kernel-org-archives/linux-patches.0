Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030395;
	b=uV9YaYaAIMwmzlXpG40xqgToH6mAXuLLeUvx72wrDBfaLaIBvXMVw9IyFWUbpIw8Xubh
	 naVCZFzRpfhhueeXCxbCXG3O6vyajgxtvW+UBkllSNaj/oUXOJqgYMJzgFQdnaUiW84Wk
	 u0422fDM7AkW2WjXZ4YKkjFW6OtjMgKB9Aic97nc7edZf1obiUXOAsC7C1EDNoTs7m1jT
	 TpyD1zDy6BNHZMA0thlQnfN95g2ahUcICx8B6KJPP8oZ4cq+b/eeL9LLtQGV8Z0/lz9E5
	 Ky+50T5+GypyCGDuekp9HMcxXmfOdCEspUfpUWDVBBldbsq6hIE02Cy1SfVF4d4D+vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4TONxrtuQhYqREzLp3v6l1CnlBDnJ+tcG7S3ShsxhvA=;
	b=Md3m3cgdxNcEnBzinwIHAl9b8RS29JiosKeXbH/N2qxN7/DrVtBvC99/TdrLMdBYqjqV
	 AYNeaQuURuC1zahRdDZEwmzpP/WNGgR5UxJlGavx2wMWB9tCgsgTkttJT1PTh1aIlqlSq
	 AiMYHc+H3ex2nDlUiY2Fdc8tHEmF2H66lb2++k7FKTFzLCDFDfvnrnP9muHUyoTNwW7VQ
	 og0tW3qgaTcND12qv4qUwoggUTpWZowoqxztkuiEWLYt0FOvv6ZXbHCw+9qt17VOezLzU
	 ADZbXCtr+ALCLr3YjJyHB+zgAn4SI2qcJn/H84R9LXRG8Ply9OaMmZ5rSIoSFscX+nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F3HA4MVG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8C1606A339;
	Wed, 18 Nov 2026 19:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F3HA4MVG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B231F000C4;
	Wed, 18 Nov 2026 19:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030395;
	bh=4TONxrtuQhYqREzLp3v6l1CnlBDnJ+tcG7S3ShsxhvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F3HA4MVGV8XbAAOXZujq0P4KBVFf1RwYHLIwWc2oTC1TuyHJNPSAg2mo+mtQEcmxH
	 414slApXTHUWmd92e/u4BZQaebaXnAWE/hBZVHpC3oT7748zm/7ZN86V8GIxp9nUQP
	 9F1a6IrGCyspnjyf5ZR1kxnILW+aiqPc3F7jNHwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0687/1756] RDMA/bnxt_re: Fix the PD and DPI table size
Date: Wed, 18 Nov 2026 15:46:54 +0100
Message-ID: <20261118150036.573984036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 5a99fa8e9be39..d43cbb953750c 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -45,6 +45,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/if_vlan.h>
 #include <linux/vmalloc.h>
+#include <linux/bitops.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/iter.h>
 
@@ -684,9 +685,9 @@ static int bnxt_qplib_alloc_pd_tbl(struct bnxt_qplib_res *res,
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
@@ -821,9 +822,9 @@ static int bnxt_qplib_alloc_dpi_tbl(struct bnxt_qplib_res *res,
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



