Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC52134A5
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 18:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D222DC433C8;
	Thu, 29 Jun 2023 18:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688064447;
	bh=zXC782oxtZOMhTfhgA8oJrTT74rTFF9F+enP7bDyRxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/jquRbDxHBTVoCDX3N29d4RyELzJOWrvdLGhXDTdu5/LyIGzvTwJC0B4TW9FGOg/
	 PS1NJCV/PEGR9WMFSPYZ0g5JscjRZn1to+YzgS1UFoeyL2iaG9Ysv7GZl9O2emkSCj
	 PgpN0viB3ELSIsqAieLngjMlCPwYOyOLSgLW5dOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Hommey <mh@glandium.org>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 6.3 28/29] HID: logitech-hidpp: add HIDPP_QUIRK_DELAYED_INIT for the T651.
Date: Thu, 29 Jun 2023 20:43:58 +0200
Message-ID: <20230629184152.842499216@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230629184151.705870770@linuxfoundation.org>
References: <20230629184151.705870770@linuxfoundation.org>
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
@@ -4364,7 +4364,7 @@ static const struct hid_device_id hidpp_
 	{ /* wireless touchpad T651 */
 	  HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LOGITECH,
 		USB_DEVICE_ID_LOGITECH_T651),
-	  .driver_data = HIDPP_QUIRK_CLASS_WTP },
+	  .driver_data = HIDPP_QUIRK_CLASS_WTP | HIDPP_QUIRK_DELAYED_INIT },
 	{ /* Mouse Logitech Anywhere MX */
 	  LDJ_DEVICE(0x1017), .driver_data = HIDPP_QUIRK_HI_RES_SCROLL_1P0 },
 	{ /* Mouse logitech M560 */


