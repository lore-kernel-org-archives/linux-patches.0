Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518881E87B;
	Mon, 23 Jun 2025 22:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716343; cv=none; b=U7OFkdBRB41bTCnTKaAyTKQeZL2XknZnifx3AB3A4JVJswjWF/lDEUWLQ4ucI1Q6trGi9pZNMlFEvRic8pnAZVLp2IGVs4r+fmKkM5YmncumG/LH0wI/sBJipw0L2hUrlX4vPvtFSZo9357acZMgIOaXL5vKGQXj1JMhiHCn62c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716343; c=relaxed/simple;
	bh=wpTtqIV0sZ3MfbqbiHqFJTzz3xxE/7Iz9R2GI5ja448=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/eAuY7alPwrw/5B8mpqv00mtQlFQ/HbQ3YII5uiDYGQF5TkAUhgjTNofqQihZWx+gAvGZlexgtCeCHV/qph11t4VpsSVXz+jzdVr+aKto1v4esFK8JIZOy9rzt6NXkYsqB/yckaW/dUMILqM0Y/DaaZDb1kOS06BTpJjoh/UEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NkfP98LS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NkfP98LS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20FFC4CEEA;
	Mon, 23 Jun 2025 22:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716343;
	bh=wpTtqIV0sZ3MfbqbiHqFJTzz3xxE/7Iz9R2GI5ja448=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NkfP98LSZ8AzOu0t5hvQeIbfpfMUObGm5A6kZV8oi39cLevOHam529DffZMlRaIwl
	 k3h8taAjwV4as/HMUHXtHTwP5Ehb66wrL7nXeOA+Fq6SOyqEhjL99pum7uHChgyRK8
	 3NGTo47bHAN9+Lnp4jVDD1uiCoR4zl9LREMYA6Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Benesh <scott.benesh@microchip.com>,
	Scott Teel <scott.teel@microchip.com>,
	Mike McGowen <mike.mcgowen@microchip.com>,
	David Strahan <david.strahan@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 245/414] scsi: smartpqi: Add new PCI IDs
Date: Mon, 23 Jun 2025 15:06:22 +0200
Message-ID: <20250623130648.175528118@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Strahan <david.strahan@microchip.com>

[ Upstream commit 01b8bdddcfab035cf70fd9981cb20593564cd15d ]

Add in support for more PCI devices.

All PCI ID entries in Hex.

Add PCI IDs for Ramaxel controllers:
                                                  VID  / DID  / SVID / SDID
                                                  ----   ----   ----   ----
                      Ramaxel SmartHBA RX8238-16i 9005   028f   1018   8238
                      Ramaxel SSSRAID card        9005   028f   1f3f   0610

Add PCI ID for Alibaba controller:
                                                  VID  / DID  / SVID / SDID
                                                  ----   ----   ----   ----
                      HBA AS1340                  9005   028f   1ded   3301

Add PCI IDs for Inspur controller:
                                                  VID  / DID  / SVID / SDID
                                                  ----   ----   ----   ----
                      RT0800M6E2i                 9005   028f   1bd4   00a3

Add PCI IDs for Delta controllers:
                                                  VID  / DID  / SVID / SDID
                                                  ----   ----   ----   ----
ThinkSystem 4450-8i SAS/SATA/NVMe PCIe Gen4       9005   028f   1d49   0222
24Gb HBA
ThinkSystem 4450-16i SAS/SATA/NVMe PCIe Gen4      9005   028f   1d49   0223
24Gb HBA
ThinkSystem 4450-8e SAS/SATA PCIe Gen4            9005   028f   1d49   0224
24Gb HBA
ThinkSystem RAID 4450-16e PCIe Gen4 24Gb          9005   028f   1d49   0225
Adapter HBA
ThinkSystem RAID 5450-16i PCIe Gen4 24Gb Adapter  9005   028f   1d49   0521
ThinkSystem RAID 9450-8i 4GB Flash PCIe Gen4      9005   028f   1d49   0624
24Gb Adapter
ThinkSystem RAID 9450-16i 4GB Flash PCIe Gen4     9005   028f   1d49   0625
24Gb Adapter
ThinkSystem RAID 9450-16i 4GB Flash PCIe Gen4     9005   028f   1d49   0626
24Gb Adapter
ThinkSystem RAID 9450-32i 8GB Flash PCIe Gen4     9005   028f   1d49   0627
24Gb Adapter
ThinkSystem RAID 9450-16e 4GB Flash PCIe Gen4     9005   028f   1d49   0628
24Gb Adapter

Add PCI ID for Cloudnine Controller:
                                                  VID  / DID  / SVID / SDID
                                                  ----   ----   ----   ----
                      SmartHBA P6600-24i          9005   028f   1f51   100b

Add PCI IDs for Hurraydata Controllers:
                                                  VID  / DID  / SVID / SDID
                                                  ----   ----   ----   ----
                      HRDT TrustHBA H4100-8i      9005   028f   207d   4044
                      HRDT TrustHBA H4100-8e      9005   028f   207d   4054
                      HRDT TrustHBA H4100-16i     9005   028f   207d   4084
                      HRDT TrustHBA H4100-16e     9005   028f   207d   4094
                      HRDT TrustRAID D3152s-8i    9005   028f   207d   4140
                      HRDT TrustRAID D3154s-8i    9005   028f   207d   4240

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: David Strahan <david.strahan@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Link: https://lore.kernel.org/r/20250423183229.538572-3-don.brace@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 84 +++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 8cc9f924a8ae6..c5a21e369e167 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -9708,6 +9708,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1bd4, 0x0089)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1bd4, 0x00a3)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1ff9, 0x00a1)
@@ -10044,6 +10048,30 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x14f0)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4044)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4054)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4084)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4094)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4140)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4240)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADVANTECH, 0x8312)
@@ -10260,6 +10288,14 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1cc4, 0x0201)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1018, 0x8238)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f3f, 0x0610)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_LENOVO, 0x0220)
@@ -10268,10 +10304,30 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_LENOVO, 0x0221)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0222)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0223)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0224)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0225)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_LENOVO, 0x0520)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0521)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_LENOVO, 0x0522)
@@ -10292,6 +10348,26 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_LENOVO, 0x0623)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0624)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0625)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0626)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0627)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_LENOVO, 0x0628)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 				0x1014, 0x0718)
@@ -10320,6 +10396,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1137, 0x0300)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1ded, 0x3301)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1ff9, 0x0045)
@@ -10468,6 +10548,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 				0x1f51, 0x100a)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1f51, 0x100b)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1f51, 0x100e)
-- 
2.39.5



