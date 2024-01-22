Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488C25662;
	Tue, 23 Jan 2024 00:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969499; cv=none; b=OORzscuUm7F+IcKct7adB4JV+REBoqauYfH+CQeZNV9sHXqzo13BeagHU2I6DUW4ELkYJG4piNDmiUMsEJU3HD44sjOW5ieLVRLmOqQzQv1MmaFuZZc7+O6LAftRGW93IYbAu4YIxiS9ixTXZiOLaXNbFADIC4HOQ5YxPZH4lT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969499; c=relaxed/simple;
	bh=hFatx0c08Wa63R1h887QiFpT/uIRS9Wae8LisAriOc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tiacjhlhRB8zRLCK7y7JWwCU/HrmlFdFvpd8a98kSV9fflv0nJHtPNh/jGbcIgAuL+sxCg3meWZtx0x9KReCWMronLgVylAAm9ja2baV0txwY1S9gVqbJf3rJfKUF/842XzTg5X1nH5rEDNPFXByJGopMKsHvd2eRGhtUZFxnPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPDYhldN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPDYhldN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EB2C43390;
	Tue, 23 Jan 2024 00:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969499;
	bh=hFatx0c08Wa63R1h887QiFpT/uIRS9Wae8LisAriOc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPDYhldNjEYiZOq87L9hoTgSytpoiMJ7xCoFPI8NBJ4v0LwFe2VCURRW7/t/oqfAr
	 j4R3NEWFH3S9beojcAZ7B94Hk0jkWJWa130/HpXk1SyokzkaHJA7ssfkd6LSQ6T3Vj
	 UMo78ueoDLYPhbOesK1BuTurQhEAU6EDRGMAw6cE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 285/641] ASoC: Intel: sof_sdw_rt_sdca_jack_common: ctx->headset_codec_dev = NULL
Date: Mon, 22 Jan 2024 15:53:09 -0800
Message-ID: <20240122235826.811020198@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit e38e252dbceeef7d2f848017132efd68e9ae1416 ]

sof_sdw_rt_sdca_jack_exit() are used by different codecs, and some of
them use the same dai name.
For example, rt712 and rt713 both use "rt712-sdca-aif1" and
sof_sdw_rt_sdca_jack_exit().
As a result, sof_sdw_rt_sdca_jack_exit() will be called twice by
mc_dailink_exit_loop(). Set ctx->headset_codec_dev = NULL; after
put_device(ctx->headset_codec_dev); to avoid ctx->headset_codec_dev
being put twice.

Fixes: 5360c6704638 ("ASoC: Intel: sof_sdw: add rt712 support")
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20231204214200.203100-5-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw_rt_sdca_jack_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/boards/sof_sdw_rt_sdca_jack_common.c b/sound/soc/intel/boards/sof_sdw_rt_sdca_jack_common.c
index 65bbcee88d6d..49a513399dc4 100644
--- a/sound/soc/intel/boards/sof_sdw_rt_sdca_jack_common.c
+++ b/sound/soc/intel/boards/sof_sdw_rt_sdca_jack_common.c
@@ -168,6 +168,7 @@ int sof_sdw_rt_sdca_jack_exit(struct snd_soc_card *card, struct snd_soc_dai_link
 
 	device_remove_software_node(ctx->headset_codec_dev);
 	put_device(ctx->headset_codec_dev);
+	ctx->headset_codec_dev = NULL;
 
 	return 0;
 }
-- 
2.43.0



