Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51449441D
	for <patches@lists.linux.dev>; Mon, 24 Jun 2024 11:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719228868; cv=none; b=GqWSvYpx0wGC6hPOWD7hpdYxhPSeNtxM0oDs/PxlMGS9GuD7gIoLI3JLIOQozDKm8x+foSrxNo9kCPtFTEZESTtAsXx+f4Dpe1j3eWLHCmRHAG+UV7r0iaF8YkuOQOB8/RkImSlnzppZJVLrX5oeIeKFsdJcxQa7PCX1a0kJlaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719228868; c=relaxed/simple;
	bh=xxAoEhnSkTQySCuhhUAaYn4Tm+x+IpDt4eE43HYk+20=;
	h=From:To:Cc:Date:Message-Id:Subject; b=WHpXg2ivphKaPz68O7+LsvtRCrDRNBPvgGIjjlT567GYgtMZf3S+GYiviwQsgfP/lkrTquWfPRHQYI0IDAIt8ywXUl4DslLgQZyMleBfUci8PJ+d8LExhuYwRawdc1XXz2pXblPgr/QraJHIxiF+5cm4xhw8hfaDlrJhKvNvSsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE71C2BBFC
	for <patches@lists.linux.dev>; Mon, 24 Jun 2024 11:34:27 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Mon, 24 Jun 2024 12:34:24 +0100
Resent-Message-ID: <ZnlZwMKNM_KX8gHg@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Mon, 24 Jun 2024 04:06:59 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=Gyrm=N2=everest-semi.com=zhangyi@kernel.org>)
	id 1sLa2i-006Y51-VB
	for broonie@sirena.co.uk; Mon, 24 Jun 2024 04:06:59 +0100
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 46EC4609FA
	for <broonie@sirena.co.uk>; Mon, 24 Jun 2024 03:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 0314CC4AF0B; Mon, 24 Jun 2024 03:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E5E3EC2BD10
	for <broonie@kernel.org>; Mon, 24 Jun 2024 03:06:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org E5E3EC2BD10
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=everest-semi.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=everest-semi.com
Received: from unknown (HELO zy-virtual-machine.localdomain)([116.227.101.59])
	by sina.net (10.75.30.239) with ESMTP
	id 6678E2A10002B8DA; Mon, 24 Jun 2024 11:06:10 +0800 (CST)
X-Sender: zhangyi@everest-semi.com
X-Auth-ID: zhangyi@everest-semi.com
Authentication-Results: sina.net;
	 spf=none smtp.mailfrom=zhangyi@everest-semi.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=zhangyi@everest-semi.com
X-SMAIL-MID: 8C3D5F56266C4568BCB670E98F8427D6
X-SMAIL-UIID: 8C3D5F56266C4568BCB670E98F8427D6-20240624-110610
From: Zhang Yi <zhangyi@everest-semi.com>
To: alsa-devel@alsa-project.org,
	broonie@kernel.org
Cc: tiwai@suse.com,
	amadeuszx.slawinski@linux.intel.com,
	yangxiaohua@everest-semi.com,
	zhuning@everest-semi.com,
	zhangyi@everest-semi.com
Date: Mon, 24 Jun 2024 11:06:03 +0800
Message-Id: <20240624030607.4307-1-zhangyi@everest-semi.com>
X-Mailer: git-send-email 2.17.1
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=Gyrm=N2=everest-semi.com=zhangyi@kernel.org
Subject: [PATCH 0/4] ASoC: codecs: ES8326: Solving headphone detection and 
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: faFq1fTVp5vc
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

We propose four patches to solve headphone detection and suspend issues.
And there are several registers that should be read-only registers. So 
we create es8326_writeable_register, and set these registers to false.

Zhang Yi (4):
  ASoC: codecs: ES8326: Slove headphone detection issue
  ASoC: codecs: ES8326: codec can't enter suspend issue
  ASoC: codecs: ES8326: Minimize the pop noise
  ASoC: codecs: ES8326: regcache_sync error issue

 sound/soc/codecs/es8326.c | 92 ++++++++++++++++++++++-----------------
 1 file changed, 52 insertions(+), 40 deletions(-)

-- 
2.17.1

