Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0382FE042;
	Tue, 31 Mar 2026 17:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976750; cv=none; b=oliX/oVZ44Vx1JvwPcw7NGIlVA9JrNYC2lt9wvO63p/J4ZlZlxYkCIEtMPzWRC4eq+e1TtFHjZKW1OJ+UaXB3uAVOjtlw0f9zOvAko+BPcByyrYzsRFJ0WqmPc3KOPHYSRrExuUHCmfw3k7lyLv06xl2DtXS1g3Ae9g5786rcmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976750; c=relaxed/simple;
	bh=IG8hYLJOXVqzFYDwohPeWYVJ8Hjk8rTWArBYcKRMa9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y1C8Wv8MgkNVgkqBq3SV/1abu+LdzDJX8PKYkYux8EIpPCugbV6DGucCWy25dxlvzwzYiroli5LtOQEVnnVP91PtcnqcTPj+KtnGZKXfoeYvvMh6LN2wIFStp15jjJGKt+0St4nroFEaMLdMbXhPvf74KdgvYphACgfzKCxk1TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBhVwMgk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBhVwMgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58C4C19423;
	Tue, 31 Mar 2026 17:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976750;
	bh=IG8hYLJOXVqzFYDwohPeWYVJ8Hjk8rTWArBYcKRMa9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xBhVwMgk+g/fFUZ6xzeGR05cRx1diPJBEVizH5D8GpP8rmkoClgiTfkgPvv1cDvxB
	 2lmRBBYRduiCMDmpBrbwKktuoGYnu+PgDltVG1utdNGgugVIVIFIzoY/nbb4sRbhWk
	 ecK5/rJZqg07NheY+rsB0XWMt0yoSbVvi02FmzAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Rawat <nitin.rawat@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 214/309] phy: qcom: qmp-ufs: Fix SM8650 PCS table for Gear 4
Date: Tue, 31 Mar 2026 18:21:57 +0200
Message-ID: <20260331161801.324205240@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -928,6 +928,7 @@ static const struct qmp_phy_init_tbl sm8
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_MULTI_LANE_CTRL1, 0x02),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_MID_TERM_CTRL1, 0x43),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_PCS_CTRL1, 0xc1),
+	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_PLL_CNTL, 0x33),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_LARGE_AMP_DRV_LVL, 0x0f),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_RX_SIGDET_CTRL2, 0x68),
 	QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_POST_EMP_LVL_S4, 0x0e),
@@ -937,13 +938,11 @@ static const struct qmp_phy_init_tbl sm8
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


