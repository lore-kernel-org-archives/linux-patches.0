Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1BD1FC0F3;
	Tue,  8 Jul 2025 16:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993184; cv=none; b=axa6F0kY6WyLHSwTO/vk36x1fEqhazjCi6B+zpIuAaBUmujUKkvSSCgmDbm2ftFUFGkEbrvm66BckaYSHZWoAOY/xxHMUbHF316Yhi4rx8zG7MHJGjBJAKWXfmAIri4r4N72jBGxdPKaZMqDaZFxHg6ygrJTnszy75EQL/9dfu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993184; c=relaxed/simple;
	bh=miWteFMF38CQvnECIrTTEheltBoyF6a4M03/PD/++Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OVZn3oD5rK1tHVaTUo8X5TA4qJ65nlJG4+GXL9iMGMopHAA1ztwmiNtZ84bEJ5pxIUXtw9p3QjMrwylXflyZ6UlentzPgdrCT3a+jLUcVYihV9bCL/iMwfLKteS4c4hm1SLViQ66deTEfFM9ulL9Dg+GvfOBCaF0Y3bHipRRifA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kqzltk/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kqzltk/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3E2C4CEF5;
	Tue,  8 Jul 2025 16:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993184;
	bh=miWteFMF38CQvnECIrTTEheltBoyF6a4M03/PD/++Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kqzltk/QdEWXDdKN8rzkdHxSUIkLkWYwja0iF0xgwSkQAv8DUEAYzVY3HB3QQHKxU
	 Gd0MSlncNGN+DjlgG8BqEANnMf1vAbQ51GjR/35J7gEITsgnZa61w0rGgDxSjXikbD
	 EpD/iqU1BJcRa4vyALZfve9SiRQnVT6UZ8CWDtps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 216/232] Logitech C-270 even more broken
Date: Tue,  8 Jul 2025 18:23:32 +0200
Message-ID: <20250708162247.088676938@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


