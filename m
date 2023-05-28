Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F58569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E68C433EF;
	Sun, 28 May 2023 19:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302014;
	bh=Rt++F6LEd2cg5HTNWU743syrLxSvDitO01cQS9yAkls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kEFrxC57NxV5xoPgXs0/w49+rwO7EkEmnJBk6+cHAhC2BDNPyyswapeUlQpnYEW50
	 Nb1vyQnJl+lkzCeTw2Pa/TYvMWof8k4x3gx8vTNVVlCK1IICSujflZmJWn3m41dXTl
	 r5s9OAEqslFPWKdbH3rNz4ZHDDXV8qb6HIuBPtu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaliy Tomin <tomin@iszf.irk.ru>,
	stable <stable@kernel.org>
Subject: [PATCH 5.4 099/161] serial: Add support for Advantech PCI-1611U card
Date: Sun, 28 May 2023 20:10:23 +0100
Message-Id: <20230528190840.262239256@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vitaliy Tomin <tomin@iszf.irk.ru>

commit d2b00516de0e1d696724247098f6733a6ea53908 upstream.

Add support for Advantech PCI-1611U card

Advantech provides opensource drivers for this and many others card
based on legacy copy of 8250_pci driver called adv950

https://www.advantech.com/emt/support/details/driver?id=1-TDOIMJ

It is hard to maintain to run as out of tree module on newer kernels.
Just adding PCI ID to kernel 8250_pci works perfect.

Signed-off-by: Vitaliy Tomin <tomin@iszf.irk.ru>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20230423034512.2671157-1-tomin@iszf.irk.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1837,6 +1837,8 @@ pci_moxa_setup(struct serial_private *pr
 #define PCI_SUBDEVICE_ID_SIIG_DUAL_30	0x2530
 #define PCI_VENDOR_ID_ADVANTECH		0x13fe
 #define PCI_DEVICE_ID_INTEL_CE4100_UART 0x2e66
+#define PCI_DEVICE_ID_ADVANTECH_PCI1600	0x1600
+#define PCI_DEVICE_ID_ADVANTECH_PCI1600_1611	0x1611
 #define PCI_DEVICE_ID_ADVANTECH_PCI3620	0x3620
 #define PCI_DEVICE_ID_ADVANTECH_PCI3618	0x3618
 #define PCI_DEVICE_ID_ADVANTECH_PCIf618	0xf618
@@ -4157,6 +4159,9 @@ static SIMPLE_DEV_PM_OPS(pciserial_pm_op
 			 pciserial_resume_one);
 
 static const struct pci_device_id serial_pci_tbl[] = {
+	{	PCI_VENDOR_ID_ADVANTECH, PCI_DEVICE_ID_ADVANTECH_PCI1600,
+		PCI_DEVICE_ID_ADVANTECH_PCI1600_1611, PCI_ANY_ID, 0, 0,
+		pbn_b0_4_921600 },
 	/* Advantech use PCI_DEVICE_ID_ADVANTECH_PCI3620 (0x3620) as 'PCI_SUBVENDOR_ID' */
 	{	PCI_VENDOR_ID_ADVANTECH, PCI_DEVICE_ID_ADVANTECH_PCI3620,
 		PCI_DEVICE_ID_ADVANTECH_PCI3620, 0x0001, 0, 0,


