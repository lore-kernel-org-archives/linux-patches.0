Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D331094A
	for <patches@lists.linux.dev>; Mon,  3 Jul 2023 18:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82847C433C9;
	Mon,  3 Jul 2023 18:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688410629;
	bh=oi764CHePWt7d2E9zKL0uxtd+fmH0tVvpeFTsgK01q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WNyfuCxEj+8N9MXTTFbXmZa2Pai4HF2/2nUzdVURgiIf/xnlneMYfWWT6uztlVfhV
	 NNTKm9gxR3+YufFLjW3lou83dttjfJqYU+m4kkdjZR3dmfC39T1jUbGCyY9y+EROzz
	 wTNnvZQnL8BJ12q/Gn81qysp+BdGPCWf9OdoeG3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Hommey <mh@glandium.org>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.15 11/15] HID: logitech-hidpp: add HIDPP_QUIRK_DELAYED_INIT for the T651.
Date: Mon,  3 Jul 2023 20:54:56 +0200
Message-ID: <20230703184519.200537588@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230703184518.896751186@linuxfoundation.org>
References: <20230703184518.896751186@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Hommey <mh@glandium.org>

commit 5fe251112646d8626818ea90f7af325bab243efa upstream.

commit 498ba2069035 ("HID: logitech-hidpp: Don't restart communication if
not necessary") put restarting communication behind that flag, and this
was apparently necessary on the T651, but the flag was not set for it.

Fixes: 498ba2069035 ("HID: logitech-hidpp: Don't restart communication if not necessary")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Hommey <mh@glandium.org>
Link: https://lore.kernel.org/r/20230617230957.6mx73th4blv7owqk@glandium.org
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-logitech-hidpp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4295,7 +4295,7 @@ static const struct hid_device_id hidpp_
 	{ /* wireless touchpad T651 */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH,
 		USB_DEVICE_ID_LOGITECH_T651),
-	  .driver_data = HIDPP_QUIRK_CLASS_WTP },
+	  .driver_data = HIDPP_QUIRK_CLASS_WTP | HIDPP_QUIRK_DELAYED_INIT },
 	{ /* Mouse Logitech Anywhere MX */
 	  LDJ_DEVICE(0x1017), .driver_data = HIDPP_QUIRK_HI_RES_SCROLL_1P0 },
 	{ /* Mouse Logitech Cube */


