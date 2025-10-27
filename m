Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB0131D754;
	Mon, 27 Oct 2025 19:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592761; cv=none; b=WP2R2DlQHNE8PZUkHGtM1v9t1HkCK3z0+QlR8uuorYkIfHC4vLzwej0vPuW9Ow7rQjuIicvloj6QQVZLj0O9DO9kiYLKHuoFPqYvJPemggPtSvgy5BvTeu/lrxlkTJV0iNWljWTDmoqvry9AJ2bkzQA1XqEMFiH08M5IRvWV9hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592761; c=relaxed/simple;
	bh=dFXkp0jU8j/VGHfga0XTsG6OlJfLfNs67+iVvX3iXA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TB2Hpd7uX0Y0NDto+dNqJlPLVRk7HXsbxv05adu9pHRO8lgRo1a1qmKjPxQ6e9+JTe+ILHVWrNNZLLupbvHzER7nyFXtk96e+lpqhNk+CYtWaG5LEjc0KkYEjhnrem8vaTnid8U4Rxi6baLeL/twbdRFZc7LIaBvOh0eXNBln8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZB7TC4rz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZB7TC4rz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE8CC4CEF1;
	Mon, 27 Oct 2025 19:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592761;
	bh=dFXkp0jU8j/VGHfga0XTsG6OlJfLfNs67+iVvX3iXA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZB7TC4rzFuyONoJSu6lHNOsg6pfrm6ZugFiJOSS1KCAJTm/QTBYKZ5PTrn1jqluU2
	 IX3O4J1ipUkeT8mECeebxzREcuMVLVixtmF+mnK92gTso0tHlbFvw0XQdqYPEmKbMe
	 ZTa5iOuLSU4Xt3sbcQiZBRW/jHIJr8ZKHCvI3v58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tim Guttzeit <t.guttzeit@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>
Subject: [PATCH 6.6 62/84] usb/core/quirks: Add Huawei ME906S to wakeup quirk
Date: Mon, 27 Oct 2025 19:36:51 +0100
Message-ID: <20251027183440.469708381@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Guttzeit <t.guttzeit@tuxedocomputers.com>

commit dfc2cf4dcaa03601cd4ca0f7def88b2630fca6ab upstream.

The list of Huawei LTE modules needing the quirk fixing spurious wakeups
was missing the IDs of the Huawei ME906S module, therefore suspend did not
work.

Cc: stable <stable@kernel.org>
Signed-off-by: Tim Guttzeit <t.guttzeit@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20251020134304.35079-1-wse@tuxedocomputers.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -464,6 +464,8 @@ static const struct usb_device_id usb_qu
 	/* Huawei 4G LTE module */
 	{ USB_DEVICE(0x12d1, 0x15bb), .driver_info =
 			USB_QUIRK_DISCONNECT_SUSPEND },
+	{ USB_DEVICE(0x12d1, 0x15c1), .driver_info =
+			USB_QUIRK_DISCONNECT_SUSPEND },
 	{ USB_DEVICE(0x12d1, 0x15c3), .driver_info =
 			USB_QUIRK_DISCONNECT_SUSPEND },
 


