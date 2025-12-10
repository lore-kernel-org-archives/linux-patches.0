Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10ADF31353D;
	Wed, 10 Dec 2025 07:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352211; cv=none; b=NFF4XbL7BubBx2TGONDv76qlUFyM2AGKZyNdHlWFlvh3OnYOVvBGGMBKjPTXBrThhJOFzTorHTVotdowjZGXg2HNekJIvCwrHiyX3TJR/B368VkqmptobGN1RqNX2eN8bLERgNRQs6hyECYuC6VGKNNnbHODHv1rcxRrm32XefM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352211; c=relaxed/simple;
	bh=XfDn1plZ2RH2AKMRYNTGMZj67XSBqzI8reVF6gEJf9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEAX7lfIsLFfQZG+kbuK4WPtImD/RGt4c0S1n0HQv1z5QnMo2JwAnHW9vRPiEk4FagPr3lH4HCrBHXzI85Th3ygwePE03Y8shd5V7Jd2AIC8VTA/9CIYPalpNug+ptWZKHdLbx/7sZ9s9sEkRxR8a04hpXqWYh/9nsqZ/97hZV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YjF68Y+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YjF68Y+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B014EC4CEF1;
	Wed, 10 Dec 2025 07:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352210;
	bh=XfDn1plZ2RH2AKMRYNTGMZj67XSBqzI8reVF6gEJf9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YjF68Y+IOCCGZUIBpIztjFZQvZDHNIzxu8plGs+mTDBR5VGLLgvK0IFg3jymlG8GQ
	 qNXyEZyzIgFseOKnkqUuLBTs2DAhWsH6eleFc8odqfs8lvFlrPySYJoAtXMebis5lm
	 lvMCEd+tmqO6aVXQOFJbvYYm4u0DwkefcXPQZHyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Porcedda <fabio.porcedda@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 13/29] USB: serial: option: move Telit 0x10c7 composition in the right place
Date: Wed, 10 Dec 2025 16:30:23 +0900
Message-ID: <20251210072944.730330274@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
References: <20251210072944.363788552@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Porcedda <fabio.porcedda@gmail.com>

commit 072f2c49572547f4b0776fe2da6b8f61e4b34699 upstream.

Move Telit 0x10c7 composition right after 0x10c6 composition and
before 0x10c8 composition.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1445,6 +1445,9 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(4) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x10c6, 0xff),	/* Telit FE910C04 (MBIM) */
 	  .driver_info = NCTRL(4) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10c7, 0xff, 0xff, 0x30),	/* Telit FE910C04 (ECM) */
+	  .driver_info = NCTRL(4) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10c7, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x10c8, 0xff),	/* Telit FE910C04 (rmnet) */
 	  .driver_info = RSVD(0) | NCTRL(2) | RSVD(3) | RSVD(4) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x10c9, 0xff),	/* Telit FE910C04 (MBIM) */
@@ -1455,9 +1458,6 @@ static const struct usb_device_id option
 	  .driver_info = NCTRL(5) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d0, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d0, 0xff, 0xff, 0x60) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10c7, 0xff, 0xff, 0x30),	/* Telit FE910C04 (ECM) */
-	  .driver_info = NCTRL(4) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10c7, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d1, 0xff, 0xff, 0x30),	/* Telit FN990B (MBIM) */
 	  .driver_info = NCTRL(6) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(TELIT_VENDOR_ID, 0x10d1, 0xff, 0xff, 0x40) },


