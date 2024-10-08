Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C901D540;
	Tue,  8 Oct 2024 12:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390092; cv=none; b=k+XmB07YbVJEA/0iFOjIclx2OSoc/O99XFzzNCZq2w2Am4esh6/cMY9PpMNo4ZAC12Rw1Zu3zNeeZS1evLeG+1y2ezfoOUcyawyB8cWWKxGZMYTcCW8JmfBlSzxCTqj7pTrDJsYHM5sKlrWRCNBOh38mLDGukevdAB/bAZ7xXJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390092; c=relaxed/simple;
	bh=yVbtUbt0pUjXlNTJnc+5ZGke2T43D9l9r2yxEocErGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1o0r7Glr9jkjq2sCNkPZw86mUPRyXd3sCxSsm6m5JXG0p01nCZmkZdZzNwZGVCuyzd7K+qpEswjxzJCKcSEw9txb5u9MJWP3UMZ2OltXFP4tuuLoMrybMdeuC4MRkCVb47O9MQMe6W0MSGNbOlC8rSNmko+y6llJo7yR1OayLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9Vc0KqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9Vc0KqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30379C4CEC7;
	Tue,  8 Oct 2024 12:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390092;
	bh=yVbtUbt0pUjXlNTJnc+5ZGke2T43D9l9r2yxEocErGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9Vc0KqWkOLwhIbCz1DV9c4trBMK656ghBdw35yJBOzqioz9TA2hsxWFekNuBXafO
	 6XTiNU6Xrm61SS3CZIGk5461gwPnrzq1kwcLegi2QNYVTeARVbtnO/EmP1fhor/s7Y
	 V/hcWBizPH5ye3Cq4ql9rgsKn0Cj7S+Ubh2X/WOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Benesh <scott.benesh@microchip.com>,
	Scott Teel <scott.teel@microchip.com>,
	Mike McGowen <mike.mcgowen@microchip.com>,
	David Strahan <David.Strahan@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 187/482] scsi: smartpqi: Add new controller PCI IDs
Date: Tue,  8 Oct 2024 14:04:10 +0200
Message-ID: <20241008115655.662317354@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Strahan <David.Strahan@microchip.com>

[ Upstream commit 0e21e73384d324f75ea16f3d622cfc433fa6209b ]

All PCI ID entries in hex.

Add new inagile PCI IDs:
                                             VID  / DID  / SVID / SDID
                                             ----   ----   ----   ----
            SMART-HBA 8242-24i               9005 / 028f / 1ff9 / 0045
            RAID 8236-16i                    9005 / 028f / 1ff9 / 0046
            RAID 8240-24i                    9005 / 028f / 1ff9 / 0047
            SMART-HBA 8238-16i               9005 / 028f / 1ff9 / 0048
            PM8222-SHBA                      9005 / 028f / 1ff9 / 004a
            RAID PM8204-2GB                  9005 / 028f / 1ff9 / 004b
            RAID PM8204-4GB                  9005 / 028f / 1ff9 / 004c
            PM8222-HBA                       9005 / 028f / 1ff9 / 004f
            MT0804M6R                        9005 / 028f / 1ff9 / 0051
            MT0801M6E                        9005 / 028f / 1ff9 / 0052
            MT0808M6R                        9005 / 028f / 1ff9 / 0053
            MT0800M6H                        9005 / 028f / 1ff9 / 0054
            RS0800M5H24i                     9005 / 028f / 1ff9 / 006b
            RS0800M5E8i                      9005 / 028f / 1ff9 / 006c
            RS0800M5H8i                      9005 / 028f / 1ff9 / 006d
            RS0804M5R16i                     9005 / 028f / 1ff9 / 006f
            RS0800M5E24i                     9005 / 028f / 1ff9 / 0070
            RS0800M5H16i                     9005 / 028f / 1ff9 / 0071
            RS0800M5E16i                     9005 / 028f / 1ff9 / 0072
            RT0800M7E                        9005 / 028f / 1ff9 / 0086
            RT0800M7H                        9005 / 028f / 1ff9 / 0087
            RT0804M7R                        9005 / 028f / 1ff9 / 0088
            RT0808M7R                        9005 / 028f / 1ff9 / 0089
            RT1608M6R16i                     9005 / 028f / 1ff9 / 00a1

Add new h3c pci_id:
                                             VID  / DID  / SVID / SDID
                                             ----   ----   ----   ----
            UN RAID P4408-Mr-2               9005 / 028f / 193d / 1110

Add new powerleader pci ids:
                                             VID  / DID  / SVID / SDID
                                             ----   ----   ----   ----
            PL SmartROC PM8204               9005 / 028f / 1f3a / 0104

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: David Strahan <David.Strahan@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Link: https://lore.kernel.org/r/20240711194704.982400-2-don.brace@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 104 ++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index c1524fb334eb5..02d16fddd3123 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -9456,6 +9456,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x110b)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x193d, 0x1110)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x8460)
@@ -9572,6 +9576,14 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1bd4, 0x0089)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x00a1)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f3a, 0x0104)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x19e5, 0xd227)
@@ -10164,6 +10176,98 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1137, 0x02fa)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0045)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0046)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0047)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0048)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x004a)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x004b)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x004c)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x004f)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0051)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0052)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0053)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0054)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x006b)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x006c)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x006d)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x006f)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0070)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0071)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0072)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0086)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0087)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0088)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x0089)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 				0x1e93, 0x1000)
-- 
2.43.0



