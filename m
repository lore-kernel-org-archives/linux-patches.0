Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8277338F253;
	Sat, 17 Oct 2026 16:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254668; cv=none; b=ua/X/av77vaNeWCEEn0o0dtiScRvy++N3XiL5MJQbbOug8/4C+vK2OFvs9rMiPySIRbV10L+FAppD5sd07cDWw0q5WB720ZF8O3ub+YP0/zKw/LNI+rQraoYscnySzy7LSG14qNk34Wm8RExGvhXTlNQATwWjfd+O6ZsrLvx0sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254668; c=relaxed/simple;
	bh=YhFjrU25w75g3EjkGqg6JL9t1BdmBvQRHdgChpLq4JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVIg5NnMZkfsZ9Nh9UlQ2I2b7BY49o+CQh61lDYXx8v8Vi4pEMsJP3lf4lhT4vdkwtVeDRmXfFzpfA3Zj3A7EZ9B/g6fZhUB1oiVJVQsZfH7A3uQKcF+WsA+9XHHq57alrsqv8fLmA+S/y3SL+dcS/cfLkZqNv7Z5bDXwunajLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxXN6Wgy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxXN6Wgy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723CE1F000C5;
	Sat, 17 Oct 2026 16:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254667;
	bh=72WICmzPoj4P4UJqZv1DE9P+/stX00ntTJx2IixGUbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uxXN6Wgy6eEd6b4iRu3noPjRLI/1W2ms0jksO6/5kZVL1TE0kBLP42iBgvzwXxgTc
	 ivtiUAY8ahTTzZ2cqPaAHYdHJ2+ybUyGmUD1MfsaJIu3SedxGi1U6/UGvDdGD7BsXb
	 MZ6lmyjLAgXqza1PatPAStMI/dTlCoznQF2r0EcQ=
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
Subject: [PATCH 6.12 523/869] ASoC: SOF: pcm: Move period/buffer configuration print after platform open
Date: Sat, 17 Oct 2026 17:56:04 +0200
Message-ID: <20261017160050.523011383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
---
 sound/soc/sof/pcm.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/sound/soc/sof/pcm.c b/sound/soc/sof/pcm.c
index 61bd690b29fa5..cba6d0b67999e 100644
--- a/sound/soc/sof/pcm.c
+++ b/sound/soc/sof/pcm.c
@@ -536,15 +536,6 @@ static int sof_pcm_open(struct snd_soc_component *component,
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
 
@@ -554,10 +545,21 @@ static int sof_pcm_open(struct snd_soc_component *component,
 	spcm->prepared[substream->stream] = false;
 
 	ret = snd_sof_pcm_platform_open(sdev, substream);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(component->dev, "error: pcm open failed %d\n", ret);
+		return ret;
+	}
 
-	return ret;
+	dev_dbg(component->dev, "period bytes min %zd, max %zd\n",
+		runtime->hw.period_bytes_min,
+		runtime->hw.period_bytes_max);
+	dev_dbg(component->dev, "period count min %d, max %d\n",
+		runtime->hw.periods_min,
+		runtime->hw.periods_max);
+	dev_dbg(component->dev, "buffer bytes max %zd\n",
+		runtime->hw.buffer_bytes_max);
+
+	return 0;
 }
 
 static int sof_pcm_close(struct snd_soc_component *component,
-- 
2.53.0



