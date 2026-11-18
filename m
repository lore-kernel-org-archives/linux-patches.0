Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019636;
	b=sK4X7LP7wXwqEw068iDNyiy9tWeTPQuPyZcI77dh/P2LyAv5DzNwZLFh1Nt3bu1jfaXr
	 HSWTx5iOfp9wRsbbj6eufba8I4/7f6FrSnhnSMJU1reLa6/2GRxp9EYuZB2XCvUMp2FkD
	 qT8PXpDHCJJzS3LGQyQwH0pIpefCvBMgxrDZYOexPMxtGvl6JR3w4fc1AlXCZ92cHV0PS
	 NDN8uKc/8o8P+Vffcj9sLsRpQcfxXoGfDPHrGhvRvZLBa/Cdsfsifvkgg5suN5XM/gUc2
	 FehmD2shL+JuAYxavwRU5sVS50noF9TyeQ1fef52H2NLsAa9kDyfFtLCb6n43QinRgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019636;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ow7y3oAPNFv67o3lKcUM2d/iVXhYAQqy9v2AvN0u0lA=;
	b=1XZNA7Q3kD28UQvvHdNtYuwYtD69GGC1/HQbd2XRfuCipY/28A0oQttK0o0+bCGjvmfE
	 8NRKCqjCqcAI73+0SL2G4/OznT04lCpkOpc5GNHWP6gu03ddB+WV/c8c025ivbWzMQhIS
	 ft0A9eA4UbJK5JE3C6MgQT89dE5QvUQ670M2Hiuxycg0XxmM5jamJ+fPdqK5K1Xe17h1p
	 mWPIUSD9StSBXi+t0T79dSlfK6Ubqki0qDmS8dltcEfGFNNrm/W5bIW+GG8JKdFZVAM27
	 j6TQFqxB0FfO1htIYqXGPFAXJ7MjdRRcuUerxaaJXwFXLqr6mMAq6tynWHHyGQs24Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iMARRzdo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0887606A7C5;
	Wed, 18 Nov 2026 16:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iMARRzdo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EB41F000C4;
	Wed, 18 Nov 2026 16:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019635;
	bh=ow7y3oAPNFv67o3lKcUM2d/iVXhYAQqy9v2AvN0u0lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iMARRzdoO0caEswCzNaUI27S7q0lU1aO0IZeSm4fuBKBgq8NxiweN+Ex0q23kg1Yq
	 p8NsHZhGINGWNpagb8YkWOSQ2hXCfnDJQr7neGeP+LCOLtsEE7/jdTo33G4bDkVSQL
	 rYjh6zGSec1iQhb/nIOrFBY+100ulre+yiiX5Uzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1667/2651] PCI: Update saved Max Payload Size in pcie_set_mps()
Date: Wed, 18 Nov 2026 15:48:27 +0100
Message-ID: <20261118150347.725177948@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 581cf67cb6f66eabc6bcd7f61dd64b2559270507 ]

pcie_set_mps() changes the Max Payload Size (MPS) in the Device Control
register but leaves the copy saved by pci_save_state() alone, so the next
pci_restore_state() puts back the old value.

The PCI core does change the MPS of devices whose state has already been
saved: pci_configure_mps() reduces a Root Port's MPS when a device with a
smaller MPS Supported is hot-added directly below it (commit 9f0e89359775
("PCI: Match Root Port's MPS to endpoint's MPSS as necessary")), and with
"pci=pcie_bus_safe", pcie_bus_configure_settings() can do the same when
pciehp calls it after a hot-add.  The Root Port's state was saved when it
was added and again when portdrv probed it.

Since commit 3fc686d550f6 ("PCI/ERR: Add support for resetting the Root
Ports in a platform-specific way"), pcibios_reset_secondary_bus() restores
that saved state, without saving it first, after host->reset_root_port()
has reset the Root Port, e.g. during AER recovery or on Link Down with the
qcom and Rockchip DWC drivers.  The Root Port then goes back to the old,
larger MPS while the device below it is restored to the smaller one, so the
Root Port may send TLPs that the device treats as Malformed.

Update the saved copy of Device Control when pcie_set_mps() changes the
MPS, like commit 909f7bf9b080 ("PCI: Update saved_config_space upon
resource assignment") does for BARs.

Fixes: 3fc686d550f6 ("PCI/ERR: Add support for resetting the Root Ports in a platform-specific way")
Assisted-by: LLM
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Link: https://patch.msgid.link/20261005124154.2190628-2-cassel@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index f85256413cf3d..7c6f2aba81443 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1743,6 +1743,24 @@ static void pci_restore_pcie_state(struct pci_dev *dev)
 	pcie_capability_write_word(dev, PCI_EXP_SLTCTL2, cap[i++]);
 }
 
+/*
+ * Update the saved copy of the Device Control register after changing it, so
+ * that pci_restore_state() doesn't put back a stale value.  Device Control is
+ * the first register saved by pci_save_pcie_state().
+ */
+static void pcie_update_saved_devctl(struct pci_dev *dev, u16 clear, u16 set)
+{
+	struct pci_cap_saved_state *save_state;
+	u16 *devctl;
+
+	save_state = pci_find_saved_cap(dev, PCI_CAP_ID_EXP);
+	if (!save_state)
+		return;
+
+	devctl = (u16 *)&save_state->cap.data[0];
+	*devctl = (*devctl & ~clear) | set;
+}
+
 static int pci_save_pcix_state(struct pci_dev *dev)
 {
 	int pos;
@@ -5998,8 +6016,12 @@ int pcie_set_mps(struct pci_dev *dev, int mps)
 
 	ret = pcie_capability_clear_and_set_word(dev, PCI_EXP_DEVCTL,
 						  PCI_EXP_DEVCTL_PAYLOAD, v);
+	if (ret)
+		return pcibios_err_to_errno(ret);
 
-	return pcibios_err_to_errno(ret);
+	pcie_update_saved_devctl(dev, PCI_EXP_DEVCTL_PAYLOAD, v);
+
+	return 0;
 }
 EXPORT_SYMBOL(pcie_set_mps);
 
-- 
2.53.0



