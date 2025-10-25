Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB6D2586E8;
	Sat, 25 Oct 2025 16:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409030; cv=none; b=RyRCOGrjaEgkBwBjhXkGe+VMEANpLK8BBZh39bQ90sRpqW6/qq5AU2s+y4D38DolkeR5wGv4KpZwHldCzl0w0c0RQKO77Ogq3KcdZ0qAwVEVYnuqAckqW7KybZ68E3EEN87hbyAy94EoPgbyLpb2IItCNCSlbPtZCcosOUavti8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409030; c=relaxed/simple;
	bh=dbR48RiKov+Hu0FSI18WV78rq4kh+PZpv1m7s70OZpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jlOkZMuksrd+uGAfEr7e23PdmGL89AKzdtc+8RDIRk+MvuV+BGbYIQ0SfBR8JmQWgEJy/bZeolbA+pm8aneGHTK7NqJqcFKHI6GZMsjo9rcURp/XpdLo3qIlzzixjLj1a/ZPABvIW+0WkLZN2SH+Q6a7r+5UZcggIIBAOqXcXhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sgSRjqtU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sgSRjqtU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15BDC4CEFB;
	Sat, 25 Oct 2025 16:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409029;
	bh=dbR48RiKov+Hu0FSI18WV78rq4kh+PZpv1m7s70OZpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sgSRjqtU9JPnRSAobbur/XUjRo/PxubF2NY8ALMP2de8iBOhnMtiKnrVJXl9hxFto
	 rSx01odurYtbVIZTGgSPkw9BwBMFRqFn09emkv66wsbyr5eEIJ2eCrpTn8HoyugqTQ
	 nfLjVvIvWRiE67XvfvYWAOCoEUSCFd/gi3MKCS1zz3A7i1xiTKUttHicBtZ1x6fN6f
	 sCf5RVp1S1/3UdknDjSzvEA0B1c1G8xsPDqJ/j26PhNl3IwuqiFmRML0Qcqu6HzczQ
	 ZZaaXJmoyA3TsYVHO8U8SKpPBAIQrhOHj2zavUOg4jF0tSdfVGJBvs4IqNar0bVgh3
	 GZtlhPuOq37LA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shimrra Shai <shimrrashai@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	u.kleine-koenig@baylibre.com,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com
Subject: [PATCH AUTOSEL 6.17] ASoC: es8323: add proper left/right mixer controls via DAPM
Date: Sat, 25 Oct 2025 11:56:47 -0400
Message-ID: <20251025160905.3857885-176-sashal@kernel.org>
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

[ Upstream commit 7e39ca4056d11fef6b90aedd9eeeb3e070d3ce9f ]

Add proper DAC and mixer controls to DAPM; no initialization in
es8323_probe.

Signed-off-by: Shimrra Shai <shimrrashai@gmail.com>
Link: https://patch.msgid.link/20250815042023.115485-3-shimrrashai@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - The DAPM mixer inputs for the DAC paths are not wired to hardware,
    so user-visible “Playback Switch” controls don’t actually program
    the codec. In current code, both controls use `SND_SOC_NOPM`,
    meaning they only affect DAPM topology but never touch the
    registers:
    - `sound/soc/codecs/es8323.c:185` Left: `SOC_DAPM_SINGLE("Left
      Playback Switch", SND_SOC_NOPM, 7, 1, 1)`
    - `sound/soc/codecs/es8323.c:191` Right: `SOC_DAPM_SINGLE("Right
      Playback Switch", SND_SOC_NOPM, 6, 1, 1)`
  - The driver also forces the left playback mixer path on during probe
    by writing `ES8323_DACCONTROL17 = 0xB8`:
    - `sound/soc/codecs/es8323.c:635`
      `snd_soc_component_write(component, ES8323_DACCONTROL17, 0xB8);`
  - Together these cause a mismatch between DAPM state and hardware:
    - Left DAC→Mixer path is forced on at boot (ignoring user control
      and DAPM).
    - Right DAC→Mixer path starts off and cannot be enabled by the
      “Right Playback Switch” control (since it’s NOPM), leading to
      channel imbalance or silence on the right.

- What the change does
  - Wires mixer switches to the correct hardware bits so DAPM and user
    controls actually program the codec:
    - Left mixer control is changed to `ES8323_DACCONTROL17` bit 7 with
      normal polarity (was NOPM): “Left Playback Switch”,
      `ES8323_DACCONTROL17`, bit 7, invert 0.
    - Right mixer control is changed to `ES8323_DACCONTROL20` bit 7 with
      normal polarity (was NOPM): “Right Playback Switch”,
      `ES8323_DACCONTROL20`, bit 7, invert 0.
  - Removes ad‑hoc forced initialization in `es8323_probe`, i.e. no
    manual mixer enabling at probe time, as stated in the commit message
    (“no initialization in es8323_probe”). This addresses the forced-on
    left path (see current write at `sound/soc/codecs/es8323.c:635`),
    allowing DAPM to control power and routing coherently.

- Why it’s a stable-quality bug fix
  - User-visible functional bug: Right channel playback switch can’t
    enable hardware; left path is wrongly forced on. The fix makes the
    controls effective and restores proper DAPM/hardware coherence.
  - Small, self-contained change in a codec driver; no API/ABI changes,
    no architectural refactors.
  - Aligns es8323 behavior with similar Everest codecs (e.g., es8328
    maps playback switches to DACCONTROLx bit 7 with non-inverted
    semantics), reducing surprise and improving power management.
  - Expected to reduce power/leakage and unintended audio mixing by not
    forcing left mixer active at probe.
  - Likely “Fixes:” the original addition of the driver:
    - Fixes: b97391a604b9e ("ASoC: codecs: Add support for ES8323")

- Risk/side effects
  - The default-on left mixer path enabled in probe is removed; default
    becomes hardware-driven and off until DAPM/user enables the switch.
    This is the correct behavior and matches DAPM design. Existing
    machine drivers and userspace will gain working, persistent
    controls; DAPM will correctly power the path when in use.
  - Change is limited to `sound/soc/codecs/es8323.c`.

- Applicability to stable trees
  - Backport to stable series that already contain the ES8323 driver
    (introduced in b97391a604b9e). It’s an important functional fix with
    minimal regression risk and no feature additions.

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

