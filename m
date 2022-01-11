Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809CF2CA1
	for <patches@lists.linux.dev>; Tue, 11 Jan 2022 17:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCD0C36AED
	for <patches@lists.linux.dev>; Tue, 11 Jan 2022 17:35:01 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VxLwslB3"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 11 Jan 2022 17:34:58 +0000
Resent-Message-ID: <Yd2/wrzQRdqO7n55@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 11 Jan 2022 11:06:03 +0000
Received: from ams.source.kernel.org ([2604:1380:4601:e00::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=xbrW=R3=linux.intel.com=amadeuszx.slawinski@kernel.org>)
	id 1n7EyW-00ER1T-Ks
	for broonie@sirena.co.uk; Tue, 11 Jan 2022 11:06:03 +0000
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 45260B819D0
	for <broonie@sirena.co.uk>; Tue, 11 Jan 2022 11:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 326A4C36AEF; Tue, 11 Jan 2022 11:06:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6EE74C36AE9
	for <broonie@kernel.org>; Tue, 11 Jan 2022 11:05:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 6EE74C36AE9
Authentication-Results: smtp.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641899159; x=1673435159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S84M8gP6Qre+XJE1k923GHKDAiyY37wNBkvrflzp1T8=;
  b=VxLwslB36w4NNM/1UjbXkUWWoK01IQ5SyXCtNakIGtRHuJ6QVH1kT9C1
   FDiXAP74B8AieNDRg0zTr+uHCXzExxf8rC6008mwAirYxKlhp6MK8X86J
   fVzWVXn6hXiDC5BN/WIC4EV3JMtZ4tsCKGVanA/aUamo/TCSvwkQSGUgH
   qWkkp9VSaAWfjBxbq++CA3BN9bTmYO7KtCtCHDA5eID/MEVzlX08aYbFu
   /g1+NOmBoqDXYORow6jfMX+7tYnEKyaWEFl1z1KPssGGIGQ+zlNWcM3AH
   qVfYWHWWJyb3aOwqKYIFWkA85Y/PKwFdJNt9W7GrlMIzUU2gpbhX25Lgf
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="304197138"
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="304197138"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 03:05:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="528700949"
Received: from dev2 (HELO DEV2.igk.intel.com) ([10.237.148.94])
  by orsmga008.jf.intel.com with ESMTP; 11 Jan 2022 03:05:57 -0800
From: =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Takashi Iwai <tiwai@suse.com>
Cc: Cezary Rojewski <cezary.rojewski@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Jaroslav Kysela <perex@perex.cz>,
	alsa-devel@alsa-project.org,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>
Date: Tue, 11 Jan 2022 20:05:27 +0100
Message-Id: <20220111190528.445248-3-amadeuszx.slawinski@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220111190528.445248-1-amadeuszx.slawinski@linux.intel.com>
References: <20220111190528.445248-1-amadeuszx.slawinski@linux.intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2604:1380:4601:e00::1
X-SA-Exim-Mail-From: SRS0=xbrW=R3=linux.intel.com=amadeuszx.slawinski@kernel.org
Subject: [PATCH 2/3] ASoC: topology: Allow TLV control to be either read or write
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: IiYsYfagA1ln

There is no reason to force readwrite access on TLV controls. It can be
either read, write or both. This is further evidenced in code where it
performs following checks:
                if ((k->access & SNDRV_CTL_ELEM_ACCESS_TLV_READ) && !sbe->get)
                        return -EINVAL;
                if ((k->access & SNDRV_CTL_ELEM_ACCESS_TLV_WRITE) && !sbe->put)
                        return -EINVAL;

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
---
 sound/soc/soc-topology.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index e0f72ddd72c1..9d24184f85f9 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -512,7 +512,8 @@ static int soc_tplg_kcontrol_bind_io(struct snd_soc_tplg_ctl_hdr *hdr,
 
 	if (le32_to_cpu(hdr->ops.info) == SND_SOC_TPLG_CTL_BYTES
 		&& k->iface & SNDRV_CTL_ELEM_IFACE_MIXER
-		&& k->access & SNDRV_CTL_ELEM_ACCESS_TLV_READWRITE
+		&& (k->access & SNDRV_CTL_ELEM_ACCESS_TLV_READ
+		    || k->access & SNDRV_CTL_ELEM_ACCESS_TLV_WRITE)
 		&& k->access & SNDRV_CTL_ELEM_ACCESS_TLV_CALLBACK) {
 		struct soc_bytes_ext *sbe;
 		struct snd_soc_tplg_bytes_control *be;
-- 
2.25.1

