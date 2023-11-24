Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03E135F04;
	Fri, 24 Nov 2023 19:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jIzmam/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5F1C433C7;
	Fri, 24 Nov 2023 19:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700853790;
	bh=QM3UBwLGT8IBoquK8L82sy/Cui3mf7SGRFELc9D2yYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jIzmam/xAdIBt7DZHEIFq2bUBoV/2tF/+Veviu6t5aGAa0UJ3nVxIFgJgpQssGXjY
	 d9lyPi4ak8WMEZQ/fAr+9bx+Qt41qPHsSE9//I7Tf3BLTlh+jKY7KhoPOPSzdargcM
	 SwdsjRlf5E+jyeNtiUtAQP6t6fGr4CpHMS93se4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Ayrapetyan <robert.ayrapetyan@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 031/159] HID: Add quirk for Dell Pro Wireless Keyboard and Mouse KM5221W
Date: Fri, 24 Nov 2023 17:54:08 +0000
Message-ID: <20231124171943.180047507@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171941.909624388@linuxfoundation.org>
References: <20231124171941.909624388@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

[ Upstream commit 62cc9c3cb3ec1bf31cc116146185ed97b450836a ]

This device needs ALWAYS_POLL quirk, otherwise it keeps reconnecting
indefinitely.

Reported-by: Robert Ayrapetyan <robert.ayrapetyan@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 64842926aff64..182068bf28c0a 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -350,6 +350,7 @@
 
 #define USB_VENDOR_ID_DELL				0x413c
 #define USB_DEVICE_ID_DELL_PIXART_USB_OPTICAL_MOUSE	0x301a
+#define USB_DEVICE_ID_DELL_PRO_WIRELESS_KM5221W		0x4503
 
 #define USB_VENDOR_ID_DELORME		0x1163
 #define USB_DEVICE_ID_DELORME_EARTHMATE	0x0100
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 83c3322fcf187..fae784df084d5 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -66,6 +66,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_STRAFE), HID_QUIRK_NO_INIT_REPORTS | HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CREATIVELABS, USB_DEVICE_ID_CREATIVE_SB_OMNI_SURROUND_51), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DELL, USB_DEVICE_ID_DELL_PIXART_USB_OPTICAL_MOUSE), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_DELL, USB_DEVICE_ID_DELL_PRO_WIRELESS_KM5221W), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DMI, USB_DEVICE_ID_DMI_ENC), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRACAL_RAPHNET, USB_DEVICE_ID_RAPHNET_2NES2SNES), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DRACAL_RAPHNET, USB_DEVICE_ID_RAPHNET_4NES4SNES), HID_QUIRK_MULTI_INPUT },
-- 
2.42.0



