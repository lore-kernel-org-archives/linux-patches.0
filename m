Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD71264FAB;
	Thu, 17 Apr 2025 18:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914113; cv=none; b=D0DSKmbmPsfIFKUy7GIru/oNUYgIuvH8qKGMcGJmzaDZ5V5ZaynCJmBcyQgHr8M3S5yX8IU8+eKQiB/+8HcifriUYqo9hIBnvT8D5p0FRdJLj4mr2GdfaNyOZc1QhGHJbGdhLSOs/wvoFuzrQsKSsLDZ4OxdAaH4qQGNfkxmuWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914113; c=relaxed/simple;
	bh=lRiqGMqmg1NrExIKs7PksIiXmdemVaXMG64l6ck0gzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o76s5naCezTO8WxtNiiv0bgoYp3/NOoix6Mclumu70LA5IGboHUSPvXX480g78WREJXa4ZZN8yKXku7Sz7SfcrZtY5OiOFNUxbUy78GemaqGg+ytLGVKf2ma7Y1czcn3+cro5R5qfiQ27xKjWPD5jgk5wga3rkcp7OJxxG55P7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=po10kY4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="po10kY4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA03C4CEE7;
	Thu, 17 Apr 2025 18:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914113;
	bh=lRiqGMqmg1NrExIKs7PksIiXmdemVaXMG64l6ck0gzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=po10kY4U3Zg5MALCX0i0M/jWKixplgItxlNgUknA4Jgk9Q3lT6Pu9ckljJ3KPJEfA
	 lLOecSIqyKe5NPjMuVgCHE12kRbMbeb7459RG+eijskow3tvI28li+P06do4h1o9cz
	 Z6ebki5Bfllm3vjWb+1LQauGCULpXA+I9/ui51B0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Kral <d.kral@proxmox.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 109/414] ahci: add PCI ID for Marvell 88SE9215 SATA Controller
Date: Thu, 17 Apr 2025 19:47:47 +0200
Message-ID: <20250417175115.824547734@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 8d27c567be1c1..f4cc57d7a6a65 100644
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



