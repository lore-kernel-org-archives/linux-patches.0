Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CDE3598BEB;
	Thu, 17 Sep 2026 15:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659793; cv=none; b=N5zET5mX6XyyJZJLJaq/Gg0bYyEUXpiSWGDGLayhwkqRjZBZqWOPHUwrxOuBFqsPF65AE1mxsPeCYviAXdOAhELAkS1t7fLiCRlGhUGAEdzZsiDWXNE/qyIWwOSfeWuIGloLWSDeDkiucz0q2HOuN4FoHufLu49E9i5HbwbtS3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659793; c=relaxed/simple;
	bh=Hr9AME3czMdETmjkyDhnbCm9lVeiXF8XI9O6VdZG3tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adlAHVsI+Cgai2T91lZetj2BecT38/6IXxLjJ+6pMTBJXyMxw5wZ7fI6c/seMo+RG00PB991jVvoVfTfHetnB2n009CYQHzs187s+yVyKUVcy93JKM6wrUbkJ13cRcB191MCCqeY0NorZU73uSxMNfBuil4BJXTwz2BUKEdryYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdA+J3LG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdA+J3LG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6171F000FF;
	Thu, 17 Sep 2026 15:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659782;
	bh=d/r1tEKIeylz3o0AMXf6th4GCbQizw7vE/rqQqRU1dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BdA+J3LG7whsk9Uk022lDvsjrwjZHJ/11b6E0d51AWw7BiZepNNwTGp834GsrXYKS
	 FBYQpfsc6iayNNBs+cowOW5IxPODhePIKk63FyeUDXg19gdNg+UBFRiaZI4SVo7zwa
	 7MXN38JCvxz9trYGOZn1inbbI/j0dEcfdgku0n5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 334/733] ASoC: Intel: SST: Publish the PCI module aliases
Date: Thu, 17 Sep 2026 16:10:42 +0100
Message-ID: <20260917151359.854719527@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 44bb11c694905..1a53c993b57fc 100644
--- a/sound/soc/intel/atom/sst/sst_pci.c
+++ b/sound/soc/intel/atom/sst/sst_pci.c
@@ -167,6 +167,7 @@ static const struct pci_device_id intel_sst_ids[] = {
 	{ PCI_DEVICE_DATA(INTEL, SST_TNG, 0) },
 	{ 0, }
 };
+MODULE_DEVICE_TABLE(pci, intel_sst_ids);
 
 static struct pci_driver sst_driver = {
 	.name = SST_DRV_NAME,
-- 
2.53.0



