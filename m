Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016856;
	b=X9JqpjSbFashEAckwMylDTZJTqlVBmJMhImoyo5gy5+PDfbzMB58vaDCoohG9grusMp7
	 ZshnauHqssEBr33wmAxb+YayWFNXcVcuCtXajRMmC74ZuC2xsWbEKQ7u6ZxOMmhKmYTEn
	 pkz/2nfbv4T1KWvYLnFQxKAsepsxUeLDCdr8+EQxzYeKpjz8R4WqXziibC1vnMNILK6mt
	 SWu2KIkZwcfB1PZlhPgujxRyS5YzogzcKdus9ANNwhFyGZI5GfJwF2YDGdmsBl3Z3/ApS
	 9WW9liS9XACpxB1DQw/6kXXWfdGF+9OnfqYu2524QpG+E7YwoU/y1X+1MwI+CMlw9nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3QYxZBy92BIdnYYutJ+qU7Gzs/WzWEElByOL9PubJac=;
	b=eEJTfXj8B2INy9nSIcQpUTPwEBrI7IFMDPOfcMul/pw7Pv9N4hJWvfTN3rpHDPqjZYmo
	 NEDeXenjmye9yh10BFcR0eiIQSQrf8KSG1iuonAY/UuYmfP1rF1l4YsuNk09I32UOQeGf
	 ZmCMqPFn2qSrcelw9wVIG9RZXosqKObk72x5Lhhg/bC2kQ+O++BVr1FfmUEDKp1R9SVe3
	 kviFgYN71361RwTN//2qGJZkIxnaZ2UBqBdR1Iw3RB/BRE6E142EytCMSHZ2NJshKEZUf
	 dAk0BVLTFpT2wmVzaBduZEArCh9kXZ6ZKhMHeVqOUrsfv3uMU/DsbEbZM6/6ZG7Rl8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U88186bs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5F5606A320;
	Wed, 18 Nov 2026 15:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U88186bs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53681F000C4;
	Wed, 18 Nov 2026 15:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016856;
	bh=3QYxZBy92BIdnYYutJ+qU7Gzs/WzWEElByOL9PubJac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U88186bsiJ7TuAltnZIpKUHU1eVNam8JcDwOz8+IsrW8LUl5jeIalWh23SKLdxes5
	 66Ov0d4hELmfNckowT6b3Wv9Zv/Ob4GY1fmfe9IoqOnwGdgjicmMVo4K/B9ru+h6dx
	 fGUOOC9RPo+JmyyQGwTrxmmCs9moO78+8C8aWEws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0650/2651] leds: st1202: Clear unused pattern slots in pattern_set()
Date: Wed, 18 Nov 2026 15:31:30 +0100
Message-ID: <20261118150311.085352624@linuxfoundation.org>
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
index 168df5ecf27b7..b34c41d58e44e 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -259,6 +259,12 @@ static int st1202_led_pattern_set(struct led_classdev *ldev,
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



