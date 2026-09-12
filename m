Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271B035201F;
	Sat, 12 Sep 2026 11:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212858; cv=none; b=eAtoPgXhVUtBzvAoz+3XkttQjdRaibMQTrPV8C8+nhPCCkJ81P14068FpBxTNOGz3bg7+7FLU+5C0Big7w6FSP4V4bbMi8sxssszHFOd88HfThMYCTyellcInw6zIARO5mtsHOeq1Qb6SKumKoZ9kU4CI22I1KwE4iQv+38rvk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212858; c=relaxed/simple;
	bh=cbng9b8fQ7PAWG40+FQfhQq7Gu6vIBDMqAvicO7UtCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UeHS4lMyZENh1vEYuZVgHc5OfMMquNVw7/GVrpPWfC6bS8aTo21rDziMKgmK/1TGiCpHDz0uyCrsDVt60l5QqqnHcSwQJnXM3oBKZbemx8Zlz+XQwBDKhfgKxOJddvHVt6PoYu37QMdpuUhTg/JBQHXQEMggfOreRf2+eSQN5pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTujWvFI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTujWvFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3321F000FF;
	Sat, 12 Sep 2026 11:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212857;
	bh=F76DjSgNNmFIeoHpCAtj/8lRfPkNJ4RTsqk5+ZUuBfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eTujWvFIn2VcYztPej41Ii6SodRE2mUCCzb4l9glwd+fwsSbXH5tTM5RFiDPeZyIq
	 XfDlw1y3vg7XAUdNZZr+dpXEcGqfHtn18E1nqo09k9pLzuGvC/WOAB6TVZyF7pwrOo
	 L2G0tOBD5Q5RnPuT6cFfqZVjIFgb1vZLoYNeGF8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1515/1518] pinctrl: airoha: an7583: add missed gpio22 pin group
Date: Sat, 12 Sep 2026 09:01:24 +0200
Message-ID: <20260912065657.837840588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>

[ Upstream commit 9ef86358855d5fd89db019ace33c097d2d752b9d ]

gpio22 pin group is missed, fix it.

Fixes: 3ffeb17a9a27 ("pinctrl: airoha: add support for Airoha AN7583 PINs")
Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index 9821e2f6f27dd..bdb5e7012d46b 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -768,6 +768,7 @@ static const int an7583_gpio18_pins[] = { 20 };
 static const int an7583_gpio19_pins[] = { 21 };
 static const int an7583_gpio20_pins[] = { 22 };
 static const int an7583_gpio21_pins[] = { 23 };
+static const int an7583_gpio22_pins[] = { 24 };
 static const int an7583_gpio23_pins[] = { 25 };
 static const int an7583_gpio24_pins[] = { 26 };
 static const int an7583_gpio25_pins[] = { 27 };
@@ -851,6 +852,7 @@ static const struct pingroup an7583_pinctrl_groups[] = {
 	PINCTRL_PIN_GROUP("gpio19", an7583_gpio19),
 	PINCTRL_PIN_GROUP("gpio20", an7583_gpio20),
 	PINCTRL_PIN_GROUP("gpio21", an7583_gpio21),
+	PINCTRL_PIN_GROUP("gpio22", an7583_gpio22),
 	PINCTRL_PIN_GROUP("gpio23", an7583_gpio23),
 	PINCTRL_PIN_GROUP("gpio24", an7583_gpio24),
 	PINCTRL_PIN_GROUP("gpio25", an7583_gpio25),
-- 
2.53.0



