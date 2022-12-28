Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B38C1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B361EC433D2;
	Wed, 28 Dec 2022 16:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245954;
	bh=c4PJoMBpiZ6Sy9yEgOccbk7gFera47jXs90Lp50O1Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELyWOvCVj+Jk6immd+KOwzXp2XGV9Q5Yop+4jox4Xb8hyDytdsaeG9SFWhiBLAsmG
	 WvaBUUiDLoJWuFZB0CmpFWJV8tTNCNFU64+REzY92Qdj4fp9mHUuqYcqhHNiu8U4PC
	 fGmBcZIN6TXnsIJgtA0elIDHsAU/8VLqdFGGQ64g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Benesh <scott.benesh@microchip.com>,
	Scott Teel <scott.teel@microchip.com>,
	Mike McGowen <mike.mcgowen@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0986/1073] scsi: smartpqi: Add new controller PCI IDs
Date: Wed, 28 Dec 2022 15:42:54 +0100
Message-Id: <20221228144354.878715210@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike McGowen <mike.mcgowen@microchip.com>

[ Upstream commit 0b93cf2a9097b1c3d75642ef878ba87f15f03043 ]

All PCI ID entries in Hex.
Add PCI IDs for ByteDance controllers:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
    ByteHBA JGH43024-8                      9005 / 028f / 1e93 / 1000
    ByteHBA JGH43034-8                      9005 / 028f / 1e93 / 1001
    ByteHBA JGH44014-8                      9005 / 028f / 1e93 / 1002

Add PCI IDs for new Inspur controllers:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
    INSPUR RT0800M7E                        9005 / 028f / 1bd4 / 0086
    INSPUR RT0800M7H                        9005 / 028f / 1bd4 / 0087
    INSPUR RT0804M7R                        9005 / 028f / 1bd4 / 0088
    INSPUR RT0808M7R                        9005 / 028f / 1bd4 / 0089

Add PCI IDs for new FAB A controllers:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
    Adaptec SmartRAID 3254-16e /e           9005 / 028f / 9005 / 1475
    Adaptec HBA 1200-16e                    9005 / 028f / 9005 / 14c3
    Adaptec HBA 1200-8e                     9005 / 028f / 9005 / 14c4

Add H3C controller PCI IDs:
                                            VID  / DID  / SVID / SDID
                                            ----   ----   ----   ----
    H3C H4508-Mf-8i                         9005 / 028f / 193d / 110b

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Link: https://lore.kernel.org/r/166793530327.322537.6056884426657539311.stgit@brunhilda
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 44 +++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 7a8c2c75acba..898b0054cfa1 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -9302,6 +9302,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x1109)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x193d, 0x110b)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x8460)
@@ -9402,6 +9406,22 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1bd4, 0x0072)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x0086)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x0087)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x0088)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1bd4, 0x0089)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x19e5, 0xd227)
@@ -9650,6 +9670,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x1474)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x1475)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x1480)
@@ -9706,6 +9730,14 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x14c2)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14c3)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       PCI_VENDOR_ID_ADAPTEC2, 0x14c4)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADAPTEC2, 0x14d0)
@@ -9942,6 +9974,18 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_LENOVO, 0x0623)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1e93, 0x1000)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1e93, 0x1001)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+				0x1e93, 0x1002)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_ANY_ID, PCI_ANY_ID)
-- 
2.35.1



