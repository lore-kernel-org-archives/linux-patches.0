Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BD0199939
	for <patches@lists.linux.dev>; Wed, 21 Aug 2024 13:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724245417; cv=none; b=fPFtmuUcGOtAsCKTcOsYxQg5962RzAImID98WxHw8WCr4fW3A5qnHOa+ih8+pYpKR7GkTEeSpMQbP03rDtp4OmlurRjUHFKgaQWM5pbt1KFZPdPpPVeJqsrg2NO2vB64sseXEd9RD1AUyVlkzY1OucRANgCAQurb5Lcf/3ErDL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724245417; c=relaxed/simple;
	bh=tgQPJPpNAfsACxBCqDnQfbT/weDbVlMexLgIB9A0hJU=;
	h=From:To:CC:Date:Message-ID:MIME-Version:Content-Type:Subject; b=oqr5xB5lNvJp6CP6SEQk4ggk3StSYKznAoiSV7r+Osu9USS/lkWvTdD2rZHEBpRwbxpx757859XdRE6aWfJl6nopzh+oXOWTkvdFjsSUBhKs22kGICoPJ4Yhw+lIyuA4bV+8DmaWzP5o6O3+TMBW5X/xyTTVaucxuw33xemIvOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=n805qDsq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="n805qDsq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C107C32782
	for <patches@lists.linux.dev>; Wed, 21 Aug 2024 13:03:35 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="n805qDsq"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Wed, 21 Aug 2024 14:03:33 +0100
Resent-Message-ID: <ZsXlpWzuX0AkaOO8@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 21 Aug 2024 08:26:42 +0100
Received: from nyc.source.kernel.org ([2604:1380:45d1:ec00::3])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=iWmQ=PU=ti.com=baojun.xu@kernel.org>)
	id 1sgfjs-00C2nj-Ga
	for broonie@sirena.co.uk; Wed, 21 Aug 2024 08:26:42 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 11D51A41010
	for <broonie@sirena.co.uk>; Wed, 21 Aug 2024 07:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 670D8C32786; Wed, 21 Aug 2024 07:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8A6B5C32782
	for <broonie@kernel.org>; Wed, 21 Aug 2024 07:26:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 8A6B5C32782
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=ti.com
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 47L7Q5K5077423;
	Wed, 21 Aug 2024 02:26:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1724225165;
	bh=lOR+k15BENW2qTRzzlqe296w6aa0s5HlZQhvkuznWH8=;
	h=From:To:CC:Subject:Date;
	b=n805qDsq+h1TqpsmFGBeYk0F+vtYI9oxFSsy4LWEi1s2UGYWypLYLYi8xEUsDl8QO
	 hmD5kszKzsJWXmjI/b8kthjSM4HitPFO/s38XNQTVj/hnYxIyx+GPhHtoDVNWpYTxU
	 IWirymJuAdIFjq5aq923T0+J8mS9iNSjkHpbkkKI=
Received: from DLEE105.ent.ti.com (dlee105.ent.ti.com [157.170.170.35])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 47L7Q52U001130
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 21 Aug 2024 02:26:05 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Wed, 21
 Aug 2024 02:26:04 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Wed, 21 Aug 2024 02:26:04 -0500
Received: from lelvsmtp6.itg.ti.com ([10.250.165.138])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 47L7Pqbk034829;
	Wed, 21 Aug 2024 02:25:53 -0500
From: Baojun Xu <baojun.xu@ti.com>
To: <broonie@kernel.org>
CC: <andriy.shevchenko@linux.intel.com>, <lgirdwood@gmail.com>,
        <perex@perex.cz>, <pierre-louis.bossart@linux.intel.com>,
        <13916275206@139.com>, <zhourui@huaqin.com>,
        <alsa-devel@alsa-project.org>, <i-salazar@ti.com>,
        <liam.r.girdwood@intel.com>, <jaden-yue@ti.com>,
        <yung-chuan.liao@linux.intel.com>, <dipa@ti.com>, <yuhsuan@google.com>,
        <henry.lo@ti.com>, <tiwai@suse.de>, <baojun.xu@ti.com>,
        <Baojun.Xu@fpt.com>, <judyhsiao@google.com>, <navada@ti.com>,
        <cujomalainey@google.com>, <aanya@ti.com>, <nayeem.mahmud@ti.com>,
        <savyasanchi.shukla@netradyne.com>, <flaviopr@microsoft.com>,
        <jesse-ji@ti.com>, <darren.ye@mediatek.com>, <antheas.dk@gmail.com>,
        <Jerry2.Huang@lcfuturecenter.com>, <jim.shil@goertek.com>
Date: Wed, 21 Aug 2024 15:25:27 +0800
Message-ID: <20240821072527.1294-1-baojun.xu@ti.com>
X-Mailer: git-send-email 2.43.0.windows.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-SA-Exim-Connect-IP: 2604:1380:45d1:ec00::3
X-SA-Exim-Mail-From: SRS0=iWmQ=PU=ti.com=baojun.xu@kernel.org
Subject: [PATCH v1] ASoC: tas2781: Remove unnecessary line feed for tasdevice_codec_remove
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: 5RFRoKNXPopF

Remove unnecessary line feed for tasdevice_codec_remove.
Add comma at the end the last member of the array.

Signed-off-by: Baojun Xu <baojun.xu@ti.com>

---
v1:
---
 sound/soc/codecs/tas2781-i2c.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/tas2781-i2c.c b/sound/soc/codecs/tas2781-i2c.c
index 9a32e0504857..eb8732b1bb99 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -582,13 +582,13 @@ static const struct snd_soc_dapm_widget tasdevice_dapm_widgets[] = {
 		SND_SOC_DAPM_POST_PMU | SND_SOC_DAPM_PRE_PMD),
 	SND_SOC_DAPM_SPK("SPK", tasdevice_dapm_event),
 	SND_SOC_DAPM_OUTPUT("OUT"),
-	SND_SOC_DAPM_INPUT("DMIC")
+	SND_SOC_DAPM_INPUT("DMIC"),
 };
 
 static const struct snd_soc_dapm_route tasdevice_audio_map[] = {
 	{"SPK", NULL, "ASI"},
 	{"OUT", NULL, "SPK"},
-	{"ASI OUT", NULL, "DMIC"}
+	{"ASI OUT", NULL, "DMIC"},
 };
 
 static int tasdevice_startup(struct snd_pcm_substream *substream,
@@ -730,8 +730,7 @@ static void tasdevice_deinit(void *context)
 	tas_priv->fw_state = TASDEVICE_DSP_FW_PENDING;
 }
 
-static void tasdevice_codec_remove(
-	struct snd_soc_component *codec)
+static void tasdevice_codec_remove(struct snd_soc_component *codec)
 {
 	struct tasdevice_priv *tas_priv = snd_soc_component_get_drvdata(codec);
 
-- 
2.43.0

