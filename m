Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027324;
	b=zi5t4ohb9ufCtnZpOzM0Ynron3MNfbQMSVTsSFxEq3ArcX9t2IyRtw9fxxmXH1X6WiKM
	 oobfMLP6Fqh+MnNTA40cr30ysdSCqPmnL+4unGFsBD2uPB4H2b5lD0b9nb5/F5aYJQYZG
	 3U6yQ2Av+a2/Ps7TKV0n2cHNiKnjUfBf6uzk44icZcqzwcBMIWehqtJhl16gxziXs4iIC
	 /8wDSCyF9VgwEYTCNGMjGax4zAOpzyCrRafAfhCSbYxvfo0jUWpUHzw0CwQguOfrKeZEk
	 6TbYEHUuPbl9T8Uw5ynVPj9lKdIVTj8pZkPGQJ6yXroCSJpuzaookZSuyv6yd8MS98w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027324;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/SrT+q3ZZzry+mRkpnmYeiksTM3dH3cPSk8bEE/vxWM=;
	b=MNAiXWCPA3ErgYEetkTwLMMcnTAoqgnp231nGJFpDp2Gfn54R2MsK2LsYyvrvjGAw+UA
	 1LaNUmLXAMtmCZjHSSlrz7/HMgTpcneh8YwKV3PBKOKDX/cLA6iyVfT2lF0HZBRkW0dci
	 z3Hf8QaQR2jhNXAoxQxXGLcZdzVNaFkQ1UTwp2qDfRyPP36lRS3DuBK6eqftssndL4Y6H
	 MR8zGGAPv3jDlwg9rKL24ZutmAhiUli2vCyR3xQd/dkQRO1vNZu0shrl0x0Ul0varIOZG
	 P6UT70t30UosXsDX1B3xZLSXQ8C6dzVFnXgL90/F1sbZIpNYbR6DrR3GfpWwPaoXbcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EQuOIpVX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A76606A32F;
	Wed, 18 Nov 2026 18:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EQuOIpVX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1011F000C5;
	Wed, 18 Nov 2026 18:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027324;
	bh=/SrT+q3ZZzry+mRkpnmYeiksTM3dH3cPSk8bEE/vxWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EQuOIpVXhaFi1cY0FknSlNBYh9zKk+81R8La22R90UYQpPR+Sw69CG35g/5jXDf31
	 WawsCzto2KUYitsG7yPSGSt3CFt+IlYlqdzRJ1u2s8pzDNczbacIDst/w0vavdcJcl
	 AdTiOM4C2Csx85/4VcfF0b9FiSEYb24tQOsvzyHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1750/2151] power: supply: gpio-charger: Report discharging without input power
Date: Wed, 18 Nov 2026 15:58:05 +0100
Message-ID: <20261118150225.603460019@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2504190eba82e..1dad49acc4241 100644
--- a/drivers/power/supply/gpio-charger.c
+++ b/drivers/power/supply/gpio-charger.c
@@ -101,7 +101,10 @@ static int gpio_charger_get_property(struct power_supply *psy,
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



