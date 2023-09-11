Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CDE11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4A4FC433C7;
	Mon, 11 Sep 2023 14:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443484;
	bh=WMzxKv07JmEvhvbEfG0UYktuuSIaOk/A5Flzw+wffb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZmrhzbavs2JR7Pi3Vj0YrfKaZs/Lql6ZgW39TNFztCVZqgmmYkhDwfEU+GV/jLqX
	 pduD8tyT3z3fkXfT4eIhAQ5IEJy4eIeJPbgrtqI3H7rbD6aIzicbn5e46MSt30ha8p
	 u/pg0e7691hPN9KJb5D5L7/WzzWe+Yh+Z61hfAZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Rander Wang <rander.wang@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 366/737] ASoC: SOF: Intel: fix u16/32 confusion in LSDIID
Date: Mon, 11 Sep 2023 15:43:45 +0200
Message-ID: <20230911134700.763342515@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 7a52d7062e02af4a479da24b40cfd76b54c0cd6c ]

Likely a combination of copy-paste and test coverage problem. Oops.

Fixes: 87a6ddc0cf1c ("ASoC: SOF: Intel: hda-mlink: program SoundWire LSDIID registers")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Link: https://lore.kernel.org/r/20230807210959.506849-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-mlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sof/intel/hda-mlink.c b/sound/soc/sof/intel/hda-mlink.c
index acad3ea2f4710..df87b3791c23e 100644
--- a/sound/soc/sof/intel/hda-mlink.c
+++ b/sound/soc/sof/intel/hda-mlink.c
@@ -331,14 +331,14 @@ static bool hdaml_link_check_cmdsync(u32 __iomem *lsync, u32 cmdsync_mask)
 	return !!(val & cmdsync_mask);
 }
 
-static void hdaml_link_set_lsdiid(u32 __iomem *lsdiid, int dev_num)
+static void hdaml_link_set_lsdiid(u16 __iomem *lsdiid, int dev_num)
 {
-	u32 val;
+	u16 val;
 
-	val = readl(lsdiid);
+	val = readw(lsdiid);
 	val |= BIT(dev_num);
 
-	writel(val, lsdiid);
+	writew(val, lsdiid);
 }
 
 static void hdaml_shim_map_stream_ch(u16 __iomem *pcmsycm, int lchan, int hchan,
-- 
2.40.1



