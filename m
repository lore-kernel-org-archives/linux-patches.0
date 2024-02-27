Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A5313AA2F;
	Tue, 27 Feb 2024 13:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041677; cv=none; b=h+QRFxRqT+oZnoRUoP7Pet36rNanFZ3+/SrLwM2k6qnv/F5/rmF5XTTvOAhAwy3grrvckzSSt66nhrxvd3ok4jajAV1l7Av+SXlgt6eNSiswHLcj49mDt2iMuDpTUzAyQ9bS679QsADRUe4CGrT9+YKQP2PWmo9uEOMN8Iw1Vzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041677; c=relaxed/simple;
	bh=IpTWH0BG3FrZqeU5DXHBTXO0ZRnHDOq/vOiFJU6t5Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExnBSUCI05o42xbjZEJOGjzx5i/dy/IdudCtYxG4Nq7dEkxZ3x0HaPjeUogSNlsNfW3WwUvZvgy1d6wXV/bNOwfhEwr+CanXih4p/yZ45DwhEzC+WXXplb3876o/O0trGgY+GqLjWhha8Isix2BUp22/1IvwecJSL3Gq3hfAud4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JTfaZ468; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JTfaZ468"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47177C433C7;
	Tue, 27 Feb 2024 13:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041676;
	bh=IpTWH0BG3FrZqeU5DXHBTXO0ZRnHDOq/vOiFJU6t5Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JTfaZ468N4wRvEhDd4f4+HvpNBTxUNVpdCiP4O7rs0FNgbEYLtNm2lSzWum5LylI9
	 AhERx5Op/h0L5rFYTtyseMITdL95PkBI/dQNDcVk6HEyWeKRDNacOZ2flsXPq0PCCe
	 45RCHy4B5GBcDnljgf2JeTmvDNtjIET/kRl6kPRY=
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
Subject: [PATCH 6.6 005/299] scsi: smartpqi: Add new controller PCI IDs
Date: Tue, 27 Feb 2024 14:21:56 +0100
Message-ID: <20240227131626.019505645@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



