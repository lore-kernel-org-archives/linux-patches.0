Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36348403EA1;
	Wed, 20 May 2026 18:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302961; cv=none; b=l9nUSsc7E+YW6e1PIaXK17b5zxEIe2BeRKhdhEI23R8XKoBnbP+XyhSpeRAECdrT9KRPvXghWqAdBi3sqwopDjMQVH1iS1tPFz6htzONhTGzgMvDSlHWr5aNroXIYIkq4iA6FdCQqFjcJ+lg6pXC6A8kOcjilYq1zpgS1N7Rqy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302961; c=relaxed/simple;
	bh=Tnzx5gf8CW+u7HM1dv9SQlS+Y5m48FtjQX8WE9CxlOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oNFsFuHEPlbVYbmS/Gzm6XyuFCinHvtjxt0DqVUAECnS2FnNT15h/90u69GnuUpy0rTvvoJkCtqyEnqQ0LA/jLGTsu9tbH3pk6gBdsByDS2M9GiDHb0sDOt8BP99QKhmKDVJHKlhAq7dn9WSTxCIjaKCx0s7lWRC4Nn5QQ9muOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYkDPe9v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYkDPe9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6E51F00893;
	Wed, 20 May 2026 18:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302959;
	bh=FN9BgxFacAJFYi2773N6wn2kqb8jJ0dic6UfogL3T2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYkDPe9vVb7Ly7XKcrBPoYnAZD/kKmDOc6pRKJMEPFV8iWfyvEeLxK5PW+KSb+AK2
	 wVMkrHh7dZSSZL6xA1es8qSzfU1NQqUanSBVhv9jFeoP9XpS8JNvPqpBDUmT0kyF7v
	 pepz62mNYZsjo5keRhKkdHHHPplUcETFYGhPuJEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Alva Lan <alvalan9@foxmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 464/508] ASoC: SOF: Intel: hda-dai: add support for dspless mode beyond HDAudio
Date: Wed, 20 May 2026 18:24:47 +0200
Message-ID: <20260520162108.652119405@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 2065610b5ddd5b58eed1dc3b3c3db27a26ebd4b6 ]

For SoundWire/ALH, we need to have a dai configured, but we don't want
to send a DMA_TLV to firmware. Add additional code branches.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://msgid.link/r/20240213101247.28887-16-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Alva Lan <alvalan9@foxmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-dai.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/hda-dai.c b/sound/soc/sof/intel/hda-dai.c
index f5bfa17bf6505..1fe7cce160913 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -83,6 +83,11 @@ hda_dai_get_ops(struct snd_pcm_substream *substream, struct snd_soc_dai *cpu_dai
 
 	sdev = widget_to_sdev(w);
 
+	if (!swidget) {
+		dev_err(sdev->dev, "%s: swidget is NULL\n", __func__);
+		return NULL;
+	}
+
 	if (sdev->dspless_mode_selected)
 		return hda_select_dai_widget_ops(sdev, swidget);
 
@@ -364,8 +369,11 @@ static int non_hda_dai_hw_params(struct snd_pcm_substream *substream,
 		return ret;
 	}
 
-	/* get stream_id */
 	sdev = widget_to_sdev(w);
+	if (sdev->dspless_mode_selected)
+		goto skip_tlv;
+
+	/* get stream_id */
 	hext_stream = ops->get_hext_stream(sdev, cpu_dai, substream);
 
 	if (!hext_stream) {
@@ -398,6 +406,7 @@ static int non_hda_dai_hw_params(struct snd_pcm_substream *substream,
 	dma_config->dma_stream_channel_map.device_count = 0; /* mapping not used */
 	dma_config->dma_priv_config_size = 0;
 
+skip_tlv:
 	return 0;
 }
 
-- 
2.53.0



