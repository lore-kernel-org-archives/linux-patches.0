Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB73E78F32;
	Tue, 27 May 2025 17:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365292; cv=none; b=CLIRfoRNe/icjM1hCBQYeOIqdQXwWbt7zRIoXfUA9+icCRU5PQMFF078pReCfnyjtgusKMYhnOE0WyXN3WTBvfThtGHOt03Su5dQiRaygeThpReMip4L0JH8Hglpknuiu2sz6+1JYBP8s8z3+A5+Lfc7dB8CtIh0ZXmj/9/l0QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365292; c=relaxed/simple;
	bh=exul0WEZ8TuM+ZhByA0oIABpCoLQQRn7YwYrEx6FslE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VoZ4LKliZzplwQBwKB+Qq0ajfPSG8Q0S0rVPAVYzuNQXV+Efhzc0cswZuTN1nfJoXeukoq8o6JLG+rOruQUwwQRmFZkv/GvUd0aYxRHTj9e/hoLOrn4A/AVPc+Q2x8f15/9taiucPInKlyidJuYkZH9m1flM4W8TRyeFpgpgqQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JoDbnlQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JoDbnlQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A6E8C4CEE9;
	Tue, 27 May 2025 17:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365291;
	bh=exul0WEZ8TuM+ZhByA0oIABpCoLQQRn7YwYrEx6FslE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JoDbnlQ+mWbG1w3fu+1f+S4AtW2Eu17gqxorQkh3hpA7xqku+lP/cpyZX1AmEgYd9
	 7QGu2LenRf76h3zbgz2QAB3A6DJlO0OTP0sUIrazwFGROTXNfK6elBrM2/ardj3hId
	 RBCN0kWQfI17pv4bnqcFJ9+/5SQHckM5duj4jDio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 329/626] mfd: axp20x: AXP717: Add AXP717_TS_PIN_CFG to writeable regs
Date: Tue, 27 May 2025 18:23:42 +0200
Message-ID: <20250527162458.397944195@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4051551757f2d..3780929039710 100644
--- a/drivers/mfd/axp20x.c
+++ b/drivers/mfd/axp20x.c
@@ -214,6 +214,7 @@ static const struct regmap_range axp717_writeable_ranges[] = {
 	regmap_reg_range(AXP717_VSYS_V_POWEROFF, AXP717_VSYS_V_POWEROFF),
 	regmap_reg_range(AXP717_IRQ0_EN, AXP717_IRQ4_EN),
 	regmap_reg_range(AXP717_IRQ0_STATE, AXP717_IRQ4_STATE),
+	regmap_reg_range(AXP717_TS_PIN_CFG, AXP717_TS_PIN_CFG),
 	regmap_reg_range(AXP717_ICC_CHG_SET, AXP717_CV_CHG_SET),
 	regmap_reg_range(AXP717_DCDC_OUTPUT_CONTROL, AXP717_CPUSLDO_CONTROL),
 	regmap_reg_range(AXP717_ADC_CH_EN_CONTROL, AXP717_ADC_CH_EN_CONTROL),
diff --git a/include/linux/mfd/axp20x.h b/include/linux/mfd/axp20x.h
index f4dfc1871a95b..d1c21ad6440d1 100644
--- a/include/linux/mfd/axp20x.h
+++ b/include/linux/mfd/axp20x.h
@@ -135,6 +135,7 @@ enum axp20x_variants {
 #define AXP717_IRQ2_STATE		0x4a
 #define AXP717_IRQ3_STATE		0x4b
 #define AXP717_IRQ4_STATE		0x4c
+#define AXP717_TS_PIN_CFG		0x50
 #define AXP717_ICC_CHG_SET		0x62
 #define AXP717_ITERM_CHG_SET		0x63
 #define AXP717_CV_CHG_SET		0x64
-- 
2.39.5



