Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195E64D5B7;
	Wed, 21 Feb 2024 13:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523182; cv=none; b=ECEELfmg6AVxoAUmveU9dypMW+qGoVCfM9dRd4xM9bfUz68buGqXdSXBQOE7YJUjBjCT9HhreB8G+z8b3zbO7VCl/5vZIaUBbJMo5HtUSm5jbY0IISO5Hf2L0lXZ+Y/zsv+9issb+frVK/CAsaPtshiGLJIbzWLrKHrum5WM4i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523182; c=relaxed/simple;
	bh=mLdSNEl69BGYLgW+7F4Z6ppWrh8jR+DTaLa5V8oiShA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2ORKColGiKcia0dU+6LXnyeVHevEDJ+PjRH36LZeY/QAVVJ72/q9/AQgke0nuwyRJk1C475njH4Xix+2BpKQQaC9w2ym7BlLCHtkws47Zj6PksBPKQGljC+ZsEKgMWXR/LMSiBcd7NSYY9+S8/4F4N2JO+aovhilVw7lgfyCLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uKQWd8p+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uKQWd8p+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940B4C433C7;
	Wed, 21 Feb 2024 13:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523182;
	bh=mLdSNEl69BGYLgW+7F4Z6ppWrh8jR+DTaLa5V8oiShA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKQWd8p+4a83u/9kBDU/OSVfTdBrtVgtkk9jMlAg0RHuaPnH6ONgR8vbDUboW4dda
	 zzX6NSrIcr3SVuStAHapry4CMJiZEKTljoqPPVoUHw0hAnme/vPZGCdrMgknZ2sIn9
	 VGiAFZy13udT01uNHirCMrY5HYBrVXDl6CdViK80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonard Dallmayr <leonard.dallmayr@mailbox.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 333/476] USB: serial: cp210x: add ID for IMST iM871A-USB
Date: Wed, 21 Feb 2024 14:06:24 +0100
Message-ID: <20240221130020.326237248@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Leonard Dallmayr <leonard.dallmayr@mailbox.org>

commit 12b17b4eb82a41977eb848048137b5908d52845c upstream.

The device IMST USB-Stick for Smart Meter is a rebranded IMST iM871A-USB
Wireless M-Bus USB-adapter. It is used to read wireless water, gas and
electricity meters.

Signed-off-by: Leonard Dallmayr <leonard.dallmayr@mailbox.org>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -146,6 +146,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x85F8) }, /* Virtenio Preon32 */
 	{ USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
 	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
+	{ USB_DEVICE(0x10C4, 0x87ED) }, /* IMST USB-Stick for Smart Meter */
 	{ USB_DEVICE(0x10C4, 0x8856) },	/* CEL EM357 ZigBee USB Stick - LR */
 	{ USB_DEVICE(0x10C4, 0x8857) },	/* CEL EM357 ZigBee USB Stick */
 	{ USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB Device */


