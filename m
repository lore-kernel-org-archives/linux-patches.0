Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3E2426D2B;
	Tue, 31 Mar 2026 16:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975974; cv=none; b=Ovi8jOvaIdzsY/oy1jiY7XbqjjoW7a7Y3d8RtWnAQTk2bXOYzwAN2JXBcFVWTkDHyP2Y0H4Veq4lW8Icr55QAysMzZL8nFV3j3sjH7Ymqo7UaQ/dvXPri0wvMmQJpqqax5HTzD7/7TXHl4omrNf50S3w+yl+7ujn7JOhJR1oxP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975974; c=relaxed/simple;
	bh=M8ZBvAIdyhGxpMlPsdIOgzVF2WzpkW/WWjojvVmShIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBh9kVV3GsqQaIGOGld9v1D4DJVOGDTJo+oYoyOx0viyN4qiQlinANPsFGGM5gGpInjU/NoFZChM6McB85VfJwPSzV+TUlEdQKl8zgPmbjU5d0iGEWGHBkqc5pBOvAN9btPCV00TEXFUU09Yvu1bNNTKTje0HLNnPrJf7QDx4WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kEMk8LnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kEMk8LnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D76C19423;
	Tue, 31 Mar 2026 16:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975974;
	bh=M8ZBvAIdyhGxpMlPsdIOgzVF2WzpkW/WWjojvVmShIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEMk8LnBCbKmJvYSfE/IltAy3aMV3v3mbHw50X7f1WhqO8WrsuN/qa3di8NTl1GpH
	 vLHrxCbyJ4fxJ3XISkfCLW5EKaONRZEGlqSidP4V1AbS4Q6Z7Aw52NDvc7PsKYEeri
	 i3KsCs1Hr+DZ+4c2Z2LuSPdlBKHFqvwFO2Tcoe+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Rawat <nitin.rawat@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 158/244] phy: qcom: qmp-ufs: Fix SM8650 PCS table for Gear 4
Date: Tue, 31 Mar 2026 18:21:48 +0200
Message-ID: <20260331161747.600066780@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

commit 81af9e40e2e4e1aa95f09fb34811760be6742c58 upstream.

According to internal documentation, on SM8650, when the PHY is configured
in Gear 4, the QPHY_V6_PCS_UFS_PLL_CNTL register needs to have the same
value as for Gear 5.

At the moment, there is no board that comes with a UFS 3.x device, so
this issue doesn't show up, but with the new Eliza SoC, which uses the
same init sequence as SM8650, on the MTP board, the link startup fails
with the current Gear 4 PCS table.

So fix that by moving the entry into the PCS generic table instead,
while keeping the value from Gear 5 configuration.

Cc: stable@vger.kernel.org # v6.10
Fixes: b9251e64a96f ("phy: qcom: qmp-ufs: update SM8650 tables for Gear 4 & 5")
Suggested-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Link: https://patch.msgid.link/20260219-phy-qcom-qmp-ufs-fix-sm8650-pcs-g4-table-v1-1-f136505b57f6@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
@@ -927,6 +927,7 @@ static const struct qmp_phy_init_tbl sm8
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_MULTI_LANE_CTRL1, 0x02),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_MID_TERM_CTRL1, 0x43),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_PCS_CTRL1, 0xc1),
+	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_PLL_CNTL, 0x33),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_LARGE_AMP_DRV_LVL, 0x0f),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_RX_SIGDET_CTRL2, 0x68),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_POST_EMP_LVL_S4, 0x0e),
@@ -936,13 +937,11 @@ static const struct qmp_phy_init_tbl sm8
 };
 
 static const struct qmp_phy_init_tbl sm8650_ufsphy_g4_pcs[] = {
-	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_PLL_CNTL, 0x13),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_HSGEAR_CAPABILITY, 0x04),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_RX_HSGEAR_CAPABILITY, 0x04),
 };
 
 static const struct qmp_phy_init_tbl sm8650_ufsphy_g5_pcs[] = {
-	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_PLL_CNTL, 0x33),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_HSGEAR_CAPABILITY, 0x05),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_RX_HSGEAR_CAPABILITY, 0x05),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_RX_HS_G5_SYNC_LENGTH_CAPABILITY, 0x4d),


