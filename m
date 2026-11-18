Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061266;
	b=0ZbvRAORELxP1L7nUKtJfUVwsWTbwUJDPI++TkZwpDJzAbRcwcCeG4wRQaMy4r5dql1R
	 E5ShAr5DuE0MLEOezEC+dv4vRvbKCH0wgdzxQrd5SBHv6kECuVCgGf/TodfXpAXRNCH7v
	 Q3hB+NyAJEO6mNpntwwYmcoGsoV1pfkUVMdQlRSjuSvWH7JdCcwDWxQ0uaQdcDpkF4PtK
	 KatdhwppR8SxD3vlP7Y9lCHQL8hizdjvJjNrnwdOUY5NhB/XjzCRyFFSvMVrCGzCuks7m
	 mVGwSCZkzW2C2tMzvNaYl1oSyWrBvQRgKAk+HF/FZ+d2WCiwbXp/Amn1vS3y6nnJMSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0BqgyPdVD1vWT3G5bGnF86VN+0KnOhp1CgIZOlihHXs=;
	b=eRH0VJfAb+oTzDR3GMi+lJwcg/7q/vGDYtv2PchWSmP7mq8QVl5TR6XJBs5XQZTKD+IC
	 nUQ9DYUwfj4MkWAKa4RKIe7Q/3tsUS/pazOUakQKr9WGxlMI2+LAl6Tr9AkmtkHUu0jB9
	 QsXhw2BVTXe3yc7/u6gfsyPBMnjYDu1ER/g587uSV5MnLSd+AYJYhmDop8BdcsgXl/mly
	 KMd0RMhBm7L32tfSfp5Hjb2Bujcq6SrjCN/KHsxGzFYiJS40A1ONm4rkuX+YUG7t9L75l
	 apiGhrpURkh9QcKU2Dqu9JBcicCHzNltsjCfR3YIG+a4qqf+17ql9idUvvoZxpk1Sdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S1j5H1qJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B44D6606A320;
	Thu, 19 Nov 2026 04:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S1j5H1qJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87431F000C4;
	Thu, 19 Nov 2026 04:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061266;
	bh=0BqgyPdVD1vWT3G5bGnF86VN+0KnOhp1CgIZOlihHXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1j5H1qJnim7+hpV1rNavVAd+IVY3fbPItbJUWGHzcN4KfCpLeRLHau4TSR/AbzEP
	 m1f4dhJmtj9k/tSLWc7MCnPSS2PUMcipOSjxJANr08xyVrbZORTtfhWgpMkf0bKnOw
	 aShS7WN3a0Ca5m/iBwICZKfZkyuh2sv4wKCJc1O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1464/1848] power: supply: ab8500_fg: Avoid reserved AB8505 CCConf bit
Date: Wed, 18 Nov 2026 15:58:22 +0100
Message-ID: <20261118150020.629417855@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 08114a6fc1b83..5a19cca8309cf 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -455,6 +455,16 @@ static void ab8500_fg_fill_cap_sample(struct ab8500_fg *di, int sample)
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
@@ -485,7 +495,7 @@ static int ab8500_fg_coulomb_counter(struct ab8500_fg *di, bool enable)
 		/* Start the CC */
 		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
 			AB8500_RTC_CC_CONF_REG,
-			(CC_DEEP_SLEEP_ENA | CC_PWR_UP_ENA));
+			ab8500_fg_cc_config(di));
 		if (ret)
 			goto cc_err;
 
@@ -559,7 +569,7 @@ int ab8500_fg_inst_curr_start(struct ab8500_fg *di)
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



