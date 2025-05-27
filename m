Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC04C1A3159;
	Tue, 27 May 2025 17:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367492; cv=none; b=p6AW2vpRxPwTOI9zrfUj8O4YKi7XcJnF38MkKZrKeOFGPjpW+oPlRG6upiBaYX0YxSVnK6b4uvaYwMP2H7/ZDE02SiUEJXRxGbU1rOzdUolxsWnMfqQeUkPTLiOTB+pEcF0DB8BTqHdD+NoD4bf4SKFyKiu0Ypk6jC4jZR/WRv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367492; c=relaxed/simple;
	bh=vh7qRaisPJCxH8uWVgomZICfURzXqGewgPn8X2CssQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXPVZsM/6i9csuw+q/zGMAm0rGwv2tIL+SGOTPU1pZWzS0tYVX6Vkomeim+1LXPUsyY0kFvTtUatCrmCD93diBXjba0g57oH2duNe8nFCSduXvEKulAtjbW1YTvihiIn2IgrRIO4WPUbVSJzmUfYjqiIwGqZrSEzTmWDFmDuQ2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCGK5hA1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCGK5hA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD3EC4CEE9;
	Tue, 27 May 2025 17:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367492;
	bh=vh7qRaisPJCxH8uWVgomZICfURzXqGewgPn8X2CssQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCGK5hA1H/LWBH20YzIK8cU8WPitt1zKDyO34Q9/uvEEFiMQWnt6qsASzOX8PSlc9
	 yELTa9W6He7T0aLBRl8Dir4IDtE7lft38hQYRXe24DUFl+lmOonGSC+PFdccpJiLVM
	 dKtgBSUh+KwD+O/3jdyksvTkLaiCNfORfgXQzBs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 405/783] mfd: axp20x: AXP717: Add AXP717_TS_PIN_CFG to writeable regs
Date: Tue, 27 May 2025 18:23:22 +0200
Message-ID: <20250527162529.597225649@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Morgan <macromorgan@hotmail.com>

[ Upstream commit bfad07fe298bfba0c7ddab87c5b5325970203a1e ]

Add AXP717_TS_PIN_CFG (register 0x50) to the table of writeable
registers so that the temperature sensor can be configured by the
battery driver.

Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Link: https://lore.kernel.org/r/20250204155835.161973-3-macroalpha82@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/axp20x.c       | 1 +
 include/linux/mfd/axp20x.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
index cff56deba24f0..e9914e8a29a33 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -224,6 +224,7 @@ static const struct regmap_range axp717_writeable_ranges[] = {
 	regmap_reg_range(AXP717_VSYS_V_POWEROFF, AXP717_VSYS_V_POWEROFF),
 	regmap_reg_range(AXP717_IRQ0_EN, AXP717_IRQ4_EN),
 	regmap_reg_range(AXP717_IRQ0_STATE, AXP717_IRQ4_STATE),
+	regmap_reg_range(AXP717_TS_PIN_CFG, AXP717_TS_PIN_CFG),
 	regmap_reg_range(AXP717_ICC_CHG_SET, AXP717_CV_CHG_SET),
 	regmap_reg_range(AXP717_DCDC_OUTPUT_CONTROL, AXP717_CPUSLDO_CONTROL),
 	regmap_reg_range(AXP717_ADC_CH_EN_CONTROL, AXP717_ADC_CH_EN_CONTROL),
diff --git a/include/linux/mfd/axp20x.h b/include/linux/mfd/axp20x.h
index c3df0e615fbf4..3c5aecf1d4b5b 100644
--- a/include/linux/mfd/axp20x.h
+++ b/include/linux/mfd/axp20x.h
@@ -137,6 +137,7 @@ enum axp20x_variants {
 #define AXP717_IRQ2_STATE		0x4a
 #define AXP717_IRQ3_STATE		0x4b
 #define AXP717_IRQ4_STATE		0x4c
+#define AXP717_TS_PIN_CFG		0x50
 #define AXP717_ICC_CHG_SET		0x62
 #define AXP717_ITERM_CHG_SET		0x63
 #define AXP717_CV_CHG_SET		0x64
-- 
2.39.5



