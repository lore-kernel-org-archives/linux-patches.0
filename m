Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B424326801;
	Sun,  1 Jun 2025 23:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748821342; cv=none; b=pCYfe45LAPpicfviCiCoNiKn8fA1oDn7C6cGGwwQoksS+9FjlC/6TK5Ov0AAb9n/7sTQlAbNct4PAmwbduMRgBdbf2cUBb1bXmWV/I52rBiHgeIVsApM85MBIXdoIwdrV0KkGh4ImwCZ+185R4drUEgXUl0w4GhRAZjwUgPLsq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748821342; c=relaxed/simple;
	bh=/7oMJ+atevhn2FioTxZ2s2DHy31PJT5PXhI+qQ/b/t0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sGy+5W+Sgu7ZG9KvrO/FcK1sbphfWVwPBlI5x4uL7besWqL2SITZake1q7OqEhB4AF7yPA6RGoMtd2lNQlcbDXfD7ef8VovnSX6weRpYKZZQ8q2y2bK4VZ6SJ3Xf9ZR0mfsCYrdkV1ssvsURRJIDwptti5KSEwQDNtLKKAQbkUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fPmCnEsQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fPmCnEsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE60DC4CEF1;
	Sun,  1 Jun 2025 23:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748821342;
	bh=/7oMJ+atevhn2FioTxZ2s2DHy31PJT5PXhI+qQ/b/t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPmCnEsQKB+34HafQtobbCiONko6IaaE1j5+7jI1G3u1saDtp558RjIaDymHq/Dqs
	 Jtby+xG5r98fUK2BXusHWuMdgGy+57ivFqggJZAhULD0j8HHfQ/OdbCsP1FiZt9hNP
	 B+65j7gcBwu9006s80RABlC7zlQzUIPCst3Ma45l79ahuiVfcCOHg3wBRvN8tf81dW
	 tEI8Av3Y2PvADo50QiHl+5L5yjgvbT4Q4xTMBUn8kvQiP/6Yls+ZIAiHhx7PXFTvSS
	 hXVFFcwSA4tiwcX97tX9sGKCiIfSXiU8zt1ZOS43LZEchlasFL81g6a+e9eGL8bNWx
	 QmqPD4YQA1LqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hector Martin <marcan@marcan.st>,
	Neal Gompa <neal@gompa.dev>,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	shenghao-ding@ti.com,
	kevin-lu@ti.com,
	baojun.xu@ti.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 58/58] ASoC: tas2770: Power cycle amp on ISENSE/VSENSE change
Date: Sun,  1 Jun 2025 19:40:11 -0400
Message-Id: <20250601234012.3516352-58-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601234012.3516352-1-sashal@kernel.org>
References: <20250601234012.3516352-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.140
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hector Martin <marcan@marcan.st>

[ Upstream commit f529c91be8a34ac12e7599bf87c65b6f4a2c9f5c ]

The ISENSE/VSENSE blocks are only powered up when the amplifier
transitions from shutdown to active. This means that if those controls
are flipped on while the amplifier is already playing back audio, they
will have no effect.

Fix this by forcing a power cycle around transitions in those controls.

Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: James Calligeros <jcalligeros99@gmail.com>
Link: https://patch.msgid.link/20250406-apple-codec-changes-v5-1-50a00ec850a3@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my comprehensive analysis of both the commit and the TAS2770
codebase, here is my assessment: **YES** This commit should be
backported to stable kernel trees for the following reasons: ## Critical
Functionality Fix The commit addresses a **fundamental hardware
functionality issue** where ISENSE/VSENSE blocks (current/voltage
monitoring) only power up during amplifier state transitions from
shutdown to active. This is a hardware-level limitation that affects the
core operation of the audio codec. ## Speaker Protection System Impact
The code changes reveal this is about **speaker protection**, which is
safety-critical functionality: ```c /bin /bin.usr-is-merged /boot /dev
/etc /home /init /lib /lib.usr-is-merged /lib64 /lost+found /media /mnt
/opt /proc /root /run /sbin /sbin.usr-is-merged /snap /srv /sys /tmp
/usr /var * Powering up ISENSE/VSENSE requires a trip through the
shutdown state. * Do that here to ensure that our changes are applied
properly, otherwise * we might end up with non-functional IVSENSE if
playback started earlier, * which would break software speaker
protection. */ ``` Non-functional IVSENSE/VSENSE breaks software speaker
protection algorithms that prevent hardware damage from
overcurrent/overvoltage conditions. ## Clean, Contained Fix The
implementation is minimal and surgical: - Adds a new `sense_event()`
function with only 12 lines of logic - Modifies DAPM widget definitions
to use `SND_SOC_DAPM_SWITCH_E` instead of `SND_SOC_DAPM_SWITCH` - Forces
a controlled power cycle (shutdown → normal operation) when sense
controls change - No architectural changes or new features ## Historical
Pattern Alignment This follows the **positive backport pattern** seen in
similar commit #2 (tas2562 amp_level fix) and #5 (tas2781 power state
restoration), both marked "Backport Status: YES" for fixing hardware
control issues in TAS codec family. ## Low Regression Risk The fix
operates within existing DAPM event handling framework: -
`SND_SOC_DAPM_PRE_REG`: Forces shutdown before register changes -
`SND_SOC_DAPM_POST_REG`: Restores proper power state after changes -
Uses existing `tas2770_update_pwr_ctrl()` function - No changes to
normal playback paths when sense controls aren't modified ## User-
Affecting Bug Users enabling ISENSE/VSENSE monitoring during active
playback would experience: - Silent failure of speaker protection -
Potential hardware damage risk - Inconsistent behavior depending on
timing of control changes The fix ensures these controls work reliably
regardless of when they're activated, which is essential for proper
codec operation and hardware protection.

 sound/soc/codecs/tas2770.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tas2770.c b/sound/soc/codecs/tas2770.c
index e284a3a854591..8bd98e9817c97 100644
--- a/sound/soc/codecs/tas2770.c
+++ b/sound/soc/codecs/tas2770.c
@@ -158,11 +158,37 @@ static const struct snd_kcontrol_new isense_switch =
 static const struct snd_kcontrol_new vsense_switch =
 	SOC_DAPM_SINGLE("Switch", TAS2770_PWR_CTRL, 2, 1, 1);
 
+static int sense_event(struct snd_soc_dapm_widget *w,
+			struct snd_kcontrol *kcontrol, int event)
+{
+	struct snd_soc_component *component = snd_soc_dapm_to_component(w->dapm);
+	struct tas2770_priv *tas2770 = snd_soc_component_get_drvdata(component);
+
+	/*
+	 * Powering up ISENSE/VSENSE requires a trip through the shutdown state.
+	 * Do that here to ensure that our changes are applied properly, otherwise
+	 * we might end up with non-functional IVSENSE if playback started earlier,
+	 * which would break software speaker protection.
+	 */
+	switch (event) {
+	case SND_SOC_DAPM_PRE_REG:
+		return snd_soc_component_update_bits(component, TAS2770_PWR_CTRL,
+						    TAS2770_PWR_CTRL_MASK,
+						    TAS2770_PWR_CTRL_SHUTDOWN);
+	case SND_SOC_DAPM_POST_REG:
+		return tas2770_update_pwr_ctrl(tas2770);
+	default:
+		return 0;
+	}
+}
+
 static const struct snd_soc_dapm_widget tas2770_dapm_widgets[] = {
 	SND_SOC_DAPM_AIF_IN("ASI1", "ASI1 Playback", 0, SND_SOC_NOPM, 0, 0),
 	SND_SOC_DAPM_MUX("ASI1 Sel", SND_SOC_NOPM, 0, 0, &tas2770_asi1_mux),
-	SND_SOC_DAPM_SWITCH("ISENSE", TAS2770_PWR_CTRL, 3, 1, &isense_switch),
-	SND_SOC_DAPM_SWITCH("VSENSE", TAS2770_PWR_CTRL, 2, 1, &vsense_switch),
+	SND_SOC_DAPM_SWITCH_E("ISENSE", TAS2770_PWR_CTRL, 3, 1, &isense_switch,
+		sense_event, SND_SOC_DAPM_PRE_REG | SND_SOC_DAPM_POST_REG),
+	SND_SOC_DAPM_SWITCH_E("VSENSE", TAS2770_PWR_CTRL, 2, 1, &vsense_switch,
+		sense_event, SND_SOC_DAPM_PRE_REG | SND_SOC_DAPM_POST_REG),
 	SND_SOC_DAPM_DAC_E("DAC", NULL, SND_SOC_NOPM, 0, 0, tas2770_dac_event,
 			   SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD),
 	SND_SOC_DAPM_OUTPUT("OUT"),
-- 
2.39.5

