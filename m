Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A124251785;
	Wed,  5 Mar 2025 18:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198157; cv=none; b=spFJl4DzSiBNdS9SV8TrH5vogaj5/nWNhPUl0Ijvyb8FOkjBk9FyHaYy63Npe8BJJqIKuymNJtDkDYukxXfFSCJU8wEhLeSQGAz11IXk2MV198Vyg64Qrvj0aJ6yfUtHQF9z8Mr/e9iSwWSEVVxLxFIsrVj9hdRBLWHQAh3IHk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198157; c=relaxed/simple;
	bh=lxf1Z7JCNRN97T59fTHht8Nhktr8mXWi3bEoa0TG5Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMy+c+17i26GubNMUI26eD934vkUijhQdgpl/yJ1ocvcqln8h0I0019h7ii8zMtqPjR4P6wMepNPqRldeLS+CfGJqU+Og73i94ie0Yc0V+A/gElXZVn+3cm66QBvlxyyJe8F73jtDlVAFqY/FSfVHfEXsJaag46E/lIVgIrds9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPJehBHI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPJehBHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250B6C4CED1;
	Wed,  5 Mar 2025 18:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198156;
	bh=lxf1Z7JCNRN97T59fTHht8Nhktr8mXWi3bEoa0TG5Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPJehBHIduTqNO4WkZNyGKnS64fIBPW9Th5ewTNPdYo7vQ80ix18RyPg6Gdx5wBPQ
	 5YPyTOFR5fyORjOYKUOTRtMNHyIvcbJ5ZfELbiYLJJLiffwIcSxKxY8wQlpi+jXGUB
	 LyJizVBRDiF/5zSPEd8gvExCFpPSoh+GBX+He9VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chancel Liu <chancel.liu@nxp.com>,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 042/150] ASoC: fsl: Rename stream name of SAI DAI driver
Date: Wed,  5 Mar 2025 18:47:51 +0100
Message-ID: <20250305174505.511586519@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chancel Liu <chancel.liu@nxp.com>

[ Upstream commit 0da83ab025bc45e9742e87c2cce19bff423377c8 ]

If stream names of DAI driver are duplicated there'll be warnings when
machine driver tries to add widgets on a route:

[    8.831335] fsl-asoc-card sound-wm8960: ASoC: sink widget CPU-Playback overwritten
[    8.839917] fsl-asoc-card sound-wm8960: ASoC: source widget CPU-Capture overwritten

Use different stream names to avoid such warnings.
DAI names in AUDMIX are also updated accordingly.

Fixes: 15c958390460 ("ASoC: fsl_sai: Add separate DAI for transmitter and receiver")
Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Acked-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Link: https://patch.msgid.link/20250217010437.258621-1-chancel.liu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c    | 6 +++---
 sound/soc/fsl/imx-audmix.c | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 634168d2bb6e5..c5efbceb06d1f 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -994,10 +994,10 @@ static struct snd_soc_dai_driver fsl_sai_dai_template[] = {
 	{
 		.name = "sai-tx",
 		.playback = {
-			.stream_name = "CPU-Playback",
+			.stream_name = "SAI-Playback",
 			.channels_min = 1,
 			.channels_max = 32,
-				.rate_min = 8000,
+			.rate_min = 8000,
 			.rate_max = 2822400,
 			.rates = SNDRV_PCM_RATE_KNOT,
 			.formats = FSL_SAI_FORMATS,
@@ -1007,7 +1007,7 @@ static struct snd_soc_dai_driver fsl_sai_dai_template[] = {
 	{
 		.name = "sai-rx",
 		.capture = {
-			.stream_name = "CPU-Capture",
+			.stream_name = "SAI-Capture",
 			.channels_min = 1,
 			.channels_max = 32,
 			.rate_min = 8000,
diff --git a/sound/soc/fsl/imx-audmix.c b/sound/soc/fsl/imx-audmix.c
index ff3671226306b..ca33ecad07521 100644
--- a/sound/soc/fsl/imx-audmix.c
+++ b/sound/soc/fsl/imx-audmix.c
@@ -119,8 +119,8 @@ static const struct snd_soc_ops imx_audmix_be_ops = {
 static const char *name[][3] = {
 	{"HiFi-AUDMIX-FE-0", "HiFi-AUDMIX-FE-1", "HiFi-AUDMIX-FE-2"},
 	{"sai-tx", "sai-tx", "sai-rx"},
-	{"AUDMIX-Playback-0", "AUDMIX-Playback-1", "CPU-Capture"},
-	{"CPU-Playback", "CPU-Playback", "AUDMIX-Capture-0"},
+	{"AUDMIX-Playback-0", "AUDMIX-Playback-1", "SAI-Capture"},
+	{"SAI-Playback", "SAI-Playback", "AUDMIX-Capture-0"},
 };
 
 static int imx_audmix_probe(struct platform_device *pdev)
-- 
2.39.5



