Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B3727456;
	Tue, 23 Jan 2024 00:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970930; cv=none; b=FzDUBLEB63FyHPzG6NhUVaOcHt07mJ6kS52+s7WImHQOuHNszW5IMoBhpuOW81tqtuvP0KxJ7G+s+iNf/rxEKXHtTQZnrXhM2G1JmNAs+F4uPXzG0TCNJToxVT0DIqj4iRvnpwz9Dydla47wOAZqz1PCQ30rpwjJnY1aIJwpQUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970930; c=relaxed/simple;
	bh=+jVcwGuHz14pQQU0toJHiKkx/+JlAKyVuq1MOp7jWGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXvml+hLvFUIShKpeYsII5wH1LgDlteHZj2dhSXkhozXt5sf8ppIPT7lEBZTLNR5IioybltLZWsuxkgzqY5Vw0TtP0S2WcByHzawELX6JzbauKhr8QyXnJJPYonx2eKi7Hev7acg0fd4uqIRMrjhOHe+Z3WOBOYptdmM4byNOnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqxzOkMO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqxzOkMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44F5C43390;
	Tue, 23 Jan 2024 00:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970930;
	bh=+jVcwGuHz14pQQU0toJHiKkx/+JlAKyVuq1MOp7jWGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqxzOkMOd6kLeHXucsz+2QtfgyN5kLdbo0G3mtzV1VvG2PEMD3NZkMYR8bs3hApsB
	 NdSBWA6U6Mt8tTboLJYWvs/sY+UK7E7YJeKyAhnL4gqRR+gbr8ypcyYNzzhfpxWtNM
	 0pLxmnAwRGTp+o6p/Do3obRvftnFTNBrWrK3MxdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	LeoLiuoc <LeoLiu-oc@zhaoxin.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.10 047/286] PCI: Add ACS quirk for more Zhaoxin Root Ports
Date: Mon, 22 Jan 2024 15:55:53 -0800
Message-ID: <20240122235733.844348143@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

From: LeoLiuoc <LeoLiu-oc@zhaoxin.com>

commit e367e3c765f5477b2e79da0f1399aed49e2d1e37 upstream.

Add more Root Port Device IDs to pci_quirk_zhaoxin_pcie_ports_acs() for
some new Zhaoxin platforms.

Fixes: 299bd044a6f3 ("PCI: Add ACS quirk for Zhaoxin Root/Downstream Ports")
Link: https://lore.kernel.org/r/20231211091543.735903-1-LeoLiu-oc@zhaoxin.com
Signed-off-by: LeoLiuoc <LeoLiu-oc@zhaoxin.com>
[bhelgaas: update subject, drop changelog, add Fixes, add stable tag, fix
whitespace, wrap code comment]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: <stable@vger.kernel.org>	# 5.7
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4551,17 +4551,21 @@ static int pci_quirk_xgene_acs(struct pc
  * But the implementation could block peer-to-peer transactions between them
  * and provide ACS-like functionality.
  */
-static int  pci_quirk_zhaoxin_pcie_ports_acs(struct pci_dev *dev, u16 acs_flags)
+static int pci_quirk_zhaoxin_pcie_ports_acs(struct pci_dev *dev, u16 acs_flags)
 {
 	if (!pci_is_pcie(dev) ||
 	    ((pci_pcie_type(dev) != PCI_EXP_TYPE_ROOT_PORT) &&
 	     (pci_pcie_type(dev) != PCI_EXP_TYPE_DOWNSTREAM)))
 		return -ENOTTY;
 
+	/*
+	 * Future Zhaoxin Root Ports and Switch Downstream Ports will
+	 * implement ACS capability in accordance with the PCIe Spec.
+	 */
 	switch (dev->device) {
 	case 0x0710 ... 0x071e:
 	case 0x0721:
-	case 0x0723 ... 0x0732:
+	case 0x0723 ... 0x0752:
 		return pci_acs_ctrl_enabled(acs_flags,
 			PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 	}


