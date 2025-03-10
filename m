Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3FE156861;
	Mon, 10 Mar 2025 18:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741631048; cv=none; b=BGsBy0AZ28Bt5qsEd6a61WU24GxolFdCMmb+TL8Q7uF5XLAm3n6dmh4lJT2AH6A7f5NdEYsrLqQX/jA4Sl4Wm0FIMsCZQEMdZj6LHhRR6g+1qgepQhpesgg0KGfBZhWRI4tCwlUHlZ1Blneaz0OsEYQaGtR/Pv90P8/pLpnM9TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741631048; c=relaxed/simple;
	bh=kZdOAPEMUcK6nG6cq5EECpdQWUqZ6ozILVDAhLfDA7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EREjCrEvcLY5sE1M/+WG82KlWNl+z2cDg+AO3J6ShxXYZVPn3ZUpr2YmcX217zU0PvUpIDHL7Z3g5SB/jdfK0IbmmbOuvC1Spbzvo4HlkLv1i8hJn5kbSPfSyIl3NlYFDg+T0nyIPTtaQ4M6cgQjxgp2+JpHuROP6qbyUkhJx1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9VQ2zef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9VQ2zef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C3DC4CEED;
	Mon, 10 Mar 2025 18:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741631048;
	bh=kZdOAPEMUcK6nG6cq5EECpdQWUqZ6ozILVDAhLfDA7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9VQ2zefT+ulDLNc8tZQYKGb/qZtQU/g0sBwVNfW5HyyJiefQl+NZRcQfk0hvhBlJ
	 6eV8nthVEIjpsg77HG+PPnkgN4d/buzsEgtitiW5NPwzQNWIjmqB72s1/uKPNhGIWJ
	 1vmw/8efxn3Xzyed+6M28PQZX6GDcivophuaKauI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.15 594/620] xhci: pci: Fix indentation in the PCI device ID definitions
Date: Mon, 10 Mar 2025 18:07:20 +0100
Message-ID: <20250310170608.981352018@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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


