Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343C42E62C0;
	Tue,  8 Jul 2025 17:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994183; cv=none; b=P8FGXn+3Gs+2vonNEdqG5eQH9jR9cXFqPvx0gM9QBYAK7ff140PYziCG2Rc08lYRmWhsKYNVoB5ADYYyTGOPG0RGUpCKN56wQYC4q3Ex62jFyTwKKd2furlv7HVsnfP5rXg5w3BXaCxApq3PQFTJeOGKX8JxDE2waqojvETe46g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994183; c=relaxed/simple;
	bh=03rpeH1r0pLnOxHFwuKS3Xwk5IhYX4NfHxriQacZsvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrLdjA1HEhtJ6TMN7Po9CauJ4dxaemXzo50JjDUSPLo/jcqD3tYLpYqnk8h9X+spE02Ah5A1ZBnvsgfsppCeXqKysg1bqSe6wIddIue0cKLIe0AMjhF4x5/Q/aT89v+ADzORpRluD+vxKEsZr9gQsh2hsLNjdgWbFzKGxG+OhVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mNPmrHM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mNPmrHM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7DE5C4CEF0;
	Tue,  8 Jul 2025 17:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751994183;
	bh=03rpeH1r0pLnOxHFwuKS3Xwk5IhYX4NfHxriQacZsvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mNPmrHM5C6ul2BG5GpdrquDlHn6SczIv5uE/I4fapntsiWWiuzMLsUS9LbdlZ6R1Z
	 H0ah6AXeLAVLckW5BRI8aZIXHsec5MqAKnCgD2qYxaNQtcQStiDRqkBXgYVAqDzQB5
	 KoCFRWFbGmoZkGbY3UECSTuMyyrFFFqhMx50WmWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 153/160] Logitech C-270 even more broken
Date: Tue,  8 Jul 2025 18:23:10 +0200
Message-ID: <20250708162235.549849610@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -224,7 +224,8 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x046a, 0x0023), .driver_info = USB_QUIRK_RESET_RESUME },
 
 	/* Logitech HD Webcam C270 */
-	{ USB_DEVICE(0x046d, 0x0825), .driver_info = USB_QUIRK_RESET_RESUME },
+	{ USB_DEVICE(0x046d, 0x0825), .driver_info = USB_QUIRK_RESET_RESUME |
+		USB_QUIRK_NO_LPM},
 
 	/* Logitech HD Pro Webcams C920, C920-C, C922, C925e and C930e */
 	{ USB_DEVICE(0x046d, 0x082d), .driver_info = USB_QUIRK_DELAY_INIT },


