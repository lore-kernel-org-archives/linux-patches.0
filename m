Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95801DED64;
	Wed, 19 Feb 2025 08:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954087; cv=none; b=CpSJXdDwpFSt+azIQo23IvAYM4wJLihYeZ5FOfkNWpoM6VRMowP5O7U9TAgCZIjA4zidO+BxYdbC9tl/ln4xHKyXGRB4IPmkLoIVy9JiI5uzbXPh1f6IBGfcDwionO7Ft1hb1Ygk8VmdOTVHFYtSoNYKSme11evN1BGN7x8K1Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954087; c=relaxed/simple;
	bh=ojFhZRX455DxYgJbYYTcrEZLyLzXgt0+CAtGLJtt3pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFqI7vwR7Pzsdl7FPw3PV3NISkoztvgcTxa6M11zkGkHRlq9CrRQjrryFUvm5Rjo+BPyK9qg3kcqWU8de2OnPOvGlmK9c5dSatB3SK0arbXTzG9dNGYN1Oiy82GHusSbiwQu43WuNJPl+/c3U44yUmnTEqeeq6Fo4SuYw8Fs5ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q3B0V4yQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q3B0V4yQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575C9C4CED1;
	Wed, 19 Feb 2025 08:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954087;
	bh=ojFhZRX455DxYgJbYYTcrEZLyLzXgt0+CAtGLJtt3pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q3B0V4yQ9F81tI74yKKrJziA4GotbepCwA63dJDKfHL1TjI0EwNguXolZK1SeGQg0
	 bp5v0kAbMSEivYAuzv5+bWMhBDM/NesicptgN1j1RGCyZ2tRdb4BxFrPYaKh1DoB0o
	 y3pWd4bxolmRsHQREckAdO/1LP5+ujzL4uWrtPcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 092/274] serial: 8250_pci: Resolve WCH vendor ID ambiguity
Date: Wed, 19 Feb 2025 09:25:46 +0100
Message-ID: <20250219082613.227044672@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 16076ca3a1565491bcb28689e555d569a39391c7 ]

There are two sites of the same brand: wch.cn and wch-ic.com.
They are property of the same company, but it appears that they
managed to get two different PCI vendor IDs. Rename them accordingly
using standard pattern, i.e. PCI_VENDOR_ID_...

While at it, move to PCI_VDEVICE() in the ID tables.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20241204031114.1029882-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_pci.c | 82 +++++++++++++++---------------
 1 file changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 3c3f7c926afb8..dfac79744d377 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -64,23 +64,23 @@
 #define PCIE_DEVICE_ID_NEO_2_OX_IBM	0x00F6
 #define PCI_DEVICE_ID_PLX_CRONYX_OMEGA	0xc001
 #define PCI_DEVICE_ID_INTEL_PATSBURG_KT 0x1d3d
-#define PCI_VENDOR_ID_WCH		0x4348
-#define PCI_DEVICE_ID_WCH_CH352_2S	0x3253
-#define PCI_DEVICE_ID_WCH_CH353_4S	0x3453
-#define PCI_DEVICE_ID_WCH_CH353_2S1PF	0x5046
-#define PCI_DEVICE_ID_WCH_CH353_1S1P	0x5053
-#define PCI_DEVICE_ID_WCH_CH353_2S1P	0x7053
-#define PCI_DEVICE_ID_WCH_CH355_4S	0x7173
+#define PCI_VENDOR_ID_WCHCN		0x4348
+#define PCI_DEVICE_ID_WCHCN_CH352_2S	0x3253
+#define PCI_DEVICE_ID_WCHCN_CH353_4S	0x3453
+#define PCI_DEVICE_ID_WCHCN_CH353_2S1PF	0x5046
+#define PCI_DEVICE_ID_WCHCN_CH353_1S1P	0x5053
+#define PCI_DEVICE_ID_WCHCN_CH353_2S1P	0x7053
+#define PCI_DEVICE_ID_WCHCN_CH355_4S	0x7173
 #define PCI_VENDOR_ID_AGESTAR		0x5372
 #define PCI_DEVICE_ID_AGESTAR_9375	0x6872
 #define PCI_DEVICE_ID_BROADCOM_TRUMANAGE 0x160a
 #define PCI_DEVICE_ID_AMCC_ADDIDATA_APCI7800 0x818e
 
-#define PCIE_VENDOR_ID_WCH		0x1c00
-#define PCIE_DEVICE_ID_WCH_CH382_2S1P	0x3250
-#define PCIE_DEVICE_ID_WCH_CH384_4S	0x3470
-#define PCIE_DEVICE_ID_WCH_CH384_8S	0x3853
-#define PCIE_DEVICE_ID_WCH_CH382_2S	0x3253
+#define PCI_VENDOR_ID_WCHIC		0x1c00
+#define PCI_DEVICE_ID_WCHIC_CH382_2S1P	0x3250
+#define PCI_DEVICE_ID_WCHIC_CH384_4S	0x3470
+#define PCI_DEVICE_ID_WCHIC_CH384_8S	0x3853
+#define PCI_DEVICE_ID_WCHIC_CH382_2S	0x3253
 
 #define PCI_DEVICE_ID_MOXA_CP102E	0x1024
 #define PCI_DEVICE_ID_MOXA_CP102EL	0x1025
@@ -2817,80 +2817,80 @@ static struct pci_serial_quirk pci_serial_quirks[] = {
 	},
 	/* WCH CH353 1S1P card (16550 clone) */
 	{
-		.vendor         = PCI_VENDOR_ID_WCH,
-		.device         = PCI_DEVICE_ID_WCH_CH353_1S1P,
+		.vendor         = PCI_VENDOR_ID_WCHCN,
+		.device         = PCI_DEVICE_ID_WCHCN_CH353_1S1P,
 		.subvendor      = PCI_ANY_ID,
 		.subdevice      = PCI_ANY_ID,
 		.setup          = pci_wch_ch353_setup,
 	},
 	/* WCH CH353 2S1P card (16550 clone) */
 	{
-		.vendor         = PCI_VENDOR_ID_WCH,
-		.device         = PCI_DEVICE_ID_WCH_CH353_2S1P,
+		.vendor         = PCI_VENDOR_ID_WCHCN,
+		.device         = PCI_DEVICE_ID_WCHCN_CH353_2S1P,
 		.subvendor      = PCI_ANY_ID,
 		.subdevice      = PCI_ANY_ID,
 		.setup          = pci_wch_ch353_setup,
 	},
 	/* WCH CH353 4S card (16550 clone) */
 	{
-		.vendor         = PCI_VENDOR_ID_WCH,
-		.device         = PCI_DEVICE_ID_WCH_CH353_4S,
+		.vendor         = PCI_VENDOR_ID_WCHCN,
+		.device         = PCI_DEVICE_ID_WCHCN_CH353_4S,
 		.subvendor      = PCI_ANY_ID,
 		.subdevice      = PCI_ANY_ID,
 		.setup          = pci_wch_ch353_setup,
 	},
 	/* WCH CH353 2S1PF card (16550 clone) */
 	{
-		.vendor         = PCI_VENDOR_ID_WCH,
-		.device         = PCI_DEVICE_ID_WCH_CH353_2S1PF,
+		.vendor         = PCI_VENDOR_ID_WCHCN,
+		.device         = PCI_DEVICE_ID_WCHCN_CH353_2S1PF,
 		.subvendor      = PCI_ANY_ID,
 		.subdevice      = PCI_ANY_ID,
 		.setup          = pci_wch_ch353_setup,
 	},
 	/* WCH CH352 2S card (16550 clone) */
 	{
-		.vendor		= PCI_VENDOR_ID_WCH,
-		.device		= PCI_DEVICE_ID_WCH_CH352_2S,
+		.vendor		= PCI_VENDOR_ID_WCHCN,
+		.device		= PCI_DEVICE_ID_WCHCN_CH352_2S,
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
 		.setup		= pci_wch_ch353_setup,
 	},
 	/* WCH CH355 4S card (16550 clone) */
 	{
-		.vendor		= PCI_VENDOR_ID_WCH,
-		.device		= PCI_DEVICE_ID_WCH_CH355_4S,
+		.vendor		= PCI_VENDOR_ID_WCHCN,
+		.device		= PCI_DEVICE_ID_WCHCN_CH355_4S,
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
 		.setup		= pci_wch_ch355_setup,
 	},
 	/* WCH CH382 2S card (16850 clone) */
 	{
-		.vendor         = PCIE_VENDOR_ID_WCH,
-		.device         = PCIE_DEVICE_ID_WCH_CH382_2S,
+		.vendor         = PCI_VENDOR_ID_WCHIC,
+		.device         = PCI_DEVICE_ID_WCHIC_CH382_2S,
 		.subvendor      = PCI_ANY_ID,
 		.subdevice      = PCI_ANY_ID,
 		.setup          = pci_wch_ch38x_setup,
 	},
 	/* WCH CH382 2S1P card (16850 clone) */
 	{
-		.vendor         = PCIE_VENDOR_ID_WCH,
-		.device         = PCIE_DEVICE_ID_WCH_CH382_2S1P,
+		.vendor         = PCI_VENDOR_ID_WCHIC,
+		.device         = PCI_DEVICE_ID_WCHIC_CH382_2S1P,
 		.subvendor      = PCI_ANY_ID,
 		.subdevice      = PCI_ANY_ID,
 		.setup          = pci_wch_ch38x_setup,
 	},
 	/* WCH CH384 4S card (16850 clone) */
 	{
-		.vendor         = PCIE_VENDOR_ID_WCH,
-		.device         = PCIE_DEVICE_ID_WCH_CH384_4S,
+		.vendor         = PCI_VENDOR_ID_WCHIC,
+		.device         = PCI_DEVICE_ID_WCHIC_CH384_4S,
 		.subvendor      = PCI_ANY_ID,
 		.subdevice      = PCI_ANY_ID,
 		.setup          = pci_wch_ch38x_setup,
 	},
 	/* WCH CH384 8S card (16850 clone) */
 	{
-		.vendor         = PCIE_VENDOR_ID_WCH,
-		.device         = PCIE_DEVICE_ID_WCH_CH384_8S,
+		.vendor         = PCI_VENDOR_ID_WCHIC,
+		.device         = PCI_DEVICE_ID_WCHIC_CH384_8S,
 		.subvendor      = PCI_ANY_ID,
 		.subdevice      = PCI_ANY_ID,
 		.init           = pci_wch_ch38x_init,
@@ -3967,11 +3967,11 @@ static const struct pci_device_id blacklist[] = {
 
 	/* multi-io cards handled by parport_serial */
 	/* WCH CH353 2S1P */
-	{ PCI_DEVICE(0x4348, 0x7053), 0, 0, REPORT_CONFIG(PARPORT_SERIAL), },
+	{ PCI_VDEVICE(WCHCN, 0x7053), REPORT_CONFIG(PARPORT_SERIAL), },
 	/* WCH CH353 1S1P */
-	{ PCI_DEVICE(0x4348, 0x5053), 0, 0, REPORT_CONFIG(PARPORT_SERIAL), },
+	{ PCI_VDEVICE(WCHCN, 0x5053), REPORT_CONFIG(PARPORT_SERIAL), },
 	/* WCH CH382 2S1P */
-	{ PCI_DEVICE(0x1c00, 0x3250), 0, 0, REPORT_CONFIG(PARPORT_SERIAL), },
+	{ PCI_VDEVICE(WCHIC, 0x3250), REPORT_CONFIG(PARPORT_SERIAL), },
 
 	/* Intel platforms with MID UART */
 	{ PCI_VDEVICE(INTEL, 0x081b), REPORT_8250_CONFIG(MID), },
@@ -6044,27 +6044,27 @@ static const struct pci_device_id serial_pci_tbl[] = {
 	 * WCH CH353 series devices: The 2S1P is handled by parport_serial
 	 * so not listed here.
 	 */
-	{	PCI_VENDOR_ID_WCH, PCI_DEVICE_ID_WCH_CH353_4S,
+	{	PCI_VENDOR_ID_WCHCN, PCI_DEVICE_ID_WCHCN_CH353_4S,
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0, pbn_b0_bt_4_115200 },
 
-	{	PCI_VENDOR_ID_WCH, PCI_DEVICE_ID_WCH_CH353_2S1PF,
+	{	PCI_VENDOR_ID_WCHCN, PCI_DEVICE_ID_WCHCN_CH353_2S1PF,
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0, pbn_b0_bt_2_115200 },
 
-	{	PCI_VENDOR_ID_WCH, PCI_DEVICE_ID_WCH_CH355_4S,
+	{	PCI_VENDOR_ID_WCHCN, PCI_DEVICE_ID_WCHCN_CH355_4S,
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0, pbn_b0_bt_4_115200 },
 
-	{	PCIE_VENDOR_ID_WCH, PCIE_DEVICE_ID_WCH_CH382_2S,
+	{	PCI_VENDOR_ID_WCHIC, PCI_DEVICE_ID_WCHIC_CH382_2S,
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0, pbn_wch382_2 },
 
-	{	PCIE_VENDOR_ID_WCH, PCIE_DEVICE_ID_WCH_CH384_4S,
+	{	PCI_VENDOR_ID_WCHIC, PCI_DEVICE_ID_WCHIC_CH384_4S,
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0, pbn_wch384_4 },
 
-	{	PCIE_VENDOR_ID_WCH, PCIE_DEVICE_ID_WCH_CH384_8S,
+	{	PCI_VENDOR_ID_WCHIC, PCI_DEVICE_ID_WCHIC_CH384_8S,
 		PCI_ANY_ID, PCI_ANY_ID,
 		0, 0, pbn_wch384_8 },
 	/*
-- 
2.39.5



