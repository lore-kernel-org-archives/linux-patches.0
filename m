Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF0733063;
	Fri, 24 Nov 2023 18:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYCyb7Q5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EBFC433C7;
	Fri, 24 Nov 2023 18:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850579;
	bh=auuLbcASmmmbAO/TX2mzC3OpGBuDO1IlLXAXCy6mf44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYCyb7Q5EOcg+fZ7mML+yUcQQoMuoWWAmUaDECmeNxj+BgLvopjYIqlYZM8OYKdLt
	 M9qyN6nSwzkOaqEThgbGl587u2Wmcg/Uxet8HAw4hbItwRVvguj4BmpN61hRRTNLi5
	 rezpgrtAJkbC/OYRqLwCB6ZhVrWaBXcRtYhdCvpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 105/491] misc: pci_endpoint_test: Add Device ID for R-Car S4-8 PCIe controller
Date: Fri, 24 Nov 2023 17:45:41 +0000
Message-ID: <20231124172027.714617765@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 6c4b39937f4e65688ea294725ae432b2565821ff ]

Add Renesas R8A779F0 in pci_device_id table so that pci-epf-test
can be used for testing PCIe EP on R-Car S4-8.

Link: https://lore.kernel.org/linux-pci/20231018085631.1121289-16-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pci_endpoint_test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
index 7e1acc68d4359..af519088732d9 100644
--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -82,6 +82,7 @@
 #define PCI_DEVICE_ID_RENESAS_R8A774B1		0x002b
 #define PCI_DEVICE_ID_RENESAS_R8A774C0		0x002d
 #define PCI_DEVICE_ID_RENESAS_R8A774E1		0x0025
+#define PCI_DEVICE_ID_RENESAS_R8A779F0		0x0031
 
 static DEFINE_IDA(pci_endpoint_test_ida);
 
@@ -991,6 +992,9 @@ static const struct pci_device_id pci_endpoint_test_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_RENESAS, PCI_DEVICE_ID_RENESAS_R8A774B1),},
 	{ PCI_DEVICE(PCI_VENDOR_ID_RENESAS, PCI_DEVICE_ID_RENESAS_R8A774C0),},
 	{ PCI_DEVICE(PCI_VENDOR_ID_RENESAS, PCI_DEVICE_ID_RENESAS_R8A774E1),},
+	{ PCI_DEVICE(PCI_VENDOR_ID_RENESAS, PCI_DEVICE_ID_RENESAS_R8A779F0),
+	  .driver_data = (kernel_ulong_t)&default_data,
+	},
 	{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_J721E),
 	  .driver_data = (kernel_ulong_t)&j721e_data,
 	},
-- 
2.42.0



