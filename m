Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038604;
	b=MdjhSTny/Ph/CZkgJYiS9hNM1dJVWCsP0vqU/wU3G+XE/7R9TbK7bM2nDN3/j95557kE
	 JrAMncBc+p+4BFrdeEBrurxBGh+M5Vr17I8HC9J3JsZmn3p1vfdooD9j2pik4KJhVeqXs
	 Ssj2nCGKLGlELSy3NECrK2uXCiGtwTBg+H6DQrJ3UAIW3C6mxe/d5Hn1NqAIO6wHiVRZ4
	 lZ4bGXHtobl9EiMTvDiJQtnNz1pS5A4L3U8842ncbT0CrAV8w/c18gc86VVufB9NIbx4Q
	 RSNnq/wWjtsMdO3mVO4ws5yjB6vDyALjsWIQjPbtK0FVFG3ePumIW3sapGqDvtrIIsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bBGUitn2lw2xQU3WeMS/Y3cRvhOchX/LF9JEJ8OKXTE=;
	b=qOrCnM6i6aO6odw/y0f8XQ79E5YDaZ6CLOcf70m4G0r4k/EugLl9t54V9coThxn2oNm3
	 wVuA+3BxfC1DGOoOkKvv0SSXZ8rtb6msE+3ZhwmewXkh5wB6jYZj6fZb00wox9QCFC87o
	 Bn3BLhHnTtar4nNVSCeWAXhuSnN7KkZ3XfubOvfI+Dz5+zOpBpbdLieVSjZmcF7Mg/d9m
	 4HzlFa/hzoxp70siSh+oIrWZmyezsbYSYMJYkLboQn4lsY/hEJVA4a4sYlbjCDf0VLd/g
	 v7NpB1sQU2HDOuzwOmBHl84y6jfnmxZptyIupjsVUdvdVhtZ9xfGFfa3WkRij2lGmSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mAh7loy/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950F1606A31C;
	Wed, 18 Nov 2026 21:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mAh7loy/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBBC1F000C4;
	Wed, 18 Nov 2026 21:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038604;
	bh=bBGUitn2lw2xQU3WeMS/Y3cRvhOchX/LF9JEJ8OKXTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mAh7loy/A83pp2CKKo6wVe7G9JBVFzuxzBkI/a8E2Yjq9Iv9WE2baYiw3+1Y5SqUt
	 S5B1bRvL3vQeklu+nboSYlHIapW28BdPkJMVbuduBUlOdCZiRsfNqAI7C1RiNMWchW
	 zJprHa+PVQBGMhN4PR/ygxQvCyIaaVE04DwyrGjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1802/3318] PCI: cadence: Preserve all error codes in cdns_plat_pcie_probe()
Date: Wed, 18 Nov 2026 15:40:24 +0100
Message-ID: <20261118150415.915466506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit fe108800a865b268eec103e4940c248c85a86e9f ]

The blamed commit functionally changed the error path of
cdns_pcie_host_probe(), now cdns_plat_pcie_probe().

When the old code path executed "goto err_get_sync", the PCIe controller
probe function propagated the pm_runtime_get_sync() error code. The new
code doesn't, and returns 0.

Similarly for the "goto err_init" previously triggered by
cdns_pcie_host_init() errors, and now triggered by
cdns_pcie_host_setup() and cdns_pcie_ep_setup() errors. These are not
propagated and will result in probing success, which is incorrect.

Fixes: bd22885aa188 ("PCI: cadence: Refactor driver to use as a core library")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260810124315.433448-2-vladimir.oltean@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pcie-cadence-plat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/cadence/pcie-cadence-plat.c b/drivers/pci/controller/cadence/pcie-cadence-plat.c
index 528038f926c13..c1ec619ab0a4e 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-plat.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-plat.c
@@ -119,7 +119,7 @@ static int cdns_plat_pcie_probe(struct platform_device *pdev)
 	while (phy_count--)
 		device_link_del(pcie->link[phy_count]);
 
-	return 0;
+	return ret;
 }
 
 static void cdns_plat_pcie_shutdown(struct platform_device *pdev)
-- 
2.53.0



