Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCCD79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7D9C433C1;
	Wed, 30 Nov 2022 18:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834348;
	bh=tTRqSFCJTHRzOvtXKah9zhdHqr2wucnOMBEYIBD4rws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ksr4qPfmkLlQaaZ0omFFVpOT8NPPZ4W57/SRWuMLT9xKy94i68Mrs60KTfbjuYx7t
	 IEuYWv/2nFCn7+MxE6ADPJFmcDLoBIx4v3RXx7scE5DmpXjPwv62EL1z/l9ISeqf6U
	 /lr3LxJ3eadi78ynnIMO84sWZBplyvGaiYTWNf98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 220/289] ASoC: SOF: Fix compilation when HDA_AUDIO_CODEC config is disabled
Date: Wed, 30 Nov 2022 19:23:25 +0100
Message-Id: <20221130180549.105721404@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cezary Rojewski <cezary.rojewski@intel.com>

commit 1cda83e42bf66beb06bf61c7a78951ec0c028898 upstream.

hda_codec_device_init() expects three parameters, not two.

Fixes: 3fd63658caed ("ASoC: Intel: Drop hdac_ext usage for codec device creation")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Acked-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20220819124740.3564862-1-cezary.rojewski@intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/hda-codec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/sof/intel/hda-codec.c
+++ b/sound/soc/sof/intel/hda-codec.c
@@ -213,7 +213,7 @@ out:
 		put_device(&codec->core.dev);
 	}
 #else
-	codec = hda_codec_device_init(&hbus->core, address);
+	codec = hda_codec_device_init(&hbus->core, address, HDA_DEV_ASOC);
 	ret = PTR_ERR_OR_ZERO(codec);
 #endif
 


