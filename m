Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEC62E3AE8;
	Tue,  8 Jul 2025 16:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992520; cv=none; b=iz0d0l4wDz5/5TJapUKUN91tICo1cVRYF6EYURMBvuENJP8W/ZDP2wo18N/wSiq60bVVdGI5IAex3/D4Y6nqosd6qVwADgx5ljUF2uKJgRorO2iHvJtHsnYvfgLXmYe+fVeQwc4DBt5Wp8RX5nw+HeNFnG6wgzoHMCzT88ZJlXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992520; c=relaxed/simple;
	bh=ZmbTdH7OONgbwFuK/3skgNcX9v/9FXXJmhCBLE51AKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQjUku1B5ZOhOFLSP0VSbHxU3XksIctGTwQ57nDJw0SD9WJkQiyXLH5utZChAzE015fmdfz01yM6X0Bsss0Da3q7NevVu1n+hOSPl8mqHizhkr9IMPzhDHlPlfb8a3j2QQaFPPkiFfe3W/nIQUXUJzD0ObXi9USzUje3zJsYLlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dIWfCXOI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dIWfCXOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FC4C4CEED;
	Tue,  8 Jul 2025 16:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992520;
	bh=ZmbTdH7OONgbwFuK/3skgNcX9v/9FXXJmhCBLE51AKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dIWfCXOIE8QnLoVlGYO6ZonrpULEX2WH6SQeru4hOUazGg3+LdSaVDfhLBamWHgxp
	 E6qlfZSPf0aywSxJPHsMFfJ4wbi48yC5bTSpeZhYRIRF1CK6Z4Hjj/04SNyYMAvS2G
	 I9pxVPuk6ZlzFEJIYplDNuJpw5l6s4je/jebUCTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 120/132] Logitech C-270 even more broken
Date: Tue,  8 Jul 2025 18:23:51 +0200
Message-ID: <20250708162234.056085230@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Oliver Neukum <oneukum@suse.com>

commit cee4392a57e14a799fbdee193bc4c0de65b29521 upstream.

Some varieties of this device don't work with
RESET_RESUME alone.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20250605122852.1440382-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -227,7 +227,8 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x046a, 0x0023), .driver_info = USB_QUIRK_RESET_RESUME },
 
 	/* Logitech HD Webcam C270 */
-	{ USB_DEVICE(0x046d, 0x0825), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x046d, 0x0825), .driver_info = USB_QUIRK_RESET_RESUME |
+		USB_QUIRK_NO_LPM},
 
 	/* Logitech HD Pro Webcams C920, C920-C, C922, C925e and C930e */
 	{ USB_DEVICE(0x046d, 0x082d), .driver_info = USB_QUIRK_DELAY_INIT },


