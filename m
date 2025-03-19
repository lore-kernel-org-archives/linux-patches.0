Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EF31B2194;
	Wed, 19 Mar 2025 14:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395076; cv=none; b=QvhX/2CiFctqWWhtm7ZJaWkVcroyheLhZw9qh91HpddfO2YGsZCKPsz9Ol0M2Ujdlscj58XhK2Kj7LDTDtB0ozzptFXuQwCHdui1/IggBso/N/MjQj21O/yPejhtX68HZudoE3YgMSczTDugYpUo5cNzRl7o2XiUBkGCtvxfJlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395076; c=relaxed/simple;
	bh=VNLOgO2QvWoYsOWCNlRdNj8iiCXfuqlNPTU07FxdSgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tke0VdNYJlseXVLsm8OdRZjMYbURLBFlUcvHe89Svt3EuToNEl89QNLVNvjlFvRPH6VNldXtmcbqebqgs05BRbFaUkr1++QSDH4314Tj/3enKQRUA00kHcvKMiIYCWwWgecZEGcTzZZCAWldmE1RXRjnLs01TMgHQgCXuL7V9ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmRtOtzK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmRtOtzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C86AC4CEE4;
	Wed, 19 Mar 2025 14:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395076;
	bh=VNLOgO2QvWoYsOWCNlRdNj8iiCXfuqlNPTU07FxdSgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmRtOtzKg4HS8kVKOTh9m1uAQntGRdjqNeGfZE0MngrSlZhE7oQTqT87bS7BLhu/H
	 wya3cmamx0KGOzjjesUfjyh5DWnRep0DFWjvZW5RfN8/IMQ/eNSIrdUVdkAVHuPu74
	 TCUz0PAhWeVch9oTrFaQh12V4gIHTwnbZTrxRIt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/231] ASoC: SOF: Intel: pci-ptl: Add support for PTL-H
Date: Wed, 19 Mar 2025 07:30:08 -0700
Message-ID: <20250319143029.687952830@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 4e9c87cfcd0584f2a2e2f352a43ff003d688f3a4 ]

PTL-H uses the same configuration as PTL.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Acked-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250210081730.22916-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/pci-ptl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/intel/pci-ptl.c b/sound/soc/sof/intel/pci-ptl.c
index 69195b5e7b1a9..f54d098d616f6 100644
--- a/sound/soc/sof/intel/pci-ptl.c
+++ b/sound/soc/sof/intel/pci-ptl.c
@@ -50,6 +50,7 @@ static const struct sof_dev_desc ptl_desc = {
 /* PCI IDs */
 static const struct pci_device_id sof_pci_ids[] = {
 	{ PCI_DEVICE_DATA(INTEL, HDA_PTL, &ptl_desc) }, /* PTL */
+	{ PCI_DEVICE_DATA(INTEL, HDA_PTL_H, &ptl_desc) }, /* PTL-H */
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, sof_pci_ids);
-- 
2.39.5



