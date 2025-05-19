Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A050C234964;
	Mon, 19 May 2025 21:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689769; cv=none; b=KFfPc5QfQK4Jy43C6p1j4jYcVL1zp3gP1iVsEQxjXWWAJhPzkNu0oXv3aRdpCkIE9+h/5XjzOksFfxCk09aObiyBi1BDlzI7Yhld2fjvJx0POnbKzvq8u7S9kmshYql+jENbK1Fqi1ueyQH+T4MKeW9To3/cGCT6DaCsBOap9b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689769; c=relaxed/simple;
	bh=8F/TlMcvRuQY/wh7dOu/sb0z5hIuO3UPBT+My1/PgDI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ru5pskqOz3uGfxrdG5n5vAHOTYbvYvBH1yNEnplA0fhCoeh8wD8sAfklde5L8933xsabiAqyzSEaAr0qeXc6F4WrKEbE/l8S+cbCjsAjSRIUkqWp8sunCVE8J8Qk0g5gVmybphLn3d+fXZywJBHPsjJWgAGY2uQhiJ/niRzxDTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DX2yjhe+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DX2yjhe+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA118C4CEE9;
	Mon, 19 May 2025 21:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689769;
	bh=8F/TlMcvRuQY/wh7dOu/sb0z5hIuO3UPBT+My1/PgDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DX2yjhe+mgALbtTAhwRk5WJkufBkftdtfiqthz4kFtRcjypeGcuSaAuyCMGkpS1cU
	 hqKTpAoHRYV9ZrxqoL98LSpoClDjMfS2N5ucaILTH7pBvaIrngKJqmO0S/8i57jIzY
	 7i00PxeWqRELFElWobG/QjzlPHSAp/ueX1A0toa/UYklpAnVyGFsFLdVPqgGmlj6bB
	 X7EMz8ChfheB3q4maVGGy91IjFcHhQdr+vPXxM117oUnTDQHeNeGu1Ex69/plRYNwq
	 8FtuQVN+GMX7ScMxRyQe4MqyZfjzaHv4Hv6+xA9xmYO/8VYEMFqlyB7nlTwFGsw+Gj
	 46gKjAZn/4k/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hal Feng <hal.feng@starfivetech.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	kishon@ti.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 07/11] phy: starfive: jh7110-usb: Fix USB 2.0 host occasional detection failure
Date: Mon, 19 May 2025 17:22:33 -0400
Message-Id: <20250519212237.1986368-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212237.1986368-1-sashal@kernel.org>
References: <20250519212237.1986368-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.91
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
index 633912f8a05d0..bf52b41110db8 100644
--- a/drivers/phy/starfive/phy-jh7110-usb.c
+++ b/drivers/phy/starfive/phy-jh7110-usb.c
@@ -16,6 +16,8 @@
 #include <linux/usb/of.h>
 
 #define USB_125M_CLK_RATE		125000000
+#define USB_CLK_MODE_OFF		0x0
+#define USB_CLK_MODE_RX_NORMAL_PWR	BIT(1)
 #define USB_LS_KEEPALIVE_OFF		0x4
 #define USB_LS_KEEPALIVE_ENABLE		BIT(4)
 
@@ -68,6 +70,7 @@ static int jh7110_usb2_phy_init(struct phy *_phy)
 {
 	struct jh7110_usb2_phy *phy = phy_get_drvdata(_phy);
 	int ret;
+	unsigned int val;
 
 	ret = clk_set_rate(phy->usb_125m_clk, USB_125M_CLK_RATE);
 	if (ret)
@@ -77,6 +80,10 @@ static int jh7110_usb2_phy_init(struct phy *_phy)
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

