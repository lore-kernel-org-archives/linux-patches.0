Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055143;
	b=sKeXrHsnhu6S5GbMp4jeX/C1udV3ccgcadrzf2QAZFbO/c+bl9EQ8FI1hRx0bhPH4C0j
	 mWoCr6chWMnypslNYrwHu48B+JEgi3Dn+5oP52P4DeH8wYx/N3eqRtIwA4KZGyHmT4Snv
	 W5m1nAy7PMOEsj0kwsklRAcr4Wg30D8EOQWn9p94bzmSx4TFAsT5SCk51PltK9wRjJbZI
	 sf547939DrCgrWORI9aQr74F0Hnh29ZrJJfay7gSht0aEb8Mv2xHeXklTEfdefQlrZeCD
	 Viayb1d2l72HAWKdc08R0m5qzojinxgd199OueaMZE6tnYLnT7fo47+T1dk+WcGTZnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pjFzNm+B0DUKT6znzfGaL9nyV6io7k6lJs/6d0suaak=;
	b=WEOnQgHk21DUWKVjjc6jCA5KMWHjcI1+geXm0pN+MtlJdhYe8pc2mF+swxwOucjBSOUN
	 PDILUSu29M8wZ1XaDdXxvpy5tEnBsJh6kdQHuDLOlPywz7htMtDjduJ46luQ5niuAsngm
	 2UA2yDj/U3Yyed49FHAMJczn8qC/ynLyIWteWV5nzgLKHEjHUSjvElB8f6bdSccQGLctE
	 qNZ4sGGsaHELF8MEagAVF8405KpxrlQVukM91wKkMmOm4EQb72RFVHgidIb/jIUOYeqRa
	 xOojzeiL8b6ppkrA5OD3/+LUAZODYzYQEVz+uiqrgiFHOB+8E7BhCTGJTcH3A54cQ6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M2J6SE9r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2938606A31C;
	Thu, 19 Nov 2026 02:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M2J6SE9r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBB81F000C4;
	Thu, 19 Nov 2026 02:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055143;
	bh=pjFzNm+B0DUKT6znzfGaL9nyV6io7k6lJs/6d0suaak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2J6SE9rGySHRmfdwcsEAxYH0Yd4dIjpnVFC/WiKfcXp6uzYBZ8gC+N1HMOUoazKC
	 8GsWssOlPgxBipMrlWo3u4kzUNO17TH32aMPdi2pUuK5TlrQzs+Y9Rgs9R1RGE/0bp
	 2bdeI1qL9Aesa1NCoirFQXGkoCOnD1GVh7GXiOeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1526/2214] PCI: cadence: Preserve all error codes in cdns_plat_pcie_probe()
Date: Wed, 18 Nov 2026 15:53:22 +0100
Message-ID: <20261118150113.250940079@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 181b36a5d159d..d34bc117f8c27 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-plat.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-plat.c
@@ -122,7 +122,7 @@ static int cdns_plat_pcie_probe(struct platform_device *pdev)
 	while (phy_count--)
 		device_link_del(pcie->link[phy_count]);
 
-	return 0;
+	return ret;
 }
 
 static void cdns_plat_pcie_shutdown(struct platform_device *pdev)
-- 
2.53.0



