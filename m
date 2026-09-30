Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F7C519DEA;
	Wed, 30 Sep 2026 17:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788389; cv=none; b=GYMeTxmnDj8wYbWn8MtCDRl77lOtYGWV4JHac61ch1OIVzSV9h5uFZhVVPPI1MhEu7m3qheCszemJrexcZXAv7cdrBBKsG/fQpCOTk9zHX8P8/bD4zPWeauhZPWb5lWYa15CWrCJA6x9t/Wq1HNQ5TT+kWh7H6vsBUSqiiAQ+h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788389; c=relaxed/simple;
	bh=6CRDgvP7hQQA0tqZNpCpqKeiWBqQsHEBgat6tdwHQj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBIIN/RAh3Ds3f156HQoV7pvPZ4TJbDEJ+cmrR1rNY/Ak2Lsi2yhGYPFPPInVsk4JzuAW/rvJB/4Km0sEzPb0J/tYZ5QAJm7m+V3K2Ar+k0ZGNl1gaMS+8gm4rfQGzJ5B4gxKGl15XFdefGhwpsce6VT4x2AhYqjxQAYmsH+vsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjCxJHKi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjCxJHKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8028E1F000FF;
	Wed, 30 Sep 2026 17:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788388;
	bh=21BfyelgcI//HNhfwuSHz745mYjdtydEJfhwu4uF2io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JjCxJHKi9sYmT8W9nbZpOIe314TxXG8RBG018Rg9dVJPuTsd+htX+9NheYUHpVdSG
	 OdY6Qo2/zCuKFWb361lIbJnTKHq3xOMgCq2z0kN0mXr2l/OxSjnQxipld763JAqJiI
	 d5AzMs/g5P+AU2Bio07fb7jdZiztLtV6tIxiCcYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 105/877] ASoC: Rename snd_soc_dai_link_ch_map.ch_mask to cpu_ch_mask
Date: Wed, 30 Sep 2026 17:16:56 +0200
Message-ID: <20260930152417.004928730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 4d855d747521505b54457c96bc73577bf74b2374 ]

Rename the ch_mask member of snd_soc_dai_link_ch_map to cpu_ch_mask,
as that is what it is used for.

The CPU and codec channel masks are not necessarily the same, and are
quite likely different. SoundWire and I2S/TDM both support assigning
different sample slots to each codec, so for example channel 0 on each
codec could map to different channels at the CPU. So it's quite normal
that the channel mask at the CPU end is different for each codec, but
the codec channel masks are the same for each codec.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260910114500.1586637-2-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 6b382bdfe26a ("ASoC: soc-pcm: Apply snd_soc_dai_link_ch_map.codec_ch_mask to codec params")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc.h                 | 2 +-
 sound/soc/sdw_utils/soc_sdw_utils.c | 2 +-
 sound/soc/soc-pcm.c                 | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/sound/soc.h b/include/sound/soc.h
index cd467f8babdb6..87e50c8cdda31 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -717,7 +717,7 @@ struct snd_soc_dai_link_component {
 struct snd_soc_dai_link_ch_map {
 	unsigned int cpu;
 	unsigned int codec;
-	unsigned int ch_mask;
+	unsigned int cpu_ch_mask;
 };
 
 struct snd_soc_dai_link {
diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index e6ac5c0fd3bec..70a7abede618f 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -795,7 +795,7 @@ int asoc_sdw_hw_params(struct snd_pcm_substream *substream,
 	 * ASoC will set the corresponding channel numbers for each cpu dai.
 	 */
 	for_each_link_ch_maps(rtd->dai_link, i, ch_maps)
-		ch_maps->ch_mask = ch_mask << (i * step);
+		ch_maps->cpu_ch_mask = ch_mask << (i * step);
 
 	return 0;
 }
diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 628322790c878..440acec700a56 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1180,7 +1180,7 @@ static int __soc_pcm_hw_params(struct snd_soc_pcm_runtime *rtd,
 		 */
 		for_each_rtd_ch_maps(rtd, j, ch_maps)
 			if (ch_maps->cpu == i)
-				ch_mask |= ch_maps->ch_mask;
+				ch_mask |= ch_maps->cpu_ch_mask;
 
 		/* fixup cpu channel number */
 		if (ch_mask)
-- 
2.53.0



