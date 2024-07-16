Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAB01DDCE;
	Tue, 16 Jul 2024 16:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145729; cv=none; b=R3LyAYf41VzHT8K3xYnbdgHC70k358OZPDNq3smuB570F91mfJKWRtlvwGaSWL8whmUDMCVNWQv2Vhsj94Meq8jr1C7DOWz35i8LkJmsgcJjUHE7Znqvax0NMfri6qHr+FjJ6XQSJ/mYZx8psqbB5KRWGGqTt0jgwBvLAt2Qm9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145729; c=relaxed/simple;
	bh=QDWAzIHlO+eyqYx8PJJ8MmGdtWHf6wwmW5IpJkqdhYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qb2GlZm4cGxlaF6+mtIZ3846tULlo65fyI+TuuOhE5mDAPv0vCjEphnKJvkhgOUtBRzqrOhrprjAlpqFjB8aXtVkegOhd8GnjGNcpoRNvBRc9zeIuGbS9vSe+xQRRks9g83RtsldAvyBW1E1nSdOll26mM4pWvcpWec61Q75B1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dkNWswkr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dkNWswkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658A4C116B1;
	Tue, 16 Jul 2024 16:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145728;
	bh=QDWAzIHlO+eyqYx8PJJ8MmGdtWHf6wwmW5IpJkqdhYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dkNWswkrGufBU571M50cwOLu/4KoMEux9WsaBJ64Nhx6loxRSo5fFCZpUt97tI3Am
	 xNJvntJSfTvP+M1G5CXIvy28HikbRwRzviVG9DEoAuy5j9kHHaAXFq/+SMTeQyieUh
	 NgqNqMAMYb2S59X8Ctg2o0FYBXpF2iBP86UiCu8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.6 065/121] usb: dwc3: pci: add support for the Intel Panther Lake
Date: Tue, 16 Jul 2024 17:32:07 +0200
Message-ID: <20240716152753.829421041@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 2bf35ea46d0bc379c456e14c0ec1dc1e003b39f1 upstream.

This patch adds the necessary PCI IDs for Intel Panther Lake
devices.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@kernel.org>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20240628111834.1498461-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-pci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -54,6 +54,10 @@
 #define PCI_DEVICE_ID_INTEL_MTL			0x7e7e
 #define PCI_DEVICE_ID_INTEL_ARLH_PCH		0x777e
 #define PCI_DEVICE_ID_INTEL_TGL			0x9a15
+#define PCI_DEVICE_ID_INTEL_PTLH		0xe332
+#define PCI_DEVICE_ID_INTEL_PTLH_PCH		0xe37e
+#define PCI_DEVICE_ID_INTEL_PTLU		0xe432
+#define PCI_DEVICE_ID_INTEL_PTLU_PCH		0xe47e
 #define PCI_DEVICE_ID_AMD_MR			0x163a
 
 #define PCI_INTEL_BXT_DSM_GUID		"732b85d5-b7a7-4a1b-9ba0-4bbd00ffd511"
@@ -430,6 +434,10 @@ static const struct pci_device_id dwc3_p
 	{ PCI_DEVICE_DATA(INTEL, MTLS, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, ARLH_PCH, &dwc3_pci_intel_swnode) },
 	{ PCI_DEVICE_DATA(INTEL, TGL, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, PTLH, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, PTLH_PCH, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, PTLU, &dwc3_pci_intel_swnode) },
+	{ PCI_DEVICE_DATA(INTEL, PTLU_PCH, &dwc3_pci_intel_swnode) },
 
 	{ PCI_DEVICE_DATA(AMD, NL_USB, &dwc3_pci_amd_swnode) },
 	{ PCI_DEVICE_DATA(AMD, MR, &dwc3_pci_amd_mr_swnode) },


