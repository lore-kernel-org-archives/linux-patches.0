Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28412497B79;
	Wed, 23 Sep 2026 14:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173034; cv=none; b=VF+w4srEWRdrvXNWFnmQzvc2cMmd08eTI9IiPRsVemkSaMAlCg9B4w18G5QNc109mjPqUDmU2XVFHx5hwZypgawCxgrM8itXfTIlfRxgfPyH3cgFqezYW8i7VGLXs6W8g1yMlF4yZ+vsOrqf5JJHxZRxmrLTPJt5VMzop/6zVmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173034; c=relaxed/simple;
	bh=Vo5k9hvtCi+xsFjO8w96NeT+te69kXNy8mNAJZ0jmmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2YTu+qUZEPK0i9dMTlQmavzhxByeH3BCuSGuQxT5WvGiN6pzgGIK4fqLRpf/Fwnu0s3htpTHeRfrPhhlYhS7Z1QBFfErH131CkoddfPt2U4CF5A/2mD2ffo6p+HdPcqV+QxR/ln2XrK1GwWSdHTXNCU5XUKpyMsAH7rqbmq71s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6b6tmYM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6b6tmYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638331F000FF;
	Wed, 23 Sep 2026 14:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173033;
	bh=3HuhWbNeAxta7gqnVcjZLts73RuT0sVjZHYAigEGIbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f6b6tmYMJiYOzw/ZFOSjVVE/KaLoZcSe/DMkq6tuRkcO2rAzL99FmhrJ0fNR0XbcP
	 2Va2yvlRaJ+pOOHfATwLlDr6QtBjR0RFDootC1W8Xmret/KDSiBse1I/mLxDWVxffY
	 XG89/PMJXybKVOoH71e4Y4aac+3KBczA05rWwvE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 131/438] ASoC: Rename snd_soc_dai_link_ch_map.ch_mask to cpu_ch_mask
Date: Wed, 23 Sep 2026 16:02:32 +0200
Message-ID: <20260923140648.175732695@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 10ad80f930c2e..300ce20fc7b70 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -698,7 +698,7 @@ struct snd_soc_dai_link_component {
 struct snd_soc_dai_link_ch_map {
 	unsigned int cpu;
 	unsigned int codec;
-	unsigned int ch_mask;
+	unsigned int cpu_ch_mask;
 };
 
 struct snd_soc_dai_link {
diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index d8db8fc5313ee..ce2a9c28fe1a5 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -1541,7 +1541,7 @@ int asoc_sdw_hw_params(struct snd_pcm_substream *substream,
 	 * ASoC will set the corresponding channel numbers for each cpu dai.
 	 */
 	for_each_link_ch_maps(rtd->dai_link, i, ch_maps)
-		ch_maps->ch_mask = ch_mask << (i * step);
+		ch_maps->cpu_ch_mask = ch_mask << (i * step);
 
 	return 0;
 }
diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index 0e49290a8c903..cb64ced211494 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -1264,7 +1264,7 @@ static int __soc_pcm_hw_params(struct snd_pcm_substream *substream,
 		 */
 		for_each_rtd_ch_maps(rtd, j, ch_maps)
 			if (ch_maps->cpu == i)
-				ch_mask |= ch_maps->ch_mask;
+				ch_mask |= ch_maps->cpu_ch_mask;
 
 		/* fixup cpu channel number */
 		if (ch_mask)
-- 
2.53.0



