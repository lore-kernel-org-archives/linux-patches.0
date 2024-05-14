Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6B857CBC;
	Tue, 14 May 2024 11:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686938; cv=none; b=WFbs+kgO7gj/VGlgH5ht6kheW+qF1AEqASUF+pRCb/ODUQTLIpjCovEzHAk0PeBH7PyxTG9e3hl02UYY8cuImpaxONKCvUrLIfYII+FDBnPm/pm0LlXOLjSyRD+iGNdhH3RaRI4pLdNkuwoqVhMjcwDhCzHmm7XzCzEsr45ukKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686938; c=relaxed/simple;
	bh=YEtA1KUjuFYgW7D1LMPzUiTIl2fmb8vw+lqj0eVMTrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUO7an5cTgO4HDnRUGF9URvR8Ppy/YRw5X00zu7s6gD/eamt6SKnrTevIo94m2J5PYHjpabN2sSaZ55VV+TL7jqAtz6LFgMA/0Dn/tMjIRFqeMxnT6lLqKRNYr7lo3r58/RP6ntXYy43Qhndw17ibkrOK+dwXfhJMLvT8Ak0SKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVb5z0Nk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVb5z0Nk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AE7C2BD10;
	Tue, 14 May 2024 11:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686937;
	bh=YEtA1KUjuFYgW7D1LMPzUiTIl2fmb8vw+lqj0eVMTrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tVb5z0NkLsCYKLu3wxh98nf/41eSAAvUmvc9dAT53uz5x9HEsXADnx4AdzBFAjghh
	 17wNRfgl3GWOKuKDCUukZvagyo3gDs26NDiKPzeRL3yXHEKfEBlKT1u10Pw58B9RrN
	 CxMokp9EmP8fp/ds6dqmzVFtcxh/WGdp2FSfapuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Light Hsieh <light.hsieh@mediatek.com>,
	Stanley Chu <stanley.chu@mediatek.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/84] pinctrl: mediatek: remove shadow variable declaration
Date: Tue, 14 May 2024 12:19:21 +0200
Message-ID: <20240514100952.080614688@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Light Hsieh <light.hsieh@mediatek.com>

[ Upstream commit d1f7af4b4a11bcd85a18b383cb6fae1915916a83 ]

Remove shadow declaration of variable 'pullup' in mtk_pinconf_get()

Signed-off-by: Light Hsieh <light.hsieh@mediatek.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Link: https://lore.kernel.org/r/1586255632-27528-1-git-send-email-light.hsieh@mediatek.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: c5d3b64c568a ("pinctrl: mediatek: paris: Rework support for PIN_CONFIG_{INPUT,OUTPUT}_ENABLE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index 18706c46d46ba..b613dda50151b 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -164,8 +164,6 @@ static int mtk_pinconf_get(struct pinctrl_dev *pctldev,
 	case MTK_PIN_CONFIG_PU_ADV:
 	case MTK_PIN_CONFIG_PD_ADV:
 		if (hw->soc->adv_pull_get) {
-			bool pullup;
-
 			pullup = param == MTK_PIN_CONFIG_PU_ADV;
 			err = hw->soc->adv_pull_get(hw, desc, pullup, &ret);
 		} else
-- 
2.43.0



