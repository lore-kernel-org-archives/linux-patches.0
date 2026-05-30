Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E993148DA;
	Sat, 30 May 2026 17:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161172; cv=none; b=IylyZtEAYFSlPhbl8pIqcGKLcbNXM5/UkEUR2AVKfNhJYpzBvz4bJbyWgHwQfQ1kr5jWPq/Hc17QRlDSEEWW3iaQRMS4Q22Uvnx7mcYl36cp2v20Kj9BAT/2J4TidsTju+gN89YplfY3UAGSh8zricuQ1syMyNbJIAJaouoVSCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161172; c=relaxed/simple;
	bh=zdLp2Je3KMpJnlLWJ+2EvHSBy8pA/Yi/ZbFdGHAGhD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6K8felp1gOrUGNlDGAYCq7Wzw45Lu/51cqc+MQnFoQf51QWpfON5xz5qmjLPZ2FW5Qv2q+A+ajljd7WD/I/edsrOFb62UE2Pk/FEd+T2FVqbUzlcTqSj/5aMVRvlUztTDoTqHIWXcbYFxE9hEfTtWZKJdks7zZs3exal2BeXMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qTSSoHIq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qTSSoHIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EA41F00893;
	Sat, 30 May 2026 17:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161171;
	bh=ZGr7JSxegmNJbtaHXBoVp8cT+ijYZlvSZRIhvRCk4SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qTSSoHIqKheYszUetAoBxtd22HgZFw1G8HCq4kQ7IbOSyyE3QEM2LiX2+BN3YpDwy
	 jEAKE0Q2RpmymgaTTlCuF8ZoBpuIIIIQ1Z0ZFWNTfUuy4am9EI9k5yIiBqw1BEGNXz
	 QL6NgsqBqBnZ8IjsBlZeyxaxYJoPIg+pfFqARe/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Olaru <paul.olaru@nxp.com>,
	Iuliana Prodan <iuliana.prodan@nxp.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 547/969] ASoC: SOF: Add support for compress API for stream data/offset
Date: Sat, 30 May 2026 18:01:11 +0200
Message-ID: <20260530160315.479710202@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Baluta <daniel.baluta@nxp.com>

[ Upstream commit 090349a9feba3ceee3997d31d68ffe54e5b57acb ]

snd_sof_pcm_stream keeps information about both PCM (snd_pcm_substream)
and Compress (snd_compr_stream) streams.

When PCM substream pointer is NULL this means we are dealing with a
compress stream.

Reviewed-by: Paul Olaru <paul.olaru@nxp.com>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://lore.kernel.org/r/20230117122533.201708-4-daniel.baluta@oss.nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 2c4fdd055f92 ("ASoC: SOF: compress: return the configured codec from get_params")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-priv.h   |  1 +
 sound/soc/sof/stream-ipc.c | 48 ++++++++++++++++++++++++++++----------
 2 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/sound/soc/sof/sof-priv.h b/sound/soc/sof/sof-priv.h
index d7f4f828f38f9..6f5b06473011d 100644
--- a/sound/soc/sof/sof-priv.h
+++ b/sound/soc/sof/sof-priv.h
@@ -112,6 +112,7 @@ struct sof_compr_stream {
 	u32 sampling_rate;
 	u16 channels;
 	u16 sample_container_bytes;
+	size_t posn_offset;
 };
 
 struct snd_sof_dev;
diff --git a/sound/soc/sof/stream-ipc.c b/sound/soc/sof/stream-ipc.c
index 872a49550672c..216b454f6b94e 100644
--- a/sound/soc/sof/stream-ipc.c
+++ b/sound/soc/sof/stream-ipc.c
@@ -33,14 +33,27 @@ int sof_ipc_msg_data(struct snd_sof_dev *sdev,
 	if (!sps || !sdev->stream_box.size) {
 		snd_sof_dsp_mailbox_read(sdev, sdev->dsp_box.offset, p, sz);
 	} else {
-		struct snd_pcm_substream *substream = sps->substream;
-		struct sof_stream *stream = substream->runtime->private_data;
+		size_t posn_offset;
 
-		/* The stream might already be closed */
-		if (!stream)
-			return -ESTRPIPE;
+		if (sps->substream) {
+			struct sof_stream *stream = sps->substream->runtime->private_data;
 
-		snd_sof_dsp_mailbox_read(sdev, stream->posn_offset, p, sz);
+			/* The stream might already be closed */
+			if (!stream)
+				return -ESTRPIPE;
+
+			posn_offset = stream->posn_offset;
+		} else {
+
+			struct sof_compr_stream *sstream = sps->cstream->runtime->private_data;
+
+			if (!sstream)
+				return -ESTRPIPE;
+
+			posn_offset = sstream->posn_offset;
+		}
+
+		snd_sof_dsp_mailbox_read(sdev, posn_offset, p, sz);
 	}
 
 	return 0;
@@ -51,18 +64,29 @@ int sof_set_stream_data_offset(struct snd_sof_dev *sdev,
 			       struct snd_sof_pcm_stream *sps,
 			       size_t posn_offset)
 {
-	struct snd_pcm_substream *substream = sps->substream;
-	struct sof_stream *stream = substream->runtime->private_data;
-
 	/* check if offset is overflow or it is not aligned */
 	if (posn_offset > sdev->stream_box.size ||
 	    posn_offset % sizeof(struct sof_ipc_stream_posn) != 0)
 		return -EINVAL;
 
-	stream->posn_offset = sdev->stream_box.offset + posn_offset;
+	posn_offset += sdev->stream_box.offset;
+
+	if (sps->substream) {
+		struct sof_stream *stream = sps->substream->runtime->private_data;
+
+		stream->posn_offset = posn_offset;
+		dev_dbg(sdev->dev, "pcm: stream dir %d, posn mailbox offset is %zu",
+			sps->substream->stream, posn_offset);
+	} else if (sps->cstream) {
+		struct sof_compr_stream *sstream = sps->cstream->runtime->private_data;
 
-	dev_dbg(sdev->dev, "pcm: stream dir %d, posn mailbox offset is %zu",
-		substream->stream, stream->posn_offset);
+		sstream->posn_offset = posn_offset;
+		dev_dbg(sdev->dev, "compr: stream dir %d, posn mailbox offset is %zu",
+			sps->cstream->direction, posn_offset);
+	} else {
+		dev_err(sdev->dev, "No stream opened");
+		return -EINVAL;
+	}
 
 	return 0;
 }
-- 
2.53.0



