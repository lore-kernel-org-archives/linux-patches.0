Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0887120316
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHlwsCdu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79754C433C9;
	Mon,  6 Nov 2023 13:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276491;
	bh=Udm8/nUEi0p8A0iEH9HVKU1pJco4ulDNpjiOZoQzW+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHlwsCdus4xVcmdVg0iVL8yNi760pUEFWeAFJpwBcTbBkewfhcrEnCTINjYxUNvjl
	 EefYb5X2ueMFziHEh328v01/bYKadtKV98R/2sLHIX8oYUfMfYUGaKsdpUNJ9uwnbA
	 4dIb7iU6dR5fxV+iOmTjogeiBlE7aezoves5g5xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	stable <stable@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 6.1 60/62] misc: pci_endpoint_test: Add deviceID for J721S2 PCIe EP device support
Date: Mon,  6 Nov 2023 14:04:06 +0100
Message-ID: <20231106130303.906689757@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
References: <20231106130301.807965064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

commit 8293703a492ae97c86af27c75b76e6239ec86483 upstream.

Add DEVICE_ID for J721S2 and enable support for endpoints configured
with this DEVICE_ID in the pci_endpoint_test driver.

Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Cc: stable <stable@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20231020120248.3168406-1-s-vadapalli@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/pci_endpoint_test.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -71,6 +71,7 @@
 #define PCI_DEVICE_ID_TI_AM654			0xb00c
 #define PCI_DEVICE_ID_TI_J7200			0xb00f
 #define PCI_DEVICE_ID_TI_AM64			0xb010
+#define PCI_DEVICE_ID_TI_J721S2		0xb013
 #define PCI_DEVICE_ID_LS1088A			0x80c0
 
 #define is_am654_pci_dev(pdev)		\
@@ -1004,6 +1005,9 @@ static const struct pci_device_id pci_en
 	{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_AM64),
 	  .driver_data = (kernel_ulong_t)&j721e_data,
 	},
+	{ PCI_DEVICE(PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_J721S2),
+	  .driver_data = (kernel_ulong_t)&j721e_data,
+	},
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, pci_endpoint_test_tbl);


