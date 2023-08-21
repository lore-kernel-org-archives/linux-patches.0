Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A451171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58543C433CB;
	Mon, 21 Aug 2023 20:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648009;
	bh=ALB/MI+MZj1ushqSM7e160C8jWUpJbO9XbUq0MqBWh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVAf1NECbyXMThHjJ9RHtsdQdUpkBUjqCPDEEfrd95c39zElnHnNgQu2BCZAv2oIT
	 pErSRv+FMTg1bnAujOGwhB9FUfmJbPf9dnCTMI9nPnZlG6zVcAz26xXOp3aEhH0iNN
	 xbUI3+kF1OeDyr2BiqjZEgx+clMKfNKueU0rFKu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 022/234] ASoC: Intel: sof_sdw: add quick for Dell SKU 0BDA
Date: Mon, 21 Aug 2023 21:39:45 +0200
Message-ID: <20230821194129.741587485@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 3daf02819ac3fd8d7605804a00213cf123ac880d ]

The SKU numbering isn't quite consistent with the existing RaptorLake
SKUs but the PCI ID is definitively RaptorLake.

Closes: https://github.com/thesofproject/linux/issues/4380
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20230602202225.249209-17-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/sof_sdw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 1a37f4cdc0ea7..b0b6a084837a7 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -367,6 +367,16 @@ static const struct dmi_system_id sof_sdw_quirk_table[] = {
 					RT711_JD2),
 	},
 	/* RaptorLake devices */
+	{
+		.callback = sof_sdw_quirk_cb,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "0BDA")
+		},
+		.driver_data = (void *)(SOF_SDW_TGL_HDMI |
+					RT711_JD2 |
+					SOF_SDW_FOUR_SPK),
+	},
 	{
 		.callback = sof_sdw_quirk_cb,
 		.matches = {
-- 
2.40.1



