Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC60879F0;
	Mon,  8 Apr 2024 13:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583969; cv=none; b=LNzXC38XVJ1SER+QGhDGHnhWphcgGmR+P3it4eU4NCrNt90/JK/qvnsr1AkFFHIegxsYbecBP3p3bnTNibXoUUZs/znsNdh4NJz0/BS53EBu53cRk/0UIUXvEoYUqKOaQtckS3xm6ht4JrnuLF2l2L9WI+HsVf12LOsNSTUiRbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583969; c=relaxed/simple;
	bh=hXnLleezAG9gR4XyagoUi7wHIkKXNKbozjoNsGu5XPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gaR6KeJhUAtl65riZxMPrWGbtwwjCYdBeoCWiXZ6QdO1q8yqFBwehuK0egB6DM6CtGyHCQJzF1pZKuYfhEhGDfDS0MJabTwRsYmo325/JSsqv2AmDd5HjbYRVSJUvcblC89UxyH2mrRkB4jVPAZerfs6t8M5nFSZnV7/1PbUPPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vX7cLfNj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vX7cLfNj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36628C433F1;
	Mon,  8 Apr 2024 13:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583969;
	bh=hXnLleezAG9gR4XyagoUi7wHIkKXNKbozjoNsGu5XPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vX7cLfNjove8UWjgr0pVp9ijTMrRL610IoJAitY63LUmnTCpOkbIF9FtT8qLoR+Hm
	 OedWioCKG5074qTDQFCEV2XiAh5AAhc0E4JhQAD4FXrF4Lvwd1ZRykj9XnP9q6q3+i
	 8Y/y41AUb/tT5xMJgfrNVD+Rn1LU/rw3zi4hTkdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.8 221/273] ASoC: SOF: Remove the get_stream_position callback
Date: Mon,  8 Apr 2024 14:58:16 +0200
Message-ID: <20240408125316.266235344@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 07007b8ac42cffc23043d00e56b0f67a75dc4b22 upstream.

The get_stream_position has been replaced by get_dai_frame_counter and all
related code can be dropped form the core.

Cc: stable@vger.kernel.org # 6.8
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://msgid.link/r/20240321130814.4412-11-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ops.h      |   10 ----------
 sound/soc/sof/sof-priv.h |    9 ---------
 2 files changed, 19 deletions(-)

--- a/sound/soc/sof/ops.h
+++ b/sound/soc/sof/ops.h
@@ -523,16 +523,6 @@ static inline int snd_sof_pcm_platform_a
 	return 0;
 }
 
-static inline u64 snd_sof_pcm_get_stream_position(struct snd_sof_dev *sdev,
-						  struct snd_soc_component *component,
-						  struct snd_pcm_substream *substream)
-{
-	if (sof_ops(sdev) && sof_ops(sdev)->get_stream_position)
-		return sof_ops(sdev)->get_stream_position(sdev, component, substream);
-
-	return 0;
-}
-
 static inline u64
 snd_sof_pcm_get_dai_frame_counter(struct snd_sof_dev *sdev,
 				  struct snd_soc_component *component,
--- a/sound/soc/sof/sof-priv.h
+++ b/sound/soc/sof/sof-priv.h
@@ -255,15 +255,6 @@ struct snd_sof_dsp_ops {
 	int (*pcm_ack)(struct snd_sof_dev *sdev, struct snd_pcm_substream *substream); /* optional */
 
 	/*
-	 * optional callback to retrieve the link DMA position for the substream
-	 * when the position is not reported in the shared SRAM windows but
-	 * instead from a host-accessible hardware counter.
-	 */
-	u64 (*get_stream_position)(struct snd_sof_dev *sdev,
-				   struct snd_soc_component *component,
-				   struct snd_pcm_substream *substream); /* optional */
-
-	/*
 	 * optional callback to retrieve the number of frames left/arrived from/to
 	 * the DSP on the DAI side (link/codec/DMIC/etc).
 	 *


