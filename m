Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAC734250D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301815; cv=none; b=Kv5uV4ZKM6ABQ5FXGF41XCSQq28cndvY/JzpqDCaYtO1GQpLgUt8BzZPLUuRkikKDdwQDMcx74pkqhHiF50PehffnGN6MUCqcdjOywIZdT8vLNnvug0HCVLUcC3MUphX66/WJnnG5tSiqKBCEMDDDbOWBbZdSbalySlHElC7Lls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301815; c=relaxed/simple;
	bh=ei7LqxZ7esI31qRW8KE0Jp8Qx7ScRfDgPlqpG1DzBcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5KVLgjCrPpLWrI0Mz1QlmB2SW2YKBgjyxM72hBrbqEMOrWeAq8EiI/2fj8qWLntDOuRDGBRs/glvDIvpqDQBBSbb6FdqgBgCD8uqLactDoHFFVmSGO2fhVYONjwmH0CMBbOLYO8rEkXTiOfVu/YRB8Nc/O0qTstC+sLNuaSBPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KzABzVEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KzABzVEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF4AC116D0;
	Sat, 28 Feb 2026 18:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301815;
	bh=ei7LqxZ7esI31qRW8KE0Jp8Qx7ScRfDgPlqpG1DzBcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KzABzVEfq/KduGyhdD8htht7mpdLWeR9kRuJaL8iKXFa8lBLKLu0LXGjC7ODe8dvA
	 8RjT/heEVeIBLzng8kX6W42QRDMr0I7DP4dAc9MlbyzIt3nRZh898M0IdpCqFpR3Da
	 WQOpoVnLs3sp8VDAOvAllaymMsxarpbZfnPRCLS65I6EYuBP0hWEca452DfQIH8vbH
	 w1fUDUQIQOXZX1XEj1aWlSiKlpIpFf5QpeJoapNxb44iUvTkg++0Dj/aWQ3NU/f+GE
	 J+2eBFrRLde9YdGpkI4CxWbrFZdERWudbEHjiFj8SkjD8lQ4RCYNv5Z1E/BYth4p9n
	 DHMgrTY17xZNg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 230/385] PCI: Add ACS quirk for Pericom PI7C9X2G404 switches [12d8:b404]
Date: Sat, 28 Feb 2026 12:57:32 -0500
Message-ID: <20260228180011.1568201-230-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 49a2d6858b4b7..d9ba1786fc1ae 100644
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

