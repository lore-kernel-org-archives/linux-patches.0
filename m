Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3583090CB;
	Sat, 25 Oct 2025 16:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409447; cv=none; b=FB3H+l7K9oniuiH/CvKudLqKh9p4mCGHKYSKmPVXXnAaaNk+kwiS8bKxDoO6VviqKOXh1H/RaCIVDfh8nJOzCabbVUroui0D98iiLDNebT6t3PmAiZD6q3uJ872XbovnU28BynLGyINDdkoUupK71qJzZeZnr2zADUcKRHY08FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409447; c=relaxed/simple;
	bh=4VBQPx28R3pgimV/LhJio69BjI6W2zNU70EflQKyOgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CsXVK+QxJQwV5vzbZVfvL2zq55AVOg7QaE1Mjb8k+eMVZ8JfrKKWPVZUw0Jma1T+2BDxvwC/mwUzdilri7m5v8gFkg+jYaO0Xp3ihh5wpP0EAzjBhhuclspfLrMPnzOZs56lO15lgOr21RMAjIk2R6/DcjIjhKnCEA3S4w99vsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P53u/NAM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P53u/NAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FFCC4CEF5;
	Sat, 25 Oct 2025 16:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409447;
	bh=4VBQPx28R3pgimV/LhJio69BjI6W2zNU70EflQKyOgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P53u/NAMvn9xKFH+QbW3MxMHgeQZxi+Cqao310mqmq0lHZA9UiQZtoKnvuXSAOW0c
	 rlCRxdkFAKxnc96RO+BshVQo7RpzDcvtMgE3MXRK7PHoemcatwz4Tnj2ZqzknDRMx7
	 zQlaUO6nIDk4dVePfAOP2tvnjPTSB3cAf2EWlQm0CUBSUD27m4GWcPl2ES0jRFi4At
	 b9NV74CvJQb+NQgNb8R1Z/z0Za3gugQICuPcbuFfelkJb++cnP3wCcUL9weyKozF2E
	 hKkZgFBS0Xh1dyzo4I0TLqGf1BeMMYqZ6bser1xfp5Xshg+nA4abohflL5Pi0NGdJs
	 Q7u7dal4yE0jQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shimrra Shai <shimrrashai@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com,
	u.kleine-koenig@baylibre.com
Subject: [PATCH AUTOSEL 6.17] ASoC: es8323: enable DAPM power widgets for playback DAC and output
Date: Sat, 25 Oct 2025 11:59:20 -0400
Message-ID: <20251025160905.3857885-329-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shimrra Shai <shimrrashai@gmail.com>

[ Upstream commit 258384d8ce365dddd6c5c15204de8ccd53a7ab0a ]

Enable DAPM widgets for power and volume control of playback.

Signed-off-by: Shimrra Shai <shimrrashai@gmail.com>
Link: https://patch.msgid.link/20250814014919.87170-1-shimrrashai@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Why this is a bug fix
- Previously the playback DACs and output amps were declared as DAPM
  widgets without a backing power register, so DAPM could not actually
  power them on/off. This can cause silent playback (if hardware
  defaults to powered-down) or excess power consumption/pops (if left
  always-on).
- The change wires those DAPM widgets to the codec’s DAC power register
  with correct bit polarity, so the hardware is powered in sync with the
  DAPM graph during stream start/stop and routing changes. This is
  functional correctness, not a new feature.

What changed (specific code references)
- Binds DAC widgets to the DAC power register:
  - sound/soc/codecs/es8323.c:194
    - Right DAC: `SND_SOC_DAPM_DAC(..., ES8323_DACPOWER, 6, 1)` (was
      `SND_SOC_NOPM`)
    - Left DAC: `SND_SOC_DAPM_DAC(..., ES8323_DACPOWER, 7, 1)` (was
      `SND_SOC_NOPM`)
  - The `invert=1` indicates those bits are power-down bits in hardware
    (1 = off), so DAPM will clear them when enabling.
- Binds output amplifier PGAs to the same DAC power register:
  - sound/soc/codecs/es8323.c:194
    - Right Out 2: `SND_SOC_DAPM_PGA(..., ES8323_DACPOWER, 2, 0)` (was
      `SND_SOC_NOPM`)
    - Left Out 2: `SND_SOC_DAPM_PGA(..., ES8323_DACPOWER, 3, 0)` (was
      `SND_SOC_NOPM`)
    - Right Out 1: `SND_SOC_DAPM_PGA(..., ES8323_DACPOWER, 4, 0)` (was
      `SND_SOC_NOPM`)
    - Left Out 1: `SND_SOC_DAPM_PGA(..., ES8323_DACPOWER, 5, 0)` (was
      `SND_SOC_NOPM`)
  - The `invert=0` indicates those bits are enable bits (1 = on).
- ADC side and mic bias remain unchanged; only playback path power
  control is corrected.

Why it fits stable backport criteria
- Fixes an important, user-visible functional issue: playback path may
  not power up reliably without these bindings, leading to no audio or
  erratic power behavior.
- Small and tightly scoped: affects only `sound/soc/codecs/es8323.c`
  DAPM widget definitions; no API/ABI or architectural changes.
- Low regression risk: aligns with ASoC/DAPM design where power bits are
  owned by DAPM. Similar fixes have been applied across other codecs
  (e.g., ES83xx/ES8316 families) and routinely backported.
- No security or behavioral changes outside this codec; no dependency on
  DT/Kconfig; uses existing register define `ES8323_DACPOWER` and
  established DAPM patterns.

Potential side effects and why acceptable
- If any out-of-band code previously toggled `ES8323_DACPOWER`, DAPM
  will now own those bits. This generally removes races and produces
  correct sequencing. Minor changes in pop/click characteristics are
  possible but usually improved by proper DAPM gating.
- No new controls, no user-visible mixer name changes; only the power
  lifecycle is corrected.

Backport considerations
- The change is mechanical and compile-time obvious. Ensure the target
  stable branch’s `es8323.c` already defines `ES8323_DACPOWER` with the
  same bit layout (very likely). If not, a trivial definition addition
  would be needed in that branch.
- No additional follow-ups appear required for this specific wiring; if
  later upstream commits tweak routing or invert bits for ES8323,
  consider them if reports of polarity mismatch arise on older branches.

Conclusion
- This is a classic DAPM power hookup fix for a specific codec. It
  corrects functional behavior with minimal, contained changes, and is
  safe to backport to stable trees.

 sound/soc/codecs/es8323.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/es8323.c b/sound/soc/codecs/es8323.c
index a9822998199fb..70d348ff3b437 100644
--- a/sound/soc/codecs/es8323.c
+++ b/sound/soc/codecs/es8323.c
@@ -211,8 +211,8 @@ static const struct snd_soc_dapm_widget es8323_dapm_widgets[] = {
 
 	SND_SOC_DAPM_ADC("Right ADC", "Right Capture", SND_SOC_NOPM, 4, 1),
 	SND_SOC_DAPM_ADC("Left ADC", "Left Capture", SND_SOC_NOPM, 5, 1),
-	SND_SOC_DAPM_DAC("Right DAC", "Right Playback", SND_SOC_NOPM, 6, 1),
-	SND_SOC_DAPM_DAC("Left DAC", "Left Playback", SND_SOC_NOPM, 7, 1),
+	SND_SOC_DAPM_DAC("Right DAC", "Right Playback", ES8323_DACPOWER, 6, 1),
+	SND_SOC_DAPM_DAC("Left DAC", "Left Playback", ES8323_DACPOWER, 7, 1),
 
 	SND_SOC_DAPM_MIXER("Left Mixer", SND_SOC_NOPM, 0, 0,
 			   &es8323_left_mixer_controls[0],
@@ -223,10 +223,10 @@ static const struct snd_soc_dapm_widget es8323_dapm_widgets[] = {
 
 	SND_SOC_DAPM_PGA("Right ADC Power", SND_SOC_NOPM, 6, 1, NULL, 0),
 	SND_SOC_DAPM_PGA("Left ADC Power", SND_SOC_NOPM, 7, 1, NULL, 0),
-	SND_SOC_DAPM_PGA("Right Out 2", SND_SOC_NOPM, 2, 0, NULL, 0),
-	SND_SOC_DAPM_PGA("Left Out 2", SND_SOC_NOPM, 3, 0, NULL, 0),
-	SND_SOC_DAPM_PGA("Right Out 1", SND_SOC_NOPM, 4, 0, NULL, 0),
-	SND_SOC_DAPM_PGA("Left Out 1", SND_SOC_NOPM, 5, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("Right Out 2", ES8323_DACPOWER, 2, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("Left Out 2", ES8323_DACPOWER, 3, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("Right Out 1", ES8323_DACPOWER, 4, 0, NULL, 0),
+	SND_SOC_DAPM_PGA("Left Out 1", ES8323_DACPOWER, 5, 0, NULL, 0),
 	SND_SOC_DAPM_PGA("LAMP", ES8323_ADCCONTROL1, 4, 0, NULL, 0),
 	SND_SOC_DAPM_PGA("RAMP", ES8323_ADCCONTROL1, 0, 0, NULL, 0),
 
-- 
2.51.0

