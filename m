Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050348;
	b=h7LbZkzc9Z5MdQN3CghUSA8N5C8b/ks6ytK7S0IhMDvR76ytFfrwXJQgFKlLq8xb6f7M
	 Y3SBKNgzGdcwyHTzm9brTTrH4SWTJtoMc6DIZKEIewwDE6YHBliCR7Sb+r2XxpGTczHto
	 i1CviuvXBjyICk77hv+Xi8lI/s0w23hOEq7YESKk7bEgOK6vKMgkP64bQkWrtryQerskL
	 PxXLtAerUvVqjTu2TVX5TK8I3lAWhWhyVu/V77530s98OvoZCiyxwihIs6KysPDeK6TTD
	 I5Vjg6IyptWL1F2NYeGZUdQ5wUSh0OceghUcQoYpOirRFpB6gqiLOcPVQuMWJTha7vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050348;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LJwjc3Foh6wXXqjqS+RWm1IDjJ48auRkzJouDNqd3nc=;
	b=48umsYWXS0BC4vg5wPUrNw7G/4uh2yvLHdYO3skMUEqxsq6kPB6S5hwulh+Ba84dpeRf
	 OJX/vCTCmG5zlB/RAX6D9ZiTB9WMAH4HaBeiQiW0fvJt9guTikLyeHN8absxpduq7ah3w
	 7+VhfmrrjQx6S3Xv1yfPPRv/OP5Vl1qE61CQs4COQ7epG64+YSIawjB6NvT/5h0UqYFLZ
	 6r2r3F0C/kcpI2yeyoekSxAOYpLIppUFax+mNiTqqvbX8bFcG2HQJUMbK171HisXllvOo
	 q6YGzofqc8HJSD9ue9nyk9ZGrWj6CW8lmHi4SEnr3ePB72xxaEJqca/ApHha3XEGzhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zymrFbbl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B45A606A32A;
	Thu, 19 Nov 2026 01:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zymrFbbl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCD51F000C4;
	Thu, 19 Nov 2026 01:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050347;
	bh=LJwjc3Foh6wXXqjqS+RWm1IDjJ48auRkzJouDNqd3nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zymrFbblAFZy0UwzDKWQzJhv9EcBQgOmsvYvfCGRxbXsKSD9ZCrhJaPfQY9UkUXsm
	 KfsuJ+BbDCs5FmwflBzkNJ7A2xH35mOvPR0NLcVNSK47JRUe14Orhg/Qx/bJEUUtf7
	 ZHG3M4BKXn+WLVp2pLHGm+b7KJFr2FP9Bym9fOIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2677/2857] ASoC: soc.h: convert asoc_xxx() to snd_soc_xxx()
Date: Wed, 18 Nov 2026 16:01:51 +0100
Message-ID: <20261118150337.961540687@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 1d5a2b5dd0a8d2b2b535b5266699429dbd48e62f ]

ASoC is using 2 type of prefix (asoc_xxx() vs snd_soc_xxx()), but there
is no particular reason about that [1].
To reduce confusing, standarding these to snd_soc_xxx() is sensible.

This patch adds asoc_xxx() macro to keep compatible for a while.
It will be removed if all drivers were switched to new style.

Link: https://lore.kernel.org/r/87h6td3hus.wl-kuninori.morimoto.gx@renesas.com [1]
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87fs3ks26i.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: d9c23ac1217a ("ASoC: samsung: midas_wm1811: run FLL1 at the AIF1 configured rate when idle")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc-card.h |  4 ++--
 include/sound/soc.h      | 42 ++++++++++++++++++++++++++--------------
 sound/soc/soc-utils.c    |  4 ++--
 3 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/include/sound/soc-card.h b/include/sound/soc-card.h
index 40d3023cf0d16..7ef49ec7c1f06 100644
--- a/include/sound/soc-card.h
+++ b/include/sound/soc-card.h
@@ -100,8 +100,8 @@ struct snd_soc_dai *snd_soc_card_get_codec_dai(struct snd_soc_card *card,
 	struct snd_soc_pcm_runtime *rtd;
 
 	for_each_card_rtds(card, rtd) {
-		if (!strcmp(asoc_rtd_to_codec(rtd, 0)->name, dai_name))
-			return asoc_rtd_to_codec(rtd, 0);
+		if (!strcmp(snd_soc_rtd_to_codec(rtd, 0)->name, dai_name))
+			return snd_soc_rtd_to_codec(rtd, 0);
 	}
 
 	return NULL;
diff --git a/include/sound/soc.h b/include/sound/soc.h
index cb6bfa8d69fe3..6c018deed162f 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -754,37 +754,42 @@ struct snd_soc_dai_link {
 #endif
 };
 
+/* REMOVE ME */
+#define asoc_link_to_cpu	snd_soc_link_to_cpu
+#define asoc_link_to_codec	snd_soc_link_to_codec
+#define asoc_link_to_platform	snd_soc_link_to_platform
+
 static inline struct snd_soc_dai_link_component*
-asoc_link_to_cpu(struct snd_soc_dai_link *link, int n) {
+snd_soc_link_to_cpu(struct snd_soc_dai_link *link, int n) {
 	return &(link)->cpus[n];
 }
 
 static inline struct snd_soc_dai_link_component*
-asoc_link_to_codec(struct snd_soc_dai_link *link, int n) {
+snd_soc_link_to_codec(struct snd_soc_dai_link *link, int n) {
 	return &(link)->codecs[n];
 }
 
 static inline struct snd_soc_dai_link_component*
-asoc_link_to_platform(struct snd_soc_dai_link *link, int n) {
+snd_soc_link_to_platform(struct snd_soc_dai_link *link, int n) {
 	return &(link)->platforms[n];
 }
 
 #define for_each_link_codecs(link, i, codec)				\
 	for ((i) = 0;							\
 	     ((i) < link->num_codecs) &&				\
-		     ((codec) = asoc_link_to_codec(link, i));		\
+		     ((codec) = snd_soc_link_to_codec(link, i));		\
 	     (i)++)
 
 #define for_each_link_platforms(link, i, platform)			\
 	for ((i) = 0;							\
 	     ((i) < link->num_platforms) &&				\
-		     ((platform) = asoc_link_to_platform(link, i));	\
+		     ((platform) = snd_soc_link_to_platform(link, i));	\
 	     (i)++)
 
 #define for_each_link_cpus(link, i, cpu)				\
 	for ((i) = 0;							\
 	     ((i) < link->num_cpus) &&					\
-		     ((cpu) = asoc_link_to_cpu(link, i));		\
+		     ((cpu) = snd_soc_link_to_cpu(link, i));		\
 	     (i)++)
 
 /*
@@ -874,8 +879,11 @@ asoc_link_to_platform(struct snd_soc_dai_link *link, int n) {
 #define COMP_CODEC_CONF(_name)		{ .name = _name }
 #define COMP_DUMMY()			{ .name = "snd-soc-dummy", .dai_name = "snd-soc-dummy-dai", }
 
+/* REMOVE ME */
+#define asoc_dummy_dlc		snd_soc_dummy_dlc
+
 extern struct snd_soc_dai_link_component null_dailink_component[0];
-extern struct snd_soc_dai_link_component asoc_dummy_dlc;
+extern struct snd_soc_dai_link_component snd_soc_dummy_dlc;
 
 
 struct snd_soc_codec_conf {
@@ -1087,8 +1095,8 @@ struct snd_soc_pcm_runtime {
 	 * dais = cpu_dai + codec_dai
 	 * see
 	 *	soc_new_pcm_runtime()
-	 *	asoc_rtd_to_cpu()
-	 *	asoc_rtd_to_codec()
+	 *	snd_soc_rtd_to_cpu()
+	 *	snd_soc_rtd_to_codec()
 	 */
 	struct snd_soc_dai **dais;
 
@@ -1116,10 +1124,16 @@ struct snd_soc_pcm_runtime {
 	int num_components;
 	struct snd_soc_component *components[]; /* CPU/Codec/Platform */
 };
+
+/* REMOVE ME */
+#define asoc_rtd_to_cpu		snd_soc_rtd_to_cpu
+#define asoc_rtd_to_codec	snd_soc_rtd_to_codec
+#define asoc_substream_to_rtd	snd_soc_substream_to_rtd
+
 /* see soc_new_pcm_runtime()  */
-#define asoc_rtd_to_cpu(rtd, n)   (rtd)->dais[n]
-#define asoc_rtd_to_codec(rtd, n) (rtd)->dais[n + (rtd)->dai_link->num_cpus]
-#define asoc_substream_to_rtd(substream) \
+#define snd_soc_rtd_to_cpu(rtd, n)   (rtd)->dais[n]
+#define snd_soc_rtd_to_codec(rtd, n) (rtd)->dais[n + (rtd)->dai_link->num_cpus]
+#define snd_soc_substream_to_rtd(substream) \
 	(struct snd_soc_pcm_runtime *)snd_pcm_substream_chip(substream)
 
 #define for_each_rtd_components(rtd, i, component)			\
@@ -1128,11 +1142,11 @@ struct snd_soc_pcm_runtime {
 	     (i)++)
 #define for_each_rtd_cpu_dais(rtd, i, dai)				\
 	for ((i) = 0;							\
-	     ((i) < rtd->dai_link->num_cpus) && ((dai) = asoc_rtd_to_cpu(rtd, i)); \
+	     ((i) < rtd->dai_link->num_cpus) && ((dai) = snd_soc_rtd_to_cpu(rtd, i)); \
 	     (i)++)
 #define for_each_rtd_codec_dais(rtd, i, dai)				\
 	for ((i) = 0;							\
-	     ((i) < rtd->dai_link->num_codecs) && ((dai) = asoc_rtd_to_codec(rtd, i)); \
+	     ((i) < rtd->dai_link->num_codecs) && ((dai) = snd_soc_rtd_to_codec(rtd, i)); \
 	     (i)++)
 #define for_each_rtd_dais(rtd, i, dai)					\
 	for ((i) = 0;							\
diff --git a/sound/soc/soc-utils.c b/sound/soc/soc-utils.c
index 9c746e4edef71..941ba0639a4e6 100644
--- a/sound/soc/soc-utils.c
+++ b/sound/soc/soc-utils.c
@@ -225,12 +225,12 @@ int snd_soc_component_is_dummy(struct snd_soc_component *component)
 		(component->driver == &dummy_codec));
 }
 
-struct snd_soc_dai_link_component asoc_dummy_dlc = {
+struct snd_soc_dai_link_component snd_soc_dummy_dlc = {
 	.of_node	= NULL,
 	.dai_name	= "snd-soc-dummy-dai",
 	.name		= "snd-soc-dummy",
 };
-EXPORT_SYMBOL_GPL(asoc_dummy_dlc);
+EXPORT_SYMBOL_GPL(snd_soc_dummy_dlc);
 
 static int snd_soc_dummy_probe(struct platform_device *pdev)
 {
-- 
2.53.0



