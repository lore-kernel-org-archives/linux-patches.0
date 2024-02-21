Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803E04C62;
	Wed, 21 Feb 2024 14:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525666; cv=none; b=mG0BUQzie7hX1YuewYGwv6iTAYz4lTrtAenBWeDDAotebobDzMbx+z66sLPCgep2ucO4Ky4Ze6BP7wK5yzaQ+ZRx2T8m9Um4AHv7HYzcasd9myCCvbC1jwnJz7sI2bX8EExmeVLgSy3lZ6Mjj8nMXaMYeqbVhMqAp3ZlrIGwBu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525666; c=relaxed/simple;
	bh=RKtQHe4uuops0aZnbJZcJ4YXfYAMpUC818f84Ud8WYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmr5FEaRovqxqkoNZ+7eLg8BGsY4louYUhNRfWjFMnqBwIH8Qm2gM6KlOR+9jBS63xMgEJAxINAKbuEiIaTI2MUogKsuBEOlqPscwGVcoLgCnfilX4WLZx1YGa9HI/3Ev+IQa4A8oOpKhHc0bhyupPBuHmpSg3LjinXTtEPPsqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWRf8Stv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWRf8Stv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2E9C433C7;
	Wed, 21 Feb 2024 14:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525666;
	bh=RKtQHe4uuops0aZnbJZcJ4YXfYAMpUC818f84Ud8WYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWRf8Stv/C4qOo3SC1IaBeowghbSkx5Xl1zMAoLlwn4NLAKJ/hRYH918pxIathU7v
	 TaV3fGtHWHN4uiAeY30QGCCUBVStpge3nw1As+BROVDj6SccR685OiFvyw2E2gZZXt
	 n0Z9M3OGD7/l3J/h9gCRGzaJG6CuxgGdL3Uy/9aI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonard Dallmayr <leonard.dallmayr@mailbox.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 197/267] USB: serial: cp210x: add ID for IMST iM871A-USB
Date: Wed, 21 Feb 2024 14:08:58 +0100
Message-ID: <20240221125946.335579141@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -147,6 +147,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x85F8) }, /* Virtenio Preon32 */
 	{ USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
 	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
+	{ USB_DEVICE(0x10C4, 0x87ED) }, /* IMST USB-Stick for Smart Meter */
 	{ USB_DEVICE(0x10C4, 0x8856) },	/* CEL EM357 ZigBee USB Stick - LR */
 	{ USB_DEVICE(0x10C4, 0x8857) },	/* CEL EM357 ZigBee USB Stick */
 	{ USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB Device */


