Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE185F54E;
	Tue, 13 Feb 2024 17:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845112; cv=none; b=uOIRULqa2ayyBxvo58lyHIifckxheVxF+OotMDHtO4o1ocx+uzGuPFmdkudG6tJuCNGjPLb8Ogz1HCpiEA9wHlT4HOQgYux63kqvEAkyde4SMXafhA7JYVupztRJZhGaWx1xSQsvOTIrxqS/8V2TLXJBPwXq8RRGLJc1KBxCeF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845112; c=relaxed/simple;
	bh=v+PeOSj61LuTbLTDI1pQIFhvuEEsGbzjLtSuGlh9pXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3EXNtHrclLDbWf94dEA3pwjRojZyXHP/AVAzODE1MY1T+wz9RndNXqg5LE9Ie3aL9kiv1hi5YTeQCuKKBSseTXu/uH0yFk4+VeQG5PyQ5DlMBFJzRfYgUF0HjMhQbJrakvVgUMQ4CFHAXq8BwvVuAL2qFtSnTa7U5+6TAFA1rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XBq9gFwv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XBq9gFwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C35C433C7;
	Tue, 13 Feb 2024 17:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845111;
	bh=v+PeOSj61LuTbLTDI1pQIFhvuEEsGbzjLtSuGlh9pXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XBq9gFwvwqmBdYiOB37aDAv8mWKtJWUWGjcQj7w/yrTObeqUxwzZN8XVxYt/AbQm1
	 bcpfLwbLp3XvAp4ZRcXlqku1CyEBzzS5+CsdU1FwKeZ1vtgHiF2gLJb8QINBsEMt/e
	 PxVqw9cT3J9/cjST2Y6B3JsVCry95kfvuyWGbvSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonard Dallmayr <leonard.dallmayr@mailbox.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 50/64] USB: serial: cp210x: add ID for IMST iM871A-USB
Date: Tue, 13 Feb 2024 18:21:36 +0100
Message-ID: <20240213171846.315042146@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


