Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E8E267B05;
	Sat, 30 May 2026 17:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162130; cv=none; b=YpQGEhRIHryNPjddESHh48v0CmVCGuVtOHVog83txioYfjCpMGzEypIwxtUlPbB4OzQ+O8gqcuoPjmyloORPBkKU7nt56dwJHllnBj/ASnmd617h7vM5CmOCuf6qxVkepY7fuNcMBP9Q/93/PNSNHsklrF72wieoG5ArzU1thcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162130; c=relaxed/simple;
	bh=N7zuIq136JwEM1EGMm0JeWp8LM7dmNFllVRxh5RaWcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i79BcGFklWYuYslIqALgktfinY/ZNdAXc1ngPmHpR7i9e9PlKHRa6MVQXmZ1ho9UteoNKuatgD0TDroTTg8jxVKbjAG/LZiiM48Ez3y+txP2HCkrP9Dmcz/McWzQu0ty2NO/aJz+BrkyhjygESKTD8ph45oL7GHWcl+aQkA+6JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXCQW3rQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXCQW3rQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E041F00893;
	Sat, 30 May 2026 17:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162129;
	bh=YXws0JolffewAVhka/JRQ52MtWUY2kyJ8u/pZ5EWYKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AXCQW3rQyCtP3ein1CndAlYvuSeoDnhAUkJ/SEzVJT22YK8b4z6+qIXieoU86g+vw
	 D8McBr65rZq7AJWwu5uRlR8bpa0LjOUqRgBzN8hdza2teMS7/ely5lpXC1Gdg5Xwgb
	 7yuI5P0KPvnvORf8TEYx0Hy+ht1kMsQAg85GJxbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Curtis Malainey <cujomalainey@chromium.org>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 800/969] ASoC: SOF: stream-ipc: Check for cstream nullity in sof_ipc_msg_data()
Date: Sat, 30 May 2026 18:05:24 +0200
Message-ID: <20260530160322.720120321@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit d8d99c3b5c485f339864aeaa29f76269cc0ea975 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/stream-ipc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/sof/stream-ipc.c b/sound/soc/sof/stream-ipc.c
index 216b454f6b94e..3edcb0ea38488 100644
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
2.53.0



