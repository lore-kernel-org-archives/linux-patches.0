Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AA567E8F;
	Tue, 23 Jan 2024 02:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975315; cv=none; b=VzLFFt62jlDoYg7knJYfFjDNJUz5Q2JwUqQJY4MmZ2SHLeFfVwpV4FxuL3ArSdJ6f+QQWggMd0cjEhzWv+Go5QAyUyKpRv7lfypj7OOVnS22Hqh/EVpemEw2UJGZ6KXSya4y10Vkfrru/R604b3dGQhl2I822PepHaeV/tqxtWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975315; c=relaxed/simple;
	bh=BWffboewXo8GnCIx5SkQDwELr28xd2QbgQB3X6tDJno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oNdnLyoxseoXJxEeB28ue7qWFj80PnPn2s0LsUYycR7bL6giD8mmSRmh8GF0LJMhC8Hlt+SXjoGrnMkTxykIruHBPVq69cig6aTQlZwqdBl6Rlqt8wqD45pyLWG+voWAD19FOtJPkBNEATyhWzkWnkXXUb8ekhF5+fxP0kKOpyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFNMZQwt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFNMZQwt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FD5C433A6;
	Tue, 23 Jan 2024 02:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975315;
	bh=BWffboewXo8GnCIx5SkQDwELr28xd2QbgQB3X6tDJno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFNMZQwtHfjylB+aCtX6c57PsHp3nRCAYMrkYT34lsObhm+CJS9RQWxY9F96NrPZ/
	 G3Fcn0ae19gZ0tsBFWxX5A8LMjeQzLMkf7CMv2ODbJikzfVEKvlol1N8E7T8J/SZJK
	 y7mzRx5ZK6yqbkbzYGO0iRf129C9i2bFJWaza6EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 256/583] ASoC: Intel: sof_sdw_rt_sdca_jack_common: ctx->headset_codec_dev = NULL
Date: Mon, 22 Jan 2024 15:55:07 -0800
Message-ID: <20240122235819.840319719@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4360b9f5ff2c..890517eb63f6 100644
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



