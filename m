Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D48256C82;
	Thu, 17 Apr 2025 17:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912789; cv=none; b=awmtHwjoPATaEN0SFjxXqUyW2oUusDMs+oArVDvDQXBfRGSlNwcFRs2FIMhlaJIvKKcBpPXwc16RVlLOx/HcHFOB27yHyTME2Lc9ykYdSRJlyRecCmjnzoqn7XFDz4SSOM/wlbXnX2ra9hCBTIB6iBK5qLiDHSQYYMXEwwBHwDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912789; c=relaxed/simple;
	bh=x04BcQka7kZhK+u/d4+aOlh5hbDzbiLhXc/eVNDpX6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7n1LZdRlQgPQ9zFhPHoyzJYpSPF2o48zwGpdO9he0zdJEDg5wnAmvk/Uto6LwAMgdd2Z3aOYCKkKdM/XfOqmPbeS5VIHOpoznFQKNbDV7MfzNOv75eayXbJHAWbhtfkWsAfbG08BXKTibhKBcbbOKHzLwZ7kKww58crWa3QJ+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzGfAJOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzGfAJOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3450FC4CEE4;
	Thu, 17 Apr 2025 17:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912788;
	bh=x04BcQka7kZhK+u/d4+aOlh5hbDzbiLhXc/eVNDpX6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzGfAJOLvOLguN0ZrYtg+j51rHafRXF98uPHWdHUGQHkHJ9CX7U4LQQwPEJMMJxmc
	 kz60e0ddpb30lX2USJ1F7cjybLLyGRz+WKObAUulifaMaqr8/K0qD0Kul1N/R4gm+q
	 0yWXnnlUtrFKBCv4U1d4JM2YkYNuJoHbMgkCRSc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Kral <d.kral@proxmox.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 124/449] ahci: add PCI ID for Marvell 88SE9215 SATA Controller
Date: Thu, 17 Apr 2025 19:46:52 +0200
Message-ID: <20250417175122.957699468@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index f813dbdc2346f..52ae8f9a7dd61 100644
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



