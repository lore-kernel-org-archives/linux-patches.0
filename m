Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB9E2CA1
	for <patches@lists.linux.dev>; Tue, 11 Jan 2022 17:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116E3C36AE3
	for <patches@lists.linux.dev>; Tue, 11 Jan 2022 17:34:53 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FFtazzn/"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 11 Jan 2022 17:34:50 +0000
Resent-Message-ID: <Yd2/ulCTQ1Y9i1ku@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 11 Jan 2022 11:06:00 +0000
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=xbrW=R3=linux.intel.com=amadeuszx.slawinski@kernel.org>)
	id 1n7EyS-00ER1K-WA
	for broonie@sirena.co.uk; Tue, 11 Jan 2022 11:06:00 +0000
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 01D2D614DE
	for <broonie@sirena.co.uk>; Tue, 11 Jan 2022 11:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 7D227C36AE9; Tue, 11 Jan 2022 11:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E5097C36AE3
	for <broonie@kernel.org>; Tue, 11 Jan 2022 11:05:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org E5097C36AE3
Authentication-Results: smtp.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641899155; x=1673435155;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UZTEJwqrWznAXGdvsV/ZHOp1lI6B4x07xoOVy5ZfMec=;
  b=FFtazzn/Rr1WizfhWUA1GsSMVImx4dQraUCgzaTyCpZzd6D1/fe2f62k
   mAgleD8QYI2X+w0J4QwqL8XCE+Qeq4PnIzZy15Qars+jIr9OpHb7LC9+T
   OxXtZumFQo7TVW+/08VmKOMoDZh2VbDjdH1oaFEsP9fXiCp8GQyIOqiBM
   B0Qm9vjfom7Ujomolh8l0/gtTyFpMR2Tk95wWHM6aanKAlofZgEEi3imO
   A9Ji8M0n9XH+DwIU2YNGc+v/U3i5lQjid4ZEtTf/uxiYvF2MdvYXSYOGy
   SdzKJhRZbxdgmuczg6V/f7321V3L4CwPTxIlsybrYeGWyzouMSwsPxgPR
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="304197125"
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="304197125"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 03:05:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="528700927"
Received: from dev2 (HELO DEV2.igk.intel.com) ([10.237.148.94])
  by orsmga008.jf.intel.com with ESMTP; 11 Jan 2022 03:05:52 -0800
From: =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Takashi Iwai <tiwai@suse.com>
Cc: Cezary Rojewski <cezary.rojewski@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Jaroslav Kysela <perex@perex.cz>,
	alsa-devel@alsa-project.org,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>
Date: Tue, 11 Jan 2022 20:05:25 +0100
Message-Id: <20220111190528.445248-1-amadeuszx.slawinski@linux.intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=xbrW=R3=linux.intel.com=amadeuszx.slawinski@kernel.org
Subject: [PATCH 0/3] ASoC: topology: Fixes
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: fhkWmKbRFD+X

Following series performs few cleanups in topology code.

First patch reduces number of prints we get from failure.
Second allos TLV controls to be either read or write which should be
possible as evidenced by further code in function.
Last one cleanups after refactoring of memory handling.

Amadeusz Sławiński (3):
  ASoC: topology: Remove superfluous error prints
  ASoC: topology: Allow TLV control to be either read or write
  ASoC: topology: Optimize soc_tplg_dapm_graph_elems_load behavior

 sound/soc/soc-topology.c | 103 ++++++++++-----------------------------
 1 file changed, 27 insertions(+), 76 deletions(-)

-- 
2.25.1

