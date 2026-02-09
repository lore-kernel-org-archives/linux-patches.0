Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBEA3019CB;
	Mon,  9 Feb 2026 12:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770640061; cv=none; b=FoUODheWiRCR8+dAIBnvn51Bxtgz/2z71wSAGoWMGegMZFE4675JHP4Pbrykb2jEtifCcp4UYBR85SQvMNc4CcORTqWzOgksjNSG5nmoq12AonRE+YhkJWTzQthXWZ4TNcK25uzSZGIp/Wn2AVuyXrloOrWpspxVo4+8TY0W+5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770640061; c=relaxed/simple;
	bh=hLs9OLJDEPbxFuGB2sd94CU5PFLTgqmQPHiFlsGsbP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ec4tFW/PARR/5TWtdLF0tCPa6DbNWGtOT5fXkxBUIQEX5ogBAVnXEyJluN14oMSTrKFkftJyUWbGaTRkC7idXH45Qc0I7PjxQyriquVKyOrJfVCe0XoTMnv8K4TeqTaE6Z1DTRTrcwswrL5C3A/gtEEyRH1MhHwwt81OdgVR9Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ng6MLnKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ng6MLnKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F4CC16AAE;
	Mon,  9 Feb 2026 12:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770640061;
	bh=hLs9OLJDEPbxFuGB2sd94CU5PFLTgqmQPHiFlsGsbP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ng6MLnKfIUJt+mBp7jKM23KrSiyN/CJ8XKdmSpPZLGMi/uB/BA8cCeg+Nd5MOu2IY
	 moMu47aypn1MPJoWPPPQGKEFYegTWAilEahQ0qIeIjomaniUIV6HqgwYqKuvn94TCR
	 dy5mZwYuA6MlNg9XQdyvxtsxgb7/0YPgu73O4PwzQRAjrkANve68TQrRnH867fMWfD
	 ep/Y9Qtb4+JVoT6kWGCHBtOIj1BQ5JxpXxrkJ7mKDYAv/HI7PadjGhltu2N9AUB7cE
	 Qqw1exuGuo4umB+GOKdWcKs9SD64FIRw+GJ9Im2IinY0zLmzdv4DygTTvWPdWF3D/8
	 b3rmh4b8O8egA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	david.rhodes@cirrus.com,
	rf@opensource.cirrus.com,
	linux-sound@vger.kernel.org,
	patches@opensource.cirrus.com
Subject: [PATCH AUTOSEL 6.18-6.6] ASoC: cs42l43: Correct handling of 3-pole jack load detection
Date: Mon,  9 Feb 2026 07:26:53 -0500
Message-ID: <20260209122714.1037915-14-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260209122714.1037915-1-sashal@kernel.org>
References: <20260209122714.1037915-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit e77a4081d7e324dfa876a9560b2a78969446ba82 ]

The load detection process for 3-pole jacks requires slightly
updated reference values to ensure an accurate result. Update
the code to apply different tunings for the 3-pole and 4-pole
cases. This also updates the thresholds overall so update the
relevant comments to match.

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260130150927.2964664-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The driver was added in August 2023 (likely kernel 6.6 or 6.7
timeframe), so it exists in recent stable trees.

### User Impact Assessment

- **Who is affected**: Users with CS42L43 audio codec hardware (Cirrus
  Logic codec, likely found in laptops/tablets)
- **Symptom**: Headphones could be misdetected as line-out, resulting in
  incorrect audio output behavior
- **Severity**: MEDIUM — not a crash, but audio malfunction that
  directly impacts user experience
- **Vendor fix**: From Cirrus Logic themselves, high confidence in
  correctness

### Risk vs. Benefit

- **Benefit**: Correct headphone/line-out detection for CS42L43 users,
  especially for 3-pole jacks
- **Risk**: Very low — codec-specific, vendor-provided values, only
  affects this hardware
- **Backport complexity**: The patch is self-contained;
  `regmap_multi_reg_write_bypassed()` already exists in stable trees

### Conclusion

This is a vendor-provided hardware tuning fix from Cirrus Logic that
corrects jack detection behavior on their CS42L43 codec. It fixes real-
world audio misdetection where headphones are wrongly classified as
line-out. The fix is contained to a single codec driver, uses existing
kernel APIs, and comes directly from the hardware vendor with
authoritative knowledge of the correct register values. It's analogous
to a hardware quirk — different tuning values needed for different jack
types.

The change is small, well-scoped, low-risk, and fixes a user-visible bug
(incorrect jack type detection).

**YES**

 sound/soc/codecs/cs42l43-jack.c | 37 +++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/cs42l43-jack.c b/sound/soc/codecs/cs42l43-jack.c
index 867e23d4fb8d8..744488f371ea4 100644
--- a/sound/soc/codecs/cs42l43-jack.c
+++ b/sound/soc/codecs/cs42l43-jack.c
@@ -496,7 +496,23 @@ void cs42l43_bias_sense_timeout(struct work_struct *work)
 	pm_runtime_put_autosuspend(priv->dev);
 }
 
-static void cs42l43_start_load_detect(struct cs42l43_codec *priv)
+static const struct reg_sequence cs42l43_3pole_patch[] = {
+	{ 0x4000,	0x00000055 },
+	{ 0x4000,	0x000000AA },
+	{ 0x17420,	0x8500F300 },
+	{ 0x17424,	0x36003E00 },
+	{ 0x4000,	0x00000000 },
+};
+
+static const struct reg_sequence cs42l43_4pole_patch[] = {
+	{ 0x4000,	0x00000055 },
+	{ 0x4000,	0x000000AA },
+	{ 0x17420,	0x7800E600 },
+	{ 0x17424,	0x36003800 },
+	{ 0x4000,	0x00000000 },
+};
+
+static void cs42l43_start_load_detect(struct cs42l43_codec *priv, bool mic)
 {
 	struct cs42l43 *cs42l43 = priv->core;
 
@@ -520,6 +536,15 @@ static void cs42l43_start_load_detect(struct cs42l43_codec *priv)
 			dev_err(priv->dev, "Load detect HP power down timed out\n");
 	}
 
+	if (mic)
+		regmap_multi_reg_write_bypassed(cs42l43->regmap,
+						cs42l43_4pole_patch,
+						ARRAY_SIZE(cs42l43_4pole_patch));
+	else
+		regmap_multi_reg_write_bypassed(cs42l43->regmap,
+						cs42l43_3pole_patch,
+						ARRAY_SIZE(cs42l43_3pole_patch));
+
 	regmap_update_bits(cs42l43->regmap, CS42L43_BLOCK_EN3,
 			   CS42L43_ADC1_EN_MASK | CS42L43_ADC2_EN_MASK, 0);
 	regmap_update_bits(cs42l43->regmap, CS42L43_DACCNFG2, CS42L43_HP_HPF_EN_MASK, 0);
@@ -598,7 +623,7 @@ static int cs42l43_run_load_detect(struct cs42l43_codec *priv, bool mic)
 
 	reinit_completion(&priv->load_detect);
 
-	cs42l43_start_load_detect(priv);
+	cs42l43_start_load_detect(priv, mic);
 	time_left = wait_for_completion_timeout(&priv->load_detect,
 						msecs_to_jiffies(CS42L43_LOAD_TIMEOUT_MS));
 	cs42l43_stop_load_detect(priv);
@@ -622,11 +647,11 @@ static int cs42l43_run_load_detect(struct cs42l43_codec *priv, bool mic)
 	}
 
 	switch (val & CS42L43_AMP3_RES_DET_MASK) {
-	case 0x0: // low impedance
-	case 0x1: // high impedance
+	case 0x0: // < 22 Ohm impedance
+	case 0x1: // < 150 Ohm impedance
+	case 0x2: // < 1000 Ohm impedance
 		return CS42L43_JACK_HEADPHONE;
-	case 0x2: // lineout
-	case 0x3: // Open circuit
+	case 0x3: // > 1000 Ohm impedance
 		return CS42L43_JACK_LINEOUT;
 	default:
 		return -EINVAL;
-- 
2.51.0

