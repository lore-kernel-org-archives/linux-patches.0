Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056589;
	b=zaPuWgonxi3aQT5/Hz8gI7hlUX0k5Dd/4QkErjEXxzbhdK4NMNLgsRcpEwajU8lsk4Dm
	 N5SY6c2PkX0sYJlxmnRQ/5vJE/sKxIHGYqZ8LyMXo49Rgwg6w3ulPYfVoWNIW7kqPj71T
	 hnNTbVG4TWMT95yFQTg8Q5RC01lKzR4YfaErjkYYv7C+G2+DtYZa13Po3kWfjkxGh0ad1
	 Px/B/s9yLOPB676ZOTtgFDPNnowHKq8RFiiZ/vzJ0crLo+7U+6tzGzL7I6AC79hU+tbMS
	 OPgzKcV4H1EEQjPu51wgNERoV0E296Qnefqqo0nL/NeDsEewt0ARpsdW4j2zwf4atew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+xOksTeryO0ZXLsVT/lQmaX316wBcWa+QrTo/RIYZXY=;
	b=qN+qYvNRHaThhtPWq4Phcl2GfaCN3WeglaekU0SQ4DnsIzt8hP/u1p8Jci3NY8pMD5Dz
	 BQ8GSyhfm/LUsqM2qv+v+3xfXhKlhy5fNkcL10KMYbuJtw7sPhfsJwa3j23AF74QYDR8h
	 X0u+WHC/xCvqN4RQ8Gb5/7++ngMEqV6j3R/m55PGzU8wf7U01q8gl5CjQJJegepwkhXbl
	 +dud8+ip/c77PEywDin7WA1q0Hwh5t0rGjgFOgQ/YkbvmI4NV5c1WulTaKf3yDzPVaqvS
	 QijfBtYdD/IYUK4kT9ZJUfdbdfD3PqKhqsdH2PqbUJFABBOzdzCaz/TGR57DcjNDlHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tx46vjun;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32FD606A325;
	Thu, 19 Nov 2026 02:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tx46vjun
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430D11F000C4;
	Thu, 19 Nov 2026 02:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056588;
	bh=+xOksTeryO0ZXLsVT/lQmaX316wBcWa+QrTo/RIYZXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tx46vjunXHPK4QXL2ZPzEuh2/A+ro+oEaUq0Nk4o+Lgjpo3m83/9o77iGKL/XFGRI
	 N7tZ00QS5EWQukBU2FOb6ZKBoxkGJTPYPlNrcKhz/5vfhM/iBYyUvj4iqWdTnvpjxV
	 9+kW6Zi9bTnyA+Xm4za8wYVs5QH1aqk9MF7CZULM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2034/2214] power: supply: gpio-charger: Report discharging without input power
Date: Wed, 18 Nov 2026 16:01:50 +0100
Message-ID: <20261118150132.118366761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



