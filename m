Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CE82153C4;
	Thu, 12 Dec 2024 15:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017727; cv=none; b=dMvKzQHQyDEqpLX9nXe4i1iD44n85GiUgv1KQVWY+4yszg7XADJi9ofbNoaPShb8cUQTvU9Jx8NrIVbd7qcPhiUrPNRT13Z07rk8khrRmMlG7zCsRf4BGOHCugXx53jVXjMdpm3IsIi36wG/2f9wkq9FmhMySLKG+Mh37svbLI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017727; c=relaxed/simple;
	bh=sdr5WuFWABjpNLnHpmIQL9p8hrRm+dN6jhvF7+26rAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9zo1Hb0rsZsK+wcgcMEKVu43zkBemWpoFeLdehJ+pvcdzxIydbA9pFkVDt8mcbG3l46sWupFHhYVzEk5fFKGGDvs9m3vryIRY8hRG+VczCRESNp5ulR3k1T2wlEug3h6FAoSKTKSdw3QZ2dTYzGnHkywejT0Gu7d08r4BVPKT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJfp+Dx2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJfp+Dx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34EEC4CECE;
	Thu, 12 Dec 2024 15:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017727;
	bh=sdr5WuFWABjpNLnHpmIQL9p8hrRm+dN6jhvF7+26rAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yJfp+Dx2Lbl2x5aYoMPZepB2fFCr8x+y3Zr9qwynJqPRzOZYgZhdROjfEa2AiNcH+
	 DjY8c2i2Ll+FTtAkVRGTiVEZGFtLhRA89YPyNqgWXh19dBAGQJfvAjGZbbBFoiGB81
	 0i53u61Aq4R+Cp1cLn2ofXxWR8gNnSWE3ZWytJMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/356] xhci: Allow RPM on the USB controller (1022:43f7) by default
Date: Thu, 12 Dec 2024 15:56:24 +0100
Message-ID: <20241212144247.199336511@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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
Stable-dep-of: d7b11fe57902 ("xhci: Combine two if statements for Etron xHCI host")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-pci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index c2b37aa2cdfca..3a2a0d8f7af86 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -374,8 +374,11 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
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
2.43.0



