Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5536D3AE5C
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3F2C433D2;
	Wed,  7 Jun 2023 20:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169784;
	bh=KV/i11XG/lWp64QQWcJy6Zm5eBpF2PRGxJS2tKrP694=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvAaJC3AroI0lKmq0GXeBCEs5CQ+l4jL3Ha6SPNLubc0vBYgrfJJp7mBnjsVvHThS
	 BTpcyhbh8i+Xao4ynciOLZMropYaPNmZaEQYz2yjJ6OOkDSqFMlJRi7cv0k3egAhN+
	 qajiDuqUFO0JHE0RqkKY6Uq4yEiFu8I1zng5eZxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sung-Chi Li <lschyi@chromium.org>,
	Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 6.3 195/286] HID: google: add jewel USB id
Date: Wed,  7 Jun 2023 22:14:54 +0200
Message-ID: <20230607200929.629883542@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sung-Chi Li <lschyi@chromium.org>

commit ed84c4517a5bc536e8572a01dfa11bc22a280d06 upstream.

Add 1 additional hammer-like device.

Signed-off-by: Sung-Chi Li <lschyi@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-google-hammer.c |    2 ++
 drivers/hid/hid-ids.h           |    1 +
 2 files changed, 3 insertions(+)

--- a/drivers/hid/hid-google-hammer.c
+++ b/drivers/hid/hid-google-hammer.c
@@ -587,6 +587,8 @@ static const struct hid_device_id hammer
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_GOOGLE, USB_DEVICE_ID_GOOGLE_HAMMER) },
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
+		     USB_VENDOR_ID_GOOGLE, USB_DEVICE_ID_GOOGLE_JEWEL) },
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_GOOGLE, USB_DEVICE_ID_GOOGLE_MAGNEMITE) },
 	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
 		     USB_VENDOR_ID_GOOGLE, USB_DEVICE_ID_GOOGLE_MASTERBALL) },
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -529,6 +529,7 @@
 #define USB_DEVICE_ID_GOOGLE_MOONBALL	0x5044
 #define USB_DEVICE_ID_GOOGLE_DON	0x5050
 #define USB_DEVICE_ID_GOOGLE_EEL	0x5057
+#define USB_DEVICE_ID_GOOGLE_JEWEL	0x5061
 
 #define USB_VENDOR_ID_GOTOP		0x08f2
 #define USB_DEVICE_ID_SUPER_Q2		0x007f


