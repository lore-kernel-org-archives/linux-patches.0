Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3D128469B;
	Wed, 23 Apr 2025 15:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420506; cv=none; b=n8r71JMZPFEXaZYabiN2nRBLcWiLRHaKKng+MYl4r9svyfj0E6ixr/rmWKC/8JF3ijDI3/HwL/df6juHG2X0OEEVmiKTewo8SP3G1UZzbhej3xZbdQSkLBNYlnsBAi6pHhEg6wcdhaEccspdCZnao2Ka763a0IC1WJQwXFM6bQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420506; c=relaxed/simple;
	bh=Xexuu2hHC7pvQRsHmw612efSR9FL9rkLDxGNQhpGSpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZieGOmrGa/7ngY3OIdM91ppISOy9CiJMNL4403s/6ZqN1jkTG8N91bCBoW5DKtCcQ1rIbkNaMbOK7R3cATpbeswxlcbg19VALK4ls5PHeFuHDUX4LAQe2NN0uil6xNYQh/pNIWMftleVifnd23hgvS3iHwtuJCyDbO94KOrGGSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGC2pzx2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGC2pzx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DA2C4CEED;
	Wed, 23 Apr 2025 15:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420505;
	bh=Xexuu2hHC7pvQRsHmw612efSR9FL9rkLDxGNQhpGSpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HGC2pzx233QLRsiXmYXnkzBI119B0HR65ucM2F3JcF+/IBoBxPhku1KxNGHzFUGqv
	 /g++18wkwaNY4jj/3l7Mug7THJX5zarHEJYX3sS2dpNZf4L3ZcnVOm7Br646LAEtky
	 ZUBdjUfFoghk/gzujb4FIUm//AFpPXA4bnKrZ0Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Kral <d.kral@proxmox.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/393] ahci: add PCI ID for Marvell 88SE9215 SATA Controller
Date: Wed, 23 Apr 2025 16:39:36 +0200
Message-ID: <20250423142646.607102040@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Kral <d.kral@proxmox.com>

[ Upstream commit 885251dc35767b1c992f6909532ca366c830814a ]

Add support for Marvell Technology Group Ltd. 88SE9215 SATA 6 Gb/s
controller, which is e.g. used in the DAWICONTROL DC-614e RAID bus
controller and was not automatically recognized before.

Tested with a DAWICONTROL DC-614e RAID bus controller.

Signed-off-by: Daniel Kral <d.kral@proxmox.com>
Link: https://lore.kernel.org/r/20250304092030.37108-1-d.kral@proxmox.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 6e76780fb4308..98104d0b842bd 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -591,6 +591,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	  .driver_data = board_ahci_yes_fbs },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x91a3),
 	  .driver_data = board_ahci_yes_fbs },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9215),
+	  .driver_data = board_ahci_yes_fbs },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9230),
 	  .driver_data = board_ahci_yes_fbs },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9235),
-- 
2.39.5



