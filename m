Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622007;
	b=oFbfkKGVDdmaNJqMU43t0i9u2gzLrfRkx1ldhfnG0R7zlcbppk4WqtGfKx9FHXu/Z2HN
	 V8ny2FniiR47lrEzCh0JJzunKG63yCPD4wtGB2169aNXaYYWCM9C9d9+xi8P9TM3IpenO
	 hAqEHQX2TZ68nDJH6WROofUtRzY1mW3keSiAt5XG0phelOpQeRUMW+JsUcsWdH16PC6ZI
	 b+JxR3Vbhw0ZQVGGnEvDZnMgH9W56/47WH2dIkOrofyTMsjRsDtZHbWew2cKe7yBUEnjL
	 E8yzKwxLKP2rn0tiIluN2xsVZRKj4VofXqmaeI9smrrijinngaSELH3wf6r5p/V9n+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pSvqZIRvlmmO2Ts+UhUOJ/4YHfT9Mz5E/tN39dD2hVY=;
	b=I9VUkAfndM3Gb3SF5MOP7IarnnjG54rMFRVWh1cEzl6KItEs17tjjaZhonu5dtmLXAZ+
	 3zPXTBpA1jmE/jQzo6PX8rPU69A70fqV9s2J5vjc2Gs+rvHgjInUvzoalXmfOTn1ZqqmW
	 7Y993GtQKCi5GbkNfHCj8/uP6J5O1orIrV4TMU/9CuZU2dyZCyBJMm9F3eJqdTXosytXy
	 MaYnjrMSPhODLvHp/hpb+Y0JUkoe/JvDRzD9CgWj1mqrRuU8DmogAqjfZx1IP6SEoeLDA
	 7NyzkxUyL8JIXaAaCNrDuWeBhdxdU3imnh9uyKQ2cj0I74cvg02vbZGgJipy0lD6GCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WqGezLoG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241DE606A321;
	Wed, 25 Nov 2026 15:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WqGezLoG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AA01F000C6;
	Wed, 25 Nov 2026 15:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622007;
	bh=pSvqZIRvlmmO2Ts+UhUOJ/4YHfT9Mz5E/tN39dD2hVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WqGezLoGnudFHFuUskoQNl9O2MR/PiP7QglYrO8zu+QXDqJ4zCKmv7wpJ7Rmc69s3
	 8VSCwbRhb13YFkOwVjrcXFrgZXhLCGn7QAUxY0fNWPQUuw2/mOzWVsgZ0j32GJScqj
	 pRpnNa074u/OuUTWouo28ZawLGyzKaTK42lwm9Rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Steev Klimaszewski <threeway@gmail.com>
Subject: [PATCH 6.18 356/990] ASoC: qcom: sdw: remove redundant code
Date: Wed, 25 Nov 2026 15:28:43 +0100
Message-ID: <20261125143830.430231973@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit d02460317ed9c95aa2c5f6ff1c70e22e1857d95d ]

remove redundant code and pointers to handle sdw_stream_runtime by
making use of qcom_snd_sdw_get_stream(). This removes need of machine
specific shutdown and hw_params sdw callbacks and also need to store
sdw_stream_runtime pointers in machine drivers.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Tested-by: Steev Klimaszewski <threeway@gmail.com> # Thinkpad X13s
Link: https://patch.msgid.link/20251022143349.1081513-3-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 704251f9dad3 ("ASoC: qcom: x1e80100: recreate the headset jack on card rebind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/sc8280xp.c | 33 +++------------------------------
 sound/soc/qcom/sdw.c      | 24 ++++++++++++------------
 sound/soc/qcom/sdw.h      |  6 +-----
 sound/soc/qcom/sm8250.c   | 33 +++------------------------------
 sound/soc/qcom/x1e80100.c | 33 +++------------------------------
 5 files changed, 22 insertions(+), 107 deletions(-)

diff --git a/sound/soc/qcom/sc8280xp.c b/sound/soc/qcom/sc8280xp.c
index ed8b04c6022e9..b3f2558c9fb8f 100644
--- a/sound/soc/qcom/sc8280xp.c
+++ b/sound/soc/qcom/sc8280xp.c
@@ -18,7 +18,6 @@
 struct sc8280xp_snd_data {
 	bool stream_prepared[AFE_PORT_MAX];
 	struct snd_soc_card *card;
-	struct sdw_stream_runtime *sruntime[AFE_PORT_MAX];
 	struct snd_soc_jack jack;
 	struct snd_soc_jack dp_jack[8];
 	bool jack_setup;
@@ -68,17 +67,6 @@ static int sc8280xp_snd_init(struct snd_soc_pcm_runtime *rtd)
 	return qcom_snd_wcd_jack_setup(rtd, &data->jack, &data->jack_setup);
 }
 
-static void sc8280xp_snd_shutdown(struct snd_pcm_substream *substream)
-{
-	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
-	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(rtd, 0);
-	struct sc8280xp_snd_data *pdata = snd_soc_card_get_drvdata(rtd->card);
-	struct sdw_stream_runtime *sruntime = qcom_snd_sdw_get_stream(substream);
-
-	pdata->sruntime[cpu_dai->id] = NULL;
-	sdw_release_stream(sruntime);
-}
-
 static int sc8280xp_be_hw_params_fixup(struct snd_soc_pcm_runtime *rtd,
 				     struct snd_pcm_hw_params *params)
 {
@@ -108,25 +96,13 @@ static int sc8280xp_be_hw_params_fixup(struct snd_soc_pcm_runtime *rtd,
 	return 0;
 }
 
-static int sc8280xp_snd_hw_params(struct snd_pcm_substream *substream,
-				struct snd_pcm_hw_params *params)
-{
-	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
-	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(rtd, 0);
-	struct sc8280xp_snd_data *pdata = snd_soc_card_get_drvdata(rtd->card);
-
-	return qcom_snd_sdw_hw_params(substream, params, &pdata->sruntime[cpu_dai->id]);
-}
-
 static int sc8280xp_snd_prepare(struct snd_pcm_substream *substream)
 {
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(rtd, 0);
 	struct sc8280xp_snd_data *data = snd_soc_card_get_drvdata(rtd->card);
-	struct sdw_stream_runtime *sruntime = data->sruntime[cpu_dai->id];
 
-	return qcom_snd_sdw_prepare(substream, sruntime,
-				    &data->stream_prepared[cpu_dai->id]);
+	return qcom_snd_sdw_prepare(substream, &data->stream_prepared[cpu_dai->id]);
 }
 
 static int sc8280xp_snd_hw_free(struct snd_pcm_substream *substream)
@@ -134,16 +110,13 @@ static int sc8280xp_snd_hw_free(struct snd_pcm_substream *substream)
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct sc8280xp_snd_data *data = snd_soc_card_get_drvdata(rtd->card);
 	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(rtd, 0);
-	struct sdw_stream_runtime *sruntime = data->sruntime[cpu_dai->id];
 
-	return qcom_snd_sdw_hw_free(substream, sruntime,
-				    &data->stream_prepared[cpu_dai->id]);
+	return qcom_snd_sdw_hw_free(substream, &data->stream_prepared[cpu_dai->id]);
 }
 
 static const struct snd_soc_ops sc8280xp_be_ops = {
 	.startup = qcom_snd_sdw_startup,
-	.shutdown = sc8280xp_snd_shutdown,
-	.hw_params = sc8280xp_snd_hw_params,
+	.shutdown = qcom_snd_sdw_shutdown,
 	.hw_free = sc8280xp_snd_hw_free,
 	.prepare = sc8280xp_snd_prepare,
 };
diff --git a/sound/soc/qcom/sdw.c b/sound/soc/qcom/sdw.c
index 5f880c74c8dc2..6576b47a4c8c3 100644
--- a/sound/soc/qcom/sdw.c
+++ b/sound/soc/qcom/sdw.c
@@ -124,19 +124,21 @@ int qcom_snd_sdw_startup(struct snd_pcm_substream *substream)
 EXPORT_SYMBOL_GPL(qcom_snd_sdw_startup);
 
 int qcom_snd_sdw_prepare(struct snd_pcm_substream *substream,
-			 struct sdw_stream_runtime *sruntime,
 			 bool *stream_prepared)
 {
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(rtd, 0);
+	struct sdw_stream_runtime *sruntime;
 	int ret;
 
-	if (!sruntime)
-		return 0;
 
 	if (!qcom_snd_is_sdw_dai(cpu_dai->id))
 		return 0;
 
+	sruntime = qcom_snd_sdw_get_stream(substream);
+	if (!sruntime)
+		return 0;
+
 	if (*stream_prepared)
 		return 0;
 
@@ -183,26 +185,24 @@ struct sdw_stream_runtime *qcom_snd_sdw_get_stream(struct snd_pcm_substream *sub
 }
 EXPORT_SYMBOL_GPL(qcom_snd_sdw_get_stream);
 
-int qcom_snd_sdw_hw_params(struct snd_pcm_substream *substream,
-			   struct snd_pcm_hw_params *params,
-			   struct sdw_stream_runtime **psruntime)
+void qcom_snd_sdw_shutdown(struct snd_pcm_substream *substream)
 {
-	*psruntime = qcom_snd_sdw_get_stream(substream);
-
-	return 0;
+	struct sdw_stream_runtime *sruntime = qcom_snd_sdw_get_stream(substream);
 
+	sdw_release_stream(sruntime);
 }
-EXPORT_SYMBOL_GPL(qcom_snd_sdw_hw_params);
+EXPORT_SYMBOL_GPL(qcom_snd_sdw_shutdown);
 
-int qcom_snd_sdw_hw_free(struct snd_pcm_substream *substream,
-			 struct sdw_stream_runtime *sruntime, bool *stream_prepared)
+int qcom_snd_sdw_hw_free(struct snd_pcm_substream *substream, bool *stream_prepared)
 {
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(rtd, 0);
+	struct sdw_stream_runtime *sruntime;
 
 	if (!qcom_snd_is_sdw_dai(cpu_dai->id))
 		return 0;
 
+	sruntime = qcom_snd_sdw_get_stream(substream);
 	if (sruntime && *stream_prepared) {
 		sdw_disable_stream(sruntime);
 		sdw_deprepare_stream(sruntime);
diff --git a/sound/soc/qcom/sdw.h b/sound/soc/qcom/sdw.h
index b8bc5beb05223..061a63f1ac523 100644
--- a/sound/soc/qcom/sdw.h
+++ b/sound/soc/qcom/sdw.h
@@ -7,14 +7,10 @@
 #include <linux/soundwire/sdw.h>
 
 int qcom_snd_sdw_startup(struct snd_pcm_substream *substream);
+void qcom_snd_sdw_shutdown(struct snd_pcm_substream *substream);
 int qcom_snd_sdw_prepare(struct snd_pcm_substream *substream,
-			 struct sdw_stream_runtime *runtime,
 			 bool *stream_prepared);
 struct sdw_stream_runtime *qcom_snd_sdw_get_stream(struct snd_pcm_substream *stream);
-int qcom_snd_sdw_hw_params(struct snd_pcm_substream *substream,
-			   struct snd_pcm_hw_params *params,
-			   struct sdw_stream_runtime **psruntime);
 int qcom_snd_sdw_hw_free(struct snd_pcm_substream *substream,
-			 struct sdw_stream_runtime *sruntime,
 			 bool *stream_prepared);
 #endif
diff --git a/sound/soc/qcom/sm8250.c b/sound/soc/qcom/sm8250.c
index ce5b0059207f1..203a8705a42fe 100644
--- a/sound/soc/qcom/sm8250.c
+++ b/sound/soc/qcom/sm8250.c
@@ -21,7 +21,6 @@
 struct sm8250_snd_data {
 	bool stream_prepared[AFE_PORT_MAX];
 	struct snd_soc_card *card;
-	struct sdw_stream_runtime *sruntime[AFE_PORT_MAX];
 	struct snd_soc_jack jack;
 	struct snd_soc_jack usb_offload_jack;
 	bool usb_offload_jack_setup;
@@ -112,36 +111,13 @@ static int sm8250_snd_startup(struct snd_pcm_substream *substream)
 	return qcom_snd_sdw_startup(substream);
 }
 
-static void sm8250_snd_shutdown(struct snd_pcm_substream *substream)
-{
-	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
-	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(rtd, 0);
-	struct sm8250_snd_data *data = snd_soc_card_get_drvdata(rtd->card);
-	struct sdw_stream_runtime *sruntime = qcom_snd_sdw_get_stream(substream);
-
-	data->sruntime[cpu_dai->id] = NULL;
-	sdw_release_stream(sruntime);
-}
-
-static int sm8250_snd_hw_params(struct snd_pcm_substream *substream,
-				struct snd_pcm_hw_params *params)
-{
-	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
-	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(rtd, 0);
-	struct sm8250_snd_data *pdata = snd_soc_card_get_drvdata(rtd->card);
-
-	return qcom_snd_sdw_hw_params(substream, params, &pdata->sruntime[cpu_dai->id]);
-}
-
 static int sm8250_snd_prepare(struct snd_pcm_substream *substream)
 {
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(rtd, 0);
 	struct sm8250_snd_data *data = snd_soc_card_get_drvdata(rtd->card);
-	struct sdw_stream_runtime *sruntime = data->sruntime[cpu_dai->id];
 
-	return qcom_snd_sdw_prepare(substream, sruntime,
-				    &data->stream_prepared[cpu_dai->id]);
+	return qcom_snd_sdw_prepare(substream, &data->stream_prepared[cpu_dai->id]);
 }
 
 static int sm8250_snd_hw_free(struct snd_pcm_substream *substream)
@@ -149,16 +125,13 @@ static int sm8250_snd_hw_free(struct snd_pcm_substream *substream)
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct sm8250_snd_data *data = snd_soc_card_get_drvdata(rtd->card);
 	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(rtd, 0);
-	struct sdw_stream_runtime *sruntime = data->sruntime[cpu_dai->id];
 
-	return qcom_snd_sdw_hw_free(substream, sruntime,
-				    &data->stream_prepared[cpu_dai->id]);
+	return qcom_snd_sdw_hw_free(substream, &data->stream_prepared[cpu_dai->id]);
 }
 
 static const struct snd_soc_ops sm8250_be_ops = {
 	.startup = sm8250_snd_startup,
-	.shutdown = sm8250_snd_shutdown,
-	.hw_params = sm8250_snd_hw_params,
+	.shutdown = qcom_snd_sdw_shutdown,
 	.hw_free = sm8250_snd_hw_free,
 	.prepare = sm8250_snd_prepare,
 };
diff --git a/sound/soc/qcom/x1e80100.c b/sound/soc/qcom/x1e80100.c
index 2e3599516aa2a..a3f4785c4bbe6 100644
--- a/sound/soc/qcom/x1e80100.c
+++ b/sound/soc/qcom/x1e80100.c
@@ -18,7 +18,6 @@
 struct x1e80100_snd_data {
 	bool stream_prepared[AFE_PORT_MAX];
 	struct snd_soc_card *card;
-	struct sdw_stream_runtime *sruntime[AFE_PORT_MAX];
 	struct snd_soc_jack jack;
 	struct snd_soc_jack dp_jack[8];
 	bool jack_setup;
@@ -50,17 +49,6 @@ static int x1e80100_snd_init(struct snd_soc_pcm_runtime *rtd)
 	return qcom_snd_wcd_jack_setup(rtd, &data->jack, &data->jack_setup);
 }
 
-static void x1e80100_snd_shutdown(struct snd_pcm_substream *substream)
-{
-	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
-	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(rtd, 0);
-	struct x1e80100_snd_data *data = snd_soc_card_get_drvdata(rtd->card);
-	struct sdw_stream_runtime *sruntime = qcom_snd_sdw_get_stream(substream);
-
-	data->sruntime[cpu_dai->id] = NULL;
-	sdw_release_stream(sruntime);
-}
-
 static int x1e80100_be_hw_params_fixup(struct snd_soc_pcm_runtime *rtd,
 				     struct snd_pcm_hw_params *params)
 {
@@ -85,16 +73,6 @@ static int x1e80100_be_hw_params_fixup(struct snd_soc_pcm_runtime *rtd,
 	return 0;
 }
 
-static int x1e80100_snd_hw_params(struct snd_pcm_substream *substream,
-				struct snd_pcm_hw_params *params)
-{
-	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
-	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(rtd, 0);
-	struct x1e80100_snd_data *data = snd_soc_card_get_drvdata(rtd->card);
-
-	return qcom_snd_sdw_hw_params(substream, params, &data->sruntime[cpu_dai->id]);
-}
-
 static int x1e80100_snd_hw_map_channels(unsigned int *ch_map, int num)
 {
 	switch (num) {
@@ -128,7 +106,6 @@ static int x1e80100_snd_prepare(struct snd_pcm_substream *substream)
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(rtd, 0);
 	struct x1e80100_snd_data *data = snd_soc_card_get_drvdata(rtd->card);
-	struct sdw_stream_runtime *sruntime = data->sruntime[cpu_dai->id];
 	unsigned int channels = substream->runtime->channels;
 	unsigned int rx_slot[4];
 	int ret;
@@ -149,8 +126,7 @@ static int x1e80100_snd_prepare(struct snd_pcm_substream *substream)
 		break;
 	}
 
-	return qcom_snd_sdw_prepare(substream, sruntime,
-				    &data->stream_prepared[cpu_dai->id]);
+	return qcom_snd_sdw_prepare(substream, &data->stream_prepared[cpu_dai->id]);
 }
 
 static int x1e80100_snd_hw_free(struct snd_pcm_substream *substream)
@@ -158,16 +134,13 @@ static int x1e80100_snd_hw_free(struct snd_pcm_substream *substream)
 	struct snd_soc_pcm_runtime *rtd = snd_soc_substream_to_rtd(substream);
 	struct x1e80100_snd_data *data = snd_soc_card_get_drvdata(rtd->card);
 	struct snd_soc_dai *cpu_dai = snd_soc_rtd_to_cpu(rtd, 0);
-	struct sdw_stream_runtime *sruntime = data->sruntime[cpu_dai->id];
 
-	return qcom_snd_sdw_hw_free(substream, sruntime,
-				    &data->stream_prepared[cpu_dai->id]);
+	return qcom_snd_sdw_hw_free(substream, &data->stream_prepared[cpu_dai->id]);
 }
 
 static const struct snd_soc_ops x1e80100_be_ops = {
 	.startup = qcom_snd_sdw_startup,
-	.shutdown = x1e80100_snd_shutdown,
-	.hw_params = x1e80100_snd_hw_params,
+	.shutdown = qcom_snd_sdw_shutdown,
 	.hw_free = x1e80100_snd_hw_free,
 	.prepare = x1e80100_snd_prepare,
 };
-- 
2.53.0



