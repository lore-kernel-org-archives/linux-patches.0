Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB764153836;
	Fri,  6 Dec 2024 15:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497750; cv=none; b=JwtzTPYlaXwC1LzR53Ft28MRM9HPb5OG+yREhdTn4Xlpew7c+uSkBNdul60H7ctEQPSBtkd7Ut95eEifadvjj5k1ogwVA3bod2UBtqg7fJKnReaTPK4UWBWm75xux1YWyorKEXm2sDV7q5unzEOYiX7D8CyDRHBDmXDgqZGhP7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497750; c=relaxed/simple;
	bh=oEOSo+SaUpdr9HbARV34gipfN6FW8/OHyiLOYYvsjn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UT5WZa4rfoHDzKnTRkoQ4j8WExdZ6BiXRIFsoxg87tsJ9cCiTZxUz91a4xzT3TDQWvIso0/1T9P73bBhKE9LaoQBHLdUYgx2RXkGMy1giOJlurIVhwOg39XgQGxEW4Qzj1mhLNqhtHOcwZNvAHodEGCxO1W6oWev5DBSV9kYuNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZIeUCzD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZIeUCzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48BFAC4CED1;
	Fri,  6 Dec 2024 15:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497750;
	bh=oEOSo+SaUpdr9HbARV34gipfN6FW8/OHyiLOYYvsjn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZIeUCzDVuyyWy7DJNytpyC5Dua0PpJci3WnzJaZyA6H1ppO8D+kyC/wVOBPaJbA+
	 UzfdemPgyHbwWzDSD/mYW8zT+eO/FaigsKbho00aXXD2YxLHSuPn/gyP45Zeh4ZRIy
	 QhRAyBbTFvpjuRA7bzWzrQzNadno1HdNQr6JXu1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	weiyufeng <weiyufeng@kylinos.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 351/676] PCI: cpqphp: Use PCI_POSSIBLE_ERROR() to check config reads
Date: Fri,  6 Dec 2024 15:32:50 +0100
Message-ID: <20241206143707.059867041@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: weiyufeng <weiyufeng@kylinos.cn>

[ Upstream commit 87d5403378cccc557af9e02a8a2c8587ad8b7e9a ]

Use PCI_POSSIBLE_ERROR() to check the response we get when we read data
from hardware.  This unifies PCI error response checking and makes error
checks consistent and easier to find.

Link: https://lore.kernel.org/r/20240806065050.28725-1-412574090@163.com
Signed-off-by: weiyufeng <weiyufeng@kylinos.cn>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: e2226dbc4a49 ("PCI: cpqphp: Fix PCIBIOS_* return value confusion")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/cpqphp_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp_pci.c b/drivers/pci/hotplug/cpqphp_pci.c
index 3b248426a9f42..ae95307e6ece3 100644
--- a/drivers/pci/hotplug/cpqphp_pci.c
+++ b/drivers/pci/hotplug/cpqphp_pci.c
@@ -138,7 +138,7 @@ static int PCI_RefinedAccessConfig(struct pci_bus *bus, unsigned int devfn, u8 o
 
 	if (pci_bus_read_config_dword(bus, devfn, PCI_VENDOR_ID, &vendID) == -1)
 		return -1;
-	if (vendID == 0xffffffff)
+	if (PCI_POSSIBLE_ERROR(vendID))
 		return -1;
 	return pci_bus_read_config_dword(bus, devfn, offset, value);
 }
@@ -253,7 +253,7 @@ static int PCI_GetBusDevHelper(struct controller *ctrl, u8 *bus_num, u8 *dev_num
 			*dev_num = tdevice;
 			ctrl->pci_bus->number = tbus;
 			pci_bus_read_config_dword(ctrl->pci_bus, *dev_num, PCI_VENDOR_ID, &work);
-			if (!nobridge || (work == 0xffffffff))
+			if (!nobridge || PCI_POSSIBLE_ERROR(work))
 				return 0;
 
 			dbg("bus_num %d devfn %d\n", *bus_num, *dev_num);
-- 
2.43.0



