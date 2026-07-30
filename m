Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E534643D510;
	Thu, 30 Jul 2026 14:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421481; cv=none; b=CQjz6o1n2je1n72HivvAMiatjCCTfNXMJILKUDahVzpia6AdoVcEeDq1JAjyb+A5zQsud4i+JJlpzZI1ulWpBIAMRdwk3Mm8+FjD98ObuH89pM5O86uIju1/AA5fpExoSOCz1a1qRedVN2mc1okzH9wVjDGyfVwg5PL8N2X+j8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421481; c=relaxed/simple;
	bh=Bb8PEJdFIEm2aO7G1pHz4b/vBspixolUpsqizYjO0WA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBMyNWyz1riGjY0XLQMsJXFrUHnENfNOFa9IUZ/pBvct8C3L7wQXuBw1yYnTjgMxLu78vjbKsPLWuj5nRQUEjWL3xTMppc7w/uA7e1ppbBzb3OSojkBe2ePQEvmMj8Y12LYMiOekIzYJ5+w7ESicch0NPtB4hH08aPcvPAAdS4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JKT1o5E+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JKT1o5E+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F781F000E9;
	Thu, 30 Jul 2026 14:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421480;
	bh=7C7i4V0UK/xeuSFrxtWbNpUy2Y3NGsNhXooTUODpnhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JKT1o5E+FuXlyJMUWZnS7FB9uhUP5ho+Z1K+1joUtODTNsjxwdwq7f0ZCvXDeVVmg
	 SKLiu7WHktZZ8EMR+yOqDcryZPlo2VxiMjv17lkABSL0rO6jd88oYAz2UKC6Yc7VEj
	 Xt95dKuj3ou8r04AWst1ByzKFZYccaIYo0w8kurQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 081/744] ASoC: cs42l43: Correct report for forced microphone jack
Date: Thu, 30 Jul 2026 16:05:54 +0200
Message-ID: <20260730141445.993271502@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit f74e6e15485b68b92b2807071e822db6309b7e38 ]

Currently if the jack is forced to the microphone mode, it will report
as line in. Correct the report to microphone.

Fixes: fc918cbe874e ("ASoC: cs42l43: Add support for the cs42l43")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260708103430.1395207-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l43-jack.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l43-jack.c b/sound/soc/codecs/cs42l43-jack.c
index 3e04e6897b1423..e88109979c1831 100644
--- a/sound/soc/codecs/cs42l43-jack.c
+++ b/sound/soc/codecs/cs42l43-jack.c
@@ -310,6 +310,7 @@ irqreturn_t cs42l43_bias_detect_clamp(int irq, void *data)
 #define CS42L43_JACK_ABSENT 0x0
 
 #define CS42L43_JACK_OPTICAL (SND_JACK_MECHANICAL | SND_JACK_AVOUT)
+#define CS42L43_JACK_MICROPHONE (SND_JACK_MECHANICAL | SND_JACK_MICROPHONE)
 #define CS42L43_JACK_HEADPHONE (SND_JACK_MECHANICAL | SND_JACK_HEADPHONE)
 #define CS42L43_JACK_HEADSET (SND_JACK_MECHANICAL | SND_JACK_HEADSET)
 #define CS42L43_JACK_LINEOUT (SND_JACK_MECHANICAL | SND_JACK_LINEOUT)
@@ -871,7 +872,7 @@ static const struct cs42l43_jack_override_mode {
 		.hsdet_mode = CS42L43_JACK_3_POLE_SWITCHES,
 		.mic_ctrl = (0x3 << CS42L43_JACK_STEREO_CONFIG_SHIFT) |
 			    CS42L43_HS1_BIAS_EN_MASK | CS42L43_HS2_BIAS_EN_MASK,
-		.report = CS42L43_JACK_LINEIN,
+		.report = CS42L43_JACK_MICROPHONE,
 	},
 	[CS42L43_JACK_RAW_OPTICAL] = {
 		.hsdet_mode = CS42L43_JACK_3_POLE_SWITCHES,
-- 
2.53.0



