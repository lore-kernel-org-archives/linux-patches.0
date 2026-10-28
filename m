Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214218;
	b=p8cWxfk/c+zUUVqqwX9a1KQz9dCiYiLuXFUKc0c8cyFvTXLFgb0v++Is3Tjk2DQemNJQ
	 taPpCphxyFRIdGdVYqRXZlMbxIETh+pYaHYhQNmFxErvockErgxfcQNSERjd4sGzjfzIZ
	 1jWtkoXPLK0325kRlIZ3OrCyD9YBLdzkVpqorhNQP4gdh0qpCqL2US9KXcJD1TZnfOemr
	 jfpeCr1biR3Nwor0//Mcr9dx/KOqwiJ8nSSfcbnS58T0vDQkKX/9+wgco3WEtXMRD4QNf
	 WxkULqHbNMXuia132zyyJc21Zma4D9ntjz6iP4y3+BaXH953DYIwHPDr/NF8sMTRrGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6+tux3Aq2foz7me+OQj2Bm6B7ZF+kiBDsinnjyJMaX4=;
	b=Q21r7mh6yA9YOu88rglNKX6Z4/aZcFRlgJ5+cbev/452XnyQZKBipy9/K7SKQ+DpS8Zf
	 V0GLSg0uTpY9UOazbIOpAo3VWeAGJ2wlkNyJbZ95Ovzc/GW8qYdsX/Udyp9RbIe/dQRCR
	 bFRGTgnxbpIVRZBORYIliVTIMapehym3Fa8Tdh2mQaLzT9LjlKR/d3TUwaPSmwZOWHaBN
	 DekUjQmKoesh2iOSnkA/q7MhdjPFuqSSuoFsvB/H/4NSL1raEIOFLnP14hNpRiANWksPS
	 q4hkPpY8ube24NHaTMohueIZho714AKPa2uMADmhKN5jmKmt7cjGMhX3K5sQmIf85rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yin5vc8r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62347606A327;
	Wed, 28 Oct 2026 19:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yin5vc8r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF61E1F013C0;
	Wed, 28 Oct 2026 19:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214218;
	bh=6+tux3Aq2foz7me+OQj2Bm6B7ZF+kiBDsinnjyJMaX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yin5vc8r3GOkDGC+yBXKL457LkKBz5IQ+UnUu9dqFV5OurECqUqpbuoivVKqvyaBr
	 liiO/sHgZMneO7DTlcphuBx3c10nuhw6BjdMMXgUOst2FgV/Qj/nBWgGfZD+rgmgPY
	 tYokZhEtJJluXF7P33gDyJviGdU2LUVEN3iv5F68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	Chanho Park <chanho61.park@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0781/1887] scsi: ufs: exynos: Disable iocc if dma-coherent property isnt set
Date: Wed, 28 Oct 2026 17:47:57 +0100
Message-ID: <20261028170517.212436492@linuxfoundation.org>
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

From: Peter Griffin <peter.griffin@linaro.org>

[ Upstream commit f92bb7436802f8eb7ee72dc911a33c8897fde366 ]

If dma-coherent property isn't set then descriptors are non-cacheable
and the iocc shareability bits should be disabled. Without this UFS can
end up in an incompatible configuration and suffer from random cache
related stability issues.

Suggested-by: Bart Van Assche <bvanassche@acm.org>
Fixes: cc52e15397cc ("scsi: ufs: ufs-exynos: Support ExynosAuto v9 UFS")
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://lore.kernel.org/r/20250319-exynos-ufs-stability-fixes-v2-3-96722cc2ba1b@linaro.org
Cc: Chanho Park <chanho61.park@samsung.com>
Cc: stable@vger.kernel.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-exynos.c | 17 +++++++++++++----
 drivers/ufs/host/ufs-exynos.h |  3 ++-
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index 17db3f8c8c516..6bb8da1436867 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -200,8 +200,8 @@ static int exynosauto_ufs_drv_init(struct device *dev, struct exynos_ufs *ufs)
 	/* IO Coherency setting */
 	if (ufs->sysreg) {
 		return regmap_update_bits(ufs->sysreg,
-					  ufs->shareability_reg_offset,
-					  UFS_SHARABLE, UFS_SHARABLE);
+					  ufs->iocc_offset,
+					  UFS_SHARABLE, ufs->iocc_val);
 	}
 
 	attr->tx_dif_p_nsec = 3200000;
@@ -1102,12 +1102,21 @@ static int exynos_ufs_parse_dt(struct device *dev, struct exynos_ufs *ufs)
 		ufs->sysreg = NULL;
 	else {
 		if (of_property_read_u32_index(np, "samsung,sysreg", 1,
-					       &ufs->shareability_reg_offset)) {
+					       &ufs->iocc_offset)) {
 			dev_warn(dev, "can't get an offset from sysreg. Set to default value\n");
-			ufs->shareability_reg_offset = UFS_SHAREABILITY_OFFSET;
+			ufs->iocc_offset = UFS_SHAREABILITY_OFFSET;
 		}
 	}
 
+	/*
+	 * no 'dma-coherent' property means the descriptors are
+	 * non-cacheable so iocc shareability should be disabled.
+	 */
+	if (of_dma_is_coherent(dev->of_node))
+		ufs->iocc_val = UFS_SHARABLE;
+	else
+		ufs->iocc_val = 0;
+
 	ufs->pclk_avail_min = PCLK_AVAIL_MIN;
 	ufs->pclk_avail_max = PCLK_AVAIL_MAX;
 
diff --git a/drivers/ufs/host/ufs-exynos.h b/drivers/ufs/host/ufs-exynos.h
index a4bd6646d7f13..65aa04d41c3eb 100644
--- a/drivers/ufs/host/ufs-exynos.h
+++ b/drivers/ufs/host/ufs-exynos.h
@@ -212,7 +212,8 @@ struct exynos_ufs {
 	ktime_t entry_hibern8_t;
 	const struct exynos_ufs_drv_data *drv_data;
 	struct regmap *sysreg;
-	u32 shareability_reg_offset;
+	u32 iocc_offset;
+	u32 iocc_val;
 
 	u32 opts;
 #define EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL		BIT(0)
-- 
2.53.0



