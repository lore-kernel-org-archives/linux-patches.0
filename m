Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025410;
	b=l4BHXOc/kfHy5SD5rSvDJS8gteAgA2+drjEfLEYEh8g2yixU/Js+NPK3WWUVZkx5PmZa
	 wAzYIHOCsayD5RUe8PAm+RcHPIhrzrhSDwtNS6nA8Bj4Ym+w7lGL3xlXv9mW92b12RHpL
	 nDb/sxMviv7lb4KnCe1pTJdmB8qpeiCXuUyQeyAxRLsIzVPATv+3YzK7uVgaysI7dguMt
	 gKPgnYV52D4/Lh/QaJZ8O62hVlmE4NOUusRD3E0k3OTd3e3RzVjJBXXyQT6Pvui9TrdCS
	 LLW6ByxmpiQvtyUEeVuSB9rAF9mls2Qy8hgYQRtMiksxe0XWOCsyKd68ckJFaJ4N5dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025410;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MUMUteqVDoRkSYW87NgAUGh+uywSMUBAphUJaZU6zWA=;
	b=OwRGcemlw4D8sSNp9QgzT64UakbM+z674S2hUwobfbf0cXJ307SbhSP2G8Bw+MMUTvdb
	 7/k4yrlxVhYm95pGOYPotrTYF9YNfy0mBOrHFMJICurat0ogKX7FK5rPUdFGCGImevuZg
	 X90XceWmhqgF0DbZsPdh0Wqz0lU2CjYRtVTsbo7yb6x6izLHC2jNXHFlQ2qLU6j3TgIbw
	 +K0hswDf8pDZ5+1hiuLsX5omRz5nrnIwGfh0MDkHBxsGKrAmJNl1aA7OhkWF1rm1WiuuE
	 1xgvlbtrW1QjTFn9ZjCpN8SX7iCpl84DCEVHEPIHjsA9LTaxFAP3MOIGFoaOEUOFYng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O7PQUFUN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B852606A31C;
	Wed, 18 Nov 2026 18:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O7PQUFUN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE371F000C4;
	Wed, 18 Nov 2026 18:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025409;
	bh=MUMUteqVDoRkSYW87NgAUGh+uywSMUBAphUJaZU6zWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O7PQUFUNaz8pwwgWcnZpAWZj8PNIVOYpTyz0gVUTibKHZ+O0Dhr8ksKkj24rD8YLU
	 FNa0ZthCBP0ofEn5ywM9w+q1KxUkgWUWSVHSJMBrd8pNME/6/MAJ5mrDVH6bc0g2Ps
	 vLrHiRTB+pPt4mMLb6/07tSKWoyiwuWMZ7iLmBNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1062/2151] power: supply: ab8500_fg: Avoid reserved AB8505 CCConf bit
Date: Wed, 18 Nov 2026 15:46:37 +0100
Message-ID: <20261118150200.982287636@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 04c12ebdfebfa..8d90b078a9e90 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -451,6 +451,16 @@ static void ab8500_fg_fill_cap_sample(struct ab8500_fg *di, int sample)
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
@@ -481,7 +491,7 @@ static int ab8500_fg_coulomb_counter(struct ab8500_fg *di, bool enable)
 		/* Start the CC */
 		ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
 			AB8500_RTC_CC_CONF_REG,
-			(CC_DEEP_SLEEP_ENA | CC_PWR_UP_ENA));
+			ab8500_fg_cc_config(di));
 		if (ret)
 			goto cc_err;
 
@@ -555,7 +565,7 @@ int ab8500_fg_inst_curr_start(struct ab8500_fg *di)
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



