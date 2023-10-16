Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310FD1D55F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGLukQc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86623C433C9;
	Mon, 16 Oct 2023 14:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467646;
	bh=PWmzVR5UzgKfK0iTbZX8a8SY2OBSELg6gaOP675oAGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGLukQc9y32a/B2VmonF8sOi3rpETQcCg+8MttYi2ggSEb597Olq9T07zwGNxKUa6
	 6iW1CKAfOcHhBRwy2+Va2V1LODJ1WUVcZe/1qx9JrFDVz4rX/zRvtCJrml5PvmU18O
	 deuuszOUezbhZqFNRyMSpWybqEeOZthRajS1loKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.5 032/191] ASoC: simple-card-utils: fixup simple_util_startup() error handling
Date: Mon, 16 Oct 2023 10:40:17 +0200
Message-ID: <20231016084016.149307573@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

commit 69cf63b6560205a390a736b88d112374655adb28 upstream.

It should use "goto" instead of "return"

Fixes: 5ca2ab459817 ("ASoC: simple-card-utils: Add new system-clock-fixed flag")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/202309141205.ITZeDJxV-lkp@intel.com/
Closes: https://lore.kernel.org/all/202309151840.au9Aa2W4-lkp@intel.com/
Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/r/87v8c76jnz.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/generic/simple-card-utils.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/generic/simple-card-utils.c
+++ b/sound/soc/generic/simple-card-utils.c
@@ -310,7 +310,8 @@ int asoc_simple_startup(struct snd_pcm_s
 		if (fixed_sysclk % props->mclk_fs) {
 			dev_err(rtd->dev, "fixed sysclk %u not divisible by mclk_fs %u\n",
 				fixed_sysclk, props->mclk_fs);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto codec_err;
 		}
 		ret = snd_pcm_hw_constraint_minmax(substream->runtime, SNDRV_PCM_HW_PARAM_RATE,
 			fixed_rate, fixed_rate);


