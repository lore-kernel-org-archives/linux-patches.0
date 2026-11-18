Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016798;
	b=RdhWZjJLKmAoEdxLeF8K2MYWdrcig37Orlr+07bXmrjcOJDaci4Jc36GF2EunvJ0GMwG
	 2onB+3XdTltYnlQpF5M7jgtMHGemhfeiN0J50QoddcaL8UZgyUHdu/4s8nPuVXZkvbfKX
	 dADludV6ON11Jzf+IXxo0ON2rBih4XcIUlgiBDURs8lXPxZyMde0+fs02olEDRf0oQJgf
	 PBkQfPALq5l9XDZsOIBGdkniXUrFXzSF7qgrHygC/mXJs8CmYZwM+ILdJYXEZPcbWVNcT
	 0/QHYPOLaVBBiXrRhlZbdcTuUp4MpIgip/3CLSKnrmmsIyfblDBvNOwCy6xWO2MU3Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4c2L8mcof9PhudThtmaMOdWmXmvx82BqIzhYwZS75VA=;
	b=yBKmsOFZyTUgr/NAGy8RNFr8buhkeveU1YAOQ3861hmsFfx6uOxZ3/Xfwb1YR/DAe1Qt
	 Jjvr30rEhqs45/WWjypISocbxmhz0A4R33nKNZ5ksC73hkgrNwP05JYMMMht++70oTZM9
	 qPlf9EUUT5fmLD5g36dGjAsKbuw7JX6RfaNMlaMtxtdtC38D7HPZ0GPTMYFZzNRczeX/R
	 hXozuePkiSAXexDfLnhUk+68siqz+S6mJ2ESp96l+s6tZzH0Sbxuch2TTm7ohTALflHY6
	 +CYpDYGlD5O8dGy0KJFjIbkEwyzragnxQe8cFxWQBEG7uLG1TNXgIU5RmjpS+kmpoAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xoLBplAe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0134606A325;
	Wed, 18 Nov 2026 15:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xoLBplAe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157401F000C4;
	Wed, 18 Nov 2026 15:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016798;
	bh=4c2L8mcof9PhudThtmaMOdWmXmvx82BqIzhYwZS75VA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xoLBplAez/hqXGYmiatXVAiWfL06P/SYXpc4ub0/AUfVivyGLONHmMrHGzrsxm3oQ
	 D9o8dzOxkCpmA2P8orQiiCdoWT8S/4wmRqpGnL/xy2MDoZMG2UnrKcdvcFrY+QkBgo
	 v2547ePtrc24Ilb7wVNYfvdnPQD68BFeDKbgaCd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0658/2651] leds: st1202: Clear unused pattern slots in blink_set()
Date: Wed, 18 Nov 2026 15:31:38 +0100
Message-ID: <20261118150311.549818755@linuxfoundation.org>
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
index 6051f985d95d9..c4eb5ec0fc313 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -358,9 +358,11 @@ static int st1202_blink_set(struct led_classdev *led_cdev,
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



