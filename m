Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061006;
	b=XHcFPCOxfJp+HQ2Bq/qNoX83KPIc1Sf20/t454a94WqzYTxFN2Jm3Q5LfMpNO+LQ/mu0
	 gi+iyAo0+AzM6Sn3GWKR4RqXBGYR9a7nRdq/ttDL+vxF9xARCm6PmAEgzWvPXUPdE2gNY
	 qdJj/tCyF/DV5J//sTcAYWTdnWI/AnkLgrAx3p/Z/vw6YKROqsgFaPi3fu6c+Rlc+J4zl
	 rPceFbQMNNYnjS3rrnEtRyPGyhkYiSnCmGYuZHoSuZJNrPvy1ryfmjJNFE+FU7qf3OQYW
	 ZLJ4F8VMcCD7fOMnqm4vC2uvQVzcqKYP4ZT4RS3f9vmWfmiGRaBRSEBIkWQaQ+dVWsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7IvZEUd555+IM9hEBC3nMSEtB0GXh+o8GSzgKmkxlC8=;
	b=xWuzMl9rciwW/Dkio5S6UwfZHqTMbuR9OQWmg8If+q8WjOFB+cgcj03JsvlphVzny9f2
	 0ZtvVMvhllQtZJIpsbl36jYEEU03tiXcj2Gp3BAG5b01h7qHkF8TtzZ6QQ7kyztsNfjMl
	 1B31vmflJiYGeL4KvrzJwiK1bbZuZ+6drADqT7oPZH+Q1nQVtKyQu7CUvq/RuvOnqiQMi
	 SCqOB10XNoadLgzdWvCUQXKk0QZXqSenOQ/BO9aXGoSAiJzXm0qZY7l6mrbh9YTjNLbkg
	 iVpPqJYekNnmsl4TfQ0F8jGacZbwwNI/hq5z7i1HU9n+2+UQQMweplbQC4+gYgKkFMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X5zyvVdY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885D4606A320;
	Thu, 19 Nov 2026 04:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X5zyvVdY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2031F000C4;
	Thu, 19 Nov 2026 04:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061006;
	bh=7IvZEUd555+IM9hEBC3nMSEtB0GXh+o8GSzgKmkxlC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X5zyvVdYU4vUXo9AvtJ/fubn0h8ehO2nNVFvuqq0LexOzWnzTZFV0ueZpGWabTfRb
	 HoxvTxtoFFhN/WIlPfmUPfuIo5N7Ya06U62YobrD7c/+EgETj7+A5NQSAfL+7yBwk/
	 Tsx9wwsQxJ/MRKiPDZhrKiwdZwgfut+6b8Jjsg8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1400/1848] RDMA/bnxt_re: Fix the PD and DPI table size
Date: Wed, 18 Nov 2026 15:57:18 +0100
Message-ID: <20261118150018.143268056@linuxfoundation.org>
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
index 49e6b9fae36e7..c601e0d15fcc6 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -45,6 +45,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/if_vlan.h>
 #include <linux/vmalloc.h>
+#include <linux/bitops.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/iter.h>
 
@@ -712,9 +713,9 @@ static int bnxt_qplib_alloc_pd_tbl(struct bnxt_qplib_res *res,
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
@@ -819,9 +820,9 @@ static int bnxt_qplib_alloc_dpi_tbl(struct bnxt_qplib_res     *res,
 	if (!dpit->app_tbl)
 		goto unmap_io;
 
-	bytes = dpit->max >> 3;
+	bytes = BITS_TO_LONGS(dpit->max) * sizeof(unsigned long);
 	if (!bytes)
-		bytes = 1;
+		bytes = sizeof(unsigned long);
 
 	dpit->tbl = kmalloc(bytes, GFP_KERNEL);
 	if (!dpit->tbl) {
-- 
2.53.0



