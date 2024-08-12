Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D3F16D9B8;
	Mon, 12 Aug 2024 16:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480274; cv=none; b=mMxQ/1i2Z+aRVYr0htxMyC7/8fCe8OOS+2wstVnlVljmRTMm67eXW3f81bjGRSqWXxH5qDmz5tI5qJUN+OFSMCtpCYngvoQKGhHJVufBtkGfTKTYNp1yG4wQbEwKiAkMk9Mf3Ojs5dyUiRqx7Z8GGxS71E7k72IRAGtjbyf23aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480274; c=relaxed/simple;
	bh=1+XWjnwEDMch54EGfeMToZLhanLegxgowWFa0IjR4bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLZTm/VGo1W4/G/kpj2bFJr1iUaaa/8xrhKkZdAHYgTEFvw5pQVXj6U5KYLQ9env92x4cVGVJuUbGXjzBS6PeDuzoMqmJx1TfyIDYnpZ29XvR01vn0iLstkL1vM/jz00emidgbogCiBleWVbO+dOcdJA/X5GhMVmbLB7mRCjMMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yjttPvQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yjttPvQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E953C4AF09;
	Mon, 12 Aug 2024 16:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480274;
	bh=1+XWjnwEDMch54EGfeMToZLhanLegxgowWFa0IjR4bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjttPvQ3ICUAhy4AC+aFQaQih+/yOFsndjTeXRbYFnToPd/5MIa9zA6QuqFnonutV
	 DBh6iRb6u6AAOSwYiPL7iWjFAduhJ+L+1mvoXb365+ek452IPM6m5YFMUhwPFxB8tO
	 5Zj2eDdy7RNR9LqNsU7RKIWlFLvL+zLgQoaANxDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Audu <jau@free.fr>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 146/263] ASoC: sti: add missing probe entry for player and reader
Date: Mon, 12 Aug 2024 18:02:27 +0200
Message-ID: <20240812160152.137038373@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Audu <jau@free.fr>

[ Upstream commit 6b99068d5ea0aa295f15f30afc98db74d056ec7b ]

This patch addresses a regression in the ASoC STI drivers that was
introduced in Linux version 6.6.y. The issue originated from a series of
patches (see https://lore.kernel.org/all/87wmy5b0wt.wl-kuninori.morimoto.gx@renesas.com/)
that unintentionally omitted necessary probe functions for the player
and reader components.

Probe function in `sound/soc/sti/sti_uniperif.c:415` is being replaced
by another probe function located at `sound/soc/sti/sti_uniperif.c:453`,
which should instead be derived from the player and reader components.
This patch correctly reinserts the missing probe entries,
restoring the intended functionality.

Fixes: 9f625f5e6cf9 ("ASoC: sti: merge DAI call back functions into ops")
Signed-off-by: Jerome Audu <jau@free.fr>
Link: https://patch.msgid.link/20240727-sti-audio-fix-v2-1-208bde546c3f@free.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sti/sti_uniperif.c    | 2 +-
 sound/soc/sti/uniperif.h        | 1 +
 sound/soc/sti/uniperif_player.c | 1 +
 sound/soc/sti/uniperif_reader.c | 1 +
 4 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sti/sti_uniperif.c b/sound/soc/sti/sti_uniperif.c
index ba824f14a39cf..a7956e5a4ee5d 100644
--- a/sound/soc/sti/sti_uniperif.c
+++ b/sound/soc/sti/sti_uniperif.c
@@ -352,7 +352,7 @@ static int sti_uniperiph_resume(struct snd_soc_component *component)
 	return ret;
 }
 
-static int sti_uniperiph_dai_probe(struct snd_soc_dai *dai)
+int sti_uniperiph_dai_probe(struct snd_soc_dai *dai)
 {
 	struct sti_uniperiph_data *priv = snd_soc_dai_get_drvdata(dai);
 	struct sti_uniperiph_dai *dai_data = &priv->dai_data;
diff --git a/sound/soc/sti/uniperif.h b/sound/soc/sti/uniperif.h
index 2a5de328501c1..74e51f0ff85c8 100644
--- a/sound/soc/sti/uniperif.h
+++ b/sound/soc/sti/uniperif.h
@@ -1380,6 +1380,7 @@ int uni_reader_init(struct platform_device *pdev,
 		    struct uniperif *reader);
 
 /* common */
+int sti_uniperiph_dai_probe(struct snd_soc_dai *dai);
 int sti_uniperiph_dai_set_fmt(struct snd_soc_dai *dai,
 			      unsigned int fmt);
 
diff --git a/sound/soc/sti/uniperif_player.c b/sound/soc/sti/uniperif_player.c
index dd9013c476649..6d1ce030963c6 100644
--- a/sound/soc/sti/uniperif_player.c
+++ b/sound/soc/sti/uniperif_player.c
@@ -1038,6 +1038,7 @@ static const struct snd_soc_dai_ops uni_player_dai_ops = {
 		.startup = uni_player_startup,
 		.shutdown = uni_player_shutdown,
 		.prepare = uni_player_prepare,
+		.probe = sti_uniperiph_dai_probe,
 		.trigger = uni_player_trigger,
 		.hw_params = sti_uniperiph_dai_hw_params,
 		.set_fmt = sti_uniperiph_dai_set_fmt,
diff --git a/sound/soc/sti/uniperif_reader.c b/sound/soc/sti/uniperif_reader.c
index 065c5f0d1f5f0..05ea2b794eb92 100644
--- a/sound/soc/sti/uniperif_reader.c
+++ b/sound/soc/sti/uniperif_reader.c
@@ -401,6 +401,7 @@ static const struct snd_soc_dai_ops uni_reader_dai_ops = {
 		.startup = uni_reader_startup,
 		.shutdown = uni_reader_shutdown,
 		.prepare = uni_reader_prepare,
+		.probe = sti_uniperiph_dai_probe,
 		.trigger = uni_reader_trigger,
 		.hw_params = sti_uniperiph_dai_hw_params,
 		.set_fmt = sti_uniperiph_dai_set_fmt,
-- 
2.43.0



