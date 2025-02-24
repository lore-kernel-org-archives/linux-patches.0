Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AC81624CF;
	Mon, 24 Feb 2025 14:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408160; cv=none; b=EG75KvuGYrpwIezXWAwa+N23lhKNdCwHfyw33IV2+5rATgDLPvh8DbytNbsI9ScX6pqK+sQwTMpBRU+BC6cSE8at1k66zgcBM8XI033FVehjMb2nZRXeUjViHlNcFoNNNnAEFFr/m62S1McrdtkBwUMTv76HRBKrGIMXeAnd9Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408160; c=relaxed/simple;
	bh=x+3i/0azM51lYoOjuACFPspbuvSPM3LRixa8g0zE6j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J53Ur3fG2/6Rw96DNNIwf8Ot92X3+VBzeECumbmhv2iitf0M2650vMqwk1VXpCCMHChErfGWBjoZtIy5vqDEwnmiRSSLANZTCowqnlnpZbIq2XRNEmRKIhh3c05uM2xVpxtwNkPe3vTMLfQ19tWv8FJ2XTkF3LC/hBqeSgdiUu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPP5AGuq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPP5AGuq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF8FC4CED6;
	Mon, 24 Feb 2025 14:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408160;
	bh=x+3i/0azM51lYoOjuACFPspbuvSPM3LRixa8g0zE6j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPP5AGuqnxtRw7+dIC56ajIBr0prvILarox746abmwPbv99r0J1PC3IL9Qqvz3Ts3
	 x/v8RNUE10PwG9qJgWRzdQROYAudEsU49aniLiFgavi+UrRtGmkDRJAVY1RrcduJW1
	 A1ghjEfKdsVMto1S2etkLqpKbevIDddyaX3LtMIw=
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
Subject: [PATCH 6.6 117/140] ASoC: SOF: stream-ipc: Check for cstream nullity in sof_ipc_msg_data()
Date: Mon, 24 Feb 2025 15:35:16 +0100
Message-ID: <20250224142607.613911347@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 sound/soc/sof/stream-ipc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/stream-ipc.c b/sound/soc/sof/stream-ipc.c
index 794c7bbccbaf..8262443ac89a 100644
--- a/sound/soc/sof/stream-ipc.c
+++ b/sound/soc/sof/stream-ipc.c
@@ -43,7 +43,7 @@ int sof_ipc_msg_data(struct snd_sof_dev *sdev,
 				return -ESTRPIPE;
 
 			posn_offset = stream->posn_offset;
-		} else {
+		} else if (sps->cstream) {
 
 			struct sof_compr_stream *sstream = sps->cstream->runtime->private_data;
 
@@ -51,6 +51,10 @@ int sof_ipc_msg_data(struct snd_sof_dev *sdev,
 				return -ESTRPIPE;
 
 			posn_offset = sstream->posn_offset;
+
+		} else {
+			dev_err(sdev->dev, "%s: No stream opened\n", __func__);
+			return -EINVAL;
 		}
 
 		snd_sof_dsp_mailbox_read(sdev, posn_offset, p, sz);
-- 
2.48.1



