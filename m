Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A292253F9;
	Tue,  6 May 2025 21:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567387; cv=none; b=NftRtYt9L79+MrkMzTmPgl4zqdNhq9J6WNvuiBOnbpZvPxTJ/IEnaXbCRpmbI9cxx64BE7ZkoyWGRffWEz/vrJp3LzMWr5QFVaa2CDmxFia/fTsL+UYeLvTiJbIX8AZc/cn13UUB8MxQ/Un3b/1gzNuPSRylaGkJkkE90XARqKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567387; c=relaxed/simple;
	bh=ZFS/cOA4uhmIrJCCoSmxVe1M1yiqzEf1zoliJJ66p7M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TyBMFOp2p2fKXQV7YfTGb7etgM/m6HVuUORoqKKnYyp0HMqnsVEoayE5KDab9gTIHsUCiMOWSDdvQ3NbyzX3fDsrs/Sm7I3xVtGr/ldC7sliouFFoa7pxKQkwH50ObhxNZaI2b/nufCFFSGVKuV8C24IJFYnDVFbafoGmsyOw7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ksmUbmWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ksmUbmWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDB0C4CEEF;
	Tue,  6 May 2025 21:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567386;
	bh=ZFS/cOA4uhmIrJCCoSmxVe1M1yiqzEf1zoliJJ66p7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ksmUbmWQxmoONDWIQ/Of+yjs8CoYG3+IE0nUIn5iN77g70HrTrswI4LCpoIwTa+2l
	 ZcTQ7QY/fA5y4chtYF/MG9aX4LBMdbr6oesI8WhP23bF2KaTSBhriAPsOFmfBMxDuI
	 XbWkhyF5vXdBJhRCakxJFr810O7ZSiFe5TGae3T8cau+0DtNHz/HKITFOPyxZ6JCDK
	 QIRG+NGm5s7EUsjF2Ub9DOrDpRXNeDCCtbSTZ0uGewPaF8Cc0HGnoPwx9J2REvIjfS
	 vRMoQZat6kbf7UAMEP0Tpy9i9tca8j9u0MTbT2FQovW/Bi5ffmZRnIDEyzhsMmMOEK
	 ckTu1OKg3/ybQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	david.rhodes@cirrus.com,
	rf@opensource.cirrus.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	patches@opensource.cirrus.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 08/18] ASoC: cs42l43: Disable headphone clamps during type detection
Date: Tue,  6 May 2025 17:36:00 -0400
Message-Id: <20250506213610.2983098-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213610.2983098-1-sashal@kernel.org>
References: <20250506213610.2983098-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.27
Content-Transfer-Encoding: 8bit

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 70ad2e6bd180f94be030aef56e59693e36d945f3 ]

The headphone clamps cause fairly loud pops during type detect
because they sink current from the detection process itself. Disable
the clamps whilst the type detect runs, to improve the detection
pop performance.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20250423090944.1504538-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l43-jack.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/codecs/cs42l43-jack.c b/sound/soc/codecs/cs42l43-jack.c
index 73d764fc85392..984a7f470a31f 100644
--- a/sound/soc/codecs/cs42l43-jack.c
+++ b/sound/soc/codecs/cs42l43-jack.c
@@ -654,6 +654,10 @@ static int cs42l43_run_type_detect(struct cs42l43_codec *priv)
 
 	reinit_completion(&priv->type_detect);
 
+	regmap_update_bits(cs42l43->regmap, CS42L43_STEREO_MIC_CLAMP_CTRL,
+			   CS42L43_SMIC_HPAMP_CLAMP_DIS_FRC_VAL_MASK,
+			   CS42L43_SMIC_HPAMP_CLAMP_DIS_FRC_VAL_MASK);
+
 	cs42l43_start_hs_bias(priv, true);
 	regmap_update_bits(cs42l43->regmap, CS42L43_HS2,
 			   CS42L43_HSDET_MODE_MASK, 0x3 << CS42L43_HSDET_MODE_SHIFT);
@@ -665,6 +669,9 @@ static int cs42l43_run_type_detect(struct cs42l43_codec *priv)
 			   CS42L43_HSDET_MODE_MASK, 0x2 << CS42L43_HSDET_MODE_SHIFT);
 	cs42l43_stop_hs_bias(priv);
 
+	regmap_update_bits(cs42l43->regmap, CS42L43_STEREO_MIC_CLAMP_CTRL,
+			   CS42L43_SMIC_HPAMP_CLAMP_DIS_FRC_VAL_MASK, 0);
+
 	if (!time_left)
 		return -ETIMEDOUT;
 
-- 
2.39.5

