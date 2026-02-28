Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589634BC018;
	Sat, 28 Feb 2026 17:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301349; cv=none; b=O8ts28zS7UYEbWo/0rWF4Q00Tq1LYAIZYoUynojcC8saKu7sKUgjBd6Xgqqf1vh1UyMg3EYXvAfCoZLm3e1avdUD2ODz4orSZH5+WoaMAYFgvwE+K9a32eXe4ZXm+8/XSRNS1mwp7CknyfMN+2dVdY5nnqfsCwycWS6WfXKltbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301349; c=relaxed/simple;
	bh=lhXnGwmdh85DzCOT/wLJjkLUSg5MH+79X/nuB8V2xns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSulL+5ORhw1GCTiO2Gjt/rLaqNKMdWVRBakNslkxVe4iFnwreCgzcVxoexDIjDdFJkK1JoBSH31B8RAFtyrS0dSYviX6T6aU1Nj8cKOQwVkEtDUTHPcMoFwbaw9fC9/g1DqqSh0UBaA6eprMLjXtsggFKa935xO3OWfBvhXdZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KXrfUTyX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KXrfUTyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D81C116D0;
	Sat, 28 Feb 2026 17:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301349;
	bh=lhXnGwmdh85DzCOT/wLJjkLUSg5MH+79X/nuB8V2xns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KXrfUTyXnufHNKU823sutpVnji5IhYVTKT6MhZ2i4A40gdG1/gc48ikrJH2Oqrnnm
	 2JYQSrUszIkyMYrJYJi5U1wPJguwOqalkdFv7COFIhLG00E/eVODkAcSrOpZ4UmJOn
	 d2PHH4raUOVu4kxn1aju40JSbOl1mV6OkBUOuaPf6NPfMEevBOpSoGlQTO/ml+NPQW
	 9SGwvHN+alR2OjPwzvtH+DbDwaHRZi6DL4w5G/rrF3bv+myKihrP2BAuAhQoKIY5Nb
	 zshnuZWTUz7bkgPSZwIIIq8fFmVAIm9HMLbTCWk1USq5vKb6EvEr5TK2/DMCmmRc2K
	 WPLq2USkr6iAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Bingbu Cao <bingbu.cao@intel.com>,
	Stable@vger.kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 536/752] media: staging/ipu7: Update CDPHY register settings
Date: Sat, 28 Feb 2026 12:44:07 -0500
Message-ID: <20260228174750.1542406-536-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Bingbu Cao <bingbu.cao@intel.com>

[ Upstream commit f7923e6bafcad686adb51cc100ba1860f8b43922 ]

Some CPHY settings needs to updated according to the latest guide from
SNPS. This patch program 45ohm for tuning resistance to fix CPHY problem
and update the ITMINRX and GMODE for CPHY.

Cc: Stable@vger.kernel.org
Fixes: a516d36bdc3d ("media: staging/ipu7: add IPU7 input system device driver")
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/ipu7/ipu7-isys-csi-phy.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/ipu7/ipu7-isys-csi-phy.c b/drivers/staging/media/ipu7/ipu7-isys-csi-phy.c
index b8c5db7ae3009..d8f3592ad6201 100644
--- a/drivers/staging/media/ipu7/ipu7-isys-csi-phy.c
+++ b/drivers/staging/media/ipu7/ipu7-isys-csi-phy.c
@@ -124,6 +124,7 @@ static const struct cdr_fbk_cap_prog_params table7[] = {
 	{ 1350, 1589, 4 },
 	{ 1590, 1949, 5 },
 	{ 1950, 2499, 6 },
+	{ 2500, 3500, 7 },
 	{ }
 };
 
@@ -838,9 +839,10 @@ static void ipu7_isys_cphy_config(struct ipu7_isys *isys, u8 id, u8 lanes,
 		dwc_phy_write_mask(isys, id, reg + 0x400 * i,
 				   reset_thresh, 9, 11);
 
+	/* Tuning ITMINRX to 2 for CPHY */
 	reg = CORE_DIG_CLANE_0_RW_LP_0;
 	for (i = 0; i < trios; i++)
-		dwc_phy_write_mask(isys, id, reg + 0x400 * i, 1, 12, 15);
+		dwc_phy_write_mask(isys, id, reg + 0x400 * i, 2, 12, 15);
 
 	reg = CORE_DIG_CLANE_0_RW_LP_2;
 	for (i = 0; i < trios; i++)
@@ -860,7 +862,11 @@ static void ipu7_isys_cphy_config(struct ipu7_isys *isys, u8 id, u8 lanes,
 	for (i = 0; i < (lanes + 1); i++) {
 		reg = CORE_DIG_IOCTRL_RW_AFE_LANE0_CTRL_2_9 + 0x400 * i;
 		dwc_phy_write_mask(isys, id, reg, 4U, 0, 2);
-		dwc_phy_write_mask(isys, id, reg, 0U, 3, 4);
+		/* Set GMODE to 2 when CPHY >= 1.5Gsps */
+		if (mbps >= 1500)
+			dwc_phy_write_mask(isys, id, reg, 2U, 3, 4);
+		else
+			dwc_phy_write_mask(isys, id, reg, 0U, 3, 4);
 
 		reg = CORE_DIG_IOCTRL_RW_AFE_LANE0_CTRL_2_7 + 0x400 * i;
 		dwc_phy_write_mask(isys, id, reg, cap_prog, 10, 12);
@@ -930,8 +936,9 @@ static int ipu7_isys_phy_config(struct ipu7_isys *isys, u8 id, u8 lanes,
 			   7, 12, 14);
 	dwc_phy_write_mask(isys, id, CORE_DIG_IOCTRL_RW_AFE_CB_CTRL_2_7,
 			   0, 8, 10);
+	/* resistance tuning: 1 for 45ohm, 0 for 50ohm */
 	dwc_phy_write_mask(isys, id, CORE_DIG_IOCTRL_RW_AFE_CB_CTRL_2_5,
-			   0, 8, 8);
+			   1, 8, 8);
 
 	if (aggregation)
 		phy_mode = isys->csi2[0].phy_mode;
-- 
2.51.0

