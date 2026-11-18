Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024060;
	b=ILPe79350TOGsbfBu/XUz/KmMNoXbTtjZeoF8XYuEv+9hv9pFVKCO8SPk4kdXiGgCYM6
	 OtLMcizwkgt/sK0iZK6ta6KcuvkqTg4KaS1C6PE0p0q4og1N0x78MbxLMXwDhZBNA//2l
	 UH0XtjdautxEMrGIfU37YOuJtM5qHxS7wHhwHre4vXAtqjvetjGILIEJ6Km5SUX4kkBOc
	 10MSbLm48ypaj7BWd3BwSerfRoRhtJl4oB1BSA7GOFesoKtBxKU5kqbDje3aJhTV1HQfA
	 UO9f6CmD02LmWAbn0hLsSwA5Nl/RSRFBOmHoooaDDT1E8BmlFwLCFLS1dmRTPlMkfdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5Mg5Lsz/sqwjnNejG4jgPHW+57TyGnJsbuT/0cumAWc=;
	b=mqwfiw6FrFMQ78Be2Uuzy3Ou6D5szeSaHhwepaLz98ybEaKXbn8LHTEmW5Hs9D4qla0c
	 touPi6gWhm8i+JFcScxA1+52UL/fBzhqfvJX8cRXDs5F/qtpgmIUcZYm4nyRUZFtMiDew
	 KbpAFCI8EuCGMoQU/5xCkTFRyIqT3ESNHYeuFkJSBJ4pat67DDLI6eKss2JlTpP/4FlSa
	 LM23Xj4u4el2K8nZnHSWldDYqRxEjMjnwts1/QoxZimGq/6v2hYeWFlUmnOMbW1uT7CPh
	 aAhQ7KJNKnyHaQu0tUkt0Dhdpe42QTaChPeDv5kbJiVxajuhUFCR7oWDweYLxPbuwxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TSE79/g8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB0F606A31C;
	Wed, 18 Nov 2026 17:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSE79/g8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4351F000C4;
	Wed, 18 Nov 2026 17:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024060;
	bh=5Mg5Lsz/sqwjnNejG4jgPHW+57TyGnJsbuT/0cumAWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSE79/g8HIH+iJI42Rpvb05zSKJo60lR5++uj3/RLp2VF4h61R/JyRbenc1W3ALsp
	 fJYxhz5pVR3Q3pMiSYLKj1LmSIn8TUuKnf4hrmV2t3WgZ5bdkJN4438UYmADTDL1im
	 EVsEzal1lvQjn+/mf3s4xSisWxYG9HLEu0BpDPjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0590/2151] leds: st1202: Clear unused pattern slots in pattern_set()
Date: Wed, 18 Nov 2026 15:38:45 +0100
Message-ID: <20261118150143.448236971@linuxfoundation.org>
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

From: Manuel Fombuena <fombuena@outlook.com>

[ Upstream commit 119a7d375e5caedaf252198fa64e7df5d7269ab4 ]

The pattern duration registers are chip-wide while the PWM registers are
per-channel, so a channel can end up driven by a sequencer timeline it
never programmed.

st1202_led_pattern_set() programs only the first len slots. The pattern
trigger calls pattern_clear() before pattern_set() only once a channel is
already in PATTERN_TYPE_HW mode, and activating the trigger resets that
mode, so the first hardware pattern written after every activation skips
it. If another channel has already programmed a longer pattern,
durations [len, 8) are still set, and this channel's PWM for those slots
holds whatever was last written there.

That used to be LED_OFF, so a channel stayed dark for the slots it had
not programmed itself. Since commit d2ca0e2b6d64 ("leds: st1202: Set all
pattern PWM slots to full after clearing pattern") pattern_clear() leaves
ST1202_PATTERN_PWM_FULL there, and so does the brightness path since
commit 7cbe470366bd ("leds: st1202: Fix brightness having no effect while
pattern mode is active"). The channel now plays its own steps and then
sits at full brightness for the rest of the sequence.

Zero this channel's PWM for the unused slots so it stays dark for the
remainder of the timeline, as st1202_blink_set() already does for the
channels it is not driving.

The duration registers are deliberately left alone. All twelve channels
share them, so clearing them would truncate a longer pattern still
running elsewhere on the same device. A channel whose pattern is shorter
than the active timeline therefore keeps the longer period; that follows
from having a single hardware sequencer and is not something this can
correct.

Fixes: d2ca0e2b6d64 ("leds: st1202: Set all pattern PWM slots to full after clearing pattern")
Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Assisted-by: LLM
Link: https://patch.msgid.link/GV1PR08MB8497E9939E3C0D68401659D0C5BA2@GV1PR08MB8497.eurprd08.prod.outlook.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-st1202.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index 684d77fbe1d81..a9e616b7be66e 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -260,6 +260,12 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
 			return ret;
 	}
 
+	for (int pattern = len; pattern < ST1202_MAX_PATTERNS; pattern++) {
+		ret = st1202_pwm_pattern_write(chip, led->led_num, pattern, LED_OFF);
+		if (ret != 0)
+			return ret;
+	}
+
 	ret = st1202_write_reg(chip, ST1202_PATTERN_REP, repeat);
 	if (ret != 0)
 		return ret;
-- 
2.53.0



