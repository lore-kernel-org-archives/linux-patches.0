Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC1A7E110;
	Tue, 11 Mar 2025 15:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706275; cv=none; b=MKEuQbHhg0X8xYOUL5oRbZXR6Fd8C8a8vde4mtsU09zPi0CZqEUI9rZkFGHxgw+avuw0o4ZWVNEAKuIgBHOpZWUSO1TuxJJLENWIEsVP2CLgLctZgTUg0/mLKG6cHjPS2/fj0gykiwYg+Dth6fUMhDFzdqPvAw2rmlXlqYcHOp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706275; c=relaxed/simple;
	bh=pkcemzfuXYe5aPFbP1v49BTHGyIT1wNBEZrbD6eeh04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cS0/F3zlv6SLe/IjR8MrsxkHkYV4JkYOquQQ1nY/NH1d75RkbGKlkE6XkPsgKNY60306kbBr5oFOdMmilROAQOA7ySsV0pAHVvm2qjSVFJKYzkg0rLeSpAAU0POMZpqsD6WSnaT52+Kq8LdPXjue5Rruh1rMYSYkTyzDkAX3FyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDYDfCSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDYDfCSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7C8C4CEE9;
	Tue, 11 Mar 2025 15:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706275;
	bh=pkcemzfuXYe5aPFbP1v49BTHGyIT1wNBEZrbD6eeh04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDYDfCSAS/76vugee7AK5gTmntj29p0FemKPho62nCbTQUn6bqSDQRSCH85i1eVL+
	 +YJf6T1Dcbhg4IyeDVP/3H+Oc76MeMmTy9n64iH+HVSmcNwn4n+v+g1jvfztXNqTEI
	 mthlAD92Vpz2woVA7XwW/FDF0jNBnzp1PzMEqgiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 322/328] xhci: pci: Fix indentation in the PCI device ID definitions
Date: Tue, 11 Mar 2025 16:01:32 +0100
Message-ID: <20250311145727.695393598@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -25,8 +25,8 @@
 #define SPARSE_CNTL_ENABLE	0xC12C
 
 /* Device for a quirk */
-#define PCI_VENDOR_ID_FRESCO_LOGIC	0x1b73
-#define PCI_DEVICE_ID_FRESCO_LOGIC_PDK	0x1000
+#define PCI_VENDOR_ID_FRESCO_LOGIC		0x1b73
+#define PCI_DEVICE_ID_FRESCO_LOGIC_PDK		0x1000
 #define PCI_DEVICE_ID_FRESCO_LOGIC_FL1009	0x1009
 #define PCI_DEVICE_ID_FRESCO_LOGIC_FL1100	0x1100
 #define PCI_DEVICE_ID_FRESCO_LOGIC_FL1400	0x1400
@@ -35,8 +35,8 @@
 #define PCI_DEVICE_ID_EJ168		0x7023
 #define PCI_DEVICE_ID_EJ188		0x7052
 
-#define PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI	0x8c31
-#define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI	0x9c31
+#define PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI		0x8c31
+#define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI		0x9c31
 #define PCI_DEVICE_ID_INTEL_WILDCATPOINT_LP_XHCI	0x9cb1
 #define PCI_DEVICE_ID_INTEL_CHERRYVIEW_XHCI		0x22b5
 #define PCI_DEVICE_ID_INTEL_SUNRISEPOINT_H_XHCI		0xa12f


