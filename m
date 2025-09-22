Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399112820D1;
	Mon, 22 Sep 2025 19:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569998; cv=none; b=qNARSmFn272DqDVB8fElk66aTsNE0zBDnEvAi1Hprkq5/lyt1DejEKMA+H3onixl4HlmQuIVR8VcirCqqxCAucmneLpHRNn7YlnQ+prFnFm5W99Cetiba+U0Toj1bpSZtggorVm3r+ThhbjDP/dM3DfdpIaNvsM628Rl/n6ZCg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569998; c=relaxed/simple;
	bh=33j6wfpBTOnQNpNMCt2O2slgDpuq2tKzbyCbJz2pA8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NBhMkI9UOYasYCEJn2WVtdfb6ElZ1tGSnpfalGcnXRFWOZzGNY7ViQimqgBLHVp6SsxNuKbYyi7LhMwAY0UjHet3U6fLeTvDukLy8lCVQ6VHzLFVnm45g7U9B5ASYaZrEjgZD1Vb9J/d3TNvFeOFfULrF1iLrH1fw9x63AopjeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BN6VIZ+9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BN6VIZ+9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C404CC4CEF0;
	Mon, 22 Sep 2025 19:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569998;
	bh=33j6wfpBTOnQNpNMCt2O2slgDpuq2tKzbyCbJz2pA8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BN6VIZ+9+IW2lttekvZYMxB313F00If+U8TQANMLhLcNge/d99hx5QCgRuvPNdTyU
	 kkF/SYXzznY3Pn8Bgc+daC21J+71nkRHA9TAkUrqF9m8ZG2CSXFf9FzMAgVpkWkBlK
	 WJcxcgyfJKf5TD0m7/7AUEGZ6maFhbcG+gfE2WpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/105] ASoC: Intel: catpt: Expose correct bit depth to userspace
Date: Mon, 22 Sep 2025 21:29:58 +0200
Message-ID: <20250922192410.862249071@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 690aa09b1845c0d5c3c29dabd50a9d0488c97c48 ]

Currently wrong bit depth is exposed in hw params, causing clipped
volume during playback. Expose correct parameters.

Fixes: a126750fc865 ("ASoC: Intel: catpt: PCM operations")
Reported-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Tested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Message-ID: <20250909092829.375953-1-amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/catpt/pcm.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/sound/soc/intel/catpt/pcm.c b/sound/soc/intel/catpt/pcm.c
index 81a2f0339e055..ff1fa01acb85b 100644
--- a/sound/soc/intel/catpt/pcm.c
+++ b/sound/soc/intel/catpt/pcm.c
@@ -568,8 +568,9 @@ static const struct snd_pcm_hardware catpt_pcm_hardware = {
 				  SNDRV_PCM_INFO_RESUME |
 				  SNDRV_PCM_INFO_NO_PERIOD_WAKEUP,
 	.formats		= SNDRV_PCM_FMTBIT_S16_LE |
-				  SNDRV_PCM_FMTBIT_S24_LE |
 				  SNDRV_PCM_FMTBIT_S32_LE,
+	.subformats		= SNDRV_PCM_SUBFMTBIT_MSBITS_24 |
+				  SNDRV_PCM_SUBFMTBIT_MSBITS_MAX,
 	.period_bytes_min	= PAGE_SIZE,
 	.period_bytes_max	= CATPT_BUFFER_MAX_SIZE / CATPT_PCM_PERIODS_MIN,
 	.periods_min		= CATPT_PCM_PERIODS_MIN,
@@ -699,14 +700,18 @@ static struct snd_soc_dai_driver dai_drivers[] = {
 		.channels_min = 2,
 		.channels_max = 2,
 		.rates = SNDRV_PCM_RATE_48000,
-		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S32_LE,
+		.subformats = SNDRV_PCM_SUBFMTBIT_MSBITS_24 |
+			      SNDRV_PCM_SUBFMTBIT_MSBITS_MAX,
 	},
 	.capture = {
 		.stream_name = "Analog Capture",
 		.channels_min = 2,
 		.channels_max = 4,
 		.rates = SNDRV_PCM_RATE_48000,
-		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S32_LE,
+		.subformats = SNDRV_PCM_SUBFMTBIT_MSBITS_24 |
+			      SNDRV_PCM_SUBFMTBIT_MSBITS_MAX,
 	},
 },
 {
@@ -718,7 +723,9 @@ static struct snd_soc_dai_driver dai_drivers[] = {
 		.channels_min = 2,
 		.channels_max = 2,
 		.rates = SNDRV_PCM_RATE_8000_192000,
-		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S32_LE,
+		.subformats = SNDRV_PCM_SUBFMTBIT_MSBITS_24 |
+			      SNDRV_PCM_SUBFMTBIT_MSBITS_MAX,
 	},
 },
 {
@@ -730,7 +737,9 @@ static struct snd_soc_dai_driver dai_drivers[] = {
 		.channels_min = 2,
 		.channels_max = 2,
 		.rates = SNDRV_PCM_RATE_8000_192000,
-		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S32_LE,
+		.subformats = SNDRV_PCM_SUBFMTBIT_MSBITS_24 |
+			      SNDRV_PCM_SUBFMTBIT_MSBITS_MAX,
 	},
 },
 {
@@ -742,7 +751,9 @@ static struct snd_soc_dai_driver dai_drivers[] = {
 		.channels_min = 2,
 		.channels_max = 2,
 		.rates = SNDRV_PCM_RATE_48000,
-		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE,
+		.formats = SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S32_LE,
+		.subformats = SNDRV_PCM_SUBFMTBIT_MSBITS_24 |
+			      SNDRV_PCM_SUBFMTBIT_MSBITS_MAX,
 	},
 },
 {
-- 
2.51.0



