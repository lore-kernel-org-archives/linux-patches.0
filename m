Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4713ACF1B;
	Wed, 21 Jan 2026 18:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020258; cv=none; b=P09k1Ib5MPxAUYbqBpDiSxory1SiDToj7+cL6rwK+aaFEQk3lbjGyaSvzj7CwnCvUg6f+GzCVVwJM5FSiAoVq/d+d3btGlWA8LvcHyCM6fsozYhkwnEfkhWUaLA+yw5vuzyQayfW59p1eO1UBp+m0P4aGbL1BsgdyDM+gue2WdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020258; c=relaxed/simple;
	bh=YjIERI61gcjiu2QTcJPiqhbgbVgVauyGt595Q97D2GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/a6/yAIb/KFp2t3tVkkJa4H30xWtmI6IDYjtU8BLsz8GYS/IfmuF9ZyhZuUfoFOvj4qKbYCxq65r0eHifRoohQD8rabCsFj9Mm4UrF1Hc/iPD34MI3apQpuHaguoDIgoUj1SCoMAHJuNhRAsMy83wroqj5MW7LsZEeb9oAXlp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TROAX7Xh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TROAX7Xh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FE0C4CEF1;
	Wed, 21 Jan 2026 18:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020258;
	bh=YjIERI61gcjiu2QTcJPiqhbgbVgVauyGt595Q97D2GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TROAX7Xhiu/jbprW9HLUlYYEjO+1Mpuaw60zoxQCuXysJy38C0qcT4TN+sIEx3iJ8
	 iezXhQqTJVUQGDpruU2XCBYcdl/UeYg1OyqZ9FK9678gqNkkwzr5ywbCpsSNuqNcf8
	 dkms2b1LClJFYri0cY9sxYZ3z8mOFGSZJhmjfBn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonid Segal <leonids@variscite.com>,
	Pierluigi Passaro <pierluigi.p@variscite.com>,
	Stefano Radaelli <stefano.r@variscite.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Fabio Estevam <festevam@gmail.com>,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 073/198] phy: fsl-imx8mq-usb: Clear the PCS_TX_SWING_FULL field before using it
Date: Wed, 21 Jan 2026 19:15:01 +0100
Message-ID: <20260121181421.186415353@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Stefano Radaelli <stefano.radaelli21@gmail.com>

[ Upstream commit 8becf9179a4b45104a1701010ed666b55bf4b3a6 ]

Clear the PCS_TX_SWING_FULL field mask before setting the new value
in PHY_CTRL5 register. Without clearing the mask first, the OR operation
could leave previously set bits, resulting in incorrect register
configuration.

Fixes: 63c85ad0cd81 ("phy: fsl-imx8mp-usb: add support for phy tuning")
Suggested-by: Leonid Segal <leonids@variscite.com>
Acked-by: Pierluigi Passaro <pierluigi.p@variscite.com>
Signed-off-by: Stefano Radaelli <stefano.r@variscite.com>
Reviewed-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Reviewed-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Link: https://patch.msgid.link/20251219160912.561431-1-stefano.r@variscite.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/freescale/phy-fsl-imx8mq-usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/freescale/phy-fsl-imx8mq-usb.c b/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
index b94f242420fc7..0c84f5f7a82cb 100644
--- a/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
+++ b/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
@@ -502,6 +502,7 @@ static void imx8m_phy_tune(struct imx8mq_usb_phy *imx_phy)
 
 	if (imx_phy->pcs_tx_swing_full != PHY_TUNE_DEFAULT) {
 		value = readl(imx_phy->base + PHY_CTRL5);
+		value &= ~PHY_CTRL5_PCS_TX_SWING_FULL_MASK;
 		value |= FIELD_PREP(PHY_CTRL5_PCS_TX_SWING_FULL_MASK,
 				   imx_phy->pcs_tx_swing_full);
 		writel(value, imx_phy->base + PHY_CTRL5);
-- 
2.51.0



