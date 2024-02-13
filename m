Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 134BC5FB94;
	Tue, 13 Feb 2024 17:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845671; cv=none; b=QS2n7ZQAHNt7I6uVi3Yqh8SZCF51ZBb8nbcyOlap56QeTpi4xCCumWZ3WGMVlfz7Uwx3zI7OOJG3ZUhbLJKwcJcd4dRcISS5RYtjI+177XYG1PFbsIquhLYUFumbei/BUf0I+//iAhKDm18CTC2R53nWua4VhLfAlbs97MIKMZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845671; c=relaxed/simple;
	bh=T1x4CsDJPPFQgGuw+N3EAOpNajp4grN5F36KvZ8qZ9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+5LUGKIoC3UpbBTX4Vf09poN/whcLUc/f0GValPDBkQPYayOdzQ3g8/4DCfeoDlOPn1RuVtZV+JzPQMpEuQ8WWK1WV+Cc292HiLJhntg+Zab99g/dQqYhCdGaXwN29/fORx1TKyZ8hMviuOxj6kuLfJUA95IcigYNjZj6U0Qzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDLz9Ypm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDLz9Ypm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C28FC433C7;
	Tue, 13 Feb 2024 17:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845670;
	bh=T1x4CsDJPPFQgGuw+N3EAOpNajp4grN5F36KvZ8qZ9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDLz9YpmzUqny767ClanaC8X3zLVgIJhZW3g8JssHgXPN2/v48yY3P8Er1YLlVKw8
	 PR+7oyf2uYl2dwempaWAaLaBQiZWALyQ0KnI6A5a33cSji6yzdwmQbR5vacoRhLjJF
	 3Q4HHGkmWZjTGK+sAnYTjq/Wzqi2QBnHOYO1vZx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mantas Pucka <mantas@8devices.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 007/124] phy: qcom-qmp-usb: fix serdes init sequence for IPQ6018
Date: Tue, 13 Feb 2024 18:20:29 +0100
Message-ID: <20240213171853.944332886@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mantas Pucka <mantas@8devices.com>

[ Upstream commit 62a5df451ab911421da96655fcc4d1e269ff6e2f ]

Commit 23fd679249df ("phy: qcom-qmp: add USB3 PHY support for IPQ6018")
noted that IPQ6018 init is identical to IPQ8074. Yet downstream uses
separate serdes init sequence for IPQ6018. Since already existing IPQ9574
serdes init sequence is identical, just reuse it and fix failing USB3 mode
in IPQ6018.

Fixes: 23fd679249df ("phy: qcom-qmp: add USB3 PHY support for IPQ6018")
Signed-off-by: Mantas Pucka <mantas@8devices.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/1706026160-17520-3-git-send-email-mantas@8devices.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
index 896a37c1e592..a3719719e2e0 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
@@ -1325,6 +1325,24 @@ static const struct qmp_usb_offsets qmp_usb_offsets_v5 = {
 	.rx		= 0x1000,
 };
 
+static const struct qmp_phy_cfg ipq6018_usb3phy_cfg = {
+	.lanes			= 1,
+
+	.offsets		= &qmp_usb_offsets_ipq8074,
+
+	.serdes_tbl		= ipq9574_usb3_serdes_tbl,
+	.serdes_tbl_num		= ARRAY_SIZE(ipq9574_usb3_serdes_tbl),
+	.tx_tbl			= msm8996_usb3_tx_tbl,
+	.tx_tbl_num		= ARRAY_SIZE(msm8996_usb3_tx_tbl),
+	.rx_tbl			= ipq8074_usb3_rx_tbl,
+	.rx_tbl_num		= ARRAY_SIZE(ipq8074_usb3_rx_tbl),
+	.pcs_tbl		= ipq8074_usb3_pcs_tbl,
+	.pcs_tbl_num		= ARRAY_SIZE(ipq8074_usb3_pcs_tbl),
+	.vreg_list		= qmp_phy_vreg_l,
+	.num_vregs		= ARRAY_SIZE(qmp_phy_vreg_l),
+	.regs			= qmp_v3_usb3phy_regs_layout,
+};
+
 static const struct qmp_phy_cfg ipq8074_usb3phy_cfg = {
 	.lanes			= 1,
 
@@ -2233,7 +2251,7 @@ static int qmp_usb_probe(struct platform_device *pdev)
 static const struct of_device_id qmp_usb_of_match_table[] = {
 	{
 		.compatible = "qcom,ipq6018-qmp-usb3-phy",
-		.data = &ipq8074_usb3phy_cfg,
+		.data = &ipq6018_usb3phy_cfg,
 	}, {
 		.compatible = "qcom,ipq8074-qmp-usb3-phy",
 		.data = &ipq8074_usb3phy_cfg,
-- 
2.43.0



