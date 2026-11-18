Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060650;
	b=BJ57H8rcIw1ioTZ29ILpgBmJKzNe5+L+ZxJhoJ6iKEel5iJBskJ4UN2utjV3uEwwP6pO
	 Isy8z6Q3omDvOhgQdgZ85wP/UZDcBcjcg6aF/nrSZmfxOYfbq6Sl4uuP66/6Z78gDYQJk
	 5yAldkh9m51Wz/eRsKVIArLi7Aty6YvLcoioAvi8kdhC+T0NXVAABWCQESR4MjEa3UmPP
	 dWMckRwZl28Q6bQSdOTEYNdFlIMPVFCfxOaVQKjWR+EMkzROKfMdFsxaTAjX+ElJqIFJ+
	 PoIAu9mjtASX2Qkqqxq09ggB6ZjJlsNIhyzsze0xbm3cu1O1i+ev0j6vXuf1AUk8lhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060650;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OWePJXIZGYLiw94buBxeFxw/o38rcSoxNOLoRQfe8hU=;
	b=Q5eoD/QatNYRXxzDikNtxiNj7Ff5fgSOkztfF6NpmTlKAbEUGAVYmpeJOI+ahmotPBIQ
	 FKQhTLSRvKvfgjQGDV/nGn8z5C4BuUWyJPqr6XJmS5TfzMXMGU9RUIMXOZ6PQGUnPm/rk
	 0QTbBGdIAL777EkF4lInpaJdO1e74+Av/FqcBkW2ZXY1eyKO+ipGMmTXxj1RItLntVSyE
	 9Xz7iYghLXd0RmxLupNThaM4RVwiX6dChOBxB4IKzpaH14ro9sIaXktNwunq7KcwnD0pM
	 HHSaUPpPkt2OkKd1dPKPj/xDgisf7NdiZSlw/PPCXVmw52os3ie2xbZVSwM9YsVQCRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZhPOb7Xz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782C0606A326;
	Thu, 19 Nov 2026 03:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZhPOb7Xz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFFD1F000C4;
	Thu, 19 Nov 2026 03:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060650;
	bh=OWePJXIZGYLiw94buBxeFxw/o38rcSoxNOLoRQfe8hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZhPOb7Xz9YLUGC8jZwRYc4l2RWnQ+O0zPf1ketYRPS8vsIVVaowsGLpc6Y9WbAAAK
	 2sJRC/IU2m02AE/ezTF19AoIyEXWWnpVtBFFVnjry7gfkgxuXmdT9bgR1Wi/29cqNA
	 k+Nbm6mX5ZaY0sWuDE4XDJfLfwyOZXaZRhHXRB8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1274/1848] PCI: cadence: Preserve all error codes in cdns_plat_pcie_probe()
Date: Wed, 18 Nov 2026 15:55:12 +0100
Message-ID: <20261118150012.964318400@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



