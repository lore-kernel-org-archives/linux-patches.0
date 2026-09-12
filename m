Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461691A9F83;
	Sat, 12 Sep 2026 11:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212697; cv=none; b=PUy4gFOjlo7tNp60+A4+pGL4ZgnNGHrIdDF/rhtjccQ1uxpqgQzcG/CXOZltP6AQuTHB2XZOdf8/3AtGst9gMkOtH7YNmQ5AG67VWTJ/+FiVFj6j75M647qv/mLHY/q4uSZ02y8VcyK+Siw2YzTi/XvPjBJc7mEwTfDqlk8uZn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212697; c=relaxed/simple;
	bh=YqNbC/pPclQN4GC387E1iqm0AcL0cvDIymIBkXOTpkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKMrXOkhFUDJrpELtBfQH6/8c2qXAOTeUVSkVs4v500+Q31Uit0iJS3UT/OeitBbkPMi1y7rj2SNjGaIko6LPY2r3u7k1+Voyn2tD+pmiXd7dTTXvwpo+T3ZxDvv9r2efV2xCa7te8RI56oF/aorgVYtRgYctc6svPyef2qj2mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fc24Q9MU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fc24Q9MU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620DC1F000FF;
	Sat, 12 Sep 2026 11:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212696;
	bh=Ct1XP7fM28ZHZldLsRM9xOSjssWeo8cHliSVem/coCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fc24Q9MUReMweBZWTX1jS37NN1emBCJQoUvI0ye6ujCXKUzngNHZ2LWFZK+ldd48H
	 zCvI1QFOWbkv5noeD/Vu94z3aJkQuWZ11y7tshfDR5msWPo5UW0pXl2/LEfp08n/pw
	 Hv6liuprCs+yho/Iu3QvhhWXbt0tm83p18gQVNCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1489/1518] pinctrl: airoha: an7583: add missed gpio32 pin group
Date: Sat, 12 Sep 2026 09:00:58 +0200
Message-ID: <20260912065657.246695048@linuxfoundation.org>
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

[ Upstream commit 81cc2285cea84e3ed8688d353e1250cf8899c80a ]

gpio32 pin group is missed for an7583 SoC. This patch add it.

Fixes: 3ffeb17a9a27 ("pinctrl: airoha: add support for Airoha AN7583 PINs")
Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index 99fee1b490d86..5d8b6e828673b 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -777,6 +777,7 @@ static const int an7583_gpio28_pins[] = { 30 };
 static const int an7583_gpio29_pins[] = { 31 };
 static const int an7583_gpio30_pins[] = { 32 };
 static const int an7583_gpio31_pins[] = { 33 };
+static const int an7583_gpio32_pins[] = { 34 };
 static const int an7583_gpio33_pins[] = { 35 };
 static const int an7583_gpio34_pins[] = { 36 };
 static const int an7583_gpio35_pins[] = { 37 };
@@ -859,6 +860,7 @@ static const struct pingroup an7583_pinctrl_groups[] = {
 	PINCTRL_PIN_GROUP("gpio29", an7583_gpio29),
 	PINCTRL_PIN_GROUP("gpio30", an7583_gpio30),
 	PINCTRL_PIN_GROUP("gpio31", an7583_gpio31),
+	PINCTRL_PIN_GROUP("gpio32", an7583_gpio32),
 	PINCTRL_PIN_GROUP("gpio33", an7583_gpio33),
 	PINCTRL_PIN_GROUP("gpio34", an7583_gpio34),
 	PINCTRL_PIN_GROUP("gpio35", an7583_gpio35),
-- 
2.53.0



