Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DAE1DE89C;
	Mon, 10 Mar 2025 17:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628158; cv=none; b=k9wvqQ44K48KciXDFFiWnrp9Iv/7JaO0KuOlt1Z1JYKO+Kx7KWXfisvJP64EbzK1/VaLVJjuQfFOTUhb0FerkhU+0QLxByXpQLLNrOOgXGxaKkuB//fnBqh4JzesnrIoxlmANriULSvFysGBlQ0ZXWwld0QsJQ4Fi1W6qT4Yi54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628158; c=relaxed/simple;
	bh=Uv2pWnJ7iG7MbQQWfShS6TTy7Xlm3An//0gI/kG6GBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r30tR/dJxzPyLScxZdG1kEVXnFXZ5SkITdU2qmceje/mAHJ90HiIMc4BHAnYCysKc07vc/j5AWUNFxSE+rbIc2N+paxy62t5vJl6z72l4UWIFfKrvtf7X+0XQ/tLWKLYhJ5jtjyt6EN+5HSA9v8oHKNz/yBwvYzxONuC+6WYxjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1X8EqCC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1X8EqCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BBDC4CEE5;
	Mon, 10 Mar 2025 17:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628158;
	bh=Uv2pWnJ7iG7MbQQWfShS6TTy7Xlm3An//0gI/kG6GBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1X8EqCCQFASnR+OJigot4JbjrOp2bMEmniVAesWJG15MsrsRpEZd86o+meiGUozX
	 3MQxziB02WqY/2hoNiU+0Rq6PI2O5owZsroD9qkHR6xpbaNnLRPaWFn8htypp4Nqvh
	 Ggax9oCpV+DhnyOoe0h4G4QLPr4xfXbAa9wazKBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.6 108/145] xhci: pci: Fix indentation in the PCI device ID definitions
Date: Mon, 10 Mar 2025 18:06:42 +0100
Message-ID: <20250310170439.118621086@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 0309ed83791c079f239c13e0c605210425cd1a61 upstream.

Some of the definitions are missing the one TAB, add it to them.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20241106101459.775897-23-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-pci.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -28,8 +28,8 @@
 #define SPARSE_CNTL_ENABLE	0xC12C
 
 /* Device for a quirk */
-#define PCI_VENDOR_ID_FRESCO_LOGIC	0x1b73
-#define PCI_DEVICE_ID_FRESCO_LOGIC_PDK	0x1000
+#define PCI_VENDOR_ID_FRESCO_LOGIC		0x1b73
+#define PCI_DEVICE_ID_FRESCO_LOGIC_PDK		0x1000
 #define PCI_DEVICE_ID_FRESCO_LOGIC_FL1009	0x1009
 #define PCI_DEVICE_ID_FRESCO_LOGIC_FL1100	0x1100
 #define PCI_DEVICE_ID_FRESCO_LOGIC_FL1400	0x1400
@@ -38,8 +38,8 @@
 #define PCI_DEVICE_ID_EJ168		0x7023
 #define PCI_DEVICE_ID_EJ188		0x7052
 
-#define PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI	0x8c31
-#define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI	0x9c31
+#define PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI		0x8c31
+#define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI		0x9c31
 #define PCI_DEVICE_ID_INTEL_WILDCATPOINT_LP_XHCI	0x9cb1
 #define PCI_DEVICE_ID_INTEL_CHERRYVIEW_XHCI		0x22b5
 #define PCI_DEVICE_ID_INTEL_SUNRISEPOINT_H_XHCI		0xa12f


