Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017800;
	b=q4bdJxTgQXrhUojXt7ynfdABdDXM0bmnFBdNJUejDZafcLxY11U6FKrE2NRISqDgIGre
	 jJ0k1HNL0rmEQNNFKSnThlq4DjKen78gQSqPzkwGpr8DufzFfwA/tH38IZc90ruk4WtZJ
	 ZttSyJhS80LA0HiN7v5NgUKLMmzJMrCFDhWm+Knq+EjdyoY8e/ovjBOVSuNpOONbJSzTh
	 2+KZdKBPt7qrpF8bDXV1MCBLIx7znKh8V2Ew2GAs1NEtrtcW436Eihi29nC4KlJtMDHGN
	 +RZc4jybRikXQMBA6VpsjYrYAHRfbDJWaGF8bZ7DMhq6F8uGPDU8iv70jkYNiD6wuKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cxz8z8MatanjeuV/0ecrjxP9ARFW3yZho5ykc/0an4o=;
	b=bCWJ7PmkHEtbbLFhzGgBT7xyydPLHMdPU4MNiKdkDK5NF1nl9f8KSKbOxqf5rHO/S0wu
	 NRhUw0An1C2bkMogrkhQn15CI7n8D/FXsV3GBVqiOwjtWq5YnFJs11PUPRey1BkHj4enD
	 Sv/oZV/w92zvFTqm2IduNfHXxeq45l4r3Kp64nkmYw0QkVGSibiLHues1dCFGk6gWvP5f
	 Deqs5Er4lGlczUVc9EG/mfswDx4CsoqXzkgOLMm6gA6tD3tme+Xo/Kc1E/5bHs61Z1NVH
	 w/myYAJNJkb3pksLqUYvWe5Qtj5f+YKhxnvKrpL4MOzGRqZZE7eVplGNmOobwULYYkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=njFRAoNd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6BE606A325;
	Wed, 18 Nov 2026 16:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=njFRAoNd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1E01F000C5;
	Wed, 18 Nov 2026 16:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017800;
	bh=Cxz8z8MatanjeuV/0ecrjxP9ARFW3yZho5ykc/0an4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njFRAoNdIrzoIqrmPkyAk3+IwdZbKgPcHhw7uWM0eXDSxSO41HcWd4b/r6u9onSrY
	 t67MjZhFmgVZMHBeahVDp8wj1zP9+goqLWgS1LKl7KFCFpLk5CyuXBdqQLzXh3hpsL
	 p/cH96OWFMzUDqS+2YVooyDDuzGXavE1bZDP0znc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1014/2651] RDMA/bnxt_re: Fix the PD and DPI table size
Date: Wed, 18 Nov 2026 15:37:34 +0100
Message-ID: <20261118150324.428287256@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 756f8b5f042a9..7ff587ce91269 100644
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
@@ -848,9 +849,9 @@ static int bnxt_qplib_alloc_dpi_tbl(struct bnxt_qplib_res *res,
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



