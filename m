Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB5D183CB8;
	Mon, 12 Aug 2024 16:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479484; cv=none; b=Yt/lUZYQnSrRfBG6Q853txxudtBy9BDdYK5AYgsP6QUfAl6mN4dG6TMRdQ3ecJ4d0ITfZmKJ/7TL8cIKpN+0HvLrYEaoeROIqEzFNh3YL/9/fhu3tgxEupju4K01yCVWuTGjeM7yTPD6sSY2n5yg/ksw8L75jnjXib8d0eqKDk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479484; c=relaxed/simple;
	bh=wUTnSGuu8RO5Y61x+JFnmr/M9VlCkdh1b8jEEHwxBjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PM2bZDUEqoS4E8qGt+sX77qe+VnDO0hYg282fHAk+uYpaRyO2QdPXpA4GSLIuOVEPFSPPsX0JR7WaskHib7VqKU2C+cPdg4jYqtW85Ro7didppjHpVF1LaAIHyhqps72MTjrEqAsWxq3FUMKBG+8+AKaOuN5u12M6NcRiaYoQSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t8zEWdMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t8zEWdMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B36C32782;
	Mon, 12 Aug 2024 16:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479483;
	bh=wUTnSGuu8RO5Y61x+JFnmr/M9VlCkdh1b8jEEHwxBjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8zEWdMnXYybA5ywtR42eQpR7WzkCzA/0FwW6xPxqhiBM+3z77+BAkCHh9aheJ5Y2
	 az+MwSwbYpgEcV5EjGzXrneMuapG3gOg+043gcIsitc1UOH+4dc3CKJN9+6eTbmD1B
	 hk0N7xc2eJYMvix8tbpwxHqUMJB4YAxnNS4FH3tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Audu <jau@free.fr>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/189] ASoC: sti: add missing probe entry for player and reader
Date: Mon, 12 Aug 2024 18:02:30 +0200
Message-ID: <20240812160135.761151548@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2c21a86421e66..cc9a8122b9bc2 100644
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



