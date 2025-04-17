Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB6722E3E6;
	Thu, 17 Apr 2025 18:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912914; cv=none; b=BrZsdb6dsI8hzP9QXy8ZOx8S6HSKxz1W0xWIjf1Rynwce57TQp4MybwHXaZ7sscrNpHUuz0ZJ0acVxWiWAF/u8QPhBQbgeNaHWck0Ugvw0nuAylGreJkIjwuT/WjdQ34tJ6xtwHe3lVtaWI0wLtRttG1X4Bicqr48nhOyr7S8BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912914; c=relaxed/simple;
	bh=Sdkocjme/0nL4o/0B9xT+wr9GEMw7Nwyt0/zfweFH6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mc90wFCuSq0ucmOspN4cjNoata7T3l0u39aZk2pQ3jIwSzS/Z0rKmvWPJf+0BsDI0GXs4kLFvGuNUsXsp8J0l/+1FV3n2VLIgTedQVhk991WfKvF4m9wzJSajl01284v1pUzCkTpWyCg3Y+2oLfd/AltFbmQ2An7h0DNskxwctI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zs8kEHYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zs8kEHYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB06C4CEE4;
	Thu, 17 Apr 2025 18:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912914;
	bh=Sdkocjme/0nL4o/0B9xT+wr9GEMw7Nwyt0/zfweFH6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zs8kEHYXRw/v5zYD+WI1Kd71S6NbCdSdg1CN0r2Og6wCyyXp/pP1aKkhZRyRX+19r
	 Fhllv4Q5oZtGGdV9fzn1eRZ/X+n+gwNZ1THv6riF0EqABhenGS1ZOCcLRvK1VLGLYM
	 oRnhOP3mS0PTWEB6vhUCIHV2Bl11ChDH0MsHXR9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 137/449] Bluetooth: btintel_pcie: Add device id of Whale Peak
Date: Thu, 17 Apr 2025 19:47:05 +0200
Message-ID: <20250417175123.479608995@linuxfoundation.org>
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

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 6b8c05e52d66e4fe4ab1df4c6e15f339ecd9aa51 ]

Add device of Whale Peak.

Output of sudo lspci -v  -s 00:14.7:

00:14.7 Bluetooth: Intel Corporation Device e476
        Subsystem: Intel Corporation Device 0011
        Flags: bus master, fast devsel, latency 0, IRQ 16, IOMMU group 11
        Memory at 11011c30000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [c8] Power Management version 3
        Capabilities: [d0] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [40] Express Root Complex Integrated Endpoint, MSI 00
        Capabilities: [80] MSI-X: Enable+ Count=32 Masked-
        Capabilities: [100] Latency Tolerance Reporting
        Kernel driver in use: btintel_pcie
        Kernel modules: btintel_pcie

Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 091ffe3e14954..6130854b6658a 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -36,6 +36,7 @@
 /* Intel Bluetooth PCIe device id table */
 static const struct pci_device_id btintel_pcie_table[] = {
 	{ BTINTEL_PCI_DEVICE(0xA876, PCI_ANY_ID) },
+	{ BTINTEL_PCI_DEVICE(0xE476, PCI_ANY_ID) },
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, btintel_pcie_table);
-- 
2.39.5



