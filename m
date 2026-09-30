Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E18544A708;
	Wed, 30 Sep 2026 18:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791628; cv=none; b=bHBMCYlsLE3cSA+OlvhRU3dkO3AyYER1oCwiLo6b0QWto6W4XhSqbNQgc5yvJF1Ex/Czm3rAT8rcngvaVqr/OmCcuATS5UKoEwK0uFhi9i6GPaX+0HHvDZH6dvrlLRdDaawMbNCME54JvV4Uky9iPQe5zTXoMaUVxVleeixSD0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791628; c=relaxed/simple;
	bh=3lle6m0oRGRNMzXr1GWznXd5pp0vcZ+7bt+/dQZJXrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMcM4S29M5T1gJFBvrTGhNFQkzUguovZOSlU4j9ZRLeHgtGabT/zhxR42pHQ8+ewAjjg8RniR/gf5wpLs3JZdMkfArow9Fo4B6ImIwSR2JUfT9EFH8Q1k3Gmgq2xqCD4PDvbJPNiRG+IFeuTImzic26H0P15F1XiDP2jhwcTBdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NRYc0beA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NRYc0beA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CD11F00899;
	Wed, 30 Sep 2026 18:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791627;
	bh=ANiuQS7hhotrHnpG/bo8kZb7jtR7tcMTCs2MqWucQ4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NRYc0beA/89fsu0L7JYPM60auv21cn11W8JjwjYy0ppHEShV7VyynuWfN9aqb8cen
	 9ebzeFCvQp4OONPJ5xNeZvU9c8X5ZNF76lqq0KXDRjjt3Jz0q1C1YZjf/FqlzUAIHu
	 2SAgjYEKbtRlh9AiqP0XHo7lpcprUB/rpIIk8sDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 324/752] ASoC: Intel: SST: Publish the PCI module aliases
Date: Wed, 30 Sep 2026 17:23:14 +0200
Message-ID: <20260930152405.307283577@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



