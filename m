Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B982D839C;
	Tue, 21 Jul 2026 16:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649666; cv=none; b=nTp/K2hxaBr/CCLm/RUKijoyJBNSz2C/4bPyyV8iJ5K7F+JT/FUdFJF3MOhwHSs6xMSEoy57XU/HZ1yiVLz5muzUZkympCzlDpvBBkTR9xU9IWGGKzxbailv6nc88/L22TO5KpXvveNAWNOhNEjCRhEHTaZ6iDFUX9SWtnxz6aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649666; c=relaxed/simple;
	bh=DqWbw08OYtrk6MuWA3EuCKHIrV2AZ+kddISA4XKJ4Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KVA6aySmBylniLGxugjau3HsF9NLzSVXPRs13Oag+1se9u8PeCFb3lie+51bGvGj5wWvIH/xJqbh2Lw1HGcEvDqbmoWvuy04/AfdI50XPdOtVspY8ldrL5RnlxN53AhkUlreZh3fJ8TMM/28JTZ3VoRCcwetuMq1Kvc6y8zEXT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aoi0KT+j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aoi0KT+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9BB1F000E9;
	Tue, 21 Jul 2026 16:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649665;
	bh=k974e2AehDaX+qgKNbiJP2L0FBx/yxZGuM0+mIaJvQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aoi0KT+jlXi8flsAyOhtTdd6GBPvtgjIpTB4FimzSPmp5Qyi9rYzRghVwxY+0iikD
	 oKf+gF65PxSodN8UuJm8yYY49Ck2oH+MQSgUJI+cLdUD130vYK3dlEZVmhw8ZilfkC
	 Twyw3KEgjPP8gozIgeqmMQpRUGUbJyRZuStpX7cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0663/2077] pinctrl: airoha: an7581: add missed gpio32 pin group
Date: Tue, 21 Jul 2026 17:05:36 +0200
Message-ID: <20260721152608.442474244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>

[ Upstream commit bdc95d7e8de3eefa9fc062302625259c0b79136d ]

gpio32 pin group is missed for an7581 SoC. This patch add it.

Fixes: 1c8ace2d0725 ("pinctrl: airoha: Add support for EN7581 SoC")
Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index 995ba6175c9504..80516622322875 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -539,6 +539,7 @@ static const int en7581_gpio28_pins[] = { 41 };
 static const int en7581_gpio29_pins[] = { 42 };
 static const int en7581_gpio30_pins[] = { 43 };
 static const int en7581_gpio31_pins[] = { 44 };
+static const int en7581_gpio32_pins[] = { 45 };
 static const int en7581_gpio33_pins[] = { 46 };
 static const int en7581_gpio34_pins[] = { 47 };
 static const int en7581_gpio35_pins[] = { 48 };
@@ -623,6 +624,7 @@ static const struct pingroup en7581_pinctrl_groups[] = {
 	PINCTRL_PIN_GROUP("gpio29", en7581_gpio29),
 	PINCTRL_PIN_GROUP("gpio30", en7581_gpio30),
 	PINCTRL_PIN_GROUP("gpio31", en7581_gpio31),
+	PINCTRL_PIN_GROUP("gpio32", en7581_gpio32),
 	PINCTRL_PIN_GROUP("gpio33", en7581_gpio33),
 	PINCTRL_PIN_GROUP("gpio34", en7581_gpio34),
 	PINCTRL_PIN_GROUP("gpio35", en7581_gpio35),
-- 
2.53.0



