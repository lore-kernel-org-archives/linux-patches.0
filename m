Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACEB28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808A1C433D2;
	Mon, 30 Jan 2023 14:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087355;
	bh=fjOyhShajLp4a1JURcndRsx8j6lSHjidPur9uMLOJEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZUBiOGDQeB0zGk9KFkMtLigAvyqYs/8ykdRrO3ZXye6E04bATyjouAArlDS3C+OY
	 itdjFU1ZYU1aLlsavqCCSh+2VH+NbKRvNFXkFPefGxJhmotMozraXgrChZgoLPVn5v
	 21d1pdeHUg3XpFvusoipoU0cvcPpnEpg0Svlduy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 181/313] r8152: add vendor/device ID pair for Microsoft Devkit
Date: Mon, 30 Jan 2023 14:50:16 +0100
Message-Id: <20230130134345.121621502@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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
index a481a1d831e2..23da1d9dafd1 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9836,6 +9836,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07ab),
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07c6),
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927),
+	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0c5e),
 	REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f),
 	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3054),
-- 
2.39.0



