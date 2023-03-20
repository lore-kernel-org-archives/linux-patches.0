Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512C61C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2F4C433EF;
	Mon, 20 Mar 2023 15:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324835;
	bh=rkwlp0RnQwFwSrinQ4bN0yAHUfgOWBVnIrAX7S3cYTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZjrS5jng0VZbTi8n6i58FL/cpn8FP5SLf/LHpdB7PIT+ne2wO5gDq9uM6zeXcexg
	 4uY0y5k2IFaV0e9S/jLpStpj1e8/3TUzonMIWGeZpJBvxNtxMrMCUhPeh+8MmEskFT
	 +BDf/urimIK3ytSXHV/j3LaV2dvXTfQkomAdszdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 011/198] ASoC: SOF: Intel: SKL: Fix device description
Date: Mon, 20 Mar 2023 15:52:29 +0100
Message-Id: <20230320145507.960909636@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit 1f320bdb29b644a2c9fb301a6fb2d6170e6417e9 ]

Add missing ops_free callback for SKL/KBL platforms.

Fixes: 52d7939d10f2 ("ASoC: SOF: Intel: add ops for SKL/KBL")

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230307093914.25409-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/pci-skl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sof/intel/pci-skl.c b/sound/soc/sof/intel/pci-skl.c
index 3a99dc444f92e..5b4bccf819658 100644
--- a/sound/soc/sof/intel/pci-skl.c
+++ b/sound/soc/sof/intel/pci-skl.c
@@ -38,6 +38,7 @@ static struct sof_dev_desc skl_desc = {
 	.nocodec_tplg_filename = "sof-skl-nocodec.tplg",
 	.ops = &sof_skl_ops,
 	.ops_init = sof_skl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 static struct sof_dev_desc kbl_desc = {
@@ -61,6 +62,7 @@ static struct sof_dev_desc kbl_desc = {
 	.nocodec_tplg_filename = "sof-kbl-nocodec.tplg",
 	.ops = &sof_skl_ops,
 	.ops_init = sof_skl_ops_init,
+	.ops_free = hda_ops_free,
 };
 
 /* PCI IDs */
-- 
2.39.2



