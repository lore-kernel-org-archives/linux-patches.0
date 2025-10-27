Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAB02D8384;
	Mon, 27 Oct 2025 19:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592510; cv=none; b=hUdBmOg6Zu3OzZSo8hjrec6zgOiUFKgKCCKqk34lQAVNMKlwNQ4FE+7CeBnuUnYZhgtGmseX1OqsDeKTH3q42Ykcrs58qENrrcy4esSIgCUESWZ/6s2vglNcPWLUontzn9AdBTFt7RizwLEpMqDuEF3PCLnY5jsYuSQwFG2eHJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592510; c=relaxed/simple;
	bh=ALyAamCzpMNWs99TU8Pdn3/+y5yJPgn3qAaSOs131n0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnBWiXVccBdnfrC2wtNH+Pl9dIMQ55IhsQDEIzlwN7ove6V1u+4zE6yBNA/XYQS2FzEQ1a9QPtw4/wa0MaBMuRC1mONE0VXe1jtzs13xbXs47UHOSMEnOi91IZ+6nj1WsM+1i0/v3L1pGIFnfmKubGFfm9XFLE714z73TwpL0bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6Mjpjd+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6Mjpjd+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3168C4CEF1;
	Mon, 27 Oct 2025 19:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592510;
	bh=ALyAamCzpMNWs99TU8Pdn3/+y5yJPgn3qAaSOs131n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6Mjpjd++ju550J0IRLET8uUkETU1OB4v2QifQdSNFUVnrw8ijho6f/07O5fSfy6d
	 QPqoa4mVZ9LgKoh/hmgnJoa7aY1B0kEDo80mcUWLGQxaMHX4mgqXNfoUALv19KYBbv
	 0+DzXs7EdsYr+PghMSTK4Xzb5+0MHEbtegZ4K9Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devarsh Thakkar <devarsht@ti.com>,
	Harikrishna Shenoy <h-shenoy@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 147/157] phy: cadence: cdns-dphy: Update calibration wait time for startup state machine
Date: Mon, 27 Oct 2025 19:36:48 +0100
Message-ID: <20251027183505.232614835@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devarsh Thakkar <devarsht@ti.com>

[ Upstream commit 2c27aaee934a1b5229152fe33a14f1fdf50da143 ]

Do read-modify-write so that we re-use the characterized reset value as
specified in TRM [1] to program calibration wait time which defines number
of cycles to wait for after startup state machine is in bandgap enable
state.

This fixes PLL lock timeout error faced while using RPi DSI Panel on TI's
AM62L and J721E SoC since earlier calibration wait time was getting
overwritten to zero value thus failing the PLL to lockup and causing
timeout.

[1] AM62P TRM (Section 14.8.6.3.2.1.1 DPHY_TX_DPHYTX_CMN0_CMN_DIG_TBIT2):
Link: https://www.ti.com/lit/pdf/spruj83

Cc: stable@vger.kernel.org
Fixes: 7a343c8bf4b5 ("phy: Add Cadence D-PHY support")
Signed-off-by: Devarsh Thakkar <devarsht@ti.com>
Tested-by: Harikrishna Shenoy <h-shenoy@ti.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://lore.kernel.org/r/20250704125915.1224738-3-devarsht@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/cadence/cdns-dphy.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/phy/cadence/cdns-dphy.c
+++ b/drivers/phy/cadence/cdns-dphy.c
@@ -31,6 +31,7 @@
 
 #define DPHY_CMN_SSM			DPHY_PMA_CMN(0x20)
 #define DPHY_CMN_SSM_EN			BIT(0)
+#define DPHY_CMN_SSM_CAL_WAIT_TIME	GENMASK(8, 1)
 #define DPHY_CMN_TX_MODE_EN		BIT(9)
 
 #define DPHY_CMN_PWM			DPHY_PMA_CMN(0x40)
@@ -422,7 +423,8 @@ static int cdns_dphy_power_on(struct phy
 	writel(reg, dphy->regs + DPHY_BAND_CFG);
 
 	/* Start TX state machine. */
-	writel(DPHY_CMN_SSM_EN | DPHY_CMN_TX_MODE_EN,
+	reg = readl(dphy->regs + DPHY_CMN_SSM);
+	writel((reg & DPHY_CMN_SSM_CAL_WAIT_TIME) | DPHY_CMN_SSM_EN | DPHY_CMN_TX_MODE_EN,
 	       dphy->regs + DPHY_CMN_SSM);
 
 	ret = cdns_dphy_wait_for_pll_lock(dphy);


