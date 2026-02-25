Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE3218B0A;
	Wed, 25 Feb 2026 01:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983284; cv=none; b=JEiSEwV1AAR3faqYBHPbMNDjSMOA1ACtJrwfaFlZnacY87/4Y1zefGfpHJpfovBJ5PToK5LPT69atLrQ8ZQbXAVjmT84PUn+h9HfjPJgB6SNpJ14bMwWsHut/HKwvD0hzyaNy+AAhJxMutZzIWu/X7Yu3lVfmBNdB/EpxKGjcpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983284; c=relaxed/simple;
	bh=V67fGRHSHPj9Yf3aBtySafwaWxzi98NviC843VmCtHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HgU8nrX+KdmGIl9u1rGUHFhH35D+wIvtkfqyIELNSw3Hw9epdBnetj5891rUUYFUIw0cYGXtlEqvsx33JbEaTIfWRHBmh7bDW3oUL1Tmuui1v48ON0uT0ycBykH2nqBSNUWQ6Szl7NDUvrU3alDgAVmKbNT5zEuBISraT+hFJWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmG5SSPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmG5SSPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD395C116D0;
	Wed, 25 Feb 2026 01:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983284;
	bh=V67fGRHSHPj9Yf3aBtySafwaWxzi98NviC843VmCtHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BmG5SSPcfXbOINUDzfwgWnGrR6vzvaB/KmPEwh9APPC10Bv3NhNotNq4dYab3myrk
	 OqIZEpyZrwaL3dcF9lqU0JIhNpzY+LuTSF9x7MDro/CP4Ml0Jq0wND7grbDy6Z3Svz
	 vX78dochGKU9yG4SWKhKY11+gpHN70H033aJJiEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 421/781] PCI: Add ACS quirk for Pericom PI7C9X2G404 switches [12d8:b404]
Date: Tue, 24 Feb 2026 17:18:50 -0800
Message-ID: <20260225012410.026092724@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

[ Upstream commit 5907a90551e9f7968781f3a6ab8684458959beb3 ]

12d8:b404 is apparently another PCI ID for Pericom PI7C9X2G404 (as
identified by the chip silkscreen and lspci).

It is also affected by the PI7C9X2G errata (e.g. a network card attached
to it fails under load when P2P Redirect Request is enabled), so apply
the same quirk to this PCI ID too.

PCI bridge [0604]: Pericom Semiconductor PI7C9X2G404 EV/SV PCIe2 4-Port/4-Lane Packet Switch [12d8:b404] (rev 01)

Fixes: acd61ffb2f16 ("PCI: Add ACS quirk for Pericom PI7C9X2G switches")
Closes: https://lore.kernel.org/all/a1d926f0-4cb5-4877-a4df-617902648d80@green-communications.fr/
Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260119160915.26456-1-nicolas.cavallari@green-communications.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 211b7f72d103e..6df78efd7f6dc 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -6189,6 +6189,10 @@ DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_PERICOM, 0x2303,
 			 pci_fixup_pericom_acs_store_forward);
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_PERICOM, 0x2303,
 			 pci_fixup_pericom_acs_store_forward);
+DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_PERICOM, 0xb404,
+			 pci_fixup_pericom_acs_store_forward);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_PERICOM, 0xb404,
+			 pci_fixup_pericom_acs_store_forward);
 
 static void nvidia_ion_ahci_fixup(struct pci_dev *pdev)
 {
-- 
2.51.0



