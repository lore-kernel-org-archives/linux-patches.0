Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020954;
	b=DxjUxG5++rshYUob31Lq/cOmp0Ei9xjHS9KP7oht7ay9UwpQI9uv/xQUWVa2vWHYnCOL
	 LjqlynpUvBWpFnDnzOTjV/PBGt4Q0JNSh566DYzhzPf8CQUJwdFpAdrW+qJ0GHQBEbop+
	 e5smngM9N1cGEpKvoELUc+8FDWgS48HExmKSDrotRxoa5bt56Ry1nmj9Adg5YYo1R8N0n
	 q1hYDLH2OKl6KJwY3mIRaD/noXTAmQuCsUOXXb2q93pixmRyjObvFkQD424sFzlMHF5Ax
	 LXYG3PorOls7cFyqUHOLcuPCxYDAmq7IwAJ+jF/7PkCHFA8SojJ889fe/kacepPIzkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AhBrqACIR4G1iM8TAHHmaBcT9YJusgmVSyfjguaQHNU=;
	b=g/EYIwhB4eEMauxSZ4tbd7PtesF2zxyRr972A4z6kfnjTkcV2RdpNw2xbKgS+pqTFOhQ
	 P9hGHklLR3n6CTTtDx/GGeeyyh0dNscSVD+NMpWlAWetGw2hadn47HAvV2ggGM7vd+Fsg
	 TFB++VcQ2qGD6TQbssia1D+2dXetcph6W6odxXVC3rGCSvWt2csF4S0VwlzRrkBcGpn4D
	 EFiAuDQYTVJeDuMSuWfa8CLXzOZ87+EUpYYelFwhhquZvShxPE9dlZOE0TU/3xN8gSkwA
	 yGR4T5e8fN4Ef650kWWrLO32Mdz8/ZqsMyOMCzpI3k+OhxXuwbFQ7wMleOZx/VFeGPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ChUkyLje;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CB0606A32A;
	Wed, 18 Nov 2026 16:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ChUkyLje
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97EFD1F000C4;
	Wed, 18 Nov 2026 16:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020954;
	bh=AhBrqACIR4G1iM8TAHHmaBcT9YJusgmVSyfjguaQHNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ChUkyLje40nQ5geKWJeIJgneE5s+uzn24cxaTtHgliB+eJqUZemfVWzTOaLpnnce3
	 ikkr+NfLmU6tVcpQ11/zGUY3ecfWi0ZLZZDiw88eFCchkpKD51HKG3HbeQdqpeh23s
	 dX0KNK8UcS0lCWH5fZtWlUq2iW7TqDq1f83JGBFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2134/2651] power: supply: gpio-charger: Report discharging without input power
Date: Wed, 18 Nov 2026 15:56:14 +0100
Message-ID: <20261118150402.708644194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



