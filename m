Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5424DDB3D;
	Wed, 30 Sep 2026 16:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785235; cv=none; b=qyfPdIAy+6oDbaep7bhCT/lIOY9C6aiZV8pARhmIAy44gUO+JHXXPeEPvaKA+Pu/Or/w5NhGUaOz+QoM2vjRwA0gZyk7zv5pFs5NLReR2Nge0JwqVfUmLZ+4h//qKOpmF4QvmwgNkU3ovfxghDeymNFGEvZoF+NJGEAkhEm9nPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785235; c=relaxed/simple;
	bh=UwyXSezGrtZpsmkVc7u3FeqoXdfEydc2/gd3EC9qVJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcdqOSb7eigDIMs5xUl6GybSQo3qEfgDZLWfWcoNWxPkNQM8QU9WPiilBVv2W1x/3MboycePsBbx2ae7FCdxkzP4P9N3xehJvKhDERRBoFIxGx6179ljA9PRYo4nljNpLhmqCZKcxQ0PZHoDFX+xzwsjKJ0OE2vfQ76/JvSNDqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1PT2oKX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1PT2oKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218761F000FF;
	Wed, 30 Sep 2026 16:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785231;
	bh=i8u4dL48F3hTqd5x0ujb2yRGoGWX/LgIINCK6wzsUYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u1PT2oKXole9VBE06MaYLsiqqAv/GTOaa04590o1ZfbiADM+Axb0QBS0Gp1Rz9ZuH
	 FwE9RgG+lhWRDxEyEA54EH++jOAkXYUJzl146YYsYs72aTmFHcI2dc+ZtaPqvkYZzX
	 mtECf0Mj56Pik+HnLgjOkd7Kz63k9CnFECISF0iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 435/982] ASoC: Intel: SST: Publish the PCI module aliases
Date: Wed, 30 Sep 2026 17:19:31 +0200
Message-ID: <20260930152426.139620526@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



