Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E393128AB;
	Mon, 13 Apr 2026 16:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097363; cv=none; b=RgL/kdhNvKO1BFU7/4CjD0Xv2oYRntGwAUxClgeZs3Zz4VI4Adhvd3XaBh4ZNpc57oUYzSTnivZXvrLq/8y8NIkPXjlp0wv3X00VMwjm2mzlyxxT+Q6eJPm4SrhMbEHeUBUon5n2li0IKWjuWGm3uhbSw6jm10q8vqNL0aWIO5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097363; c=relaxed/simple;
	bh=mPwKwRFSTyTD7mqZHr3tfZhSHPo3VIY9mUzX/l29e3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLZH7Txj/zDmQ8Zjn+yGM3WmunkrozpUrBmzrljUAERJRsGe4E8uFLtUfIaLQtHCqZaKFMMmEi6umb6qFfgy53kTyF7yw8Qu8d3J1sFClr4lpL3yehbulnCGc4BtYRQnUMe7EJsfYyJckcl/7iQdjmGG7RqAU7GrxYiE5xPn2vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dvXLi71U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dvXLi71U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86262C2BCB0;
	Mon, 13 Apr 2026 16:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097362;
	bh=mPwKwRFSTyTD7mqZHr3tfZhSHPo3VIY9mUzX/l29e3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dvXLi71UHI0LFe8SeocZhERlUgkhOAl8GtMRvuATYPHD+5kwgR05YV608PWhd9+ZY
	 QFxq/HDfOUw2KeH3t3k115dnCZBc1K7TXoZzyzXwRntUZOqB1i7VH0qpq1lY4D70Ok
	 6nYhBcqf/SC31ZiMWhuC8KzLb0IFQLXjKUo7zMKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/570] ASoC: soc-core: accept zero format at snd_soc_runtime_set_dai_fmt()
Date: Mon, 13 Apr 2026 17:53:58 +0200
Message-ID: <20260413155834.451376775@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 7db07e37e13cfd46039d82aed91092185eac6565 ]

Do nothing if format was zero at snd_soc_runtime_set_dai_fmt().
soc-core.c can be more simple code by this patch.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87ee8jt7d3.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 95bc5c225513 ("ASoC: soc-core: flush delayed work before removing DAIs and widgets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/meson-codec-glue.c |  3 ---
 sound/soc/soc-core.c               | 11 ++++++-----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/sound/soc/meson/meson-codec-glue.c b/sound/soc/meson/meson-codec-glue.c
index d07270d17cee7..2870cfad813ac 100644
--- a/sound/soc/meson/meson-codec-glue.c
+++ b/sound/soc/meson/meson-codec-glue.c
@@ -113,9 +113,6 @@ int meson_codec_glue_output_startup(struct snd_pcm_substream *substream,
 	/* Replace link params with the input params */
 	rtd->dai_link->params = &in_data->params;
 
-	if (!in_data->fmt)
-		return 0;
-
 	return snd_soc_runtime_set_dai_fmt(rtd, in_data->fmt);
 }
 EXPORT_SYMBOL_GPL(meson_codec_glue_output_startup);
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 243c623598483..a00b944be9977 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1244,6 +1244,9 @@ int snd_soc_runtime_set_dai_fmt(struct snd_soc_pcm_runtime *rtd,
 	unsigned int i;
 	int ret;
 
+	if (!dai_fmt)
+		return 0;
+
 	for_each_rtd_codec_dais(rtd, i, codec_dai) {
 		ret = snd_soc_dai_set_fmt(codec_dai, dai_fmt);
 		if (ret != 0 && ret != -ENOTSUPP)
@@ -1288,11 +1291,9 @@ static int soc_init_pcm_runtime(struct snd_soc_card *card,
 		return ret;
 
 	snd_soc_runtime_get_dai_fmt(rtd);
-	if (dai_link->dai_fmt) {
-		ret = snd_soc_runtime_set_dai_fmt(rtd, dai_link->dai_fmt);
-		if (ret)
-			return ret;
-	}
+	ret = snd_soc_runtime_set_dai_fmt(rtd, dai_link->dai_fmt);
+	if (ret)
+		return ret;
 
 	/* add DPCM sysfs entries */
 	soc_dpcm_debugfs_add(rtd);
-- 
2.51.0



