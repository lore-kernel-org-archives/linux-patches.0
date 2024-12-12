Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C502139CB;
	Thu, 12 Dec 2024 15:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017734; cv=none; b=Jqk48oEQ3JykRit9HDJsJwdqRiCMWFhAMGwPIBPxE7/2gNnXFb6CxAMBfpGz79fd2RFetqYWtQ5vhiGc4vTen2YPeV9nBWJNGeBp80BYphU8u/5GjzPdnbvUxc/i1/ySybi8YYK7aAZOM5MfE6Bp7n5bLzFi55PdC3BwoU8CrUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017734; c=relaxed/simple;
	bh=+Gfa1UD1rIfdUQUQUXHXkesSrd7vxv5EnBmjIg8eP8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zy1t03le945dtv6tUvxMjNbBQxVgKHe+tRPeRD7u0Kkyoj2TeW39tcyOFd/KPrZbNEcql5jp6YP9yUQQP9e6KGGYmJhWOXF75u0LkERsSNfuJ8ujGpp/cMxI/R0ZxuLDlAdlNHodBYHMDRGmBubIkTo0Er25yDGMVM0glkfVL1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZfaFfCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZfaFfCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A01C4CECE;
	Thu, 12 Dec 2024 15:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017733;
	bh=+Gfa1UD1rIfdUQUQUXHXkesSrd7vxv5EnBmjIg8eP8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZfaFfCKXp+FekhAfR1f4qK2sdZroOn+xCu9JeXv4OVbZiPJZTAJTfQXOQgLgmm8b
	 QQ8d8I1GUtNPX1BCorJF+wUt7qfUg/sHY7HD5LiPhfLOlgWtwmXK1cLlmtw8Cl0e1m
	 1MTQoE8Cmx5Gc9WPmv9ykJISKdVHvY9wT0FkzNas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuangyi Chiang <ki.chiang65@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/356] xhci: Combine two if statements for Etron xHCI host
Date: Thu, 12 Dec 2024 15:56:26 +0100
Message-ID: <20241212144247.278179303@linuxfoundation.org>
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

From: Kuangyi Chiang <ki.chiang65@gmail.com>

[ Upstream commit d7b11fe5790203fcc0db182249d7bfd945e44ccb ]

Combine two if statements, because these hosts have the same
quirk flags applied.

[Mathias: has stable tag because other fixes in series depend on this]

Fixes: 91f7a1524a92 ("xhci: Apply broken streams quirk to Etron EJ188 xHCI host")
Cc: stable@vger.kernel.org
Signed-off-by: Kuangyi Chiang <ki.chiang65@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20241106101459.775897-18-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-pci.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index f74c067b54587..d36158df83afc 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -456,12 +456,8 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		xhci->quirks |= XHCI_DEFAULT_PM_RUNTIME_ALLOW;
 
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
-			pdev->device == PCI_DEVICE_ID_EJ168) {
-		xhci->quirks |= XHCI_RESET_ON_RESUME;
-		xhci->quirks |= XHCI_BROKEN_STREAMS;
-	}
-	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
-			pdev->device == PCI_DEVICE_ID_EJ188) {
+	    (pdev->device == PCI_DEVICE_ID_EJ168 ||
+	     pdev->device == PCI_DEVICE_ID_EJ188)) {
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 	}
-- 
2.43.0



