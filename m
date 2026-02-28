Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A012346E5E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302621; cv=none; b=gMf+qTfJdQhvBOxA/07Hg26/wWImR1n92YnWKE+7bAZsurIOcNt+JDDNyNNPn2yxLomgboRblLX+wIKFLCn+B6V9BFnNqsqevCkNNMcdw8cKGbbEuXKuCXtrG3WGKT64TkaEKBHWOeyO6DGPddhw/NiQgkjfppjLBbehsLpGXVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302621; c=relaxed/simple;
	bh=OfClsPc+6vglVTFABxcmg4jNSV3OX7xEiyNb4x7IrfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uedr+2YFJMb5yQ/+eVXUUXhRlhdI90DvVf0bhiCQTEdsdiu/jdd0pyMttV2luiik7fFuL6P71m9+rbfSLla+Iv6h9ixTT2MErh5RLJrDH2tKKqxY9OLpu1vFBPoKnECnKOUp5IwYdOvlRakHFmcPMABeviwOP7nS8NuT6SGXzzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O3iPnn8y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O3iPnn8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6594FC116D0;
	Sat, 28 Feb 2026 18:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302621;
	bh=OfClsPc+6vglVTFABxcmg4jNSV3OX7xEiyNb4x7IrfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3iPnn8yp+7hCneHmtJxxD2OZUw4jA1le/pnxThyl/twDE6neprm171ls/oKiHlrt
	 ByE/oqZ3L0h5um4z5eZxWdQdnmtwBFYwQ6LgfNNNbOYng36fbEPvRDtP6f3Be84sql
	 iulEywXczSwm8yHfJtwQvbSNOPGRq9cG2/wlzdFK4j/aENM+mUVnboyZkOa77Gf/HI
	 HPFGLUObf7Zx5s3zLtysOywaV8fVUVN1hHwLOorT96GrcyicdwM+GmR2eYkD7OA0HM
	 Qy3Res3b3gVBvs/H0SN+Qa8AbXzFTS7mJO4P9ftkhsh67PeblPoImCloZb7rgFC8l+
	 2Fgjuc9u8OJEQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 139/164] Revert "mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms"
Date: Sat, 28 Feb 2026 13:14:38 -0500
Message-ID: <20260228181505.1600663-139-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit ff112f1ecd10b72004eac05bae395e1c65f0c63c ]

This reverts commit aced969e9bf3701dc75cfca57c78c031b7875b9d.

It was determined that this was not the correct "fix", so should be
reverted.

Fixes: aced969e9bf3 ("mmc: rtsx_pci_sdmmc: increase power-on settling delay to 5ms")
Cc: Matthew Schwartz <matthew.schwartz@linux.dev>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 02da9016245bd..d063d50d69feb 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -938,7 +938,7 @@ static int sd_power_on(struct realtek_pci_sdmmc *host, unsigned char power_mode)
 	if (err < 0)
 		return err;
 
-	mdelay(5);
+	mdelay(1);
 
 	err = rtsx_pci_write_register(pcr, CARD_OE, SD_OUTPUT_EN, SD_OUTPUT_EN);
 	if (err < 0)
-- 
2.51.0

