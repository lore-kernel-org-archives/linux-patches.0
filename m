Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26B713C69C;
	Thu, 13 Jun 2024 12:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281225; cv=none; b=D7WAZy+JTwdeUBc1OAWkoiim3snSv9xg2vlaFs2CfK2Iv9mIav7ruAp0+vibJit4+UY0FTmb3YAZEdVnWSbTigAnR9XWJL+4lDddXo13Fa2RGg6zD+HM/LkM+p0r03tuEtd+fNlH+KlHCYK+q8l3+k+rIIWDuAB2Di3lDwrVKzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281225; c=relaxed/simple;
	bh=6fA/kkFss0bTjjhG2xT4HrbojmLilmnX49EdUVrNsqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFF8ISMdyzv9Ij3paWZja6UNhao1DqT+MXnR7ySEmWstHdCbigqpvYCrvhluL9WsdxD7vbbNM9bkylZJrW9jaAp4WwamlEfA7QXEzzJdpjZMPldjO1AHwrExSaEXCsgFnZTmqHmGjCIHXn79iFNUd8vKgDdABWFGOIg/HDhNCf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RadlT3F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RadlT3F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1149C2BBFC;
	Thu, 13 Jun 2024 12:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281225;
	bh=6fA/kkFss0bTjjhG2xT4HrbojmLilmnX49EdUVrNsqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2RadlT3F2TWlmUGV5Lbk3znI6bGYYVkpAFDWaKEavuDyoml2qUPw4IFxFrU0vgwcL
	 FhxWo3MJc2YDMXAM/8fYyos8MqsbnVPZ29nk7WJTmu+5FiI8G81/BAG0/A4guLtcRf
	 sBV0IuViH+vGL51zxbfGYRPXcaRQN409xTrwn8xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	Satish Thatchanamurthy <Satish.Thatchanamurt@Dell.com>
Subject: [PATCH 5.10 182/317] PCI/EDR: Align EDR_PORT_LOCATE_DSM with PCI Firmware r3.3
Date: Thu, 13 Jun 2024 13:33:20 +0200
Message-ID: <20240613113254.600401715@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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



