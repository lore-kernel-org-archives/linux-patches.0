Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B130E28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC07C433D2;
	Mon, 30 Jan 2023 14:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088092;
	bh=E0opZVpGMvHLTfupELEr0tewt30goMO+tLp5tw2iaxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=18ksk2HgqVSFUNud/kVjgOwmedoEhQ9XyRaR4VPki5GFJt2isFgo0LCeYfW4R3r0n
	 ZIur1m/cLfo80yRHTN4llBCJXYgO6r/UbL3Ms2slmUzvdwAkcRFXaWnfs4DxEwfAVn
	 H2GqrFE1oLqitehHeUIcwhFsNsL3cFM1z5+ufvRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/204] r8152: add vendor/device ID pair for Microsoft Devkit
Date: Mon, 30 Jan 2023 14:51:18 +0100
Message-Id: <20230130134321.426214511@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit be53771c87f4e322a9835d3faa9cd73a4ecdec5b ]

The Microsoft Devkit 2023 is a an ARM64 based machine featuring a
Realtek 8153 USB3.0-to-GBit Ethernet adapter. As in their other
machines, Microsoft uses a custom USB device ID.

Add the respective ID values to the driver. This makes Ethernet work on
the MS Devkit device. The chip has been visually confirmed to be a
RTL8153.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Link: https://lore.kernel.org/r/20230111133228.190801-1-andre.przywara@arm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 109c288d8b47..cf6941b1d280 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9809,6 +9809,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07ab),
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07c6),
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927),
+	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0c5e),
 	REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3054),
-- 
2.39.0



