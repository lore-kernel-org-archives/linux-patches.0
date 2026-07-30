Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103D2419304;
	Thu, 30 Jul 2026 14:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423573; cv=none; b=k9Is/z7xDQbxOCHAuG04rxBaFhT+n3glhO1QhFZLCz5qqxdGD9ipzrMaY7jgh2dieyvb458+o8SWk+m6PQvH+QQSf5y4c3ovNomxtcp40bPrlAtY5omAGtF3bj0IcP1+DJneZ+LO5J+GMHJ5z28bLCNOX9QviKcon7k/PcL3498=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423573; c=relaxed/simple;
	bh=bRDFNKigVOlbS8cErcCccFySOC2SVEfK2NGIjiQZIjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evkxI1fbLRPyoo/PcfKXLSA2lb3Czst8bvokebO8Ty34AxhJx7gZOicou4ea9RsHktg5ktEFMUxG9Ihfk/ZPQh68efYq+cgzVs2J4WMxVwFQrbvylICR/fwYyTZImO7hkPedDResg0rvYQbN78CO8h4Oulqm9Xo/VJcLfxYCFnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xHUK9x1D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xHUK9x1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C8C1F000E9;
	Thu, 30 Jul 2026 14:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423572;
	bh=Dlt8404JQBuv293z36IQ+p8woG7wYS6O9mZQZ6r0fHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xHUK9x1DTDKaPBaig7x921Xt8Sh3gaf4YiDtgM7ZFzpKC7t7/AkxeaGkkhxqjQ6WM
	 C0Axj3oaBGZhxmpUSrm7jruuv0J0G+tsszWlZ8vK8wsnIyHbpui64w/Lq8J9vsgnU0
	 k3WzQfNOvR4UZzBM3ZtBk9lXo6YGTwLHhKro1o4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 092/675] ASoC: cs42l43: Correct report for forced microphone jack
Date: Thu, 30 Jul 2026 16:07:02 +0200
Message-ID: <20260730141447.084404804@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ecba6c79523840..36fb67059e0652 100644
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



