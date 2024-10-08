Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539971DF96D;
	Tue,  8 Oct 2024 12:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390130; cv=none; b=fpaF8mGSjTjr9TNUb8HO1owPK1Ix0gzRtytb9znUNueAt0cYA52bQndHlFgnEvhksebSsaTx8FptjStTpBxeRB34PizFBBkO98BjLlKaYxjT4YzXFBhHpDxAqJx6PEYiGg298bgmv1OXWulhHW19JKUFGe2Ur9p+fdZ5fCRT8uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390130; c=relaxed/simple;
	bh=Rb/ih7nhqD5yvhCEXUWFS4iyzETwC3HM5TG2tarYho4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5OL/GSVLksrFhFHyR23yC3TEBJZH63TsZ6nMbQkqay5AC5JfXW3LmCf3aGF7ZASPZyEKwaF1FeTYDaKJh8GNa72gCtbMANbfHwm5H+huuTpzNzpiKsZpJDFQSeVdjgfrg8lGkpG2CCSW2gG4Gj+yoo1JxYrkAvDpHKkIaYO1xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbP1jvfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbP1jvfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4D7C4CECC;
	Tue,  8 Oct 2024 12:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390130;
	bh=Rb/ih7nhqD5yvhCEXUWFS4iyzETwC3HM5TG2tarYho4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbP1jvfCbrPtHYIZFlhv8RQedNW4NtVnPvGDW7hTtm3GbSWW5QDPK/eYgCw4ohqTI
	 Gurw6H8U4xsDA0a1gUhG6Fnxi1YeayknSEL5UcAEGEqJWDxidc1a8xET1phdDhuwAi
	 854JzkNVlDMeb2Fxtbn57ckwehFu/657mbM80mAg=
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
Subject: [PATCH 6.10 200/482] scsi: smartpqi: add new controller PCI IDs
Date: Tue,  8 Oct 2024 14:04:23 +0200
Message-ID: <20241008115656.179737595@linuxfoundation.org>
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



