Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C7234DB55;
	Tue,  6 Jan 2026 17:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720068; cv=none; b=EvCQQH8AV2CGtSahN1ehwRSj12MM1HhOS5GBs8nRxxNQrr799+ZnIlOJv8axv2wsPQr9MyB0vhBBWsSdIiGO5BnMDzmOLszSlRcM1o37c0U7tV1gwxgHI9duUFyQ2G7xqtsYbqnzMeySnfMq/v4NyOP1nQWI33Mve59NAWNQQ1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720068; c=relaxed/simple;
	bh=Xovx4kNs7ol7RdnIEb14KN1x8/yx+vzuQqPQzxtgYvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQkORfw6Ru6a9r5vkXEqGgIQ0wICAXm2dAXePkITCKhd39zeWdDFQ351IbfANaCBswQMfiIp+XCqjE5onZGKZKlQkww8O4o6vSmd/MK/hKls/Jp9iAv7w1oQofUzcF1HMSXjD91bZoMtqnh2q6k0wnkjahzoJ5BkDA9FUxVhg6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iu4FHoGB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iu4FHoGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55754C116C6;
	Tue,  6 Jan 2026 17:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720067;
	bh=Xovx4kNs7ol7RdnIEb14KN1x8/yx+vzuQqPQzxtgYvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iu4FHoGBakAa8EdLnYA58V9ekLXaBYB5TzlNrOdMvSCZERkOkKhikyzg4YdKvYFYB
	 y7OYqsdHGGIs5n739SuBm5+tT1A3GAXMQtXy5b+9ojT0jiFnG+mlASjKzUw4JiEScm
	 fSWs8xoY8gm09JE0s39arLkT0jRhKLwsZVgw6t9E=
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
Subject: [PATCH 6.12 124/567] scsi: smartpqi: Add support for Hurray Data new controller PCI device
Date: Tue,  6 Jan 2026 17:58:26 +0100
Message-ID: <20260106170455.918051464@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: David Strahan <David.Strahan@microchip.com>

[ Upstream commit 48e6b7e708029cea451e53a8c16fc8c16039ecdc ]

Add support for new Hurray Data controller.

All entries are in HEX.

Add PCI IDs for Hurray Data controllers:
                                         VID  / DID  / SVID / SDID
                                         ----   ----   ----   ----
                                         9005   028f   207d   4840

Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: David Strahan <David.Strahan@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Link: https://patch.msgid.link/20251106163823.786828-4-don.brace@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 018f5428a07d..f0fb22e4117e 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -10091,6 +10091,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       0x207d, 0x4240)
 	},
+	{
+		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
+			       0x207d, 0x4840)
+	},
 	{
 		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
 			       PCI_VENDOR_ID_ADVANTECH, 0x8312)
-- 
2.51.0



