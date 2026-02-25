Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9462C0F97;
	Wed, 25 Feb 2026 06:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002581; cv=none; b=PLxj6111aTTApuJqnOjxymmzgGfPGU+Z0+sWg5GDdQubfHI3/v7tW486U0RPsoUeiW8uw8QhyQwp9TyJGQqzJ4k1fVblzkKBDY1QbIBOyZUd3AaPF4+usaBAG4ORs8Fk2x/yza7h37JINRzrTadOUlZIx1cpPBHpDaTV5dolnGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002581; c=relaxed/simple;
	bh=jSCkjQO6jYj9T2uaGHqD25rMJxkt0U/R540zryvI/O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3idXu9mwdB/A/NeRga9ei+/NTsHvaYa56PcWBLKjmZafLrCC7VFBMtg2AFrjxnSg8tcPsBLhyexWjJ5U5PSzhO+EB6ZwpsPzwe6Jypyty0zi0VwZQdsZbF5VYhn0ysKD4Uvi/9V8lKmPESw/ff1nH6KmrzsFfnNpO+ixghKLqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHSnjJKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHSnjJKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045C0C116D0;
	Wed, 25 Feb 2026 06:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002581;
	bh=jSCkjQO6jYj9T2uaGHqD25rMJxkt0U/R540zryvI/O0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kHSnjJKAkoPcsqOEG3EZZnNrWTempdD/3Jzm0HPktNmqFq0OxOXci60Px4Wv2knI+
	 PcsOKLd7kdMyCEmDau2EJAQDmhkro5hnAzxFNw2eCYLEcsY7CWWul8XrCJpzWQvteO
	 ZTvGNNsMLR53m676O3cSM2sgckBx14LEvI+FNNSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 316/641] PCI: Add ACS quirk for Pericom PI7C9X2G404 switches [12d8:b404]
Date: Tue, 24 Feb 2026 17:20:42 -0800
Message-ID: <20260225012356.374185620@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c7e733beaab03..9e073321b2dd2 100644
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



