Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2641C07DB;
	Tue, 15 Oct 2024 13:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997519; cv=none; b=GersYhPH8K7sZLqNCLxU+SI1+07EpKDLrSq7X6KhaA32FcG/2L/itGDDOdNS8zWvHd56ybGtV6VTTOSVKb/8FzI+AWuP3qmSC/gdjNrF4HbYqr77UPUddT/HDMSXlfcDSiTNUzFlK8fhsTslegDJsZdF2CQqfKWKafEAGNcGJlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997519; c=relaxed/simple;
	bh=tzkrrtIYLvr/FF+rAH2iMd5neU/mcikZHLMJMTxDyKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OB7JX7xKTfYmB30gjT691w0+6SQYIGxnaCdd0Jeuh+/17ayWIh4e3zV9qJXku7+CT25gj/z1mmMGSq7U7DJL88Bs/Y568iNaL1rrd1g7z3mfa4MulxLmqO4SAhId/DoEUrAmv3x6k/rwKSLMbr6P+ng8S0b9qaS9DJUiotBd0xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PTpPwHS4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PTpPwHS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A22FDC4CEC6;
	Tue, 15 Oct 2024 13:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997519;
	bh=tzkrrtIYLvr/FF+rAH2iMd5neU/mcikZHLMJMTxDyKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PTpPwHS4bBAfk4w+uv4rrGVa1FSTVIsB0CJCHQAJ+jHjwxSORz8bitWLNsh25enwh
	 fBYyD1cqxB+dDluwVVnR6PPixeeAuMUxEMOiuyqEvaxuftnH++h3uOaoKgIkbsG1bZ
	 rSrPIBrJ4nglAQ4oA8jan4d5fO39y048sv1T6LCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/518] PCI: keystone: Fix if-statement expression in ks_pcie_quirk()
Date: Tue, 15 Oct 2024 14:41:09 +0200
Message-ID: <20241015123923.365342794@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 6188a1c762eb9bbd444f47696eda77a5eae6207a ]

This code accidentally uses && where || was intended.  It potentially
results in a NULL dereference.

Thus, fix the if-statement expression to use the correct condition.

Fixes: 86f271f22bbb ("PCI: keystone: Add workaround for Errata #i2037 (AM65x SR 1.0)")
Link: https://lore.kernel.org/linux-pci/1b762a93-e1b2-4af3-8c04-c8843905c279@stanley.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-keystone.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pci-keystone.c b/drivers/pci/controller/dwc/pci-keystone.c
index 0b49bdf149a69..08f37ae8a1110 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -598,7 +598,7 @@ static void ks_pcie_quirk(struct pci_dev *dev)
 	 */
 	if (pci_match_id(am6_pci_devids, bridge)) {
 		bridge_dev = pci_get_host_bridge_device(dev);
-		if (!bridge_dev && !bridge_dev->parent)
+		if (!bridge_dev || !bridge_dev->parent)
 			return;
 
 		ks_pcie = dev_get_drvdata(bridge_dev->parent);
-- 
2.43.0



