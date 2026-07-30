Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC921431E60;
	Thu, 30 Jul 2026 15:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425462; cv=none; b=KAJ7dLq2+sGouAEXYkuoWvg5nECHPeGJ8bRNoDywLb1Gg2qeIrwYF2XaL/vUdYx6Y4T+p9T8bsSPOJMa9zDUUZUEe7JKJy0spjwBIRWDztiYvYi8+1MeeGFzsvpk8fiXsUSFLdhmUdOWrUhO3WJ60TQ3wnK56kfCOHEve8C49uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425462; c=relaxed/simple;
	bh=fZZaSg9XFrnzHY0/B/mu/T9AEAYzjXq3JANLW7FNcF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sj+ZWIxiHPuL2dU+P1UPLHAtSm5GV5pwAscSQ/8n3v82RUzoWAJCUKjO8ZpJlcvi8FuzakenPJxGQDQOyhilfIWP5dmhLFxkia1wq5MRa1nKc05IRvb0GpM/o+YFst6N611Z7Nah8+0v8hg4aTbcxTV7zxaTCz8wlLQK752wHFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5HMiZ/w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5HMiZ/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3420F1F000E9;
	Thu, 30 Jul 2026 15:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425460;
	bh=R3F7nY1eSX1RGeqyRAmCr0zLkWHgouMFpywC/QSx5Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5HMiZ/wYNZxK4bWQsq1zT++XlKbWduF3XmLTvtc4vhZ2xRobW/ftprjMHKtqcafa
	 daX1Wn/NhgcdOF7Porjf9Afq2/HVuU89fEdpR0hbui0ejklWodEM3KVursFXvuDX3l
	 YeehlBM1H9OxnB0t3tep62kceSKO42dLsWLvyz78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 076/602] ASoC: cs42l43: Correct report for forced microphone jack
Date: Thu, 30 Jul 2026 16:07:48 +0200
Message-ID: <20260730141437.594498156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3a61f222d85fee..57626db1140a2c 100644
--- a/sound/soc/codecs/cs42l43-jack.c
+++ b/sound/soc/codecs/cs42l43-jack.c
@@ -311,6 +311,7 @@ irqreturn_t cs42l43_bias_detect_clamp(int irq, void *data)
 #define CS42L43_JACK_ABSENT 0x0
 
 #define CS42L43_JACK_OPTICAL (SND_JACK_MECHANICAL | SND_JACK_AVOUT)
+#define CS42L43_JACK_MICROPHONE (SND_JACK_MECHANICAL | SND_JACK_MICROPHONE)
 #define CS42L43_JACK_HEADPHONE (SND_JACK_MECHANICAL | SND_JACK_HEADPHONE)
 #define CS42L43_JACK_HEADSET (SND_JACK_MECHANICAL | SND_JACK_HEADSET)
 #define CS42L43_JACK_LINEOUT (SND_JACK_MECHANICAL | SND_JACK_LINEOUT)
@@ -879,7 +880,7 @@ static const struct cs42l43_jack_override_mode {
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



