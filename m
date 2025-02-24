Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B78927701;
	Mon, 24 Feb 2025 14:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408782; cv=none; b=pGrLe27rgzIgNeg5oiq3epQZDoVDccEPBj+OEymamaSuK3QfjWkL06KMvMCeZcqSXo4pO8Z5veVpLVpkDV1GZO9HQjTk6Wwu81xaSXh5ZYkwfjRYUscAhP8WHyuBVCHFAuZz5TLuE2On3jfK7iQWRTlj4hQ3iFFkte0IJui6YcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408782; c=relaxed/simple;
	bh=xR2dnc63Qppt4W9Am2y9jBBJQItYXb/I4dlvD8O6v5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gdj1dcML9bMr3ARJ0qoDHqXfIsZxa/vzmBLFH6KQQJ3dsOTBAAakwKWHokQ/IEkyoXppn6rnCs958g2xW1so126A5pHuTWzIovirmUWPdnZXZZ7yocSc91GOS71juZi5tV1avUD7sAxuTpkG290W/L1DUsozk2pw3dl3gyJwaek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ix0fabdq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ix0fabdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7171DC4CED6;
	Mon, 24 Feb 2025 14:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408781;
	bh=xR2dnc63Qppt4W9Am2y9jBBJQItYXb/I4dlvD8O6v5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ix0fabdqAq173Fu5pz4dzJp10gtxfjTs+ioNb3oIjIXhAXsVn8zbqxq79Bn3FQF3r
	 2tQXqimDpP4oK60lagqAxS6XKrnSwcYNwiaEcWKhYaLYt+Sa6k23emLkgEZKZbXJ1f
	 0RJySQUiUlDQ1xbf8y56HQGuKzki+xpVmRTgr52U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Curtis Malainey <cujomalainey@chromium.org>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 129/154] ASoC: SOF: stream-ipc: Check for cstream nullity in sof_ipc_msg_data()
Date: Mon, 24 Feb 2025 15:35:28 +0100
Message-ID: <20250224142612.100314032@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit d8d99c3b5c485f339864aeaa29f76269cc0ea975 upstream.

The nullity of sps->cstream should be checked similarly as it is done in
sof_set_stream_data_offset() function.
Assuming that it is not NULL if sps->stream is NULL is incorrect and can
lead to NULL pointer dereference.

Fixes: 090349a9feba ("ASoC: SOF: Add support for compress API for stream data/offset")
Cc: stable@vger.kernel.org
Reported-by: Curtis Malainey <cujomalainey@chromium.org>
Closes: https://github.com/thesofproject/linux/pull/5214
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Curtis Malainey <cujomalainey@chromium.org>
Link: https://patch.msgid.link/20250205135232.19762-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/stream-ipc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/soc/sof/stream-ipc.c
+++ b/sound/soc/sof/stream-ipc.c
@@ -43,7 +43,7 @@ int sof_ipc_msg_data(struct snd_sof_dev
 				return -ESTRPIPE;
 
 			posn_offset = stream->posn_offset;
-		} else {
+		} else if (sps->cstream) {
 
 			struct sof_compr_stream *sstream = sps->cstream->runtime->private_data;
 
@@ -51,6 +51,10 @@ int sof_ipc_msg_data(struct snd_sof_dev
 				return -ESTRPIPE;
 
 			posn_offset = sstream->posn_offset;
+
+		} else {
+			dev_err(sdev->dev, "%s: No stream opened\n", __func__);
+			return -EINVAL;
 		}
 
 		snd_sof_dsp_mailbox_read(sdev, posn_offset, p, sz);


