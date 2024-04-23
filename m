Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224D7143C49;
	Tue, 23 Apr 2024 21:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908723; cv=none; b=a6sQKwMDXu55KXEffda0BLsinkosrGMcz+wR+CdqZFgvdPkB78ICiplxRoequM9qG4rKR0y969dwmPccc2ux/wiBmsrupJe6APOuIhspS0aoaT1Y/VK9fL8UQRj8o7pUAYBhnvmr3EnqkBsn4Bou765Y99ESbp5W5IbYJ74oFjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908723; c=relaxed/simple;
	bh=CUpCWBkfJ0kL3HhBayatLNFps5OeA8mvuEH1O/HHN4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H4ArAip9AR7rS5h6M5PKtgAiRA1HxN9iF1fnAW03A7sUycVf9iHPcllRJSj7dzVa0u8Mpv+HiHguB3W0Kapt68u1i5CsnhgxNmYgZDX4Fgs860AOcuZr8/vZnFFolD6flJM//8itb1OhmF0mrCoy8aIH7zYH5KVuKNWMc7K8ouc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s8pkSVgs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s8pkSVgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8407C3277B;
	Tue, 23 Apr 2024 21:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908723;
	bh=CUpCWBkfJ0kL3HhBayatLNFps5OeA8mvuEH1O/HHN4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s8pkSVgs/dUOls2wb3uTVAMtKG0FhVvCd5ROfppuCXNrelOID2nqlhtg5V018QhbO
	 NDSkVApz4zlAxriKVUE2oDrIk9lp8ArEepTGzNO1cAZ//syWVQ6mIiIF3nPFf//wgm
	 kDnatBYMJEX78U5YPS9cEP7dsabE2qKY7/ItpKeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/141] PCI: Simplify pcie_capability_clear_and_set_word() to ..._clear_word()
Date: Tue, 23 Apr 2024 14:39:06 -0700
Message-ID: <20240423213855.732564009@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 0fce6e5c87faec2c8bf28d2abc8cb595f4e244b6 ]

When using pcie_capability_clear_and_set_word() but not actually *setting*
anything, use pcie_capability_clear_word() instead.

Link: https://lore.kernel.org/r/20231026121924.2164-1-ilpo.jarvinen@linux.intel.com
Link: https://lore.kernel.org/r/20231026121924.2164-2-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
[bhelgaas: squash]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aspm.c | 8 ++++----
 drivers/pci/quirks.c    | 6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 25736d408e88e..2a3d973658dac 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -743,10 +743,10 @@ static void pcie_config_aspm_l1ss(struct pcie_link_state *link, u32 state)
 	 * in pcie_config_aspm_link().
 	 */
 	if (enable_req & (ASPM_STATE_L1_1 | ASPM_STATE_L1_2)) {
-		pcie_capability_clear_and_set_word(child, PCI_EXP_LNKCTL,
-						   PCI_EXP_LNKCTL_ASPM_L1, 0);
-		pcie_capability_clear_and_set_word(parent, PCI_EXP_LNKCTL,
-						   PCI_EXP_LNKCTL_ASPM_L1, 0);
+		pcie_capability_clear_word(child, PCI_EXP_LNKCTL,
+					   PCI_EXP_LNKCTL_ASPM_L1);
+		pcie_capability_clear_word(parent, PCI_EXP_LNKCTL,
+					   PCI_EXP_LNKCTL_ASPM_L1);
 	}
 
 	val = 0;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e4951b30b923b..ba353b37ba526 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4478,9 +4478,9 @@ static void quirk_disable_root_port_attributes(struct pci_dev *pdev)
 
 	pci_info(root_port, "Disabling No Snoop/Relaxed Ordering Attributes to avoid PCIe Completion erratum in %s\n",
 		 dev_name(&pdev->dev));
-	pcie_capability_clear_and_set_word(root_port, PCI_EXP_DEVCTL,
-					   PCI_EXP_DEVCTL_RELAX_EN |
-					   PCI_EXP_DEVCTL_NOSNOOP_EN, 0);
+	pcie_capability_clear_word(root_port, PCI_EXP_DEVCTL,
+				   PCI_EXP_DEVCTL_RELAX_EN |
+				   PCI_EXP_DEVCTL_NOSNOOP_EN);
 }
 
 /*
-- 
2.43.0



