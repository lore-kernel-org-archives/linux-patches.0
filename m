Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5488BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D3BC433D2;
	Tue, 28 Mar 2023 14:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015105;
	bh=Xsolz83rCXsNcwOTYnTFqWA0Fsn4iBJ44RuNqsIKNGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RnxbHdd27QRQ7DNqaAWRYeRkSlzfYqlsg+ftRS60SWgGiDiud5ONUjRIDtmTbEtbK
	 qtQ3FDfdU3Mp9ZaoyDiIFFTDDa/QfWmhtY0iBBLOLP/0YUaFNzwdEPUtf8NKr1sZwi
	 BtI7mn21iqNO3qyeG4nIoMbuTvevuC2WihS9MhMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Szalecki?= <perexist7@gmail.com>,
	Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 136/240] HID: logitech-hidpp: Add support for Logitech MX Master 3S mouse
Date: Tue, 28 Mar 2023 16:41:39 +0200
Message-Id: <20230328142625.438226384@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafał Szalecki <perexist7@gmail.com>

[ Upstream commit db50f7a3983f0154e730f1147ef729e0c5c2f90c ]

Add signature for the Logitech MX Master 3S mouse over Bluetooth.

Signed-off-by: Rafał Szalecki <perexist7@gmail.com>
Reviewed-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 5efc591a02a03..3c00e6ac8e76a 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4378,6 +4378,8 @@ static const struct hid_device_id hidpp_devices[] = {
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb01e) },
 	{ /* MX Master 3 mouse over Bluetooth */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb023) },
+	{ /* MX Master 3S mouse over Bluetooth */
+	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH, 0xb034) },
 	{}
 };
 
-- 
2.39.2



