Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9556C284B57;
	Wed, 23 Apr 2025 15:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420403; cv=none; b=pbiuTGWf2JSHerT2ZQBnNfhz+y1/FahjrE2i0keKGqb9HzUV3HbrsJRwKLULuF8m9VlLJekXlJgfngbJMFOsrBdzrXQ8vdKRzFKQkG1m9s1K/xhQI1d4WyP2vpYvT9h/swwLm5fJAVJ+G8k6nhK9VGbGJ4YdTdnlwL27xtwjlds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420403; c=relaxed/simple;
	bh=F9Jgx7BWN/GSaDlzONRxPt0gFKo2g+VcEsA8DehYX4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MA4mPhVvV7wpXy9ZfwioUL6aauUHvNauq9OGNZVnIkdOWCofi4//oaF/6ZXe5O2zz2W/3XFxhn6G5HSXoDwd/kWJnTDAcwxy/+VMuBhWs5vEN+Bkjg5vW0plT3HU6itLSVeioKNTaY3MOAKxdAfJ8vdofv9kqpAPEhdBg6ADVTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJ/BkQcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJ/BkQcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6677C4CEE2;
	Wed, 23 Apr 2025 15:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420403;
	bh=F9Jgx7BWN/GSaDlzONRxPt0gFKo2g+VcEsA8DehYX4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJ/BkQcG1bsuuchV9th3MjqceyoWgtfu5Bi63guc4O8l8Cg3qgWwa/1xa9UOwvDG/
	 w5oLXexM2zNigCjZkNYv+sD7cbXCxCStM5gkgD3PZz2sCAkBzJhX3ItW6KYU5/Rb3c
	 pxc7+dmqvt+pPNhtWi47HUEVYTUO3U6oi8J+FvcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Kral <d.kral@proxmox.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/291] ahci: add PCI ID for Marvell 88SE9215 SATA Controller
Date: Wed, 23 Apr 2025 16:40:33 +0200
Message-ID: <20250423142626.195859584@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 20f53ae4d204e..a4b0a499b67d4 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -592,6 +592,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
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



