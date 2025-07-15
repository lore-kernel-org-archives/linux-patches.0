Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD7A2566;
	Tue, 15 Jul 2025 13:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587291; cv=none; b=BTxl8EMEJgRIELPEt9ye28whVvSWGhfAJQue+6xerhPYBRe3h9pvOXyEDcqEOp5THG8biBxmJnkbjSjd8UMUGb8Nq1Hmvc+3WXPZYquF6PqwFblN6L7V2q8cZv5CkKsoA9vPHP8LErA9uMjgB2K5gMRkRNdfu1HTnzdBNGzWDzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587291; c=relaxed/simple;
	bh=csiWDixZoE3ByqRob/Ij0E+X485xagYKbBG3VGUCOmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEmBEyd5OZzmy78x64ovTq28nZHGCelxX6Nu/XypEdtKg0kfhh9Mdh+UhfR4BAToYuW949NfLGsbuDo3xarJGvwfwMiijGOGJU1AdNTDY169u+chjTM1UKPdXPauAiFZ6Ojkq212ch36ILylsolbgSAVQ9+Pb44zOX+R+GS1CxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6ueR+xP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6ueR+xP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F44CC4CEE3;
	Tue, 15 Jul 2025 13:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587291;
	bh=csiWDixZoE3ByqRob/Ij0E+X485xagYKbBG3VGUCOmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A6ueR+xPZrZVoYsfQAT4ENbSXP40nSI5SC+i8ccjC/5uBDOP9D6D3M3LAL8GL8e+S
	 MuKH9urAPSYbgkFPrfaYatmT/WXqULfu5ylIl8PgU5DfVnLYlLF7EyBRW4mgGOoNk6
	 zHDsAzJl2QeNTzJwtXXIp1DdinH64I5rQ8g4tExQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 46/88] xhci: Allow RPM on the USB controller (1022:43f7) by default
Date: Tue, 15 Jul 2025 15:14:22 +0200
Message-ID: <20250715130756.390364563@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 28cbed496059fe1868203b76e9e0ef285733524d ]

Enable runtime PM by default for older AMD 1022:43f7 xHCI 1.1 host as it
is proven to work.
Driver enables runtime PM by default for newer xHCI 1.2 host.

Link: https://lore.kernel.org/all/12335218.O9o76ZdvQC@natalenko.name/
Cc: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20240304054327.2564500-1-Basavaraj.Natikar@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: cbc889ab0122 ("usb: xhci: quirk for data loss in ISOC transfers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-pci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index ca27bc15209c2..30b2188a3cf8a 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -190,8 +190,11 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
 	}
 
-	if (pdev->vendor == PCI_VENDOR_ID_AMD)
+	if (pdev->vendor == PCI_VENDOR_ID_AMD) {
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
+		if (pdev->device == 0x43f7)
+			xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
+	}
 
 	if ((pdev->vendor == PCI_VENDOR_ID_AMD) &&
 		((pdev->device == PCI_DEVICE_ID_AMD_PROMONTORYA_4) ||
-- 
2.39.5



