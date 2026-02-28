Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C9538D014
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302153; cv=none; b=Krk07r6PUw4AWT/hLxV8ZPTYQlGHH9m/tdstAPRykxxBcDvEPg0Shw4jxYRiMbQpFFW88DIcdVbz4K/qlphVxclHzJoXvnqjFjCzNwV9SRWeeG53Hngtk1PcwPBT9IyGfstX5A9Hnefa1okGQwPzyxNsbVWEALsa1fJkV1YyoFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302153; c=relaxed/simple;
	bh=D7RDNUwqTa9tS11HuUTrOWg5+kwX83GAvPMtWfgFJDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uoj1mLsLfmozMWQjGQw+71ZY+/eCy51ATp3iQhGKBlPVN7jNcwBd/lacscL9GdSPSFKiN0HMA9dpdOn62g2zNJ3kAIqyT3sUp6a9KgjITzi015omFPgWW/JGulsyeDpI63fAYGtjlxYc+f6IwvgAMFQHWrR3RnYeOHE9HKIWilI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jCHp/JjW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jCHp/JjW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781C3C116D0;
	Sat, 28 Feb 2026 18:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302153;
	bh=D7RDNUwqTa9tS11HuUTrOWg5+kwX83GAvPMtWfgFJDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCHp/JjWOu7b+W+ENSLsq83I4cweu/UfOqm41Dpvg6ty45F5s19InWgq1WkWycmPg
	 LY2Lt/MAtBtSWuM6eHE6kmwZtpvzSiH3EeLE886Bs7FXQjHAEBjOe6BRrjm404X4My
	 G4QQ/JhATMiESvxBN43AaeYXYvFbEJvBWzoPRMjVRlZlDTlB34ER79owWSzm0t1JqA
	 ncM44VIIP5XnaqMreIdsPjVIrn3jvhTKk93ZxuIU0NzS7umyfUbupZPB5RgKuZTZ+7
	 q39IyuC+QWT69jbkhye6PRTJIVIKCXq2avwINZatGOiJVzT8ZsPMeptOLfhzXSN42g
	 PmHID932z+X6w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 148/283] PCI: Add ACS quirk for Pericom PI7C9X2G404 switches [12d8:b404]
Date: Sat, 28 Feb 2026 13:04:50 -0500
Message-ID: <20260228180709.1583486-148-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index cac9a163d7d55..f89070b1379fe 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -6181,6 +6181,10 @@ DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_PERICOM, 0x2303,
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

