Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1022305043;
	Mon, 13 Oct 2025 15:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369774; cv=none; b=HjqQPqs9l6gw+BuC5Spbs6QhE1XOwNJC+0k4ww7bmBkuQu5zTALQn2i+QJgJzKTuhq9AUox9dYMRGLOAFULu/HJpFjj1d+/mD6LetsE4UOO6jM4LaZyUpycrHgqGlQy9zaXwvGO3JP2FHAk3vFLDgq66j172EZreHLtmSPE6OLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369774; c=relaxed/simple;
	bh=YD5mi5yEhATSXwTJPV8OsckCqccbd/ZzFmaFd6hVx0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W8R5emZlqWtRO+q22fXKuQdwjjJmtlb29/kl8LftE0rlvpSN9UVXdFN/r2MKVqO22tIP98y+32dgaxCDwDHe5ALlZcgFuAe7hm4e2WpGDe6c3xeSgezAeB0sfgdfnUnFEzcjfRoVGVTi8fcTxfFy4MrixjpnROktyeEMkKbuZJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukkL/3ms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukkL/3ms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7E5C4CEE7;
	Mon, 13 Oct 2025 15:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369773;
	bh=YD5mi5yEhATSXwTJPV8OsckCqccbd/ZzFmaFd6hVx0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukkL/3msMv86b6BKCluZZo9W8/OdTCDNkrfInsO/6nZLKJxwTiA9VqUBn0QqzcuGA
	 ZdIcy68qqdEASqbMq/o552X3hv9uof6aXnhyryHC2bG/dAjmMvfDk9gqbbcXUpXriw
	 qNDsZNpZquH05uYWZn5ViLL+jymuV1JfYSlaP5cE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 363/563] ASoC: Intel: hda-sdw-bpt: set persistent_buffer false
Date: Mon, 13 Oct 2025 16:43:44 +0200
Message-ID: <20251013144424.429307020@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 8b184c34806e5da4d4847fabd3faeff38b47e70a ]

The persistent_buffer agreement is false when hda_cl_prepare() is
called. We should use the same value when hda_cl_cleanup() is called.

Fixes: 5d5cb86fb46ea ("ASoC: SOF: Intel: hda-sdw-bpt: add helpers for SoundWire BPT DMA")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20250915024853.1153518-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-sdw-bpt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/intel/hda-sdw-bpt.c b/sound/soc/sof/intel/hda-sdw-bpt.c
index 1327f1cad0bcd..ff5abccf0d88b 100644
--- a/sound/soc/sof/intel/hda-sdw-bpt.c
+++ b/sound/soc/sof/intel/hda-sdw-bpt.c
@@ -150,7 +150,7 @@ static int hda_sdw_bpt_dma_deprepare(struct device *dev, struct hdac_ext_stream
 	u32 mask;
 	int ret;
 
-	ret = hda_cl_cleanup(sdev->dev, dmab_bdl, true, sdw_bpt_stream);
+	ret = hda_cl_cleanup(sdev->dev, dmab_bdl, false, sdw_bpt_stream);
 	if (ret < 0) {
 		dev_err(sdev->dev, "%s: SDW BPT DMA cleanup failed\n",
 			__func__);
-- 
2.51.0



