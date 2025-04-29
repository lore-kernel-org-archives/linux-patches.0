Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF6121ABC1;
	Tue, 29 Apr 2025 17:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948618; cv=none; b=YJDe3RuYBJH7QrfHTG/UUZ23XvYkHZD8oiWM7Ihh+R2FlMQOC4OD0rHmcqUGtA3Tk/Pf/Tctr/eksnmuVA8iT8y5da3p/jVYKAvnUqC5zG+Y2QoPsL2JH80LtATJ0Sefr05ulIKZozTCppjtkAxqYVUDxlo7aBsTVIlflgZVkAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948618; c=relaxed/simple;
	bh=9wIukEJxrYW69o0BNDTIO0nuvUEd45q+oBGTc2W6GNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktpeOWQC2L02TFh9wSPuT9EqyoKdL/rQP34iuqsR61XOC1XwNgSfV1t/nCmlkaKmPJROB7f9G2TN0k/Ks5BxnX+xByyh7JcqOd+NAmYnYU8nra2pER4/SBJPNtHkeaTq1jQGqUteYprXQGmdrq9NVXchn/8qXmtHODjmSoy6r8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gG2Ha9r7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gG2Ha9r7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0246FC4CEE3;
	Tue, 29 Apr 2025 17:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948618;
	bh=9wIukEJxrYW69o0BNDTIO0nuvUEd45q+oBGTc2W6GNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gG2Ha9r7Mlo2PC6nE5Ms3N8apsKOlcUWRHVMfKZP1BqB2IJxOSPTxvaT2Wq5ppSfU
	 Ex13yNGhZb4QNizWkzk549LZzcKz5EjOdRQyMOlvDIegk4W3EswsBHB6pWN9eBmcAL
	 6JAZ2O/ncxfmVNHTd6eqA90hbYher3teLhbeplCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Kral <d.kral@proxmox.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/373] ahci: add PCI ID for Marvell 88SE9215 SATA Controller
Date: Tue, 29 Apr 2025 18:38:28 +0200
Message-ID: <20250429161124.418485166@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ff5f83c5af00e..408a25956f6e0 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -595,6 +595,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	  .driver_data = board_ahci_yes_fbs },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x91a3),
 	  .driver_data = board_ahci_yes_fbs },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9215),
+	  .driver_data = board_ahci_yes_fbs },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9230),
 	  .driver_data = board_ahci_yes_fbs },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TTI, 0x0642), /* highpoint rocketraid 642L */
-- 
2.39.5



