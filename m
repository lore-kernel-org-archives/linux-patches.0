Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA8921D5A9;
	Tue,  6 May 2025 21:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567341; cv=none; b=FGzdo5XxVs06zAvtUKe6eZfNnEck3SY/tPJh/FY54qOjqq5lu8/QM/ifvVVNrbN6DFQYxlQbOkroOGhjRocMTVZ623kjFfai9OknMS2B5bf1Oxew4TxNsNjGrgSZRDGjWu+nl+vhUXc6lK5OjiMTLJci4GqZvjKLl+szK/1Zm84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567341; c=relaxed/simple;
	bh=qtcQFSC+YGhfA1ZQ+dS8uOjrvupTpv/vX1S9klX3OY8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=egOyYTxe82v968BbFn+VUQhoj8FfLI7yWRwAb9lgejQcD3QAhYnb1WDZ4Hem9ZFX1Als9YwMDI6r+MXEnuU0frrEvlE4ylajqzL0tjG9HxBw9KBjC4hSFJI4Vx7esmp8n1l18EIcPOYlTPV1jA/IfO/44fENuDY5/NadumbaBpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eRn+/IfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eRn+/IfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F50C4CEEF;
	Tue,  6 May 2025 21:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567340;
	bh=qtcQFSC+YGhfA1ZQ+dS8uOjrvupTpv/vX1S9klX3OY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRn+/IfGK5BYHN7rw/A18A3Y3sL0vpdnJkdyU9INx1TQoBBM3VvvPHIHNRZt4/oCQ
	 Ca2WTAQQsrsg2t20yMcsbW+YbBAfgEfvvLBtKE4bDSXURarN8F+gO8Joppyfe/ufo7
	 MC3DjGbfoU+k+bKleQ/JOJpQsKmQyK0CE+th4eiSug9CDvxAsM6i2PY0mFMWmix4GK
	 kAkBy8x7en8j6gXUsPXkTzSieSZlK4kHHoZts2NvlVPvgxUjQOHxw4IMGxZPVcKaCI
	 xokpZCB9yYdvIvDS8TMyiqjWG9lQlqlHmhibBFQjsW9renCXj62ug8owoXj4y4BPin
	 3bsIFod+YIysA==
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
Subject: [PATCH AUTOSEL 6.14 08/20] ASoC: cs42l43: Disable headphone clamps during type detection
Date: Tue,  6 May 2025 17:35:11 -0400
Message-Id: <20250506213523.2982756-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213523.2982756-1-sashal@kernel.org>
References: <20250506213523.2982756-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
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
index 20e6ab6f0d4ad..6165ac16c3a95 100644
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

