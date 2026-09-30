Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC74D515972;
	Wed, 30 Sep 2026 17:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789838; cv=none; b=hoXXlLe3wNQN8AAw7ytcIQAlEzUP6vxtFfHdY29iQZPBlfVnq9o/fB1YIm8zh3clxcw49MTjzU9tQG6qfouyCpz4qC9jQAj/j55RVRNl9eE8DNEWLf/UsS1+d2sAmpp3jpRiB9rQTU7UwgfYGR9iaEIRbqyhP9GN99hDi+2Dwsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789838; c=relaxed/simple;
	bh=n+2fh9t+y3eOTm4Ufvk2CSpKNfkjk3IJ9gfV/fTmbXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WA1ipc/VrcgorR51TBUpbInOcWFCqQozpTNxPCuBJJBwpX9ijI/nb2SmHrYFwoEcfLjTUMlJD0vK1cLv9vZ76O3s/NokI7MoNNkgjgteKSg+BFl/C1x0KoZCnOdhEaBH4WyQHvn6waiznnWeQDDrmTuUt8cCc3S37MQmUuy7b/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxDlvawi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxDlvawi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AAE1F00899;
	Wed, 30 Sep 2026 17:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789837;
	bh=w3RmqIziagv12Quu7DAhKXWO6VWWrA1NpVu85B/Y2gU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wxDlvawiOMIXnPUEaXLJj+g4E47kkGHVRqEqDiOCzbJ+Bs8k1RCdANKtSz2n213iO
	 5MR8jZL9Nft2Kcbk+IlyX9tjfld9TSYQkdbg/1k98dxXvUW34azxGjSKEOCVYnSUls
	 eLqvgwsT3kPAYCDkAMNLTiiiq0g1F5riz4+TgD7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 618/877] xhci: Cleanup Candence controller PCI device and vendor ID usage
Date: Wed, 30 Sep 2026 17:25:29 +0200
Message-ID: <20260930152427.988336838@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Mathias Nyman <mathias.nyman@linux.intel.com>

[ Upstream commit f28a7d7db247af8b9f1090bd6b1ca1fa48a3f0e4 ]

Use predefined PCI vendor ID constant for Cadence controller in pci_ids.h
Rename the Candence device ID to match the pattern other PCI vendor and
device IDs use

Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Closes: https://lore.kernel.org/linux-usb/ZuMOfHp9j_6_3-WC@surfacebook.localdomain
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20241106101459.775897-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: eae6460f6173 ("usb: cdnsp: fix wakeup from S3 after controller context loss")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -94,8 +94,7 @@
 #define PCI_DEVICE_ID_ASMEDIA_3042_XHCI			0x3042
 #define PCI_DEVICE_ID_ASMEDIA_3242_XHCI			0x3242
 
-#define PCI_DEVICE_ID_CADENCE				0x17CD
-#define PCI_DEVICE_ID_CADENCE_SSP			0x0200
+#define PCI_DEVICE_ID_CDNS_SSP				0x0200
 
 static const char hcd_name[] = "xhci_hcd";
 
@@ -508,9 +507,8 @@ static void xhci_pci_quirks(struct devic
 		if (pdev->device == 0x9203)
 			xhci->quirks |= XHCI_TRB_OVERFETCH;
 	}
-
-	if (pdev->vendor == PCI_DEVICE_ID_CADENCE &&
-	    pdev->device == PCI_DEVICE_ID_CADENCE_SSP)
+	if (pdev->vendor == PCI_VENDOR_ID_CDNS &&
+	    pdev->device == PCI_DEVICE_ID_CDNS_SSP)
 		xhci->quirks |= XHCI_CDNS_SCTX_QUIRK;
 
 	/* xHC spec requires PCI devices to support D3hot and D3cold */


