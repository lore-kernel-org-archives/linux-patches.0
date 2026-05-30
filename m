Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EABA33B6C4;
	Sat, 30 May 2026 17:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162127; cv=none; b=i2x0NiQpHNriQTiILOp9XahTrWu98XfbtlQo0jsOjLxcelHiYIA+lxJeNTZM7bvOvL/OLpmHHhO00SMYOU9PZcvpA/9xWHyPS1I7EEgFEN4LSs+QcDQ7coh1unXvL60k54G0APD95vV4p5FmlVW5tjlBBFm1iqAjhkZgX2OmcO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162127; c=relaxed/simple;
	bh=DVrxANCn8hsen9wHmWCLbxWI3R0ZQEduL7fFXGRHZo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpFagVtfP10eEI6I8G4yIWygVX7h1roXy2BWTIcaiI2T9OolwFdycnn1N3ku2uvGIoFaEldsxrnon3coS4fg9x83QtEffkQro4tSVJ6sMnq4dodhXY1lnOoQArV8uy3Z9PirZAsaXXsmGrLZxQKrTQMyluQ/d9ujvSJ7yv7ZMLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mgiekmUo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mgiekmUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EAE21F00893;
	Sat, 30 May 2026 17:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162126;
	bh=XyRgICvxE4WT7Qu0kqsivYkWM8EHhdZZOA1ejy2RFl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mgiekmUoj5GGcxkWZNZ37zw7VShM7PyeX3uYOWqdmfRD39Kw4mTcmG+pooiQ/6nc9
	 rYTIsnc2fymRRZE2xZiQh3rWPp+rFJpMFZB7Wk+9DKTSQrt94WV3nAxDU8/3XROTGc
	 ve5h8MGekwOsB+B9Q4c0liFcql5qZffWJUrCnOJk=
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
Subject: [PATCH 6.1 799/969] ASoC: SOF: pcm: Clear the susbstream pointer to NULL on close
Date: Sat, 30 May 2026 18:05:23 +0200
Message-ID: <20260530160322.688944148@linuxfoundation.org>
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

[ Upstream commit 46c7b901e2a03536df5a3cb40b3b26e2be505df6 ]

The spcm->stream[substream->stream].substream is set during open and was
left untouched. After the first PCM stream it will never be NULL and we
have code which checks for substream NULLity as indication if the stream is
active or not.
For the compressed cstream pointer the same has been done, this change will
correct the handling of PCM streams.

Fixes: 090349a9feba ("ASoC: SOF: Add support for compress API for stream data/offset")
Cc: stable@vger.kernel.org
Reported-by: Curtis Malainey <cujomalainey@chromium.org>
Closes: https://github.com/thesofproject/linux/pull/5214
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Curtis Malainey <cujomalainey@chromium.org>
Link: https://patch.msgid.link/20250205135232.19762-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/pcm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sof/pcm.c b/sound/soc/sof/pcm.c
index be6f38af37b5d..c2cb005285e3f 100644
--- a/sound/soc/sof/pcm.c
+++ b/sound/soc/sof/pcm.c
@@ -484,6 +484,8 @@ static int sof_pcm_close(struct snd_soc_component *component,
 		 */
 	}
 
+	spcm->stream[substream->stream].substream = NULL;
+
 	return 0;
 }
 
-- 
2.53.0



