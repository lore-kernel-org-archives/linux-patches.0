Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064670;
	b=LV0Se26aE85hYMznqt1gqvADIk+LDlUuTmlrSeDD1MmiwQERJTDuteWP/JCg9vSjO2Dg
	 WZl8fqrYFVQbgs+NWwX/IPXGpu7uKBCVxduE/oMT0HDk6Jtzt/kprdY3+eAEryrEECebT
	 Ovc/IvYUuLO7akNceBAdZMPsbzzGUG/GYbH7IjU6KZwDEPlvxcMqf+DaKcW9kTbalXNP4
	 RDZqq3R+dnlniNIhPKKW2Ie2mu1C1/0y0dkI1xoA711r73yS6M5qUMn2z4Pq3f5Lza36f
	 hrj12x6Mbs/4FxmzoVbFEEnf6v36VaIzdgdkpNkrwpHzEym8pblcSd6JWlTqQJyeOGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xxx65RGxpaP2za65su+FKSwHw5eVJ3KMgNYe7nNxpwc=;
	b=sGRuWZWkBUfthB6ZrsudVerjoKzbVLGTa9YEicAFr2WEzxNQp9wxOT8+3tKG94qVYW8D
	 wCOWm4akQ3vBpEnB7upTX7yJbLusTOw7V79IPH+nH/SfghG/wqm9/XZHvjZKPDmnbGFFu
	 2iu5IJzJSSaxPJrHs1Uglkb9OQft6g0vcl4r9IV+nXED6yKfcbxqI6diwD+PVD4Ds2eaH
	 POa7y/AygseNcwvGExRlkT3mASa+cd9BtdNDc4iyUC93dI/45AR0fuGMpAIUpanixu1fU
	 FUmaTmowhVwLjTM949yJg97pzTOR0lvW02askh4hHGWL4YBx8WvLVJbfymQK0KCRuYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1e2HJlUI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A48606A9CF;
	Sat,  7 Nov 2026 15:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1e2HJlUI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DC81F008A1;
	Sat,  7 Nov 2026 15:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064670;
	bh=xxx65RGxpaP2za65su+FKSwHw5eVJ3KMgNYe7nNxpwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1e2HJlUIISI/+HZ7hkBHuXPP3e2lxquf7nQ8fFJj8ZbyT8rMadBkXx5JOTvsO47FM
	 zRbEScxrJCnLbGe5JN9sUQW/S9ecn71g3A2nC56//WFTLdiXHs3bQBoE7vItYXqGxW
	 k/N8ZP38WNi8i+U1PwrmcluJrCJ/3TY+wabnbh/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Jihong Min <hurryman2212@gmail.com>,
	Stephen Horvath <linux@stevetech.au>,
	Mirko Jechow <mirko.jechow@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0630/1257] usb: xhci-pci: Add AMD 600 series to xhci-pci-prom21
Date: Sat,  7 Nov 2026 08:48:46 -0500
Message-ID: <20261107134956.693350158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Horvath <linux@stevetech.au>

[ Upstream commit 29381088ac50a4910d18a5f8079d9bd505f839be ]

It seems the xhci-pci-prom21 module only has IDs for the 800 series
chipsets. However, the 600 series chipsets also have Promontory 21
chips, so we should add their IDs to the list as well.

I have tested this on my X670 board featuring DID `0x43f7`.

`1022:43f7` also appears on the PCI ID database
(https://pci-ids.ucw.cz/read/PC/1022/43f7).
Device IDs `0x43f9` (B665) & `0x43fa` (A620) were suggested by Shyam.

Also list the new IDs in Documentation/hwmon/prom21-xhci.rst.

Cc: stable@vger.kernel.org # 7.2.x
Cc: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc: Jihong Min <hurryman2212@gmail.com>
Signed-off-by: Stephen Horvath <linux@stevetech.au>
Tested-by: Mirko Jechow <mirko.jechow@gmx.de>
[mirko.jechow@gmx.de: add new IDs to prom21-xhci.rst]
Signed-off-by: Mirko Jechow <mirko.jechow@gmx.de>
Link: https://patch.msgid.link/20261004002731.49927-1-mirko.jechow@gmx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/prom21-xhci.rst | 2 +-
 drivers/usb/host/xhci-pci-prom21.c  | 3 +++
 drivers/usb/host/xhci-pci.c         | 3 +++
 drivers/usb/host/xhci-pci.h         | 3 +++
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/hwmon/prom21-xhci.rst b/Documentation/hwmon/prom21-xhci.rst
index 7984fb187bd8a..6c0b6e7368921 100644
--- a/Documentation/hwmon/prom21-xhci.rst
+++ b/Documentation/hwmon/prom21-xhci.rst
@@ -9,7 +9,7 @@ Supported chips:
 
     Prefix: 'prom21_xhci'
 
-    PCI IDs: 1022:43fc, 1022:43fd
+    PCI IDs: 1022:43f7, 1022:43f9, 1022:43fa, 1022:43fc, 1022:43fd
 
 Author:
 
diff --git a/drivers/usb/host/xhci-pci-prom21.c b/drivers/usb/host/xhci-pci-prom21.c
index 6486f4a093455..5f088a47d79f3 100644
--- a/drivers/usb/host/xhci-pci-prom21.c
+++ b/drivers/usb/host/xhci-pci-prom21.c
@@ -111,6 +111,9 @@ static void prom21_xhci_remove(struct pci_dev *dev)
 }
 
 static const struct pci_device_id pci_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_PROM21_XHCI_43F7) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_PROM21_XHCI_43F9) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_PROM21_XHCI_43FA) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_PROM21_XHCI_43FC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_PROM21_XHCI_43FD) },
 	{ /* end: all zeroes */ }
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index a8889081ae824..b407676808fca 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -701,6 +701,9 @@ static const struct pci_device_id pci_ids_renesas[] = {
 
 /* handled by xhci-pci-prom21 if enabled */
 static const struct pci_device_id pci_ids_prom21[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_PROM21_XHCI_43F7) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_PROM21_XHCI_43F9) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_PROM21_XHCI_43FA) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_PROM21_XHCI_43FC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_PROM21_XHCI_43FD) },
 	{ /* end: all zeroes */ }
diff --git a/drivers/usb/host/xhci-pci.h b/drivers/usb/host/xhci-pci.h
index 11f435f94322a..533efc7db8012 100644
--- a/drivers/usb/host/xhci-pci.h
+++ b/drivers/usb/host/xhci-pci.h
@@ -4,6 +4,9 @@
 #ifndef XHCI_PCI_H
 #define XHCI_PCI_H
 
+#define PCI_DEVICE_ID_AMD_PROM21_XHCI_43F7	0x43f7
+#define PCI_DEVICE_ID_AMD_PROM21_XHCI_43F9	0x43f9
+#define PCI_DEVICE_ID_AMD_PROM21_XHCI_43FA	0x43fa
 #define PCI_DEVICE_ID_AMD_PROM21_XHCI_43FC	0x43fc
 #define PCI_DEVICE_ID_AMD_PROM21_XHCI_43FD	0x43fd
 
-- 
2.53.0



