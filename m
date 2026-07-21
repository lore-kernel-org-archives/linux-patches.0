Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E652246A603;
	Tue, 21 Jul 2026 16:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649670; cv=none; b=PM0uhxmsVDnFNZArYZ4pDq3n5cdj8RHHEhn3hXjpq4WVD/6I4u+YRKnk/e3pGJ4S+S6IFDS2qq9jvCasYQsEYzkrzo7NTeU29yfdQriZsaNSwTvbbxBAUpi5/maajOsFZopNaJVfaenyDcT4jprhnfYZ5J5uHNV6j9b4kCP72Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649670; c=relaxed/simple;
	bh=OtmsrZxnrNvgxtTENegFY/BLUypglMdWfWUlM0ySBps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlWJN873ColWwPokCFZbnqSN3xtHJYLQKVDsEEwbmibFjrB8t+KwhVesKrDLuqeCr3KG/JIUJHZtLRbXEeV5rA35eiAxiaRBP+mJobQNR0BIrhDCUVYFheIPG8aOc/kKUyH6a9bD11UWo8CJo5CgaYMAl0Jfdjl9F1TFGJIXZw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1go7cjR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1go7cjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572991F000E9;
	Tue, 21 Jul 2026 16:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649667;
	bh=oPlEt6hEss0rC8o02iZiDIPhaOJKeTDu0BZBxV3wIdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V1go7cjRRHn0naj1tikrFMcdmc0dp9b6jqbDHAoLR2/5ttuCvgRVQeKJ93QeT5d4+
	 LgtOkWd5WMPxY4MN8rtkVW6BkGd2ADb38b6KP0ZJgtFfbBZa2aJ4UYLu8/9FPriIqF
	 7YCDfw6+uVE867mmkg6eTefC92K/acJIxH6ldzeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0664/2077] pinctrl: airoha: an7583: add missed gpio32 pin group
Date: Tue, 21 Jul 2026 17:05:37 +0200
Message-ID: <20260721152608.465631399@linuxfoundation.org>
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
index 80516622322875..c0aed1b6079208 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -758,6 +758,7 @@ static const int an7583_gpio28_pins[] = { 30 };
 static const int an7583_gpio29_pins[] = { 31 };
 static const int an7583_gpio30_pins[] = { 32 };
 static const int an7583_gpio31_pins[] = { 33 };
+static const int an7583_gpio32_pins[] = { 34 };
 static const int an7583_gpio33_pins[] = { 35 };
 static const int an7583_gpio34_pins[] = { 36 };
 static const int an7583_gpio35_pins[] = { 37 };
@@ -836,6 +837,7 @@ static const struct pingroup an7583_pinctrl_groups[] = {
 	PINCTRL_PIN_GROUP("gpio29", an7583_gpio29),
 	PINCTRL_PIN_GROUP("gpio30", an7583_gpio30),
 	PINCTRL_PIN_GROUP("gpio31", an7583_gpio31),
+	PINCTRL_PIN_GROUP("gpio32", an7583_gpio32),
 	PINCTRL_PIN_GROUP("gpio33", an7583_gpio33),
 	PINCTRL_PIN_GROUP("gpio34", an7583_gpio34),
 	PINCTRL_PIN_GROUP("gpio35", an7583_gpio35),
-- 
2.53.0



