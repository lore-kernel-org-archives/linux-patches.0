Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CC71CCB32;
	Tue,  8 Oct 2024 12:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391904; cv=none; b=JXqFQmIay+5zy4/BXkyjlCUI549WlihNOtC0eWLMbDH6RAmo/pR+o8y7WOxdr01JQwTKP5gZ/wrH3Yh9aILJjgx6+76o1zK3LmSMs5itYVxi30d33pdfV6jLNk3V8ltGRNbZLfmvVOZX7xaZvz7XV7q4ji1xUEOsb+wCuKPV2vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391904; c=relaxed/simple;
	bh=YF8lcqTHpjScbgJwen2/hKpgax5Nojs+DtVAT3E3eb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQtScDheQyXvoPzIDMIWDmMPi45X22X1BUthjpVlWuaphgB9B0kiuoYycgSvg2MfPDXoDY8I7WS7Q+2LQyFEv0VXwaIKl5wWazjCbrhpLEsSFNtfCCJOj6NI9kggLTQWTNXV6hAKOZ0tzTL9vKbOTmr61iuTS1XrRZp1EMZhrhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdKhzB+2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdKhzB+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0EAAC4CEC7;
	Tue,  8 Oct 2024 12:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391904;
	bh=YF8lcqTHpjScbgJwen2/hKpgax5Nojs+DtVAT3E3eb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdKhzB+2V0pvAD1BLmluQCAcxfe3f32OAJ65cbJRzxjWpnwZHE2q1wSaQXCHW5Mc9
	 vYC1lIA1kttQMAh7i/60bgBlaaWIfzUrTpT11pI2yLGjOb51hlfxkyqizvGZ2LQzi3
	 slogRnrMvkW7DiNO3pqj6EKixuyqk+XJe3MyQHk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Benesh <scott.benesh@microchip.com>,
	Mike McGowen <mike.mcgowen@microchip.com>,
	David Strahan <David.Strahan@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 240/558] scsi: smartpqi: add new controller PCI IDs
Date: Tue,  8 Oct 2024 14:04:30 +0200
Message-ID: <20241008115711.786982348@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Strahan <David.Strahan@microchip.com>

[ Upstream commit dbc39b84540f746cc814e69b21e53e6d3e12329a ]

All PCI ID entries in Hex.

Add new cisco pci ids:
                                             VID  / DID  / SVID / SDID
                                             ----   ----   ----   ----
                                             9005   028f   1137   02fe
                                             9005   028f   1137   02ff
                                             9005   028f   1137   0300

Add new h3c pci ids:
                                             VID  / DID  / SVID / SDID
                                             ----   ----   ----   ----
                                             9005   028f   193d   0462
                                             9005   028f   193d   8462

Add new ieit pci ids:
                                             VID  / DID  / SVID / SDID
                                             ----   ----   ----   ----
                                             9005   028f   1ff9   00a3

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: David Strahan <David.Strahan@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Link: https://lore.kernel.org/r/20240827185501.692804-5-don.brace@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index a4719af88718e..4230714e5f3a1 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -9428,6 +9428,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x152d, 0x8a37)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x193d, 0x0462)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x1104)
@@ -9468,6 +9472,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0x8461)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x193d, 0x8462)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x193d, 0xc460)
@@ -10176,6 +10184,18 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1137, 0x02fa)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1137, 0x02fe)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1137, 0x02ff)
+	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1137, 0x0300)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1ff9, 0x0045)
@@ -10352,6 +10372,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x1f51, 0x1045)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x1ff9, 0x00a3)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_ANY_ID, PCI_ANY_ID)
-- 
2.43.0



