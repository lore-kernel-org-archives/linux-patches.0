Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C2439A26E;
	Wed,  3 Dec 2025 16:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780813; cv=none; b=KilURwoDq7VRpfiHvK7sCkcxllB9beo4M76QKkoIna/O6cXLD3S+1vuhpLC5ZTugXFirKky8rg5MI3CzGIxFwt6Ny8n8YiRTxC6+4aD5XGjRVSMLy+5vyLSjltZ2m8lZi1UsvGBdsWXz/WoHo30AeZCZE1oaXwCLH1bc645gWfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780813; c=relaxed/simple;
	bh=pNsLAUCPCL5AHRBFRTVniU8XFhN+QypfYjMyhDxkxJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lgXS3IIj+MVijM/4KhNhmfNV6IpIr0bBcg8qi09/qCo9tMhtc9A6fHyXP2yogZDbG2ZPiFM0CXC5I5jsgPBbccM60uSmfMzGyVwbhv9Q8zPhszmNdLWTqjuzAcGxDMeDYf2L5DWdO12VEV6NuZWasF9K+vPYFhJEilCyEZRxIi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hh3RC1en; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hh3RC1en"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67AA4C4CEF5;
	Wed,  3 Dec 2025 16:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780812;
	bh=pNsLAUCPCL5AHRBFRTVniU8XFhN+QypfYjMyhDxkxJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hh3RC1enemP4g9xIXURf9KvzI8KPa1KVouw/gziMv4R57mi3oH6rHa6KXG5FyYRcw
	 AoNL986HofmT6qOa73KaV9pXz1BVove5dBCU8aS3fVuPG4BYLouJcSY2ceurfMWyyW
	 MijY5aBLBl8IglvNeM0FlAt87YgF9F+gasJqlKm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 096/132] usb: dwc3: pci: Sort out the Intel device IDs
Date: Wed,  3 Dec 2025 16:29:35 +0100
Message-ID: <20251203152346.844980712@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 46b28d2fbd13148981d91246bc0e13f4fc055987 upstream.

The PCI device IDs were organised based on the Intel
architecture generation in most cases, but not with every
ID. That left the device ID table with no real order.
Sorting the table based on the device ID.

Suggested-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://patch.msgid.link/20251107121548.2702900-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-pci.c |   82 ++++++++++++++++++++++----------------------
 1 file changed, 41 insertions(+), 41 deletions(-)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -21,41 +21,41 @@
 #include <linux/acpi.h>
 #include <linux/delay.h>
 
+#define PCI_DEVICE_ID_INTEL_CMLLP		0x02ee
+#define PCI_DEVICE_ID_INTEL_CMLH		0x06ee
+#define PCI_DEVICE_ID_INTEL_BXT			0x0aaa
 #define PCI_DEVICE_ID_INTEL_BYT			0x0f37
 #define PCI_DEVICE_ID_INTEL_MRFLD		0x119e
-#define PCI_DEVICE_ID_INTEL_BSW			0x22b7
-#define PCI_DEVICE_ID_INTEL_SPTLP		0x9d30
-#define PCI_DEVICE_ID_INTEL_SPTH		0xa130
-#define PCI_DEVICE_ID_INTEL_BXT			0x0aaa
 #define PCI_DEVICE_ID_INTEL_BXT_M		0x1aaa
-#define PCI_DEVICE_ID_INTEL_APL			0x5aaa
-#define PCI_DEVICE_ID_INTEL_KBP			0xa2b0
-#define PCI_DEVICE_ID_INTEL_CMLLP		0x02ee
-#define PCI_DEVICE_ID_INTEL_CMLH		0x06ee
+#define PCI_DEVICE_ID_INTEL_BSW			0x22b7
 #define PCI_DEVICE_ID_INTEL_GLK			0x31aa
-#define PCI_DEVICE_ID_INTEL_CNPLP		0x9dee
-#define PCI_DEVICE_ID_INTEL_CNPH		0xa36e
-#define PCI_DEVICE_ID_INTEL_CNPV		0xa3b0
 #define PCI_DEVICE_ID_INTEL_ICLLP		0x34ee
-#define PCI_DEVICE_ID_INTEL_EHL			0x4b7e
-#define PCI_DEVICE_ID_INTEL_TGPLP		0xa0ee
 #define PCI_DEVICE_ID_INTEL_TGPH		0x43ee
-#define PCI_DEVICE_ID_INTEL_JSP			0x4dee
-#define PCI_DEVICE_ID_INTEL_WCL			0x4d7e
 #define PCI_DEVICE_ID_INTEL_ADL			0x460e
-#define PCI_DEVICE_ID_INTEL_ADL_PCH		0x51ee
 #define PCI_DEVICE_ID_INTEL_ADLN		0x465e
+#define PCI_DEVICE_ID_INTEL_EHL			0x4b7e
+#define PCI_DEVICE_ID_INTEL_WCL			0x4d7e
+#define PCI_DEVICE_ID_INTEL_JSP			0x4dee
+#define PCI_DEVICE_ID_INTEL_ADL_PCH		0x51ee
 #define PCI_DEVICE_ID_INTEL_ADLN_PCH		0x54ee
-#define PCI_DEVICE_ID_INTEL_ADLS		0x7ae1
-#define PCI_DEVICE_ID_INTEL_RPL			0xa70e
+#define PCI_DEVICE_ID_INTEL_APL			0x5aaa
+#define PCI_DEVICE_ID_INTEL_NVLS_PCH		0x6e6f
+#define PCI_DEVICE_ID_INTEL_ARLH_PCH		0x777e
 #define PCI_DEVICE_ID_INTEL_RPLS		0x7a61
+#define PCI_DEVICE_ID_INTEL_MTL			0x7e7e
+#define PCI_DEVICE_ID_INTEL_ADLS		0x7ae1
 #define PCI_DEVICE_ID_INTEL_MTLM		0x7eb1
 #define PCI_DEVICE_ID_INTEL_MTLP		0x7ec1
 #define PCI_DEVICE_ID_INTEL_MTLS		0x7f6f
-#define PCI_DEVICE_ID_INTEL_MTL			0x7e7e
-#define PCI_DEVICE_ID_INTEL_NVLS_PCH		0x6e6f
-#define PCI_DEVICE_ID_INTEL_ARLH_PCH		0x777e
 #define PCI_DEVICE_ID_INTEL_TGL			0x9a15
+#define PCI_DEVICE_ID_INTEL_SPTLP		0x9d30
+#define PCI_DEVICE_ID_INTEL_CNPLP		0x9dee
+#define PCI_DEVICE_ID_INTEL_TGPLP		0xa0ee
+#define PCI_DEVICE_ID_INTEL_SPTH		0xa130
+#define PCI_DEVICE_ID_INTEL_KBP			0xa2b0
+#define PCI_DEVICE_ID_INTEL_CNPH		0xa36e
+#define PCI_DEVICE_ID_INTEL_CNPV		0xa3b0
+#define PCI_DEVICE_ID_INTEL_RPL			0xa70e
 #define PCI_DEVICE_ID_INTEL_PTLH		0xe332
 #define PCI_DEVICE_ID_INTEL_PTLH_PCH		0xe37e
 #define PCI_DEVICE_ID_INTEL_PTLU		0xe432
@@ -413,41 +413,41 @@ static void dwc3_pci_remove(struct pci_d
 }
 
 static const struct pci_device_id dwc3_pci_id_table[] = {
-	{ PCI_DEVICE_DATA(INTEL, BSW, &dwc3_pci_intel_swnode) },
-	{ PCI_DEVICE_DATA(INTEL, BYT, &dwc3_pci_intel_byt_swnode) },
-	{ PCI_DEVICE_DATA(INTEL, MRFLD, &dwc3_pci_intel_mrfld_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, CMLLP, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, CMLH, &dwc3_pci_intel_swnode) },
-	{ PCI_DEVICE_DATA(INTEL, SPTLP, &dwc3_pci_intel_swnode) },
-	{ PCI_DEVICE_DATA(INTEL, SPTH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, BXT, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, BYT, &dwc3_pci_intel_byt_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, MRFLD, &dwc3_pci_intel_mrfld_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, BXT_M, &dwc3_pci_intel_swnode) },
-	{ PCI_DEVICE_DATA(INTEL, APL, &dwc3_pci_intel_swnode) },
-	{ PCI_DEVICE_DATA(INTEL, KBP, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, BSW, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, GLK, &dwc3_pci_intel_swnode) },
-	{ PCI_DEVICE_DATA(INTEL, CNPLP, &dwc3_pci_intel_swnode) },
-	{ PCI_DEVICE_DATA(INTEL, CNPH, &dwc3_pci_intel_swnode) },
-	{ PCI_DEVICE_DATA(INTEL, CNPV, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, ICLLP, &dwc3_pci_intel_swnode) },
-	{ PCI_DEVICE_DATA(INTEL, EHL, &dwc3_pci_intel_swnode) },
-	{ PCI_DEVICE_DATA(INTEL, TGPLP, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, TGPH, &dwc3_pci_intel_swnode) },
-	{ PCI_DEVICE_DATA(INTEL, JSP, &dwc3_pci_intel_swnode) },
-	{ PCI_DEVICE_DATA(INTEL, WCL, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, ADL, &dwc3_pci_intel_swnode) },
-	{ PCI_DEVICE_DATA(INTEL, ADL_PCH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, ADLN, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, EHL, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, WCL, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, JSP, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, ADL_PCH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, ADLN_PCH, &dwc3_pci_intel_swnode) },
-	{ PCI_DEVICE_DATA(INTEL, ADLS, &dwc3_pci_intel_swnode) },
-	{ PCI_DEVICE_DATA(INTEL, RPL, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, APL, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, NVLS_PCH, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, ARLH_PCH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, RPLS, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, MTL, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, ADLS, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, MTLM, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, MTLP, &dwc3_pci_intel_swnode) },
-	{ PCI_DEVICE_DATA(INTEL, MTL, &dwc3_pci_intel_swnode) },
-	{ PCI_DEVICE_DATA(INTEL, NVLS_PCH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, MTLS, &dwc3_pci_intel_swnode) },
-	{ PCI_DEVICE_DATA(INTEL, ARLH_PCH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, TGL, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, SPTLP, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, CNPLP, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, TGPLP, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, SPTH, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, KBP, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, CNPH, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, CNPV, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, RPL, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, PTLH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, PTLH_PCH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, PTLU, &dwc3_pci_intel_swnode) },


