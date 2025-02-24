Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2619E2629F;
	Mon, 24 Feb 2025 14:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408174; cv=none; b=WLeBa/WQPNTRbRWRFy6wmreIEzGA+csYlRAKejpYmbrZBzIP+tQakluupIdgLv5XI+zbEd2eNbz3q0P4If7lezHHGJoWvL8hZHxhPx3jDPEP+uNVTpHzLcXWbK7A1fe6tdzPr203HF52ZMIjmTtXSGP29N7VQ6MGUJKS7d1fPss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408174; c=relaxed/simple;
	bh=HYKGFCG/aFiIXMHRYKyskx8Jhyt634/OynlS4gDsiag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+g8/D1awVy1N5b7K4NH/T94nfy5/Hx4ej+l6ZeNeJGllSBafKVxO/h8AxyHS1gSyh0f4HZBoAMXgfAPHyDFbH1qH2YziMa6vlKfp5v+b5xJXLAxSQDZC9sHd4qMycPEYOft6aI+wNUB/Ot2+26fzO+SO3QWu7n8A5VC6plcPBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQ90Txx5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQ90Txx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D221C4CED6;
	Mon, 24 Feb 2025 14:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408174;
	bh=HYKGFCG/aFiIXMHRYKyskx8Jhyt634/OynlS4gDsiag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQ90Txx5bp64ZXf0yo0QbXqmyCai90wg39m53CdFQZndBWAgTUxgg048EAeJgSLa3
	 86c/3btZvsvW2pZxcr1ea6hc5ShIyDQ/2O4uq8HLJKGpYjX/85gXdoFaN9pSEYPoJP
	 lFm6KMXf3ZnDsDMxxYdovHUCECkooUqz1wjpctFU=
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
Subject: [PATCH 6.6 121/140] ASoC: SOF: pcm: Clear the susbstream pointer to NULL on close
Date: Mon, 24 Feb 2025 15:35:20 +0100
Message-ID: <20250224142607.769895538@linuxfoundation.org>
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
@@ -507,6 +507,8 @@ static int sof_pcm_close(struct snd_soc_
 		 */
 	}
 
+	spcm->stream[substream->stream].substream = NULL;
+
 	return 0;
 }
 


