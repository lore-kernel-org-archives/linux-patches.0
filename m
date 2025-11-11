Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEA9343D66;
	Tue, 11 Nov 2025 01:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823558; cv=none; b=d4t9Us+j6rvwuDUHXKEr0kN6Gkcmg1hnyz7a55diw6IpYH0Z2r+ldevNpsRSfbjLnbuhMMva4QAccPU1udfxfT+Zz6TN3KSTBVza6/2WgDpr9SgXiRXMpT2h71xYS1Xtt6gLvWruLKLCTVkYk0lNpOaNis0Ezq0SZwjbg8GTB3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823558; c=relaxed/simple;
	bh=FByFioaCLrMoqtCg/JOlzi+S/zs+/3ZkBeCQbJUYHmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9F7mA01ySy9yoY+USmYv0GMHwQXc4XhRFqFn5sCrBKM54/dpThY4dNxiyPKeMGKwGnuc5R0jAewRdHptDYcqBbNCBdNRoMGnc5yQS8nI1iFkt7a32gEIufMTYd0wnzkJWmiAcwZGh0cNECkWnvLINtvvyw/0wEMJ+/hOkTAP3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8Llrs/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8Llrs/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E15AC4AF09;
	Tue, 11 Nov 2025 01:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823557;
	bh=FByFioaCLrMoqtCg/JOlzi+S/zs+/3ZkBeCQbJUYHmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8Llrs/a2lzBmjqZB/EaN6HeKOV10yz67CxzcG0iD4QHXggcLtQBMrSNeQSZ1/64X
	 I6tXfsD2O4eSORhEvxCWiqjjaA25pctWznhNwcZIXrDCpKYusyXOwLHildObvp1t/e
	 jpHC190HzCoW1FH7hKe4Ysw7jZ3XeK87AcoYmCHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shimrra Shai <shimrrashai@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 323/849] ASoC: es8323: add proper left/right mixer controls via DAPM
Date: Tue, 11 Nov 2025 09:38:13 +0900
Message-ID: <20251111004544.226194401@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shimrra Shai <shimrrashai@gmail.com>

[ Upstream commit 7e39ca4056d11fef6b90aedd9eeeb3e070d3ce9f ]

Add proper DAC and mixer controls to DAPM; no initialization in
es8323_probe.

Signed-off-by: Shimrra Shai <shimrrashai@gmail.com>
Link: https://patch.msgid.link/20250815042023.115485-3-shimrrashai@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8323.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/es8323.c b/sound/soc/codecs/es8323.c
index 4c15fffda733c..eb85b71e87f39 100644
--- a/sound/soc/codecs/es8323.c
+++ b/sound/soc/codecs/es8323.c
@@ -182,13 +182,13 @@ static const struct snd_kcontrol_new es8323_mono_adc_mux_controls =
 
 /* Left Mixer */
 static const struct snd_kcontrol_new es8323_left_mixer_controls[] = {
-	SOC_DAPM_SINGLE("Left Playback Switch", SND_SOC_NOPM, 7, 1, 1),
+	SOC_DAPM_SINGLE("Left Playback Switch", ES8323_DACCONTROL17, 7, 1, 0),
 	SOC_DAPM_SINGLE("Left Bypass Switch", ES8323_DACCONTROL17, 6, 1, 0),
 };
 
 /* Right Mixer */
 static const struct snd_kcontrol_new es8323_right_mixer_controls[] = {
-	SOC_DAPM_SINGLE("Right Playback Switch", SND_SOC_NOPM, 6, 1, 1),
+	SOC_DAPM_SINGLE("Right Playback Switch", ES8323_DACCONTROL20, 7, 1, 0),
 	SOC_DAPM_SINGLE("Right Bypass Switch", ES8323_DACCONTROL20, 6, 1, 0),
 };
 
-- 
2.51.0



