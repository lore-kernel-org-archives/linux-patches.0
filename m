Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651207D414;
	Mon,  8 Apr 2024 13:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583789; cv=none; b=h7jmj/mMnhR97vX9dBGgJWA96ZwvAb56/3bsRIR+WFylBURwfsjoPm7YFwUhES9xBX6AMVvKiI0ASxyzfvWx6o/MnDPF1UMXGwnp/vEg3oEfPVcjY4V1gyHT8qfW87QuwOchCFupzI+nweotJa6nmhj2cbgfr8+xnD+zdgsaYPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583789; c=relaxed/simple;
	bh=L1f0ankWjk8cVffmAezo81gnONLIjxy/AZdt94fQTic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7xlFt2pL82CZJVj3CIoVZS7LzMfRfteFCFtlTwkFTbemdonBgAwr1tBFtoYRodo/JRs/KKc0AhSCC12VEYvJ2w7AoKAoafEIGey5/ljNe9Y3HuekttWGY0DePQpYpIeBPM5pKfu4eBXC469WIq0/lAPf4fN+6QwUJg7gW4nvG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YcJhPbcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YcJhPbcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF911C433F1;
	Mon,  8 Apr 2024 13:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583789;
	bh=L1f0ankWjk8cVffmAezo81gnONLIjxy/AZdt94fQTic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YcJhPbcFpVAl9qyQxWBNC3eEja8vE/mLKNZbhCLBhf5KiY4sMAT+dgQzSN0pnum6A
	 eJp7FjVpR/uG0yrguvSsd8nj4XmfhlbMhO0Xn50beYzWejiPUhx/CbnV1ASH941m+c
	 N8xsCHuTXEcFl8ycQ8r0gPBEwUVoqG7T1zWbeSsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.8 219/273] ASoC: SOF: Intel: hda-common-ops: Do not set the get_stream_position callback
Date: Mon,  8 Apr 2024 14:58:14 +0200
Message-ID: <20240408125316.192769819@linuxfoundation.org>
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

commit 4ab6c38c664442c1fc9911eb3c5c6953d3dbcca5 upstream.

The get_stream_position has been replaced by get_dai_frame_counter, it
should not be set to allow it to be dropped from core code.

Cc: stable@vger.kernel.org # 6.8
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://msgid.link/r/20240321130814.4412-10-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/hda-common-ops.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/sof/intel/hda-common-ops.c b/sound/soc/sof/intel/hda-common-ops.c
index 4d7ea18604ee..d71bb66b9991 100644
--- a/sound/soc/sof/intel/hda-common-ops.c
+++ b/sound/soc/sof/intel/hda-common-ops.c
@@ -57,7 +57,6 @@ struct snd_sof_dsp_ops sof_hda_common_ops = {
 	.pcm_pointer	= hda_dsp_pcm_pointer,
 	.pcm_ack	= hda_dsp_pcm_ack,
 
-	.get_stream_position = hda_dsp_get_stream_llp,
 	.get_dai_frame_counter = hda_dsp_get_stream_llp,
 	.get_host_byte_counter = hda_dsp_get_stream_ldp,
 
-- 
2.44.0



