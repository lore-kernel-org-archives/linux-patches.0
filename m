Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2231129EC8;
	Mon, 18 Dec 2023 13:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDva4ewK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7754FC433C8;
	Mon, 18 Dec 2023 13:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907977;
	bh=u5x69zbIV5u0TxMxi6pOc0BkJkm6bvEZhAWdZ0YFGkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDva4ewKljI6TXRzGEPKPIdaBzwdbXIQxOyJ2CMOAudR6jXQ5hN8WePompEMa3bwH
	 HAbtqP53jRMVe8baEw5gaOldoN/j/nkgIaa40MlzZYDYGpD+Ne6pQ0qNkXdRbKhCrc
	 YSNBQKxV/iivFK0FYCW8ikaXlZfZMA19tHD9PLIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kelly Kane <kelly@hawknetworks.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/166] r8152: add vendor/device ID pair for ASUS USB-C2500
Date: Mon, 18 Dec 2023 14:49:27 +0100
Message-ID: <20231218135104.996315721@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Kelly Kane <kelly@hawknetworks.com>

[ Upstream commit 7037d95a047cd89b1f680eed253c6ab586bef1ed ]

The ASUS USB-C2500 is an RTL8156 based 2.5G Ethernet controller.

Add the vendor and product ID values to the driver. This makes Ethernet
work with the adapter.

Signed-off-by: Kelly Kane <kelly@hawknetworks.com>
Link: https://lore.kernel.org/r/20231203011712.6314-1-kelly@hawknetworks.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c   | 1 +
 include/linux/usb/r8152.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 7611c406fdb96..127b34dcc5b37 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -10016,6 +10016,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	{ USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff) },
 	{ USB_DEVICE(VENDOR_ID_TPLINK,  0x0601) },
 	{ USB_DEVICE(VENDOR_ID_DLINK,   0xb301) },
+	{ USB_DEVICE(VENDOR_ID_ASUS,    0x1976) },
 	{}
 };
 
diff --git a/include/linux/usb/r8152.h b/include/linux/usb/r8152.h
index 287e9d83fb8bc..33a4c146dc19c 100644
--- a/include/linux/usb/r8152.h
+++ b/include/linux/usb/r8152.h
@@ -30,6 +30,7 @@
 #define VENDOR_ID_NVIDIA		0x0955
 #define VENDOR_ID_TPLINK		0x2357
 #define VENDOR_ID_DLINK			0x2001
+#define VENDOR_ID_ASUS			0x0b05
 
 #if IS_REACHABLE(CONFIG_USB_RTL8152)
 extern u8 rtl8152_get_version(struct usb_interface *intf);
-- 
2.43.0



