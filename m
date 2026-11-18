Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040742;
	b=HEY5cYPU6ZzLW2dWwiLDf8zUFt3VDEYg/LOgE5hc40Z3gakuPszQeyWwjk5atwovll1t
	 QJAqUrWKUJGwyWw1B7kBtYumDjJ+/3FCYpS+QJmtU84qRBK0r7yvjJlKRSJkpWawnF5C5
	 eQskVdmsCGpx/ZyVNBs1p+IY43GMzB3XHjYM7+s3lwf+cfbde1ROZTz1sMfzjrMYPeMvz
	 hAPHxcAntpuMlwXT9sDeTYsOkKiatvo7K5ZOjRTjeikLwyA3O2sDRjkf/tpo2Yov5HG2w
	 +ydFp8G6TpZtOqf4Sd2dLXEMOz+pkDPL8Y52rPDGA8UL90xwt2TRFIjjlCUcgSdTZkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yo0/TBA8lO2awe62NAQky52/8XTSivbbTLOvXKWjPRA=;
	b=IvMG9UBGVhisVhAHZy7ADkoIZCoBAOckgY8olFDZxGd+wiqrHhMhTyeSHPcKRDI+bwo5
	 RBDrXIXLID2LDexCXsqXWgmyssPBjVGGBVftWV4vjdC0qnE6eyOreUMkHWamb0c/rpUXM
	 luJLW+0J8ryxY936RjCzEL1sk8LqhY2t06zREEqsyHC8tGXSA8BCUHjxPV5ORRbn/qEdX
	 7NIFswpwpJuG7b9H/pa90at0vcdqw7rSSV2wNgHI/TOjq/uwGkrE7tEY9wa6uKZXwoM2/
	 Ui4pCSbcDVXH0adA+LVkiq2zmf0InhjlIS8YCWboTYoIcaKDnDCfxNMVtkehgrc8aOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vPt0BST6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F07B606A320;
	Wed, 18 Nov 2026 22:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vPt0BST6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F981F000C4;
	Wed, 18 Nov 2026 22:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040741;
	bh=yo0/TBA8lO2awe62NAQky52/8XTSivbbTLOvXKWjPRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vPt0BST6FMi6qihr2nFBCcprqXYhDIwHCt9XCpyg8dTwywoXdTETYpDGS+ZbZSqf7
	 2owOI4rJIL9dKZsUeWe22sMo9bUGOqWnlRC6T/R0SNhWVDJ51Oo+6pOO81UHpTgEzx
	 8TbPlqAHbk4S6MlhpWstrtZGT+GDloPvKvP2Vges=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2565/3318] power: supply: ab8500_fg: Avoid reserved AB8505 CCConf bit
Date: Wed, 18 Nov 2026 15:53:07 +0100
Message-ID: <20261118150438.197776502@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit edafb2e4642b72b0f86ce5990d5c29c116bb642b ]

AB8500 defines CCConf bit 1 as CCDeepSleepEna, but AB8505 reserves
bits 7:1 and only defines bit 0, CCPwrUpEna. The fuel-gauge driver
currently writes both bits whenever it starts the coulomb counter.

The Samsung-GT-S7710-Skomer and related Samsung product trees use the
same unconditional value in their fuel-gauge drivers, so they provide
no AB8505 workaround to carry over. Select the value from the detected
PMIC variant instead, retaining the deep-sleep enable bit on all
existing non-AB8505 paths and avoiding the reserved bit on AB8505.

Fixes: a982362c1723 ("mfd: Support for the AB8500 AB8505 variant")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-15-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_fg.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index 0e9ab48aa339c..1f67f6d999fe7 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -456,6 +456,16 @@ static void ab8500_fg_fill_cap_sample(struct ab8500_fg *di, int sample)
 	avg->avg = sample;
 }
 
+static u8 ab8500_fg_cc_config(struct ab8500_fg *di)
+{
+	u8 config = CC_PWR_UP_ENA;
+
+	if (!is_ab8505(di->parent))
+		config |= CC_DEEP_SLEEP_ENA;
+
+	return config;
+}
+
 /**
  * ab8500_fg_coulomb_counter() - enable coulomb counter
  * @di:		pointer to the ab8500_fg structure
@@ -486,7 +496,7 @@ static int ab8500_fg_coulomb_counter(struct ab8500_fg *di, bool enable)
 		/* Start the CC */
 		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
 			AB8500_RTC_CC_CONF_REG,
-			(CC_DEEP_SLEEP_ENA | CC_PWR_UP_ENA));
+			ab8500_fg_cc_config(di));
 		if (ret)
 			goto cc_err;
 
@@ -560,7 +570,7 @@ int ab8500_fg_inst_curr_start(struct ab8500_fg *di)
 		/* Start the CC */
 		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
 			AB8500_RTC_CC_CONF_REG,
-			(CC_DEEP_SLEEP_ENA | CC_PWR_UP_ENA));
+			ab8500_fg_cc_config(di));
 		if (ret)
 			goto fail;
 	} else {
-- 
2.53.0



