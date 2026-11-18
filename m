Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039362;
	b=t31lC2g3xZFfbiT0VXLg8VeyAOr6jKQ5nJsNUxaQ1CWoDXcS8X8qeS57lnUNKtnockCV
	 6mkDfRu7Mi3P6GaxALuriz4730vGiXHs3vJ9c6+za2Gb5w8+/5j9ghM1YvTdpsBDaQYQ5
	 EnhDSBBhrw+qDPTj0jF3/b+ZSt/Sqkw9hknYRStyr6qpPcz1lBB1r2S+/p1eov/WFyYYF
	 zC577ngSHOBUGumopkvMEt6UNXUyFwRSe22/VrrUxlhZd/a8qx4wtE2fwKSbsF0lXmnAL
	 tzF7wl5GYmog6X3r+9zvnCnTeu5qc3w0Xp1E0PPMJi+Iubckwm3vU5f03z9bUBqu6aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/+pDoiaLNaaBenvatZbAD2hbMTJgjFNHKORO7VRyyAc=;
	b=gd/dvFXHqz071+J18E0NPMxAXxw8mg88s+yJx5cznsqyVRoddr6mC6x7Ti6YppLm16QB
	 lFhPcA74titE32hUNLEyPK7CQP5GEzJr45NrLlMJrWFbBtuk59ZHF/5RxXae4dzA0kRM5
	 bGkISB0pwfKOD+Jpb7Mhwdqti+kEKTvtiWGXn9T7tpo8efWCugwcV1dmLBjlnVG0a6LM4
	 L1piphoNzn2tgunhGaYLQMoGLH6lrOkkYoCseG0aSN3TK9JOnLJv4nWhRFoHa4lSUWCdA
	 27eDUIOx/3DP9RWryCjPSYmgUMLpp1ytZpG7hmovc792lRJ2Rg5zbjZQ6G1OqWISLdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QxShnM9e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B908606A320;
	Wed, 18 Nov 2026 22:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QxShnM9e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A271F000C4;
	Wed, 18 Nov 2026 22:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039362;
	bh=/+pDoiaLNaaBenvatZbAD2hbMTJgjFNHKORO7VRyyAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QxShnM9eDaADj9Jj6vuCu5owR1l8qvwXBNsfEt5W99R+VRKTVfxOTPTmGjorZTdOJ
	 f5i7n08HiMwVOH6mj1touozVjDzda0tnbLfBGj9GbDlYGzxZyGGgHm05MC8MaHpMp/
	 N1uKeTLzNPPzXKlGgSI1uBKJ00BfqeOnQeMJjf1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <zhangyi@everest-semi.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2073/3318] ASoC: codecs: ES8326: Solve error interruption issue
Date: Wed, 18 Nov 2026 15:44:55 +0100
Message-ID: <20261118150424.275541216@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <zhangyi@everest-semi.com>

[ Upstream commit 8a655cee6c9d4588570ad0cb099c5660f9a44a12 ]

We got an error report about headphone type detection and button detection.
We fixed the headphone type detection error by adjusting the debounce timer
configuration. And we fixed the button detection error by disabling the
button detection feature when the headphone are unplugged and enabling it
when headphone are plugged in.

Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
Link: https://msgid.link/r/20240402062043.20608-2-zhangyi@everest-semi.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 349e94679968 ("ASoC: es8326: report resume restore errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8326.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index b8c67b703b71a..11c86694be45c 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -640,6 +640,7 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 		regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x01);
 		regmap_write(es8326->regmap, ES8326_SYS_BIAS, 0x0a);
 		regmap_update_bits(es8326->regmap, ES8326_HP_DRIVER_REF, 0x0f, 0x03);
+		regmap_write(es8326->regmap, ES8326_INT_SOURCE, ES8326_INT_SRC_PIN9);
 		/*
 		 * Inverted HPJACK_POL bit to trigger one IRQ to double check HP Removal event
 		 */
@@ -662,6 +663,8 @@ static void es8326_jack_detect_handler(struct work_struct *work)
 			 * set auto-check mode, then restart jack_detect_work after 100ms.
 			 * Don't report jack status.
 			 */
+			regmap_write(es8326->regmap, ES8326_INT_SOURCE,
+					(ES8326_INT_SRC_PIN9 | ES8326_INT_SRC_BUTTON));
 			regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x01);
 			es8326_enable_micbias(es8326->component);
 			usleep_range(50000, 70000);
@@ -784,7 +787,7 @@ static int es8326_resume(struct snd_soc_component *component)
 	regmap_write(es8326->regmap, ES8326_VMIDSEL, 0x0E);
 	regmap_write(es8326->regmap, ES8326_ANA_LP, 0xf0);
 	usleep_range(10000, 15000);
-	regmap_write(es8326->regmap, ES8326_HPJACK_TIMER, 0xe9);
+	regmap_write(es8326->regmap, ES8326_HPJACK_TIMER, 0xd9);
 	regmap_write(es8326->regmap, ES8326_ANA_MICBIAS, 0xcb);
 	/* set headphone default type and detect pin */
 	regmap_write(es8326->regmap, ES8326_HPDET_TYPE, 0x83);
@@ -833,8 +836,7 @@ static int es8326_resume(struct snd_soc_component *component)
 	es8326_enable_micbias(es8326->component);
 	usleep_range(50000, 70000);
 	regmap_update_bits(es8326->regmap, ES8326_HPDET_TYPE, 0x03, 0x00);
-	regmap_write(es8326->regmap, ES8326_INT_SOURCE,
-		    (ES8326_INT_SRC_PIN9 | ES8326_INT_SRC_BUTTON));
+	regmap_write(es8326->regmap, ES8326_INT_SOURCE, ES8326_INT_SRC_PIN9);
 	regmap_write(es8326->regmap, ES8326_INTOUT_IO,
 		     es8326->interrupt_clk);
 	regmap_write(es8326->regmap, ES8326_SDINOUT1_IO,
-- 
2.53.0



