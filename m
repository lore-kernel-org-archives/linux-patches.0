Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F18E2E612A;
	Tue, 15 Jul 2025 13:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586168; cv=none; b=hn72BqBrLXunYU7+JjOmP54lm3nEJg8Y20DoQOlVREIavAhNg/gRUE0uMI0qpQUVGDETQvj8dJPU6yJdEfFbEcdUACM7V/1Rx//EexJqKjzIxtUsG7hfuqF3MFJn5YDC+c9IBwVDFABF1GhLdwtwT0dgcIdUhZfpPw/3Mk3Rw64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586168; c=relaxed/simple;
	bh=2BLKgcif/PeqHrnliZjDOT4A0WzCmvOd+I7jelBRHoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJKy/urXVz+FOSeC6egOiJuZMHVVzBx1erLGeCwuydp1z4C2uuWuocsv6eDYoQ9Vqwiz4EtK2lwKCiwl+hzv2J8v3NDDRyPnVTobkOq796kNjFZfBnWwKirmhiI+7Xgt5joFK3nhj/JUD4RfarRae80weQ8UAggyvmQOAJ0FAh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lloj0zwW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lloj0zwW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EDEC4CEE3;
	Tue, 15 Jul 2025 13:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586168;
	bh=2BLKgcif/PeqHrnliZjDOT4A0WzCmvOd+I7jelBRHoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lloj0zwWNks/MHYwmQGUF3jzyqAhDSmCa76E0s3N3HjsohHqPmr+hqrp/el2YclpZ
	 wyTw+ttjxpmUUH7cXlxx9hI4LpSK1TugDBlrAwFEzLNbHLIbeZgI1WCE9PoWJSAkNC
	 Ld85TOet4uSRQSA9XXX45N0O/6BslQ5qLJ2WYphI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 42/77] xhci: Allow RPM on the USB controller (1022:43f7) by default
Date: Tue, 15 Jul 2025 15:13:41 +0200
Message-ID: <20250715130753.399215654@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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
index 18200d3662fe6..5c46e85cc2d7c 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -191,8 +191,11 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
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



