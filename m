Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFAA714A62A;
	Mon, 24 Feb 2025 14:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409177; cv=none; b=M9MxJhCmhsTkcw09i2LG7HgoKoe6NUcWcoRz2egx2hHa/GW9uwS0xUU7DTi6RQ2M2D1eerVODGxHnEWPC8qSbhkAnarE+nyASH/D4D1LQUqHjBMKX/BuNUD7qjQsKtEXtcv150KIprEkdiLBOLnfNDuWduEf2BWc864TmTy+GzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409177; c=relaxed/simple;
	bh=K/+A7olelVRerV/cv20XkOTKFudQmEmuOw9lwURW4mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTlLeThYSDiCN6Q1X0KBXkL3uRKBWGAr0mbttMGBxWcix7pFMLwuWnVnoa6YffDflifR93BnwvijqRomXAtWtT/re0irppIy50GX0E8xeVF66PbB9EsuKAhO/Th3WfKxCg8+1vEYwgslqT6U+ogzPkBftG1+4PCJ0jxzpNi9R2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QaTFBtkY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QaTFBtkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6F3C4CEE8;
	Mon, 24 Feb 2025 14:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409177;
	bh=K/+A7olelVRerV/cv20XkOTKFudQmEmuOw9lwURW4mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QaTFBtkY0mlp+7gfgML9J50wkzsVkGNboDTaipMGlZ2MKubiMzerME2xHgxhA5miK
	 OmNB05XyQrkQhLxmLVaCUuTBV1zWXd89Ntw7Omk28uqVvaLfM8wfb4Bh5QMDFkuBgd
	 6d/sBYU/G0StFX33ss3PaXJTWojx/B45TgQi4oYE=
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
Subject: [PATCH 6.13 119/138] ASoC: SOF: pcm: Clear the susbstream pointer to NULL on close
Date: Mon, 24 Feb 2025 15:35:49 +0100
Message-ID: <20250224142609.151684636@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 46c7b901e2a03536df5a3cb40b3b26e2be505df6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/pcm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/sof/pcm.c
+++ b/sound/soc/sof/pcm.c
@@ -511,6 +511,8 @@ static int sof_pcm_close(struct snd_soc_
 		 */
 	}
 
+	spcm->stream[substream->stream].substream = NULL;
+
 	return 0;
 }
 


