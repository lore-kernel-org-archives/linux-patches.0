Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A76846D082;
	Tue, 21 Jul 2026 17:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656174; cv=none; b=InBcQbFe5XNrFuReAHrrHhq9OPNwYqtk/A6KgE4OYmLdpL4ojboS1FuOIypAYsIXLjl+lmUvTECOjcqRyOLQ/2aS8CHiqidyBI53pMSAdWq3KOlFiD6ZWn3H+Pr8cOFMXXNJwPbItzXITuW6CdjEAn62uc9ZIh3OfkG25l977X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656174; c=relaxed/simple;
	bh=0Eg085atxl4oSsfO+uwWjO0p1H2jQP4lM4iLJ4Oo/c0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWUFafgcE05ufDdAVDVorAB/osPsMnLy7AGuaDWPbQQgtMqX6ICNpNJEekZ5mbPlhdEn7QMYbdEKgivWvnlYRLZlEJELYNvmAHPlaH1JILi5JsUFO2wb2P4invGXZOJZmRsGFFPxM5yNKZenS+9ClIJh8o/mEWaM17YQSAaPhFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlsHEHM0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlsHEHM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E961F000E9;
	Tue, 21 Jul 2026 17:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656173;
	bh=V7dbv524Wb6gLBK5i1CkAxgdVFE01zPbMm+IijNJDCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FlsHEHM0r18zoNIO4GqC/KU+AjHdQ73nYUCnfTWGGDifHSg32LoFXrmyfsjrpkvbw
	 2ai4cxL1LV5t90sdXIkcUEuESd0JU1ZjU2Oi6NB+4DaFFAxFGwE3QHFc0QtlEXgmLs
	 NkXxaissBcfiChxlQCnI4IUkQKRjNc2Dau/zkXjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0234/1611] pinctrl: cs42l43: Fix polarity on debounce
Date: Tue, 21 Jul 2026 17:05:50 +0200
Message-ID: <20260721152520.273443758@linuxfoundation.org>
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



