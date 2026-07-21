Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C7746D0B1;
	Tue, 21 Jul 2026 17:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656637; cv=none; b=HCkJWkO41M8penU6cSYKSY/viRBLD+B7QcxABJ5UaYgEj9kBxJAFSyXJcOxbOnfdHAB80tdKDUYttcrYv2ebCfbc7EIVBwYuOxZjH0C3Cb+ixhVye4WT7A64fIUxMqkBhoXuaeLoJb+8dlCmqoFWWN9iUflVIWRlaIkVjgeY6Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656637; c=relaxed/simple;
	bh=ceHgeaIuidGjb56FQRPz8mucc0abpgGz2XQ5sRhEZdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKQ6zn9GLMPN/y/MPGgEBudR/P3tWsO9aPjANRBXL2iIhRC73IWVO/ZE2ork61/Ih/sCG5Ujk9noVwSCjUCOGYHIXobz7D+7fkzRkZxxlRCn0hgVpqFADNAP+pUSI73JfIv6Bq5K/siBufZe1S3bu2aTuF20TFAUCIgOZQjm3RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=viBjXnqz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="viBjXnqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564481F000E9;
	Tue, 21 Jul 2026 17:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656636;
	bh=/sX7lij4f1VI/zQO/eaa79LLKnJY+WqEpG0BnGGJmk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=viBjXnqzpdHi947+T4eOmBqKGABGnwuJ3QHR1mvdDxPCJTLl+gesEv4ai7ziarHJC
	 ycRYRXRXzNiy0E1ZtBt8GcEl22ZdCIJC2hD1fLeeEbdr4tEHGF9rI0KfIwoyIDM/3R
	 GaYfdg1eV1fpa+vAQJzOgppiQ/7Kk85vtbrCe0qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0460/1611] pinctrl: airoha: an7581: add missed gpio32 pin group
Date: Tue, 21 Jul 2026 17:09:36 +0200
Message-ID: <20260721152525.655985914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 32e5c1b32d5071..acc010bdf3777c 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -522,6 +522,7 @@ static const int en7581_gpio28_pins[] = { 41 };
 static const int en7581_gpio29_pins[] = { 42 };
 static const int en7581_gpio30_pins[] = { 43 };
 static const int en7581_gpio31_pins[] = { 44 };
+static const int en7581_gpio32_pins[] = { 45 };
 static const int en7581_gpio33_pins[] = { 46 };
 static const int en7581_gpio34_pins[] = { 47 };
 static const int en7581_gpio35_pins[] = { 48 };
@@ -606,6 +607,7 @@ static const struct pingroup en7581_pinctrl_groups[] = {
 	PINCTRL_PIN_GROUP("gpio29", en7581_gpio29),
 	PINCTRL_PIN_GROUP("gpio30", en7581_gpio30),
 	PINCTRL_PIN_GROUP("gpio31", en7581_gpio31),
+	PINCTRL_PIN_GROUP("gpio32", en7581_gpio32),
 	PINCTRL_PIN_GROUP("gpio33", en7581_gpio33),
 	PINCTRL_PIN_GROUP("gpio34", en7581_gpio34),
 	PINCTRL_PIN_GROUP("gpio35", en7581_gpio35),
-- 
2.53.0



