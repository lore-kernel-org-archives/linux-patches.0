Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F06352927;
	Tue,  6 Jan 2026 17:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721481; cv=none; b=KPrE3HOshQI9GZXXRF0iJk1nCQ6hyd9NqXe7ZLEq9VK1IBEdtS9b0PuAhhNJqSIFPJepPrKWoBpFwOOxLVgVR6TOj9HtS34mcV61pboqZTa9dJZOYtnOxFs3h/uNRx5AnsRy6ZsvQVKyn4uvB07pESvGUWSFBXrAE9+ZDpgW7aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721481; c=relaxed/simple;
	bh=osA5yX1bWY8l80jJOqNpCvDewHoWuMl2i7Ldrr4mlmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gTRdPBHQlhOJ8BLi01zMkMjlp8NmUjZqro1tbfTx9A6hfI4WWpOnuq3HWQln8J4Wbw8C5i35a2Jbr7MH804ZuSyciRImmyQzWOmqpiHkp5ykTpjJ0qpxglY8E7DBpub8TX/oz2+uYOIllniKGUPqfMHayKIbQRnAmcsr2ZicOdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XpR3jMDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpR3jMDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75470C19424;
	Tue,  6 Jan 2026 17:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721481;
	bh=osA5yX1bWY8l80jJOqNpCvDewHoWuMl2i7Ldrr4mlmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XpR3jMDMz5shYvdz82hl9JviaM/HsL0zGMFt68UBGUuOOAv7MG58YrOAbHXoHviZ0
	 HP6yLfiluhWl9H/zd1BTTlp3IIHcRQxkv/GpZUrjr0XHXPucbJmVUHrRqFvEXY0n0t
	 F94H7LvAnqN+BikqlK0m6fFUFExZD8Uo7N4XAAPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	shumingf@realtek.com,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 549/567] soundwire: stream: extend sdw_alloc_stream() to take type parameter
Date: Tue,  6 Jan 2026 18:05:31 +0100
Message-ID: <20260106170511.719559355@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>

[ Upstream commit dc90bbefa792031d89fe2af9ad4a6febd6be96a9 ]

In the existing definition of sdw_stream_runtime, the 'type' member is
never set and defaults to PCM. To prepare for the BPT/BRA support, we
need to special-case streams and make use of the 'type'.

No functional change for now, the implicit PCM type is now explicit.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Tested-by: shumingf@realtek.com
Link: https://lore.kernel.org/r/20250227140615.8147-5-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: bcba17279327 ("ASoC: qcom: sdw: fix memory leak for sdw_stream_runtime")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/driver-api/soundwire/stream.rst |    2 +-
 drivers/soundwire/stream.c                    |    6 ++++--
 include/linux/soundwire/sdw.h                 |    2 +-
 sound/soc/qcom/sdw.c                          |    2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)

--- a/Documentation/driver-api/soundwire/stream.rst
+++ b/Documentation/driver-api/soundwire/stream.rst
@@ -291,7 +291,7 @@ per stream. From ASoC DPCM framework, th
 
 .. code-block:: c
 
-  int sdw_alloc_stream(char * stream_name);
+  int sdw_alloc_stream(char * stream_name, enum sdw_stream_type type);
 
 The SoundWire core provides a sdw_startup_stream() helper function,
 typically called during a dailink .startup() callback, which performs
--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -1744,12 +1744,13 @@ static int set_stream(struct snd_pcm_sub
  * sdw_alloc_stream() - Allocate and return stream runtime
  *
  * @stream_name: SoundWire stream name
+ * @type: stream type (could be PCM ,PDM or BPT)
  *
  * Allocates a SoundWire stream runtime instance.
  * sdw_alloc_stream should be called only once per stream. Typically
  * invoked from ALSA/ASoC machine/platform driver.
  */
-struct sdw_stream_runtime *sdw_alloc_stream(const char *stream_name)
+struct sdw_stream_runtime *sdw_alloc_stream(const char *stream_name, enum sdw_stream_type type)
 {
 	struct sdw_stream_runtime *stream;
 
@@ -1761,6 +1762,7 @@ struct sdw_stream_runtime *sdw_alloc_str
 	INIT_LIST_HEAD(&stream->master_list);
 	stream->state = SDW_STREAM_ALLOCATED;
 	stream->m_rt_count = 0;
+	stream->type = type;
 
 	return stream;
 }
@@ -1789,7 +1791,7 @@ int sdw_startup_stream(void *sdw_substre
 	if (!name)
 		return -ENOMEM;
 
-	sdw_stream = sdw_alloc_stream(name);
+	sdw_stream = sdw_alloc_stream(name, SDW_STREAM_PCM);
 	if (!sdw_stream) {
 		dev_err(rtd->dev, "alloc stream failed for substream DAI %s\n", substream->name);
 		ret = -ENOMEM;
--- a/include/linux/soundwire/sdw.h
+++ b/include/linux/soundwire/sdw.h
@@ -1024,7 +1024,7 @@ struct sdw_stream_runtime {
 	int m_rt_count;
 };
 
-struct sdw_stream_runtime *sdw_alloc_stream(const char *stream_name);
+struct sdw_stream_runtime *sdw_alloc_stream(const char *stream_name, enum sdw_stream_type type);
 void sdw_release_stream(struct sdw_stream_runtime *stream);
 
 int sdw_compute_params(struct sdw_bus *bus);
--- a/sound/soc/qcom/sdw.c
+++ b/sound/soc/qcom/sdw.c
@@ -27,7 +27,7 @@ int qcom_snd_sdw_startup(struct snd_pcm_
 	struct snd_soc_dai *codec_dai;
 	int ret, i;
 
-	sruntime = sdw_alloc_stream(cpu_dai->name);
+	sruntime = sdw_alloc_stream(cpu_dai->name, SDW_STREAM_PCM);
 	if (!sruntime)
 		return -ENOMEM;
 


