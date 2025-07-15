Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816302E62A6;
	Tue, 15 Jul 2025 13:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586531; cv=none; b=EKzc99qBMDbsnqMjAKEnoWSzrHPSMZF8ZJx3tJbIVOUPvWnwADpkLNLcCCgi0pfJO/2BPg1NMRb22w4zjvGuFEDeFCqE05L0h9En9iFGvLlb/IV08qcYPVOSg/oE1fdEDuhV8Q7tCuezxGfXg2hhtW5PPPpQlmHDNWbTMqCO+ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586531; c=relaxed/simple;
	bh=IFh3o7MLJjRtnIR/SVDe9O0FOkH1Yd0h1VY/1g3uNKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luU1vp7nb435jQkP4Jgiam+VgUtFLHBalZNhqi7GjGUbvVasHWmrPYfX/+JkJFFODRqNoplZGlKAkuqjW+Rt4l7p9k1PrdA9YYUpp7Wbw2XCKRxISIwRIBwqzKpcnuK2jthdVvo1kzodlf5S611+Fv0IE3zhP4mTBJ1KHjarJsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtgsSvkp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtgsSvkp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A35C4CEE3;
	Tue, 15 Jul 2025 13:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586531;
	bh=IFh3o7MLJjRtnIR/SVDe9O0FOkH1Yd0h1VY/1g3uNKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rtgsSvkpq3T8S1wW75CeC0HY7PxxeP81Mq4rC2I/FTJF8+T0CEjUofZfqRzsnMoNl
	 SskybwvieB1fj/8sqRXlPZoF5ou+Z8WvKWE3J2CTLjDm6tlyTDWlkfltGQWTZnWp4o
	 HfObMCiW8GFSvNtR7/SMMQsiYNeu8exz+97UPJWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.4 099/148] Logitech C-270 even more broken
Date: Tue, 15 Jul 2025 15:13:41 +0200
Message-ID: <20250715130804.279739033@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


