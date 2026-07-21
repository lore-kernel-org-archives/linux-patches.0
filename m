Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5936F335555;
	Tue, 21 Jul 2026 15:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648779; cv=none; b=itEYAkQoR2CaU8C7d/qD8AkfdnJ10+nW/qGgffKcJKwqZ1ko3NOQ5FwhalMPAIFbITNwDqE79GO4130QsKWcvsuVwU5GXb961lGPNyM6MQakDUprnWOVDW044eGuEYZD7qevUOXR3KjRtBGGKbxIqiwr4jcHeuAkV80gN7fF9+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648779; c=relaxed/simple;
	bh=ft63c8UA7Okc4maWhCyWcqj9pDNDpUC0ckw3U/4Aiys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8VHr6wg9bYM0d4jCru8A3PNoZbEw/t8H7Dgr+HH5L7v1UX59tCh47m7AZV3zwcYFcbK2vf/Y4Q+gl05MbPWksiq1Wavc1llGOvHutstdCjtmfsP9XWbXqGjgb1LNn4Mxpbblj5mUHX4MLRrPnf8HIfA8WeCvh0pHqZQ/OXfnpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yl+th1un; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yl+th1un"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4A61F00A3A;
	Tue, 21 Jul 2026 15:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648778;
	bh=ZLN9fpfu/qeK41SMoMCSgoI+5RxGhNN1DIEzE9OIJRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yl+th1un+dITX1bwzPl/0P1wMQuE5gOLmEMzr3RJRlUzc3epfQYg0bE3yWGpYaUP5
	 7upyqGXoCFN+0vZLAmPz4QjB4RU9jC6bnSt8HbyJKjU57ihextH/640OhxUoWgKDo8
	 XKbWczoCROKICFgJZtqWZwwJYx6IY1yBDZaTML4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0329/2077] pinctrl: cs42l43: Fix polarity on debounce
Date: Tue, 21 Jul 2026 17:00:02 +0200
Message-ID: <20260721152600.443356392@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 9da52ee80aee3ab3c69208bd1cfbb4be01371214 ]

The debounce bit sets a bypass on the debounce rather than enabling it,
as such the current polarity of the debounce is set incorrectly. Invert
the polarity to correct this.

Fixes: d5282a539297 ("pinctrl: cs42l43: Add support for the cs42l43")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/cirrus/pinctrl-cs42l43.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/cirrus/pinctrl-cs42l43.c b/drivers/pinctrl/cirrus/pinctrl-cs42l43.c
index 3cc18352060770..305233fc198762 100644
--- a/drivers/pinctrl/cirrus/pinctrl-cs42l43.c
+++ b/drivers/pinctrl/cirrus/pinctrl-cs42l43.c
@@ -343,7 +343,7 @@ static int cs42l43_pin_set_db(struct cs42l43_pin *priv, unsigned int pin,
 
 	return regmap_update_bits(priv->regmap, CS42L43_GPIO_CTRL2,
 				  CS42L43_GPIO1_DEGLITCH_BYP_MASK << pin,
-				  !!us << pin);
+				  !us << pin);
 }
 
 static int cs42l43_pin_config_get(struct pinctrl_dev *pctldev,
-- 
2.53.0



