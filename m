Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4720C303A17;
	Sat, 25 Oct 2025 16:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408577; cv=none; b=R7JTXMw1/OTVOmy4UIOrB1eUePPNN9fr+uIVSJ1vRl7pENsSUNbVmEWrWPF3Ix3P+lQDedRxn3XwlFAcs/RUv7wvSzkoJYavRuhhn3PW/qUwbr5w7QqaMIPL9vCOAWcukmA8rGtju0cxc9qHBbVLySAepoLRimLsRx3VkZsLh5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408577; c=relaxed/simple;
	bh=m7aj+8/DBxIetPKpq+fkw1Em5TMm9u6G4s6b3QXYuws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j50o7t5B/2Cf3DZmu8R0zn/jAlEpaQmHKV539eZ1gapUnG49fPfjZH6NiJYaiu3PPrtLmdd0a8vb0pbf9H7snz8sDdBTawcO08cmaVyB79KVIQYiSBmE3jHSRqh9LF9H3iRTXgNX5v7bEPIV6CWS2l3FaHsHSIBel2dQOaofCwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BuoPqFSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BuoPqFSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBF3C4CEF5;
	Sat, 25 Oct 2025 16:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408576;
	bh=m7aj+8/DBxIetPKpq+fkw1Em5TMm9u6G4s6b3QXYuws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BuoPqFSGLdb/LhwStx/VEz9HCrl3FhCTymwAX1dJZr7nyGwm0WDn3vpde0nd+Udid
	 om1Kq533xBk+M1b46jkH1l4NRauFY6R4tv8JPOC9j8wBn1IFzHwRX9A58vERj5vfW+
	 MS+GQR0mQl+Z9t99+YrZkaQ/tuSMG7aHTg3rAni3LrKB7WbjcObOoTlGWYDqcMrnml
	 TuxpIeMwdG9p0J/0mjL1z8u7EtYvt+Xsz0zV9Luqf52ofV4RPEdbFlUmY03ts2lfhO
	 XZ4BxbEtA7lr9V7dZ99RlmtWPWTCGM2P6TL5+SeTZZ6qc5/2jqQfKweuDnd4F7ani+
	 7HRFBwIqbtK8A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	ranjani.sridharan@linux.intel.com,
	daniel.baluta@nxp.com,
	sound-open-firmware@alsa-project.org
Subject: [PATCH AUTOSEL 6.17-6.12] ASoC: SOF: ipc4-pcm: Add fixup for channels
Date: Sat, 25 Oct 2025 11:54:03 -0400
Message-ID: <20251025160905.3857885-12-sashal@kernel.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 6ad299a9b968e1c63988e2a327295e522cf6bbf5 ]

We can have modules in path which can change the number of channels and in
this case the BE params needs to be adjusted to configure the DAI according
to the copier configuration.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Message-ID: <20250829105305.31818-2-peter.ujfalusi@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Why this is a bugfix that helps users
- Problem: When a pipeline contains modules that change channel count
  (e.g., upmix/downmix), the BE DAI was still being configured from FE
  channels, which can misconfigure the DAI and cause failures or
  corrupted audio. The commit message explicitly states this mismatch
  and the need to adjust BE params to the copier configuration.
- Fix: Adds a channel “fixup” that mirrors the already-existing rate
  fixup so the BE DAI is configured with the correct, unambiguous
  channel count derived from the DAI copier’s available formats.

What changed (key code points)
- New function: `sof_ipc4_pcm_dai_link_fixup_channels()` selects BE
  channels from the DAI copier’s input pin formats and constrains the BE
  params when FE/BE channels differ.
  - Definition: sound/soc/sof/ipc4-pcm.c:730
  - Logic:
    - Reads `ipc4_copier->available_fmt.input_pin_fmts` and extracts
      channels via `SOF_IPC4_AUDIO_FORMAT_CFG_CHANNELS_COUNT(fmt_cfg)`.
    - If FE channels match any BE input format, do nothing.
    - If FE channels don’t match, require the BE to define a single
      (unambiguous) channel count and then constrain
      `SNDRV_PCM_HW_PARAM_CHANNELS` to exactly that value (min=max). If
      ambiguous, error out early to avoid wrong configuration.
  - This mirrors the existing rate fixup logic in
    `sof_ipc4_pcm_dai_link_fixup_rate()` (sound/soc/sof/ipc4-pcm.c:678),
    keeping behavior consistent for channels and rate.
- Integration: The new channel fixup is invoked in the main BE link
  fixup sequence right after rate fixup:
  - Calls at sound/soc/sof/ipc4-pcm.c:841 (rate) and
    sound/soc/sof/ipc4-pcm.c:845 (channels).
  - Ensures that subsequent hardware config selection (e.g.,
    `ipc4_ssp_dai_config_pcm_params_match()` using
    `params_channels(params)` and `params_rate(params)`) sees the
    corrected constraints. See call at sound/soc/sof/ipc4-pcm.c:870.

Why it’s suitable for stable backport
- Fixes a real user-visible bug: prevents misconfigured DAI when
  channel-changing modules are present, avoiding playback/capture
  failures or corrupted audio.
- Small and contained: Changes only `sound/soc/sof/ipc4-pcm.c` with a
  single helper and one new call in the existing fixup path; no ABI or
  architectural changes.
- Conservative behavior:
  - Adjusts BE channels only if FE/BE differ and the BE exposes a
    single, unambiguous channel count. Otherwise, it leaves FE/BE
    unchanged or fails fast to avoid silently choosing an arbitrary
    configuration.
  - Uses the same safe pattern as the existing rate fixup, reducing
    regression risk.
- Dependencies are already present in IPC4 code:
  - Uses existing IPC4 types/fields (`struct sof_ipc4_copier`,
    `available_fmt`, `fmt_cfg`) and macros
    (`SOF_IPC4_AUDIO_FORMAT_CFG_CHANNELS_COUNT` in
    include/sound/sof/ipc4/header.h:285).
- Impacted scope: Limited to SOF IPC4 ASoC path and only at BE parameter
  fixup time; this is not core kernel or broad subsystem behavior.

Risk assessment
- Low risk: The change only constrains BE channel interval in the
  specific mismatch case when BE channels are unambiguous; otherwise
  behavior is unchanged.
- Fails early in ambiguous configurations (which would previously risk
  misprogramming the DAI), improving robustness rather than introducing
  silent changes.

Conclusion
- This is a clear, minimal, and robust bugfix that aligns BE
  configuration with the DAI copier’s declared formats when channel
  counts differ. It should be backported to stable trees that include
  SOF IPC4, as it improves correctness with minimal regression risk.

 sound/soc/sof/ipc4-pcm.c | 56 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/sound/soc/sof/ipc4-pcm.c b/sound/soc/sof/ipc4-pcm.c
index 37d72a50c1272..9542c428daa4a 100644
--- a/sound/soc/sof/ipc4-pcm.c
+++ b/sound/soc/sof/ipc4-pcm.c
@@ -738,6 +738,58 @@ static int sof_ipc4_pcm_dai_link_fixup_rate(struct snd_sof_dev *sdev,
 	return 0;
 }
 
+static int sof_ipc4_pcm_dai_link_fixup_channels(struct snd_sof_dev *sdev,
+						struct snd_pcm_hw_params *params,
+						struct sof_ipc4_copier *ipc4_copier)
+{
+	struct sof_ipc4_pin_format *pin_fmts = ipc4_copier->available_fmt.input_pin_fmts;
+	struct snd_interval *channels = hw_param_interval(params, SNDRV_PCM_HW_PARAM_CHANNELS);
+	int num_input_formats = ipc4_copier->available_fmt.num_input_formats;
+	unsigned int fe_channels = params_channels(params);
+	bool fe_be_match = false;
+	bool single_be_channels = true;
+	unsigned int be_channels, val;
+	int i;
+
+	if (WARN_ON_ONCE(!num_input_formats))
+		return -EINVAL;
+
+	/*
+	 * Copier does not change channels, so we
+	 * need to only consider the input pin information.
+	 */
+	be_channels = SOF_IPC4_AUDIO_FORMAT_CFG_CHANNELS_COUNT(pin_fmts[0].audio_fmt.fmt_cfg);
+	for (i = 0; i < num_input_formats; i++) {
+		val = SOF_IPC4_AUDIO_FORMAT_CFG_CHANNELS_COUNT(pin_fmts[i].audio_fmt.fmt_cfg);
+
+		if (val != be_channels)
+			single_be_channels = false;
+
+		if (val == fe_channels) {
+			fe_be_match = true;
+			break;
+		}
+	}
+
+	/*
+	 * If channels is different than FE channels, topology must contain a
+	 * module which can change the number of channels. But we do require
+	 * topology to define a single channels in the DAI copier config in
+	 * this case (FE channels may be variable).
+	 */
+	if (!fe_be_match) {
+		if (!single_be_channels) {
+			dev_err(sdev->dev, "Unable to select channels for DAI link\n");
+			return -EINVAL;
+		}
+
+		channels->min = be_channels;
+		channels->max = be_channels;
+	}
+
+	return 0;
+}
+
 static int sof_ipc4_pcm_dai_link_fixup(struct snd_soc_pcm_runtime *rtd,
 				       struct snd_pcm_hw_params *params)
 {
@@ -801,6 +853,10 @@ static int sof_ipc4_pcm_dai_link_fixup(struct snd_soc_pcm_runtime *rtd,
 	if (ret)
 		return ret;
 
+	ret = sof_ipc4_pcm_dai_link_fixup_channels(sdev, params, ipc4_copier);
+	if (ret)
+		return ret;
+
 	if (single_bitdepth) {
 		snd_mask_none(fmt);
 		valid_bits = SOF_IPC4_AUDIO_FORMAT_CFG_V_BIT_DEPTH(ipc4_fmt->fmt_cfg);
-- 
2.51.0

