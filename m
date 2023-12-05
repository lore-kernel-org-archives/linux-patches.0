Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F186FB1;
	Tue,  5 Dec 2023 03:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2N4mS2B6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8ABFC433C7;
	Tue,  5 Dec 2023 03:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747606;
	bh=Oc3P8aL2tkRiD0dG0IC+bDQT5m/VjIXGM2nO3dSVsC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2N4mS2B6GzmAgk0f1T2VVZfwVvyiTV38bFtiwIJvmGhTAf0a4UnAPqm1p2wizPE1O
	 Mjd7/RFUSdBrxDtZvCq9YT3t6WETplbNTFwjOCjgsgE6uEOZmWc/1DvkQ+YgBUxsU+
	 iQz2gXqeskzq/p0NWFwiVbTAkO9EiTaLMi3tO13s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kishon Vijay Abraham I <kishon@ti.com>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/135] misc: pci_endpoint_test: Add deviceID for AM64 and J7200
Date: Tue,  5 Dec 2023 12:17:14 +0900
Message-ID: <20231205031537.937105148@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kishon Vijay Abraham I <kishon@ti.com>

[ Upstream commit 7c52009d94ab561e70cb72e007a6076f20451f85 ]

Add device ID specific to AM64 and J7200 in pci_endpoint_test so that
endpoints configured with those deviceIDs can use pci_endpoint_test
driver.

Link: https://lore.kernel.org/r/20210811123336.31357-6-kishon@ti.com
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Stable-dep-of: 8293703a492a ("misc: pci_endpoint_test: Add deviceID for J721S2 PCIe EP device support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pci_endpoint_test.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
index b4a07a166605a..9832c2966c110 100644
--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -70,6 +70,8 @@
 
 #define PCI_DEVICE_ID_TI_J721E			0xb00d
 #define PCI_DEVICE_ID_TI_AM654			0xb00c
+#define PCI_DEVICE_ID_TI_J7200			0xb00f
+#define PCI_DEVICE_ID_TI_AM64			0xb010
 #define PCI_DEVICE_ID_LS1088A			0x80c0
 
 #define is_am654_pci_dev(pdev)		\
@@ -1000,6 +1002,12 @@ static const struct pci_device_id pci_endpoint_test_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_J721E),
 	  .driver_data = (kernel_ulong_t)&j721e_data,
 	},
+	{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_J7200),
+	  .driver_data = (kernel_ulong_t)&j721e_data,
+	},
+	{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_AM64),
+	  .driver_data = (kernel_ulong_t)&j721e_data,
+	},
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, pci_endpoint_test_tbl);
-- 
2.42.0



