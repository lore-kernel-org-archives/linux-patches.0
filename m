Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1224B3C4551;
	Wed, 30 Sep 2026 19:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795423; cv=none; b=h0V+iTJKuQZmE0DoUNNM09sDOLY/lldna6fMmvwtidNs/6Ek4NBTXr8sJXyYaWVSDPf1xY6eItP4ywQSX+n1hU2oTqSnZHOEEUJQ3NoBgMuwScbY31GfbfvqkA8LqlsjfL6tvb6S+jCbTfntrgneFpCJE1d1amoM3uZjUt/nO/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795423; c=relaxed/simple;
	bh=JcGSA8iIimPzvJtwVMEOFImvEVTVpAt5b6z8BhQMdhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CD+xe9caVqGIcrwUZFIpzxpgGTsBVH3tqKnPWT1Bi6ZxFxb/SL+agIyY8g7tXA93eBjPAWkMEgclVylua0MC7pHpsq8alLYdFd1nV0oeH/YxgRCkFBj3D95t2j6nU/BWvA5SH5H7uPhHek1b8B2d0N2GzE7zg9J2DW4xmjcg8H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQRJUkzk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQRJUkzk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7C81F000FF;
	Wed, 30 Sep 2026 19:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795421;
	bh=lFUw/xEoMKzaHWFKNgwHD2fEm1zprRroy8aOKsJMWcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bQRJUkzkstdekwkheWSibBo4yvNAmzUVr3rvVPOhkM5iZKi6x3YUvKtP2Q+bZ49vt
	 xVkLjwRrw2VqbgKliC8Q4woP07BQirmj/FkR1VNnNnGf5pQxRs5sdvUQmZTShEplQD
	 PXg7h4EMYavC2269/BvA/kHfSVu+Iw0pl3fnZb70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0519/1193] ASoC: Intel: SST: Publish the PCI module aliases
Date: Wed, 30 Sep 2026 17:20:03 +0200
Message-ID: <20260930152445.710308393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 296bea33e16ff..745e2e60a1440 100644
--- a/sound/soc/intel/atom/sst/sst_pci.c
+++ b/sound/soc/intel/atom/sst/sst_pci.c
@@ -178,6 +178,7 @@ static const struct pci_device_id intel_sst_ids[] = {
 	{ PCI_DEVICE_DATA(INTEL, SST_TNG, 0) },
 	{ 0, }
 };
+MODULE_DEVICE_TABLE(pci, intel_sst_ids);
 
 static struct pci_driver sst_driver = {
 	.name = SST_DRV_NAME,
-- 
2.53.0



