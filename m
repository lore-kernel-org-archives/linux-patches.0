Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81AF4315A;
	Mon, 23 Jun 2025 21:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715077; cv=none; b=a9Qr/f3sAB5akLBBuEAXhW7vyYQhAURqhgULvle2CxSLnfRF6XP4+yGjDytAlXILeQXPVx16oB0tCTWAbB3B3CVD1Lt50ArUI1S3WUkx9bWcFbWN8eKXrdAqn/tzQwT9rKzCBcm1Y8Jb0nSPvo2j6djL86okDAilx4AG6e4PNiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715077; c=relaxed/simple;
	bh=gpFAzxP0YDpn8bou5VPEkMpzGXArcmtw6Qj+RW4/HhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGZePfb3Uk043N6cFRlx+01oG9K758dTlXlxr2WidmheXEuE6o832nttSwAco0/KZ2ZyjnQaEfvxqbQU8ZYddyzGcWn66oinLxjoS75Lnuf5zv4PxSShPrDJiViQF9u8QFn2MWZtzGtsd3ujkJo1fSzSV7cUC3ne/fUO0bSTwMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6EFzVcW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6EFzVcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD82C4CEEA;
	Mon, 23 Jun 2025 21:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715077;
	bh=gpFAzxP0YDpn8bou5VPEkMpzGXArcmtw6Qj+RW4/HhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6EFzVcWyq/kYhcNtc7zdrI4Wx4ZQMGUNlookp9RurDqt/YSZ4U71x+2rhSbugzCf
	 c5o6XCuy9idxjTMPVFgR8i0bmH0eYNP2Rwg+UkzzVvXFD/qqg2uorOm+nH8eFSSe24
	 iTjzkb/SfOv/OOPbzokiKaSuMZtpNCCNfZJw6XMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.12 154/414] PCI: dw-rockchip: Remove PCIE_L0S_ENTRY check from rockchip_pcie_link_up()
Date: Mon, 23 Jun 2025 15:04:51 +0200
Message-ID: <20250623130645.892738138@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Shawn Lin <shawn.lin@rock-chips.com>

commit 7d9b5d6115532cf90a789ed6afd3f4c70ebbd827 upstream.

rockchip_pcie_link_up() currently has two issues:
1. Value 0x11 of PCIE_L0S_ENTRY corresponds to L0 state, not L0S. So the
naming is wrong from the very beginning.
2. Checking for value 0x11 treats other states like L0S and L1 as link
down, which is wrong.

Hence, remove the PCIE_L0S_ENTRY check and also its definition. This allows
adding ASPM support in the successive commits.

Fixes: 0e898eb8df4e ("PCI: rockchip-dwc: Add Rockchip RK356X host controller driver")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
[mani: commit message rewording]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/1744850111-236269-1-git-send-email-shawn.lin@rock-chips.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-dw-rockchip.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/pci/controller/dwc/pcie-dw-rockchip.c
+++ b/drivers/pci/controller/dwc/pcie-dw-rockchip.c
@@ -44,7 +44,6 @@
 #define PCIE_LINKUP			(PCIE_SMLH_LINKUP | PCIE_RDLH_LINKUP)
 #define PCIE_RDLH_LINK_UP_CHGED		BIT(1)
 #define PCIE_LINK_REQ_RST_NOT_INT	BIT(2)
-#define PCIE_L0S_ENTRY			0x11
 #define PCIE_CLIENT_GENERAL_CONTROL	0x0
 #define PCIE_CLIENT_INTR_STATUS_LEGACY	0x8
 #define PCIE_CLIENT_INTR_MASK_LEGACY	0x1c
@@ -177,8 +176,7 @@ static int rockchip_pcie_link_up(struct
 	struct rockchip_pcie *rockchip = to_rockchip_pcie(pci);
 	u32 val = rockchip_pcie_get_ltssm(rockchip);
 
-	if ((val & PCIE_LINKUP) == PCIE_LINKUP &&
-	    (val & PCIE_LTSSM_STATUS_MASK) == PCIE_L0S_ENTRY)
+	if ((val & PCIE_LINKUP) == PCIE_LINKUP)
 		return 1;
 
 	return 0;


