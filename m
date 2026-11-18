Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047209;
	b=zJuXAlA2dhLUW6hPOukfgJ6NC9VXHzJ9gszsmauAnZvm8xXtbNq0FXAaY8xKLi30TvAs
	 u6OR86z+9BoS2UpCTL8IwTo4FvWxt/IpcPTkJNv9bkAdMGwDhNPhyU8hCbrZ3qJHnJXsV
	 4hPH8xZEn8U2Orx8/sy9ZJYGulvEumaTmcRKMnFrJaEl04OB9Op18twv/HOKcICIk6SGT
	 EUU2LcCAl2N4RHwFOAJNTzfMqsGi+m1UazAZIZMLVnqsGf5sg9aufhVw4ncXBlBKhJWwH
	 ScEJMKUUxjPLO0af1MmXsPGVvSeyXhtkwSlTcjF3rSEWkZjnSxFe87RVDhFBER0Rw2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xcZzEDxlYFuQWkY4fQZlgtC7j/NZNGC3qk4LLvrXP38=;
	b=VhtymChmMfoiZmypO0uqa2HwNSNIQVSpmrnUulwIHosd76F2ESIqlEAQpWxptPYjavSw
	 1prOI+zxaOXL8UoaGTXFs197f9xnnACiWdV1jyGSd5yPUcjXuBeFROJufPsVjqUqmnvn4
	 5rliiJZNM3k7NeLHhZ5MBuGyj5xAb3Wo7Vs/+lMFzck3UtBPJJr40WJsSR6RvE4fiIHQQ
	 0U3+Lk9uhM/7ae5Wn9lJDPRY9StB64y/RQc8TSznM1CLhBcNfYR9fFsQ1dkt11H7QRTEI
	 d3UFGy+EV+XUwyBFuULl30pxs/ghEIXwMYhz6lo/8TjrikHXylXKAs0I0u++2uetiog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lO3rfo76;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BFB606A33B;
	Thu, 19 Nov 2026 00:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lO3rfo76
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1D51F000C4;
	Thu, 19 Nov 2026 00:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047209;
	bh=xcZzEDxlYFuQWkY4fQZlgtC7j/NZNGC3qk4LLvrXP38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lO3rfo76koRGgQh8SGa5tZ8pgvCri4VUzoZoNYQSk/lilEticaAsqKzhcmP4+dVkS
	 lgEVzi65isRqzP6XsoOa/HvVmErMcEqPFpYCPBeSzqSc628E88zuFblgbO6oeZNkx+
	 A7aAsP3L806LbFffQ/z2ECbqDtSCbKPgaTqhx2Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1550/2857] PCI: cadence: Preserve all error codes in cdns_plat_pcie_probe()
Date: Wed, 18 Nov 2026 15:43:04 +0100
Message-ID: <20261118150257.139338383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index db38246d2c9ae..eb7037f7232ef 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-plat.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-plat.c
@@ -120,7 +120,7 @@ static int cdns_plat_pcie_probe(struct platform_device *pdev)
 	while (phy_count--)
 		device_link_del(pcie->link[phy_count]);
 
-	return 0;
+	return ret;
 }
 
 static void cdns_plat_pcie_shutdown(struct platform_device *pdev)
-- 
2.53.0



