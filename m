Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3FA8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:13:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E45C433C7;
	Sun, 16 Jul 2023 20:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538400;
	bh=UVor3HjPP/6Ia6VEvtyvhtsbP+3FKNtKYEcEHPQQ/q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AgEr21jVf9DU05M8LEohEbOAhM1TkH2LDQO/K2+TkPiqI+3g2cvxGslU4UgCKqhvW
	 vCHisiInvd+YIlg1aTtGG5m8ibve1AaVczSS4oD5kp4Lj6S1kuOWYnRkWlMnJKHH++
	 1C7LSnGtPhayQC4C+grDh3oJGYl+zUss7cV5DzZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 438/800] pinctrl: bcm2835: Handle gpiochip_add_pin_range() errors
Date: Sun, 16 Jul 2023 21:44:51 +0200
Message-ID: <20230716194959.257424121@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit cdf7e616120065007687fe1df0412154f259daec ]

gpiochip_add_pin_range() can fail, so better return its error code than
a hard coded '0'.

Fixes: d2b67744fd99 ("pinctrl: bcm2835: implement hook for missing gpio-ranges")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/98c3b5890bb72415145c9fe4e1d974711edae376.1681681402.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/bcm/pinctrl-bcm2835.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/bcm/pinctrl-bcm2835.c b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
index 7435173e10f43..1489191a213fe 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -376,10 +376,8 @@ static int bcm2835_add_pin_ranges_fallback(struct gpio_chip *gc)
 	if (!pctldev)
 		return 0;
 
-	gpiochip_add_pin_range(gc, pinctrl_dev_get_devname(pctldev), 0, 0,
-			       gc->ngpio);
-
-	return 0;
+	return gpiochip_add_pin_range(gc, pinctrl_dev_get_devname(pctldev), 0, 0,
+				      gc->ngpio);
 }
 
 static const struct gpio_chip bcm2835_gpio_chip = {
-- 
2.39.2



