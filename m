Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE3D14B092;
	Thu, 17 Apr 2025 18:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915378; cv=none; b=VwxV1OxgE73XOya6JpnqoMQbXTx+V/9QwAwyZkNfD+RPxxjpbpRj+JN4ZYzST7qC9Rx0TBc8o4egb/JNV+ONDHTSsPK4AMYNkHJLqAI2yLilkXavs0ZA77lVuOpLOfqnbQyXWFQfPHEKp8wpf744hHV4E+SmyMqN1J0Zuu4Jc9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915378; c=relaxed/simple;
	bh=K4l+SPIe+BdKsqsK/A/Q//CN6tf7/2RuF0bhBbpoI60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcRPTCtQN34aFkwVzf8hF/6CpF7qNqrYULvz/7YHtcDxaZsZuHSkWJfLs8/HQeMAj/ApLPbYLG9gZk4nehLpgLyGJIvBwFZMbjxYqHoJ6+HqYLXqWfjuWiPYmK60s+ous1mtZ/r84FAmCb7BJoFgisezNuRJaunKDPLS14D8Fgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xDBDA5jT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xDBDA5jT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D40C4CEE7;
	Thu, 17 Apr 2025 18:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915378;
	bh=K4l+SPIe+BdKsqsK/A/Q//CN6tf7/2RuF0bhBbpoI60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xDBDA5jTk5KzuUw0Cthsy8WPER2WKmpSCUVNUXv0gs/O0qoDBjNVygcUGlYf6kR/2
	 0iW9p6BQpK5tvtjO0f5g//erwJSw3b+25oYqDIr8pzo+htEJy0B4hAIMdmIeStGT/k
	 HUEMBsXuLVmPAb2vEMK6Dbet3qFr++evjcnZ6GTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Kral <d.kral@proxmox.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/393] ahci: add PCI ID for Marvell 88SE9215 SATA Controller
Date: Thu, 17 Apr 2025 19:48:37 +0200
Message-ID: <20250417175111.934968601@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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
index 45f63b09828a1..14dd1b432ac34 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -589,6 +589,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
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



