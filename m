Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B8222171C;
	Mon, 19 May 2025 21:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689712; cv=none; b=X4Evs/T4dwwS5IBlPQW6VyIWoaYBvSVCJ5qY0Ggnc23p3zY0WXPY2veyqIY6ylKVL1jECYCLbfXkfmUNyEoi5K5N2JecUzmeoKaluBBr8b8sCBUi4Kq1rQ7Nh7yY2nm1NxsECW2KU8t2ByvjpIn6NhB8WPLmd0l7kFUZB3Wvsa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689712; c=relaxed/simple;
	bh=NRQTrFJKsX97jTiZqIvoELGtndJGz3IEGk7s35ac0lQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=silgmhpuqtgP1OyruR0nMONmloFUl91kAE6p9NZfvH+DZujudZDhtEvjGgVL0zd0uzquryNUHRpjc79EtK8Ov+oXSkMYzH9cQ1TPOvuoG4kHAx14e0/VpAt1Fuipt8MQNN/dF7oTVmR+WhvjswcaXpElnvawjQYYWVzVt6JoM7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KaPwPZSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KaPwPZSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA7FC4CEE4;
	Mon, 19 May 2025 21:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689712;
	bh=NRQTrFJKsX97jTiZqIvoELGtndJGz3IEGk7s35ac0lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KaPwPZSVN+iG3AaAbX7PdP+ZqfBW52uyq3kQmf4ryTz7NHCx1zJrbU+DHwIpTs7fr
	 3MDunlbbzPSm+0HN8svLoWncmI/pBnh81aNQMMV/5qhHsN/6przSrPv89Cb3BZjELI
	 vGWBbf44DSyFWCo9VP5gk+QF7LsO8g9uSGTFaRGJ7zgOBHyeqriZsgUW5TFbKtBw0L
	 EEFPWyt5Ydty9Z0h49nQxrxE92OScBdK+trzA3SxeMbe9UpLiCxNzVcaZTCJ/yf0yo
	 MDfFFamtgkrzcRlsf0flrGAwKI/kKL2kJcQaNNOMtg2Qm3lOkIVuvNCpCzHlnANXuo
	 CxewnQqD9y6kg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hal Feng <hal.feng@starfivetech.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	kishon@ti.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 13/23] phy: starfive: jh7110-usb: Fix USB 2.0 host occasional detection failure
Date: Mon, 19 May 2025 17:21:20 -0400
Message-Id: <20250519212131.1985647-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212131.1985647-1-sashal@kernel.org>
References: <20250519212131.1985647-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.7
Content-Transfer-Encoding: 8bit

From: Hal Feng <hal.feng@starfivetech.com>

[ Upstream commit 3f097adb9b6c804636bcf8d01e0e7bc037bee0d3 ]

JH7110 USB 2.0 host fails to detect USB 2.0 devices occasionally. With a
long time of debugging and testing, we found that setting Rx clock gating
control signal to normal power consumption mode can solve this problem.

Signed-off-by: Hal Feng <hal.feng@starfivetech.com>
Link: https://lore.kernel.org/r/20250422101244.51686-1-hal.feng@starfivetech.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/starfive/phy-jh7110-usb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/phy/starfive/phy-jh7110-usb.c b/drivers/phy/starfive/phy-jh7110-usb.c
index cb5454fbe2c8f..b505d89860b43 100644
--- a/drivers/phy/starfive/phy-jh7110-usb.c
+++ b/drivers/phy/starfive/phy-jh7110-usb.c
@@ -18,6 +18,8 @@
 #include <linux/usb/of.h>
 
 #define USB_125M_CLK_RATE		125000000
+#define USB_CLK_MODE_OFF		0x0
+#define USB_CLK_MODE_RX_NORMAL_PWR	BIT(1)
 #define USB_LS_KEEPALIVE_OFF		0x4
 #define USB_LS_KEEPALIVE_ENABLE		BIT(4)
 
@@ -78,6 +80,7 @@ static int jh7110_usb2_phy_init(struct phy *_phy)
 {
 	struct jh7110_usb2_phy *phy = phy_get_drvdata(_phy);
 	int ret;
+	unsigned int val;
 
 	ret = clk_set_rate(phy->usb_125m_clk, USB_125M_CLK_RATE);
 	if (ret)
@@ -87,6 +90,10 @@ static int jh7110_usb2_phy_init(struct phy *_phy)
 	if (ret)
 		return ret;
 
+	val = readl(phy->regs + USB_CLK_MODE_OFF);
+	val |= USB_CLK_MODE_RX_NORMAL_PWR;
+	writel(val, phy->regs + USB_CLK_MODE_OFF);
+
 	return 0;
 }
 
-- 
2.39.5

