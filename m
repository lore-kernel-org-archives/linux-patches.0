Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB9C3B8120;
	Tue, 21 Jul 2026 22:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673265; cv=none; b=m6/s8zv0NznqPcSJMzyn1xvG30EholQBzEgp9mEufP5TgQFRIAgBR6O8+EYazABP3j3pSeXCf+A9ivJcyp/7bU7m1aQrJvIEhiSM23PKN/hY0YMWtLiFMGBiogNfFB3MP0sXGjE4BbB6kwlsbaBq4lh2TR8Att+rSfGAJcHB+7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673265; c=relaxed/simple;
	bh=UYuUOv3xj3hm8YLG8jIDRDqk/ipu9NJLb3leU3qh884=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YJYl+o9/WLoQ8Yugay2uqTcD6H9I4yoa+qiZ7qN7nZJaEqDzMwe7BwcsWl86WNhoOl9S7+9yucxIM4aTlpZKmPpH7TfFK58CqRN56IkV0VWl195GnrDw/W8Bv1ORcrpBc66uq+qToDFZ2UNoHQecYHSkXpT5alU1/wBNROn+S1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JnSqvvuQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnSqvvuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD52E1F000E9;
	Tue, 21 Jul 2026 22:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673264;
	bh=c0uZBbC7gdiXJhHKHWFsuNUWn38/fGDuH+wDjoMk5GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JnSqvvuQTQ3nHaryhFkPcxQavZHiN1VP6upULu2knSHnj98iJ2USbZrATQWEYhBtz
	 X5nbCEwPRbILC2QxXdlJkit4wNN5Pt3YZRSUPUDOvDhtwhlBwygsG2R2CwWuHo6jH4
	 4cA+lyfRSZbM2b3ZRQHQiuSWXsumcGZErD+lPMwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rodrigo=20Lugathe=20da=20Concei=C3=A7=C3=A3o=20Alves?= <lugathe2@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 098/699] USB: core: add USB_QUIRK_NO_LPM for VIA Labs USB 2.0 hub
Date: Tue, 21 Jul 2026 17:17:37 +0200
Message-ID: <20260721152357.911540425@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Lugathe da Conceição Alves <lugathe2@gmail.com>

commit bd728c3d9b1cc0bb0fda6a7055c5c8b55d7477b2 upstream.

The VIA Labs, Inc. USB 2.0 hub controller (2109:2817),
found in a KVM switch, fails to enumerate high-power devices during
cold boot and system restart.

Applying the kernel parameter
  usbcore.quirks=2109:2817:k
resolves the issue.

Enumeration failure log:
  usb 1-1.2.3: device descriptor read/64, error -32
  usb 1-1.2.3: Device not responding to setup address.
  usb 1-1.2.3: device not accepting address 11, error -71
  usb 1-1.2-port3: unable to enumerate USB device

Add USB_QUIRK_NO_LPM for this device.

Signed-off-by: Rodrigo Lugathe da Conceição Alves <lugathe2@gmail.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260603113626.395612-1-lugathe2@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -561,6 +561,9 @@ static const struct usb_device_id usb_qu
 	/* VLI disk */
 	{ USB_DEVICE(0x2109, 0x0711), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* VIA Labs, Inc. USB2.0 Hub */
+	{ USB_DEVICE(0x2109, 0x2817), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Raydium Touchscreen */
 	{ USB_DEVICE(0x2386, 0x3114), .driver_info = USB_QUIRK_NO_LPM },
 


