Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032373;
	b=m09WGBEHYcSVlPaAkfMvZtfWnw7yh/zURojyU/pbEcEipZDmAuvmLHGU1l4OXO/bQE2P
	 EH2vvK6ZrjK9ssMW0gRi1upU75hOP0mqrnjMn8U4zVkxj5GPTDGnUu9api5BSVTsgdxwC
	 MCZOQAZcBf3gOuMAKbVtAHiNAkRyMGxQyKzcnbXTcHnx6xoP2Oeyutd5BpAvd1nR6nNre
	 cjzWSu+9Npn9b8U8bCzRkCFcACbQYdYmGXrT3WUMg4D0JCeJmu+qgaAwhC5sYcGW/2HtE
	 VxCpe/LZcn472/ZBh+bzISW8jK3ksOYOpuxqS0zZb5UJKPr1F3Rlzd2u2eZuk4jOhxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W4y82VMtZgq3vQg7O78tpr6opGTjIFF+C8g3gIjHSJE=;
	b=4vUq/DHifpBvnAMaTR8QmrZNifJO8yXAeBGMv+2CQU3ocSq/7Sl+sqtUqDzEq+q4gapP
	 XelDGNRZnNrT+d3TOa2ZWzqaXu8pO6Io4b2o47JZPp+O2r/zb/FrcJxKOPY1+p7PCpcEA
	 naq5UOhPEyBLc/mxgs6nE60wSHgcbAl3Gp+UcqZGkVU5G8n5mFwp/CRuyef2yaIgD5Mo0
	 fgJWN5R22aX603Yw3YEiozjaJkiqqzqN0HOkRVONCXnfr2UYCBo/I85lnL3KoRS8iAN7i
	 fX5zacqzkT2A1721HEPVRK8vtQlRtmDxjlyw1c5VGNBnQUxdGEsoQNuPINJHB+u2FMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=egAe48tX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F8B606A31C;
	Wed, 18 Nov 2026 20:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=egAe48tX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBF51F000C4;
	Wed, 18 Nov 2026 20:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032372;
	bh=W4y82VMtZgq3vQg7O78tpr6opGTjIFF+C8g3gIjHSJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=egAe48tXRXhwY+G7gWPfINIgI2IB9hrcupdD4MY6KXNEzKKCuag6RqPi6YYf7Uxs5
	 bSDgYlT5cKqVI3jqj7BMdjqayu86ugLx5aM8UxoC44YUBxynSJu9fKTrdMIh3jZ6mQ
	 gD5ktjoRHOuQUOYKySobUF6plDBG6C+rn7BokbPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1389/1756] power: supply: gpio-charger: Report discharging without input power
Date: Wed, 18 Nov 2026 15:58:36 +0100
Message-ID: <20261118150104.459595060@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



