Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7552E285C;
	Mon, 22 Sep 2025 19:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569770; cv=none; b=DB/vBtZXIs553illi9iTvfVXJQVy6uyqOaXNfPPaMRYEbpISUUQdSi2GAGHoD3TUl5DhTmfqV9RrtjH0VWuni9lH+8qIi7Xh0+lg/5y3+LMiF9204YQs690kCdfDnIL+9dDArE2gnHz715jqC7keb1VqY6pB6QAM5uKChRdgGNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569770; c=relaxed/simple;
	bh=JjM9vMMWmw7ibm6gnV/OXnghTDEb9zkBy6N4HoPolgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYMuhBvp/v/BZZoU/UkSK6GdEqG4I4YS83t07FJXb1OEUyBrHs2TUX7pWy2+pT1xJCVhTlBTEssdXZ8FOh4F3HiET9o9OeCRCbN13oh4wEg2rKVrauVO6W6FiWOO9SoA4RzbCbuJDLCp16msJ/MbpNtGdAW4bGtvuzS+8ylP10g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/1gkgsT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/1gkgsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D436EC4CEF0;
	Mon, 22 Sep 2025 19:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569770;
	bh=JjM9vMMWmw7ibm6gnV/OXnghTDEb9zkBy6N4HoPolgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/1gkgsTvpkHAuRVcxwtkdYnMkwmNlkXQC+Adt+oypeXjzImUmvKQgWKaUYL/8N6N
	 ikMWhL8+iptkquQRi7QEsRjL64dtb6VUoHCjB/AynAMm3PbKVQLO7tdOxh7VCpPgJ2
	 Uxl7Flc5bjF2DHAy8bGmcSTv6GLm/4DEEX6u+7mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ankur Tyagi <ankur.tyagi85@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 50/70] ASoC: wm8940: Correct typo in control name
Date: Mon, 22 Sep 2025 21:29:50 +0200
Message-ID: <20250922192405.952267245@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index eff7d1369d01a..39d2c8e85d9db 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -220,7 +220,7 @@ static const struct snd_kcontrol_new wm8940_snd_controls[] = {
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



