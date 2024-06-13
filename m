Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA8912C81F;
	Thu, 13 Jun 2024 12:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282295; cv=none; b=k1CCMXYwjvwY8JmXdajjIXoUHJ3JGu0HSA3CO4gRm+x/w+evBhhRyjAQwjBhUEXW9mh3sDzuykHMb5mwE9CJVBgQAAx9kcFsoAFJzhpctyrLBsyZToqauffImls7L9En/CGHZkWLnsV3Owvth83APmkIEK4yB2bkyXDrBIC4xjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282295; c=relaxed/simple;
	bh=Qf4BbfDtLG2Cbnw+ILZ5UEeyOAdkaBcmxMFgAxOTpmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqCkW058FMZUZxt2AVIsey35HTgi4ZldshFjf8rjn05w4ysCqdmjoue1Yry+rtu1Q8IDMXyS/YN0KIREIOIIOlAOZ2M4ZUEw1x1weVVr8stRW08M7pLe4vkq7QBHl/bXO1uYl4wS+MYYIsc/NxUQdIquIci8bqKYx+8UwjxyS0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNbCmqwi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNbCmqwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E3FC2BBFC;
	Thu, 13 Jun 2024 12:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282295;
	bh=Qf4BbfDtLG2Cbnw+ILZ5UEeyOAdkaBcmxMFgAxOTpmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNbCmqwiqRd8xFWY+FqX6Zpt9/atLxW30pqIHT4hluobYMuMZ/fKuIJ62u0CnmrSt
	 tLnT2Ull3k9Z5nTXcMZKiTOoxXqVyMAy/eh/5NzkM/hrJPNjo3hYLt6TQvnHL2h4pQ
	 sdFT87C8WaQuXh//XLLIPmfJ0Q1lbhljlXSxToYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	Satish Thatchanamurthy <Satish.Thatchanamurt@Dell.com>
Subject: [PATCH 5.15 229/402] PCI/EDR: Align EDR_PORT_LOCATE_DSM with PCI Firmware r3.3
Date: Thu, 13 Jun 2024 13:33:06 +0200
Message-ID: <20240613113311.076950323@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

[ Upstream commit e2e78a294a8a863898b781dbcf90e087eda3155d ]

The "Downstream Port Containment related Enhancements" ECN of Jan 28, 2019
(document 12888 below), defined the EDR_PORT_LOCATE_DSM function with
Revision ID 5 with a return value encoding (Bits 2:0 = Function, Bits 7:3 =
Device, Bits 15:8 = Bus).  When the ECN was integrated into PCI Firmware
r3.3, sec 4.6.13, Bit 31 was added to indicate success or failure.

Check Bit 31 for failure in acpi_dpc_port_get().

Link: https://lore.kernel.org/r/20240501022543.1626025-1-sathyanarayanan.kuppuswamy@linux.intel.com
Link: https://members.pcisig.com/wg/PCI-SIG/document/12888
Fixes: ac1c8e35a326 ("PCI/DPC: Add Error Disconnect Recover (EDR) support")
Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
[bhelgaas: split into two patches, update commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Satish Thatchanamurthy <Satish.Thatchanamurt@Dell.com> # one platform
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/edr.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/edr.c b/drivers/pci/pcie/edr.c
index 5b5a502363c00..35210007602c5 100644
--- a/drivers/pci/pcie/edr.c
+++ b/drivers/pci/pcie/edr.c
@@ -80,8 +80,9 @@ static struct pci_dev *acpi_dpc_port_get(struct pci_dev *pdev)
 	u16 port;
 
 	/*
-	 * Behavior when calling unsupported _DSM functions is undefined,
-	 * so check whether EDR_PORT_DPC_ENABLE_DSM is supported.
+	 * If EDR_PORT_LOCATE_DSM is not implemented under the target of
+	 * EDR, the target is the port that experienced the containment
+	 * event (PCI Firmware r3.3, sec 4.6.13).
 	 */
 	if (!acpi_check_dsm(adev->handle, &pci_acpi_dsm_guid, 5,
 			    1ULL << EDR_PORT_LOCATE_DSM))
@@ -98,6 +99,16 @@ static struct pci_dev *acpi_dpc_port_get(struct pci_dev *pdev)
 		return NULL;
 	}
 
+	/*
+	 * Bit 31 represents the success/failure of the operation. If bit
+	 * 31 is set, the operation failed.
+	 */
+	if (obj->integer.value & BIT(31)) {
+		ACPI_FREE(obj);
+		pci_err(pdev, "Locate Port _DSM failed\n");
+		return NULL;
+	}
+
 	/*
 	 * Firmware returns DPC port BDF details in following format:
 	 *	15:8 = bus
-- 
2.43.0



