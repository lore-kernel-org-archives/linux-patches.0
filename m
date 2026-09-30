Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35313E8C65;
	Wed, 30 Sep 2026 15:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783117; cv=none; b=S+iej/jLG7rLFN0VCVzTm+neOrLWe34klppgt8M1LnCxb2I8SAKyoyKHiVOWigcJRHNDSmFg3GoVwGHEHCE0gmAn26xIm/3Kmlv7WIqiFnsN9xji3ru9lcfgzrxv7b7TM9tLFkOeKxAmuCWdcUPIKugvtPNVfvv4JJud89MkR0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783117; c=relaxed/simple;
	bh=VGMVgDRGRw4Bt8vi36Ecex+quwacmqya5PlLHgu3bK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phBhsvV2lGi2Eio5LYLOwc9/SYAsN6Rv2pxCXEwIZqXUaUl4aJDPYGk0hldrwkZ+RaHHawlTxZ2/jXE+3uhW2HOPJib99ua3sCK6VknDlm3bLdkXbFJoXUo5XngXtB5M0CDgnvnxzCL2pyuwLC0NG41I5j2w05k4kDlboGKfgyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9pC7ADl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9pC7ADl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253981F000FF;
	Wed, 30 Sep 2026 15:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783114;
	bh=RAAd8ZcsbSH6b2v+kFo05pvu43phy2EWJsXr1ahs0n0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C9pC7ADlboIFZjBOOLZzV06SFh78+Fc2idPEbR5NE0M3nmLelTtTXUempMid984FV
	 +IJ1Q1bumg0tLwhyec2FZWxU69rKul2XKm0YwWU2kSgIgB4vdH6K80uteSAyC6OtjS
	 QLmjgwZXNdWhW1oMxaA0aVhGsXzV34lfsmRm49dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 258/595] ASoC: Intel: SST: Publish the PCI module aliases
Date: Wed, 30 Sep 2026 17:22:31 +0200
Message-ID: <20260930152353.257492404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hpp.iscas <hppiscas@163.com>

[ Upstream commit d112159df5c6cc5ee6ab91cc32bf6ed29939df38 ]

The legacy SST PCI driver matches Intel Tangier devices using
intel_sst_ids, but its only explicit module alias is "sst". That alias
does not match PCI modalias events when this driver is built as a module.

Publish its PCI table. The independently configurable SOF driver does
not provide aliases for the legacy SST module.

Fixes: f533a035e4da ("ASoC: Intel: mrfld - create separate module for pci part")
Signed-off-by: hpp.iscas <hppiscas@163.com>
Link: https://patch.msgid.link/20260905133133.63661-1-hppiscas@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/atom/sst/sst_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/atom/sst/sst_pci.c b/sound/soc/intel/atom/sst/sst_pci.c
index f7ad991bf04d5..900e3d42e3d5e 100644
--- a/sound/soc/intel/atom/sst/sst_pci.c
+++ b/sound/soc/intel/atom/sst/sst_pci.c
@@ -179,6 +179,7 @@ static const struct pci_device_id intel_sst_ids[] = {
 	{ PCI_VDEVICE(INTEL, SST_MRFLD_PCI_ID), 0},
 	{ 0, }
 };
+MODULE_DEVICE_TABLE(pci, intel_sst_ids);
 
 static struct pci_driver sst_driver = {
 	.name = SST_DRV_NAME,
-- 
2.53.0



