Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A99513F007;
	Tue, 27 Feb 2024 13:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040545; cv=none; b=hkN00fYAj7zEan9/8uK3QwNGshVi/MDcTBln7brFtuUTL2giRSiL8MLB8TWjF4xY0te91rTm1TQr1rmvLFkjiGYW/cL4LAl/8AZ32F5NjLIudwZBVS1uWFKqmwJsvj8bVgK8lRiyV+znJbGJ/ZaHMO9u5fgUXA/wxpcn2qpiSbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040545; c=relaxed/simple;
	bh=MoXbq7yrlzSPOVDaBEU+XsXvBAZ4XmROSedlDvebIlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmUp5RtXRZBLoPtsUqmpaem7k93ePRFsytjSscWSaOgK3Rs5tJWpZmoMiov1uRQZk6pJp3+wEb19pgam9kDGeF8j+1tIaS3sCIau8yofrjRSqYmtrBuExFurtJxmGn2jrGsjmPOqvGw0GjBl4iI5Nx2dC9BCWRlLWwcOFTWqDhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qa5pbL84; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qa5pbL84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46414C433C7;
	Tue, 27 Feb 2024 13:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040544;
	bh=MoXbq7yrlzSPOVDaBEU+XsXvBAZ4XmROSedlDvebIlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qa5pbL84faIFNfxXgazFjkK5pYrMsqZQCvOC7ct/wz0KIG8oUI3eBC0VNd9LZaAZ7
	 eQcKGMD3si+7Wx8MtepMwEMkX1ecWI8Y63MJUXunEemk4aBbje/bRKxx6Eqcg+ITQ9
	 A3HGUEzcA2dz+oRkbU5lQeB0uCRsxrxsXFRw43DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murthy Bhat <Murthy.Bhat@microchip.com>,
	Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>,
	Scott Teel <scott.teel@microchip.com>,
	Scott Benesh <scott.benesh@microchip.com>,
	Mike McGowen <mike.mcgowen@microchip.com>,
	Kevin Barnett <kevin.barnett@microchip.com>,
	David Strahan <david.strahan@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 003/334] scsi: smartpqi: Add new controller PCI IDs
Date: Tue, 27 Feb 2024 14:17:41 +0100
Message-ID: <20240227131630.747685783@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Strahan <david.strahan@microchip.com>

[ Upstream commit c6d5aa44eaf6d119f9ceb3bfc7d22405ac04232a ]

All PCI ID entries in Hex.

Add PCI IDs for Cisco controllers:
                                                VID  / DID  / SVID / SDID
                                                ----   ----   ----   ----
        Cisco 24G TriMode M1 RAID 4GB FBWC 32D  9005 / 028f / 1137 / 02f8
        Cisco 24G TriMode M1 RAID 4GB FBWC 16D  9005 / 028f / 1137 / 02f9
        Cisco 24G TriMode M1 HBA 16D            9005 / 028f / 1137 / 02fa

Add PCI IDs for CloudNine controllers:
                                                VID  / DID  / SVID / SDID
                                                ----   ----   ----   ----
        SmartRAID P7604N-16i                    9005 / 028f / 1f51 / 100e
        SmartRAID P7604N-8i                     9005 / 028f / 1f51 / 100f
        SmartRAID P7504N-16i                    9005 / 028f / 1f51 / 1010
        SmartRAID P7504N-8i                     9005 / 028f / 1f51 / 1011
        SmartRAID P7504N-8i                     9005 / 028f / 1f51 / 1043
        SmartHBA  P6500-8i                      9005 / 028f / 1f51 / 1044
        SmartRAID P7504-8i                      9005 / 028f / 1f51 / 1045

Reviewed-by: Murthy Bhat <Murthy.Bhat@microchip.com>
Reviewed-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Signed-off-by: David Strahan <david.strahan@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Link: https://lore.kernel.org/r/20231219193653.277553-2-don.brace@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 40 +++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 9a58df9312fa7..d562011200877 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -10142,6 +10142,18 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 				0x1014, 0x0718)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1137, 0x02f8)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1137, 0x02f9)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1137, 0x02fa)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 				0x1e93, 0x1000)
@@ -10198,6 +10210,34 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 				0x1f51, 0x100a)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f51, 0x100e)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f51, 0x100f)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f51, 0x1010)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f51, 0x1011)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f51, 0x1043)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f51, 0x1044)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1f51, 0x1045)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_ANY_ID, PCI_ANY_ID)
-- 
2.43.0



