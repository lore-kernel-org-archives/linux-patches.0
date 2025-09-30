Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CC12264AB;
	Tue, 30 Sep 2025 14:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243887; cv=none; b=s0O7emXqqFfHtbojLHNmtLLoHfk1gngbet94oW5M9CF6ZrlKAOd3P+4LQIb5cK5FpdAYYWgE8HYXGr3uyE0TUUCJp37g3Y2Lh6SeluuZck2oYGnVo2Vs6iVta+DqIwW1ejlhbL/N9qPXgQ6opRhhpU8xhbNEDmSx5kosYkeDzDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243887; c=relaxed/simple;
	bh=M2rVmhsYe2/dBBjtDqcRY6+pZS1u5xPQSKPExZNh4NA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYwHxEuffsqm4oPfzv+eDzpLR5MLp6bVO2gsmpSseZ6qTzHnmEXEjEmj6CsvgCZRo3Hj1fZFO/3YODDPQFxy9W6cpHxx5h8tlYRYXIxmOV4rmuoAXqRyXA4Wp/tZ7MWixRg0fW+XRGc7hsIGQacgHVLftTVaIARpvMpWrcymYyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AK3+nvF7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AK3+nvF7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013EDC4CEF0;
	Tue, 30 Sep 2025 14:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243887;
	bh=M2rVmhsYe2/dBBjtDqcRY6+pZS1u5xPQSKPExZNh4NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AK3+nvF7KO5gndxUF7F+FY4hWomSsT01rq8jZPP0wmfrDTWelDRmAPxADV/QTgvmG
	 xoEG11I7LimtL9Qcsh4z2yrfswuUMhf9Jc6LThfzcrSdUk9pGcCJddO4I2to+f8KG1
	 Lw/NGqXGiKEjeomGm1Sz8kX/x0ml8+7dyCvPaPjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankur Tyagi <ankur.tyagi85@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 46/81] ASoC: wm8940: Correct typo in control name
Date: Tue, 30 Sep 2025 16:46:48 +0200
Message-ID: <20250930143821.605673304@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit b4799520dcd6fe1e14495cecbbe9975d847cd482 ]

Fixes: 0b5e92c5e020 ("ASoC WM8940 Driver")
Reported-by: Ankur Tyagi <ankur.tyagi85@gmail.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Tested-by: Ankur Tyagi <ankur.tyagi85@gmail.com>
Link: https://patch.msgid.link/20250821082639.1301453-3-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8940.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index c194fbde8ad6e..a02554b8edf71 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -218,7 +218,7 @@ static const struct snd_kcontrol_new wm8940_snd_controls[] = {
 	SOC_SINGLE_TLV("Digital Capture Volume", WM8940_ADCVOL,
 		       0, 255, 0, wm8940_adc_tlv),
 	SOC_ENUM("Mic Bias Level", wm8940_mic_bias_level_enum),
-	SOC_SINGLE_TLV("Capture Boost Volue", WM8940_ADCBOOST,
+	SOC_SINGLE_TLV("Capture Boost Volume", WM8940_ADCBOOST,
 		       8, 1, 0, wm8940_capture_boost_vol_tlv),
 	SOC_SINGLE_TLV("Speaker Playback Volume", WM8940_SPKVOL,
 		       0, 63, 0, wm8940_spk_vol_tlv),
-- 
2.51.0



