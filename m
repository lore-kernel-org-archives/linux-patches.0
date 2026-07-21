Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8C02E1F06;
	Tue, 21 Jul 2026 16:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649690; cv=none; b=Gy5BE4FtbFTXSMiykYKujqi1+KSLzWjarlPSWXguK5eX5qDBSLmYWvGZfqJawvL765914v9Bc4jCOu3GI4yPgc7Jss7WTW4GBUO53Q8YG/ytrdLjtSryoYFVyg6Y6pNg27SqKrdo4UeUkTLKOUC4DdZSWVKcdCs6QTPmQxcRJvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649690; c=relaxed/simple;
	bh=5R/pkaNW0OCl1QwTau99Fcaa+ctJopWNEFw33C9oDCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HD1bzPLGGDlx8cZLAm0VFgztwWZTxN9Ah0vYDRIkyG2eqg/PX+ZRGhrgt392WNpQ7Z+BgD4RgROo+ackDo6IqtEzSYD9z46uYuWNLphugIyxP0+QIWcQxIRQxhd+/N70lAh264p7xVFCxH1srrYpq9IQGY2tduFARb/5OJ8azNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sp0sou+c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sp0sou+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81ECD1F00A3A;
	Tue, 21 Jul 2026 16:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649689;
	bh=Wn4/0G8PE0yn8OKyWx3mASSX8o3l5W9ktlHwVCr1iik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sp0sou+cu4NVb8gk1lKYpUXuXYQ0urynjm9I5t84TUOs5gFfpjX/N+e3UEH2gVTfd
	 pfKJycf//yYx0ESEpAFSeVuXJ6dK8kDvJ1c5u0vShrkHxJmdxUfxjSxYCduvf6mMqq
	 q9zKHK+5FFT4spvjd10UEcvOfFPq/LJw8oFsYj5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0671/2077] pinctrl: airoha: an7583: add missed gpio22 pin group
Date: Tue, 21 Jul 2026 17:05:44 +0200
Message-ID: <20260721152608.627211005@linuxfoundation.org>
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
index 9dce3ed6de174e..e66b608c4803ae 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -749,6 +749,7 @@ static const int an7583_gpio18_pins[] = { 20 };
 static const int an7583_gpio19_pins[] = { 21 };
 static const int an7583_gpio20_pins[] = { 22 };
 static const int an7583_gpio21_pins[] = { 23 };
+static const int an7583_gpio22_pins[] = { 24 };
 static const int an7583_gpio23_pins[] = { 25 };
 static const int an7583_gpio24_pins[] = { 26 };
 static const int an7583_gpio25_pins[] = { 27 };
@@ -828,6 +829,7 @@ static const struct pingroup an7583_pinctrl_groups[] = {
 	PINCTRL_PIN_GROUP("gpio19", an7583_gpio19),
 	PINCTRL_PIN_GROUP("gpio20", an7583_gpio20),
 	PINCTRL_PIN_GROUP("gpio21", an7583_gpio21),
+	PINCTRL_PIN_GROUP("gpio22", an7583_gpio22),
 	PINCTRL_PIN_GROUP("gpio23", an7583_gpio23),
 	PINCTRL_PIN_GROUP("gpio24", an7583_gpio24),
 	PINCTRL_PIN_GROUP("gpio25", an7583_gpio25),
-- 
2.53.0



