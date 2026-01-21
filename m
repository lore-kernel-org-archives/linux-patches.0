Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C0A38735B;
	Wed, 21 Jan 2026 18:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019581; cv=none; b=gtzRTY5EcxKrImUaomNlsaAbQSLqKQFH7g4pcZgfmWFgCVeZ6saqsHPE6/RlwhImvFztLVkbY6cjCAY69b5Ajupg1sY+MzIgPpbeyxwH/WJTOg8RCYUkzvZNMM/L3Y4iylSQyNoeZmfH5aaKAO54Wh2KptQmM6Z8gUUkcRr6UMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019581; c=relaxed/simple;
	bh=ev+DY6ew5+nqDvDMOXxqdDihJt0qQMKd23i1M66d52A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYN++tzfkXd1bHoRI2J4QTy8jGE/frXU1uR+mE1+taVJhgL4PM3VrP0JsPlCOX6USoRleoa2KuYW8mTWoXUZMMygPta6R9BLDHZ1RvdQsJyhhWIZ2OErLS5UHK4+XxrbRY3xQqchQUWA6G6wOgHcZtS4G7zob/lATbkjEfjv9kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jp5wxbJy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jp5wxbJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D022C16AAE;
	Wed, 21 Jan 2026 18:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019580;
	bh=ev+DY6ew5+nqDvDMOXxqdDihJt0qQMKd23i1M66d52A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jp5wxbJynupsWbgpL23o8TRUWYPGxOpbbSGoOwNKnp7xdO4V9Jkmw4Z0DobsYmN3B
	 ZfbSBlL9g8Z5D3yqTmuLWnwfZx7rxT2+maSG1adqsOI4/2AaJDltoovb90GRiw2diY
	 eczGhHE7O+oVEUW5LE61xfJe3Dles5Cgv8a7u8JA=
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
Subject: [PATCH 6.12 047/139] phy: fsl-imx8mq-usb: Clear the PCS_TX_SWING_FULL field before using it
Date: Wed, 21 Jan 2026 19:14:55 +0100
Message-ID: <20260121181413.147412779@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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
index f914f016b3d2c..043063699e064 100644
--- a/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
+++ b/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
@@ -206,6 +206,7 @@ static void imx8m_phy_tune(struct imx8mq_usb_phy *imx_phy)
 
 	if (imx_phy->pcs_tx_swing_full != PHY_TUNE_DEFAULT) {
 		value = readl(imx_phy->base + PHY_CTRL5);
+		value &= ~PHY_CTRL5_PCS_TX_SWING_FULL_MASK;
 		value |= FIELD_PREP(PHY_CTRL5_PCS_TX_SWING_FULL_MASK,
 				   imx_phy->pcs_tx_swing_full);
 		writel(value, imx_phy->base + PHY_CTRL5);
-- 
2.51.0



