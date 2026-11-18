Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050143;
	b=4SqllevZpX7ijXdk3AcoTDZeEjl5WHtT5OSjwtKeFnMTsWWYvjOOoxuKYfSCoAwzHcv4
	 qO5ouQep9sK34xNQ6lebR7O1++M22NNjsYmTg2XiIbkdXkCYtQLnrqkkpuJK3A7TmWPVt
	 kyT3Zql6JzHWH9cRUdkFutp/oE29GocqOvx4Vu+LCM5+jbTD3m9y2LYHsOxfSj99UG+4F
	 5jIJiZCIRsj5vspGmkqDDZzETi7QKKKAhoHTyZCcXW0yPYBn5VSloJ4MAX7gsAibtN+lj
	 RhLXX88QpKrpCjlmdmg4q8MP9MXpwvuNrajtlK1ciad8Gxm1ljyTZLyxYFwnww7ZRsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NfY3wooVFUux6wAhmAPfuw9Sb/zSyy4VEYx0rGh1tVc=;
	b=F3jg+T5PM1lNCpNYzjikmiG7eNVmD+ct2fGNDVgOd2IYO6FEA1/f33i0bI3e160le9e7
	 teZn3rTobNGetblO765fHQ91Yt4fAQyn5TfM1ARAU4yhpbZ7DboxwJFdkqwMVrBEs02eQ
	 iwkpFglFzhmv9TkgFYGJc3ArWqUfa49EnOZLYK+oQnEzf0pxSteP0v1CXNBKtq/7TBqvb
	 SPl/K5+53LWYtQp+HlQTGeTjVsiWr4HSKg6v6xZJuXJyLflve6wteXc//rc6rQKTTlfUh
	 yyu0aOKth/vlBtRtugKWVwUSsWxLOvmK5XGDlnbL2r6+Q4aeWbFmeWHSjI8Zb4a4F3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cNRDLdLB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB096606A32F;
	Thu, 19 Nov 2026 01:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cNRDLdLB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4B91F000C4;
	Thu, 19 Nov 2026 01:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050143;
	bh=NfY3wooVFUux6wAhmAPfuw9Sb/zSyy4VEYx0rGh1tVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cNRDLdLBJz8UPKDYQgFpf+T71wFoUBCVErFQY61K9mWliTUzum3+XS49LaND3d2wm
	 W0GgtUePtkG0t2xS2szGOgITLEBibjoeYoYxQYgjVFwbW1opyGDk70nO0kdR3Yki8+
	 Trgw9lGfVDoYGx3EuqqFbCGElwyD1C8ycR00D8GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2603/2857] power: supply: gpio-charger: Report discharging without input power
Date: Wed, 18 Nov 2026 16:00:37 +0100
Message-ID: <20261118150335.269541685@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Velkov <iav@iav.lv>

[ Upstream commit f0f400459bf6a037e70768de623fff3f8920b8bb ]

The status property follows only the charge-status GPIO. Without input
power a charger such as the BQ24133 releases its open-drain STAT pin,
and depending on the board the GPIO then reads as charging.

On Kobol Helios64 the board runs from its battery after a mains loss,
and the charger reports online 0 with status "Charging".

Report "Discharging" whenever the online GPIO is present and inactive.

Fixes: df68c44c720a ("power: supply: gpio-charger: Add support for charger status.")
Assisted-by: LLM
Signed-off-by: Igor Velkov <iav@iav.lv>
Link: https://patch.msgid.link/20261018-gpio-charger-offline-v2-1-482795f9e27c@iav.lv
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/gpio-charger.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/gpio-charger.c b/drivers/power/supply/gpio-charger.c
index 6139f736ecbe4..fba7b0616059c 100644
--- a/drivers/power/supply/gpio-charger.c
+++ b/drivers/power/supply/gpio-charger.c
@@ -100,7 +100,10 @@ static int gpio_charger_get_property(struct power_supply *psy,
 		val->intval = gpiod_get_value_cansleep(gpio_charger->gpiod);
 		break;
 	case POWER_SUPPLY_PROP_STATUS:
-		if (gpiod_get_value_cansleep(gpio_charger->charge_status))
+		/* Without input power the battery discharges, whatever the status pin says */
+		if (gpio_charger->gpiod && !gpiod_get_value_cansleep(gpio_charger->gpiod))
+			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+		else if (gpiod_get_value_cansleep(gpio_charger->charge_status))
 			val->intval = POWER_SUPPLY_STATUS_CHARGING;
 		else
 			val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
-- 
2.53.0



