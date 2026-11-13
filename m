Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590904;
	b=gQxWieGCWinDRsHVrqXoWR5ZVStAx1t+gECwQaUHjjC/O757wKWt58alTSxOqtbOe5gW
	 RLOmSZYMYqMN8ypM/owzcikbnMf5LOiOXx3stTBfgD/skh8XHkCnt1c14AhMuVp22R4Tq
	 PxVNw9Cm50U2IN3Yq96eSIwO6FgdBm3J/M20eZ4uTum0XaskfNoHVmUKoQGkozHRRwP2Z
	 kywoaBEGq04RnlKZ5AsSRBsBIU3r5oKlgw1Fba9+t6xGj6eSgYf1KB5mr+0AvZGiWhcu8
	 EiP8w5c9GTmSbdg9KOVh+RvFWdIgCxs+tGkvYxlEjaBTZHHeeHzbrGd2VVyyPccpBBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590904;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QSN33idFEYyLzSOo0PUQf9Aqc0ZRRTAKbZ95XkbvVmQ=;
	b=5lJYM4v78VgP2QSDRkovMtKPDlBYsSp5zFWSyW4k/hC5p9UB1F4NHMpR1SuHzzEG6s4V
	 i1mTz3o/AIEjRJqltch8TW9MKGMD0xdYGRsjE73WUc8xUYRplvo4199xuenpDtcUuldRu
	 h3NNn46ZtDFKUbqB0ZRZ+eXh7i+w/n32ho8j28Wqvs/z7R5LSWREVztJ2jn4dY/4FACf4
	 lOjMLW06E/gb2raMuLCD2qdlgUEOJY3PK6sA99XqZ4l3D55OvqfKwt5XLD8P74/ltgArO
	 tJjkL8JCmDnGtuGaAuz0yVTFJJRPzrdnPIorC1NSIVvLXGo1Tb7LoA+Z0pnWHK+l3lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wgzArB9f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9BC606E237;
	Fri, 13 Nov 2026 17:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wgzArB9f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A73A1F000C4;
	Fri, 13 Nov 2026 17:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590904;
	bh=QSN33idFEYyLzSOo0PUQf9Aqc0ZRRTAKbZ95XkbvVmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wgzArB9fr9b+PXvlwMVB9mrbUqh0jpeDwcm7A8Uhbp8F5aQDM7Oy1uuAut+fbrM8c
	 PoY0dQAX3dwmEMoRxv26xgnkNZNZRG9+0izl/LzWIUrKqvUwAAnz2Q5nNyEGb+5/7I
	 rEyErKLfzNyWm82PgmqavnJ5LdPRnZvCVnbhlbQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/670] PCI: rcar-gen4: Limit Max_Read_Request_Size to 256 Bytes
Date: Fri, 13 Nov 2026 10:44:17 -0500
Message-ID: <20261113153815.056541384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit f0a5c6bd797c2b9900034983a1118d27eb2f2f16 ]

R-Car Gen4 PCIe controller has a hardware limitation of 256 Bytes
Max_Payload_Size (MPS). PCIe specification indicates that the MPS must not
exceed minimum MPS of any element along the packet path.  The PCI core
already enforces this, but add a check to warn if MPS is ever set larger
than 256.

R-Car Gen4 Reference Manual, chapter 104.4.8 Usage notes for MRRS (Max Read
Request Size) states:

  Please set "Max Read Request Size" to 128 bytes or 256 bytes.
  If "Max Read Request Size" is set to anything other than the
  above, the transferred data will not match the expected value.

This limitation also seems to apply to devices doing DMA reads, i.e.,
issuing MRd TLPs.  This limitation can be triggered by using non-HMB NVMe
SSD with Max_Read_Request_Size 512 Bytes, for example Crucial P5 Plus.  Any
write to the SSD (MRd TLP issued by the SSD controller) longer than 256
Bytes wraps around at the 256 Byte boundary, and the same data are written
to the SSD starting at offset 0 and at 256 Bytes.

Limit Max_Read_Request_Size to at most 256 Bytes for each device connected
to this PCIe controller to avoid this behavior.

A non-HMB (Host Memory Buffer) NVMe SSD can be identified using the
following command. Affected SSD reports 'hmpre' field as 0:

  $ nvme id-ctrl /dev/nvme0 | grep hmpre
  hmpre     : 0

The symptom is a read from the SSD which wraps around at 256 Byte boundary.
The test for this symptom can be implemented by writing 512 Byte of random
data into the SSD and reading the data back. If the read back data repeat
after 256 Bytes, the device is affected.

  $ dd if=/dev/urandom of=/tmp/data.bin bs=256 count=2 ; \
    dd if=/tmp/data.bin of=/dev/nvme0n1 bs=256 count=2 ; \
    dd if=/dev/nvme0n1 bs=256 count=2 of=/tmp/readback.bin

Expected data:
  $ hexdump -vC /tmp/data.bin
  00000000  97 81 b7 3b 0e 38 2b 4d  a7 d3 e0 47 ff c2 4b ca
  00000010  c1 85 98 f0 4a ac 03 a0  3b ab f3 19 44 dd 06 8b
  ...
  00000100  7a ce 3c b2 e1 d5 d9 11  88 63 10 59 76 3c dc 32 <-- random
  00000110  72 32 2a 7d a3 e1 aa 13  7c da 58 a1 7b 21 11 50 <-- data

Faulty readback, collected without this change in place:
  $ hexdump -vC /tmp/readback.bin
  00000000  97 81 b7 3b 0e 38 2b 4d  a7 d3 e0 47 ff c2 4b ca <---.
  00000010  c1 85 98 f0 4a ac 03 a0  3b ab f3 19 44 dd 06 8b <-. |
  ...                                                          | |
  00000100  97 81 b7 3b 0e 38 2b 4d  a7 d3 e0 47 ff c2 4b ca <-:-+- repeated
  00000110  c1 85 98 f0 4a ac 03 a0  3b ab f3 19 44 dd 06 8b <-+--- data
       ^^^
        |
        '--- Repeat starts at offset 0x100 = 256 Bytes

Fixes: 0d0c551011df ("PCI: rcar-gen4: Add R-Car Gen4 PCIe controller support for host mode")
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260821020636.111719-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-rcar-gen4.c | 54 +++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-rcar-gen4.c b/drivers/pci/controller/dwc/pcie-rcar-gen4.c
index 8dcb63f813beb..a5f750709e2ce 100644
--- a/drivers/pci/controller/dwc/pcie-rcar-gen4.c
+++ b/drivers/pci/controller/dwc/pcie-rcar-gen4.c
@@ -305,6 +305,57 @@ static struct rcar_gen4_pcie *rcar_gen4_pcie_alloc(struct platform_device *pdev)
 	return rcar;
 }
 
+static int rcar_gen4_pcie_enable_device(struct pci_host_bridge *bridge,
+					struct pci_dev *dev)
+{
+	/*
+	 * R-Car Gen4 PCIe controller has a hardware limitation of 256 Bytes
+	 * Max_Payload_Size (MPS). PCIe specification indicates that the MPS
+	 * must not exceed minimum MPS of any element along the packet path.
+	 * The controller reports Max_Payload_Size_Supported (MPSS) 256 Bytes
+	 * for header type 0 and 128 Bytes for header type 1. The PCIe core
+	 * will not allow MPS to be set higher than MPSS; warn here in case
+	 * something went very wrong in the core.
+	 *
+	 * For details, refer to chapter "104.1.1 Features" in either of:
+	 * R-Car S4 R19UH0161EJ0140 Rev.1.40 Jul. 31, 2026 or
+	 * R-Car V4H R19UH0186EJ0140 Rev.1.40 Aug. 7, 2026 or
+	 * R-Car V4M R19UH0217EJ0110 Rev.1.10 Jun. 30, 2026.
+	 */
+	WARN_ON(pcie_get_mps(dev) > 256);
+
+	/*
+	 * R-Car Gen4 Reference Manual, chapter 104.4.8 Usage notes for
+	 * MRRS (Max Read Request Size) states:
+	 *
+	 *   Please set "Max Read Request Size" to 128 bytes or 256 bytes.
+	 *   If "Max Read Request Size" is set to anything other than the
+	 *   above, the transferred data will not match the expected value.
+	 *
+	 * This limitation also seems to apply to devices issuing MRd TLPs.
+	 * This limitation can be triggered by using non-HMB NVMe SSD with
+	 * Max_Read_Request_Size 512 Bytes, for example Crucial P5 Plus.
+	 * Any write into the SSD (MRd TLP issued by the SSD) longer than
+	 * 256 Bytes wraps around at 256 Byte boundary, and the same data
+	 * are written into the SSD starting at offset 0 and at 256 Bytes.
+	 *
+	 * Limit Max_Read_Request_Size to at most 256 Bytes for each
+	 * device connected to this PCIe controller to avoid this behavior.
+	 *
+	 * For details, refer to aforementioned chapter in either of:
+	 * R-Car S4 R19UH0161EJ0140 Rev.1.40 Jul. 31, 2026 or
+	 * R-Car V4H R19UH0186EJ0140 Rev.1.40 Aug. 7, 2026 or
+	 * R-Car V4M R19UH0217EJ0110 Rev.1.10 Jun. 30, 2026.
+	 */
+	bridge->no_inc_mrrs = 1;
+	if (pcie_get_readrq(dev) > 256) {
+		pci_info(dev, "Limiting MRRS to 256 bytes\n");
+		pcie_set_readrq(dev, 256);
+	}
+
+	return 0;
+}
+
 /* Host mode */
 static int rcar_gen4_pcie_host_init(struct dw_pcie_rp *pp)
 {
@@ -313,6 +364,9 @@ static int rcar_gen4_pcie_host_init(struct dw_pcie_rp *pp)
 	int ret;
 	u32 val;
 
+	if (pp->bridge)
+		pp->bridge->enable_device = rcar_gen4_pcie_enable_device;
+
 	gpiod_set_value_cansleep(dw->pe_rst, 1);
 
 	ret = rcar_gen4_pcie_common_init(rcar);
-- 
2.53.0



