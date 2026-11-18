Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024085;
	b=1VxZ5zyUlQY9u1yu0oJA5pUqN5ndaleX3aBXZIpoE6YuQk1keC/sfikyUQFtEgCCzFMw
	 1v4gP9qCP4NJxgWBU8cwj3+7PleD9bLS/W9e+DNKu7zhL7Exf7g9vXJWVaZp09WyReS0R
	 BJdQ7W29pono8hrvt4+7sJqy3OVNn3fO6vfD5ibulM8hjsCsI+6C8gEFQOH4vKRC+RpeG
	 CDKa/cdFOu187iwS9h1U7XH+/00rpaRd2YhLB1xJqgMfTlngYK5y5iecl8rVvqkbCCVo3
	 6OM4D2J45e34tbWQFbdmYmu3p3JP4Jy+b+5yhAn3OK2X3LxFpXjBvAcLGKx38pzS0Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ADxtiKIfvCUbdiI9vf6PPGzScyH+RZ6LaYGR5+sGHEY=;
	b=dXNfNSpuz3PjsD6TzqIPsy+QVy6tj3IQAYjMdRPSYsOino8tVEgPgp5YFV6BqktsFPQe
	 O7w+HAO5mnkyWb7oKcvMTEpALBcBs7+ji//i0jglbRsJkHR85mqN4A3K/YoYcFP4T2y/C
	 6JfwS6nTjUke0h7N+LyQyhQt5Dbd7lFdLg07KCP+qfZpyCvvH/CUzHM/7srBMklntHB1Y
	 qlbO0b098nQw9LNRBEFHy6l6txLzhMjc31FV12TpspFvQhDhWUyU9mT10EyZQkk4q+9SJ
	 PXVBDxTVlPk/drQFez+1cl6H/1QNzxdcw7ywTAF9nXORWT9gbz8AbHvr1pYsZDgqshg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RIYFitd2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76EC3606A31C;
	Wed, 18 Nov 2026 17:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RIYFitd2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D010A1F000C4;
	Wed, 18 Nov 2026 17:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024085;
	bh=ADxtiKIfvCUbdiI9vf6PPGzScyH+RZ6LaYGR5+sGHEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RIYFitd2TxTzCn7lNfsJP85Gbxn56EkapoB+9ixY/7+a53L7t/NgUPjygASw19OWI
	 pA9wNNEH7BB4OXUe8Y9HHs9hlRlQT4LQyt3yHhtflSAOZbHiStNrsfmgZecOi8TGnH
	 thmfaMrEmFGvaX6Qc904zuJPD9j1ki+YNwDQvYsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0598/2151] leds: st1202: Clear unused pattern slots in blink_set()
Date: Wed, 18 Nov 2026 15:38:53 +0100
Message-ID: <20261118150143.732943802@linuxfoundation.org>
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

[ Upstream commit 3268b9e91db16f240ffe07ff6caf963ba8191ce8 ]

st1202_blink_set() programs slots 0 and 1 of its own channel and leaves
slots 2 to 7 at ST1202_PATTERN_PWM_FULL, the value both st1202_led_set()
and st1202_led_pattern_clear() leave behind. Nothing keeps those slots
out of the output except the duration registers being zero, and those
are shared by all twelve channels.

Another channel programming a hardware pattern longer than two steps
writes those durations again and re-arms the sequencer, so the blinking
channel drives full scale for the extra steps. With two LEDs on one
device, blinking one and giving the other a four step pattern, the
blinking channel lights during the two steps it never programmed.

Zero the channel's own unused slots, the same invariant
st1202_led_pattern_set() applies to the slots beyond its pattern length.
blink_set() already zeroes durations 2 to 7 when it runs; the slots are
exposed only when another channel sets those shared durations again.

A channel whose blink is shorter than the active timeline still loses
its own timing, because the sequencer has one set of duration registers.
This only stops it emitting output it never asked for.

Fixes: 35cbd34a6a05 ("leds: st1202: Add hardware-accelerated blink support")
Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Assisted-by: LLM
Link: https://patch.msgid.link/GV1PR08MB849770CF6D41F3DFF56B1AC3C5BA2@GV1PR08MB8497.eurprd08.prod.outlook.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-st1202.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index 23fffee873b9e..98e8a43b5ed7b 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -359,9 +359,11 @@ static int st1202_blink_set(struct led_classdev *led_cdev,
 	if (ret)
 		return ret;
 
-	ret = st1202_pwm_pattern_write(chip, led->led_num, 1, LED_OFF);
-	if (ret)
-		return ret;
+	for (int pattern = 1; pattern < ST1202_MAX_PATTERNS; pattern++) {
+		ret = st1202_pwm_pattern_write(chip, led->led_num, pattern, LED_OFF);
+		if (ret)
+			return ret;
+	}
 
 	ret = st1202_duration_pattern_write(chip, 0, on);
 	if (ret)
-- 
2.53.0



