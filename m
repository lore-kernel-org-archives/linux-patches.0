Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66CA03B27D1;
	Wed, 23 Sep 2026 14:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174423; cv=none; b=iPFJ3lcsS0bjDMH2T1Yc0LsOeRrJcGT6cXORQ3l0vz/nGnlNw/Rh2ycvKOvMYgUdy8sFMrSxVitAZqJAAB/HCyisWNVUfL23x0kdhK0y7SpKp4syYOSsGfVZBNHxle6jP96zuuh0L+tD+7KMPX9KiDs8cAJVH9mEpp4T6appdF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174423; c=relaxed/simple;
	bh=QlaM3rt9oy07kMY7u+4n/KLhaIrP+fFBPq3Btz1ZW38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ME35DlAJ9OhUWro8fLrPsd8Kpiwm0vev5ZZo/2sYLH0j0KXUhO/9kgaB5urZRYzwmhLymbPAtLuzFhCies9PcsOkxpIG59aMfUC6XYdyF04rI9uRE5u6dnYizOYeNrzGL1mZXE0zxDQMt3Fywyvrl1RIfs86ExrbZEStaakoZUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/mqVPqv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/mqVPqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9025C1F000FF;
	Wed, 23 Sep 2026 14:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174422;
	bh=FBbsLksecix8ue8NX51UKr+WB5PKUoOr38qdP4SG5Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q/mqVPqv4f8nJHFLpR5Alb3pYdFMRSx1emFqjFzaBo4uXI9wxfjAC87cydvO2vLCW
	 jHLwIUEwbO3Ui5mkQtFjgVKDpehB2u28oNAS0oUmJ4pNweL9RzVKGlmwFZgD5ahbdc
	 7D9yis6+rGvJ1Bl4bXQtlBAlahA3ipVRD9i5nNvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 110/398] ASoC: Rename snd_soc_dai_link_ch_map.ch_mask to cpu_ch_mask
Date: Wed, 23 Sep 2026 16:03:04 +0200
Message-ID: <20260923140646.292074900@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 33968935d00a9..99a8edfd1d7d8 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -682,7 +682,7 @@ struct snd_soc_dai_link_component {
 struct snd_soc_dai_link_ch_map {
 	unsigned int cpu;
 	unsigned int codec;
-	unsigned int ch_mask;
+	unsigned int cpu_ch_mask;
 };
 
 struct snd_soc_dai_link {
diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index 3facb78748acf..2c5c370503675 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -974,7 +974,7 @@ int asoc_sdw_hw_params(struct snd_pcm_substream *substream,
 	 * ASoC will set the corresponding channel numbers for each cpu dai.
 	 */
 	for_each_link_ch_maps(rtd->dai_link, i, ch_maps)
-		ch_maps->ch_mask = ch_mask << (i * step);
+		ch_maps->cpu_ch_mask = ch_mask << (i * step);
 
 	return 0;
 }
diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 99299364c9ba3..ebd766e00bac6 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1133,7 +1133,7 @@ static int __soc_pcm_hw_params(struct snd_pcm_substream *substream,
 		 */
 		for_each_rtd_ch_maps(rtd, j, ch_maps)
 			if (ch_maps->cpu == i)
-				ch_mask |= ch_maps->ch_mask;
+				ch_mask |= ch_maps->cpu_ch_mask;
 
 		/* fixup cpu channel number */
 		if (ch_mask)
-- 
2.53.0



