Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD06A2F37
	for <patches@lists.linux.dev>; Wed, 22 Mar 2023 18:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D7FC433D2
	for <patches@lists.linux.dev>; Wed, 22 Mar 2023 18:48:11 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ey9GA/9N"
Resent-From: Mark Brown <broonie@sirena.org.uk>
Resent-Date: Wed, 22 Mar 2023 18:48:08 +0000
Resent-Message-ID: <ZBtNaAPb8A6Z8FHY@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Wed, 22 Mar 2023 18:19:27 +0000
Received: from ams.source.kernel.org ([145.40.68.75])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=3V8i=7O=linux.intel.com=jyri.sarha@kernel.org>)
	id 1pf33U-008QdH-NK
	for broonie@sirena.co.uk; Wed, 22 Mar 2023 18:19:27 +0000
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id C3A02B81D96
	for <broonie@sirena.co.uk>; Wed, 22 Mar 2023 18:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id A396BC4339E; Wed, 22 Mar 2023 18:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B04AC433D2
	for <broonie@kernel.org>; Wed, 22 Mar 2023 18:19:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 6B04AC433D2
Authentication-Results: smtp.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679509162; x=1711045162;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=kfN9SenAdQDA4pArUtorjPOHqmMemYP6aWKfJD2B1Ec=;
  b=Ey9GA/9NFUcBpX7HjigyF3uJLklmO7ofNJpc7QuiGdcFgqh6u0iauFzT
   t9TXBKKrjUeXICWzCekqDNmwnURhxIxicKfnUQUvpx6jrddzmLUxotSmH
   LkYKPTzk/bxU65tGF2Qzwbo8VAmgiK3C5qTmJ2VlLMxrWDNgOI7FJ7u4A
   hawUhGMNYpJalHW9AoRJnewsVvW5cSaHSBMzl+HpJtd9oNZYM2VIwBr+j
   NZ2HpdLpbW18DeVHilnMa1Ewwv02VhX4M8KX91WPo1BZeGRtO7ct4Z31G
   UwXKadd9SjLtWh77Vn+hRgTfUgGJ5DTzK3Q2lXU+B6O5oq9Xc+eoZYA+B
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="425586040"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="425586040"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 11:19:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="1011471742"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="1011471742"
Received: from harith2x-mobl1.gar.corp.intel.com (HELO jsarha-desk.intel.com) ([10.249.254.178])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 11:18:57 -0700
From: Jyri Sarha <jyri.sarha@linux.intel.com>
To: lgirdwood@gmail.com,
	broonie@kernel.org
Cc: alsa-devel@alsa-project.org,
	pierre-louis.bossart@linux.intel.com,
	ranjani.sridharan@linux.intel.com,
	kai.vehmanen@linux.intel.com,
	peter.ujfalusi@linux.intel.com,
	rander.wang@intel.com,
	error27@gmail.com
Date: Wed, 22 Mar 2023 20:18:30 +0200
Message-Id: <20230322181830.574635-1-jyri.sarha@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 145.40.68.75
X-SA-Exim-Mail-From: SRS0=3V8i=7O=linux.intel.com=jyri.sarha@kernel.org
Subject: [PATCH] ASoC: SOF: ipc4/intel: Add missing mutex_unlock()
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: OFZWXJ26hBEN

There was a missing mutex_unlock() in sof_ipc4_widget_free()
use_chain_dma if-branch that caused a static analysis error. The
branch should not be used in a normal working configuration and if its
used its an indication of a bad topology. Add missing mutex_unlock()
and a warning print if the if-branch is taken, and another warning
print to a symmetric place in sof_ipc4_widget_setup().

Fixes: ca5ce0caa67fa9 ("ASoC: SOF: ipc4/intel: Add support for chained DMA")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/r/202303222050.dCw0fPCW-lkp@intel.com/
Signed-off-by: Jyri Sarha <jyri.sarha@linux.intel.com>
---
 sound/soc/sof/ipc4-topology.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/ipc4-topology.c b/sound/soc/sof/ipc4-topology.c
index f1e1aed94da4..12775fcb6b54 100644
--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -1989,8 +1989,11 @@ static int sof_ipc4_widget_setup(struct snd_sof_dev *sdev, struct snd_sof_widget
 	case snd_soc_dapm_scheduler:
 		pipeline = swidget->private;
 
-		if (pipeline->use_chain_dma)
+		if (pipeline->use_chain_dma) {
+			dev_warn(sdev->dev, "use_chain_dma set for schduler %s",
+				 swidget->widget->name);
 			return 0;
+		}
 
 		dev_dbg(sdev->dev, "pipeline: %d memory pages: %d\n", swidget->pipeline_id,
 			pipeline->mem_usage);
@@ -2145,8 +2148,12 @@ static int sof_ipc4_widget_free(struct snd_sof_dev *sdev, struct snd_sof_widget
 		struct sof_ipc4_msg msg = {{ 0 }};
 		u32 header;
 
-		if (pipeline->use_chain_dma)
+		if (pipeline->use_chain_dma) {
+			dev_warn(sdev->dev, "use_chain_dma set for schduler %s",
+				 swidget->widget->name);
+			mutex_unlock(&ipc4_data->pipeline_state_mutex);
 			return 0;
+		}
 
 		header = SOF_IPC4_GLB_PIPE_INSTANCE_ID(swidget->instance_id);
 		header |= SOF_IPC4_MSG_TYPE_SET(SOF_IPC4_GLB_DELETE_PIPELINE);
-- 
2.34.1

