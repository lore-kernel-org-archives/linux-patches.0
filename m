Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060836;
	b=x51lZ9z4H4tw2xXM68UCEEnjn4jfIMWutKKoZM5CAXSUsFI4RksRYs4jnQx+XWkL4W/g
	 5E32TU9zeE4rWZ0eQf0qw+AvGfv+q4oL0hrTpSRZszPXFWukUnJwNUeiE5CaPHeT/S2yd
	 RcJos5szLdz30L4zgAPkkyyiLsUGffIGvnp5M7urAq1RAwvdzx4E6Xd1P3HUunFSJwZVF
	 aUBbbqDxrIBpreeLqdatdwwM1tvsywmRCOiythDh3OwXildaEVJ3jl2YFtkBj+1jNJUIM
	 ccYBSUo+rLFSw/OxpozIPtqTW3hd482JUvPsmbRPqEvDi8BZLSjd2OKTk1T3lWR36Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060836;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k3mmRXJtOgHPhc+FwUKcM+qsLmRbZ9tzmWcdaHeL9lM=;
	b=lXW2SLrXzn9wOVoh58u7w2eVJfLVP73/MDTt4H2gnhNHzRfxuIrtqufqsI0/CCaKmR3e
	 PSshU6YtEFnczMxFcfPRd6Qhz0g13dhAQg/bq+KRrtpK+MJk1XZV7bPMjKvCOBwtoyqfE
	 RANs98435Zd7zQVRDI2AtAxj8KsX6cxmnvsY7AlbDHPuI/4SrN5T1hZ+pyg+AJw1Umjku
	 h5nood088c529xLDxi3i/6/imkFiXlx3e8nvNErbTfJv+UcVahpKXY4Crx3n2UHnjWjEs
	 RW5p2ETQ/MtGfMicRoUWBv9lhNoGGxUnoFrWmUXm1S3Am6ttsFbkPGjMaZ4cH2Ot0Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t3pJBtrQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C27F606A336;
	Sat,  7 Nov 2026 14:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t3pJBtrQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2D61F008A1;
	Sat,  7 Nov 2026 14:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060836;
	bh=k3mmRXJtOgHPhc+FwUKcM+qsLmRbZ9tzmWcdaHeL9lM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t3pJBtrQOAeHHUAGvTlABzhKJpaFTw6eyP1g2cLO5b+TLfrxeimj9F0zgeoTr/OAq
	 OPp1gpPJRG4PQEu+qKqPm/6NsY0cKutkz/jenwR5vLTMh7Dc79GOYcmjhjCwa0FZfA
	 +NeEhkpAUxW1pqMn69o3g7g4xuqkP9dKw7DUAzmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Strahan <david.strahan@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0227/1536] scsi: smartpqi: Add new PCI device-ids
Date: Sat,  7 Nov 2026 08:37:23 -0500
Message-ID: <20261107135004.045053983@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: David Strahan <David.Strahan@microchip.com>

[ Upstream commit 1a220e6e87a31c2572cd07ff47023e5cd92ac80f ]

All PCI ID entries in Hex.

Add PCI IDs for Hurray Data controllers:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
                                            9005 / 028f / 207d / 4246
                                            9005 / 028f / 207d / 4256
                                            9005 / 028f / 207d / 4356
                                            9005 / 028f / 207d / 4940
                                            9005 / 028f / 207d / 4a46

Add PCI IDs for ZTE controllers:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
                                            9005 / 028f / 1cf2 / 5451
                                            9005 / 028f / 1cf2 / 5452
                                            9005 / 028f / 1cf2 / 5453

Add PCI ID for Ramaxel controller:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
                                            9005 / 028f / 1f3f / 0670

Signed-off-by: David Strahan <david.strahan@microchip.com>
Reviewed-by: Don Brace <don.brace@microchip.com>
Link: https://lore.kernel.org/linux-scsi/20260722220401.6357-1-david.strahan@microchip.com/
Link: https://patch.msgid.link/20260722220401.6357-4-david.strahan@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 36 +++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 32c92678d5916..8ecbe30ee6d27 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -10116,10 +10116,30 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x207d, 0x4240)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4246)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4256)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4356)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x207d, 0x4840)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4940)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4a46)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADVANTECH, 0x8312)
@@ -10304,6 +10324,18 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1cf2, 0x544f)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x5451)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x5452)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1cf2, 0x5453)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1cf2, 0x54da)
@@ -10344,6 +10376,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1f3f, 0x0610)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f3f, 0x0670)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_LENOVO, 0x0220)
-- 
2.53.0



