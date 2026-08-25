Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260E3400994;
	Tue, 25 Aug 2026 13:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665776; cv=none; b=lJ8YNQmF4VEcr1O+osTB7Kl79HHsS8enpIRTtsuhIwd6trmZd5U4pPpmDYBRdZgtcypZF2WyfEuDeMwvpciKp99UB2uXladz0s3mL91FurBqPw8g9WqX58HnvDhyyeVQRLJ30NryO4vg4eVchGtG/1KC8afpwybeRwtvW4SSeps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665776; c=relaxed/simple;
	bh=NxJBZ9SHAXYp6jgzkSObdXTqunPbI1r22WZVvoK9pHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t8ZoBjDAB2z8dxFqSvTNGZrTowCODN++AA142jxxk1O2lsolhHWsww0oMM3/JYNCNIIUIPbMD1A3LkmB3fZChGhTZLa9HNijIqfnGBrscnksfiPURliQcZ1bgFL+23i1OYYkqRYdi8kCVu5aBVAipDWqodQRUGopOZ+7RynKGag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhjG0u+R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhjG0u+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C191F000E9;
	Tue, 25 Aug 2026 13:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665775;
	bh=e3dGFBhTFQAv6fbAGnjdBKHmrc6q7vgwqyLTandBBZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nhjG0u+RWVncCWGFGw0NtqIgUemQrokwDFNeDjeubvc2o4tlP6YlHewG6L4J9ddcB
	 C8wTv9VpTFsa8GbM2hjq6hIv4XZEXComGLh8GjTCf9QQ9+kmv6TpIEBWWWketj6rrO
	 r0vbrvoyzulW2RNBsG/e3CE6tXlwq2hnphZ+LijY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 59/87] ASoC: SOF: pcm: Move period/buffer configuration print after platform open
Date: Tue, 25 Aug 2026 15:26:22 +0200
Message-ID: <20260825132544.146169550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 4d2ea16576c8aa1437048cf436bff85653f139fe ]

The platform specific pcm_open call via snd_sof_pcm_platform_open() can
modify the initial buffer configuration via constraints.

Move the prints as last step in the sof_pcm_open() function to reflect the
final setup.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://patch.msgid.link/20250206092828.7569-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 17661c67b206 ("ASoC: SOF: ipc4-pcm: Continue the pipeline trigger in case of IPC timeout")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/pcm.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/sound/soc/sof/pcm.c
+++ b/sound/soc/sof/pcm.c
@@ -519,15 +519,6 @@ static int sof_pcm_open(struct snd_soc_c
 	 */
 	runtime->hw.buffer_bytes_max = le32_to_cpu(caps->buffer_size_max);
 
-	dev_dbg(component->dev, "period min %zd max %zd bytes\n",
-		runtime->hw.period_bytes_min,
-		runtime->hw.period_bytes_max);
-	dev_dbg(component->dev, "period count %d max %d\n",
-		runtime->hw.periods_min,
-		runtime->hw.periods_max);
-	dev_dbg(component->dev, "buffer max %zd bytes\n",
-		runtime->hw.buffer_bytes_max);
-
 	/* set wait time - TODO: come from topology */
 	substream->wait_time = 500;
 
@@ -537,10 +528,21 @@ static int sof_pcm_open(struct snd_soc_c
 	spcm->prepared[substream->stream] = false;
 
 	ret = snd_sof_pcm_platform_open(sdev, substream);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(component->dev, "error: pcm open failed %d\n", ret);
+		return ret;
+	}
+
+	dev_dbg(component->dev, "period bytes min %zd, max %zd\n",
+		runtime->hw.period_bytes_min,
+		runtime->hw.period_bytes_max);
+	dev_dbg(component->dev, "period count min %d, max %d\n",
+		runtime->hw.periods_min,
+		runtime->hw.periods_max);
+	dev_dbg(component->dev, "buffer bytes max %zd\n",
+		runtime->hw.buffer_bytes_max);
 
-	return ret;
+	return 0;
 }
 
 static int sof_pcm_close(struct snd_soc_component *component,


