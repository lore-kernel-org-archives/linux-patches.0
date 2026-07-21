Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36ED246EC8B;
	Tue, 21 Jul 2026 19:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661716; cv=none; b=UpPAVThs59QyymD/UVSFWJqoaHO66ILb0eUj0oWjLCndh/z9HNXsXm7DgBzXHQMMu3dm/cUhzeG3PoLKjYzYrwZzpDp3iC5JPGe8hoazTGZnGHnnNqgVbI6dC0JK3k5UUo7R11egZhJCu0MyVDqexlUuqBitE+J5VDso9hec0rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661716; c=relaxed/simple;
	bh=/ARDiRiy/B/d2xXqfVkXKymfK0mNjSe0BKOeW7rj/pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SE/xAeCqgyGlgp6V16T5h2LYQ55QyqDX534JDGVl1vFRsAlKgh8+s9jZNVdvooUVw2MflnBHspeBrvVr+yr4YMzI5Z2Wt/+B7bcLMv9OmK/IGppLRXeOIGfqG4i2XrN7MieEnZHIZIchhazCf2rJ2e23KMQ3waKqLPYCgh0Y6hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GKPRQBTF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GKPRQBTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4BF1F00A3A;
	Tue, 21 Jul 2026 19:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661715;
	bh=eyHjHQVrTTvhAf41MmTP4ZOA7nzJYis7I1WiTWgTjxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GKPRQBTFJ3TEPlPDeLxpyToADqxvJwxVa1Vw24ihryhlHfT8JmFA6CWHeugrteWqF
	 iodw3inMrGdqRp04tgil/PgWc4HHCCb6d9zPM20agAzv5eMUib9mYP5K25WtTkXB1c
	 7w4N1srumgSGmLAZivMaUCILpYEaUV8YDTCc0xhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0170/1276] pinctrl: cs42l43: Fix polarity on debounce
Date: Tue, 21 Jul 2026 17:10:13 +0200
Message-ID: <20260721152449.902846567@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7734dae06a4acb..dc808ce6d35323 100644
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



