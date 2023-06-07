Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFE737325
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4447CC433D2;
	Wed,  7 Jun 2023 20:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171002;
	bh=Fqk496yh8sAslyHz/5ECcrJnXjk9CsWnKkJs1TIszNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwNhD5LnhTcon91YABAOQCRW7onfe7b+K1rISIadlRjAPde98DSiVylz7hJdXqPfq
	 NH5iZB1lWd/auuAv9N2KoaSJcROpOdxtpWwJy+3D8faeJ2A3mNXiqckTpBBdkjqcv0
	 VlDH6sYQw3L5BiBST9+5GvC1MuSmHNx7k6ph783k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sung-Chi Li <lschyi@chromium.org>,
	Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.10 074/120] HID: google: add jewel USB id
Date: Wed,  7 Jun 2023 22:16:30 +0200
Message-ID: <20230607200903.209639810@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.915613242@linuxfoundation.org>
References: <20230607200900.915613242@linuxfoundation.org>
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
@@ -533,6 +533,8 @@ static const struct hid_device_id hammer
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
@@ -491,6 +491,7 @@
 #define USB_DEVICE_ID_GOOGLE_MOONBALL	0x5044
 #define USB_DEVICE_ID_GOOGLE_DON	0x5050
 #define USB_DEVICE_ID_GOOGLE_EEL	0x5057
+#define USB_DEVICE_ID_GOOGLE_JEWEL	0x5061
 
 #define USB_VENDOR_ID_GOTOP		0x08f2
 #define USB_DEVICE_ID_SUPER_Q2		0x007f


