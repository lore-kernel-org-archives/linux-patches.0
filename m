Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BB15F54E;
	Tue, 13 Feb 2024 17:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845611; cv=none; b=ikTgRGFDkb/0c+SR8+PYboBJu5HyArbMWdAV55GxD5/KtcbIAyiP738R43OpwREqkR2wqCvynimOJo8PheFWTPBto8EK0CLO36SisY2D8PbCL26sMBwKGH+EoTGbj/iJYw8f8wXIPT0YjVk6rC3LHYsROVev3MEsDTheD1z7/lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845611; c=relaxed/simple;
	bh=X6mnyXjCH4iopVWBxJOqNcK24PrLcxb3aW4hWrpqm7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhmwRAuczNv2ud8Mv6uaDiyu4XNaUllWC011cvPY6TGW09oekqD65ZsF/oS09vX1h8oniv0K0nMjjOcszriNHNaWe5NzrRix/wzZb5JMl9ZibwvBjNs9jFjedX5Ywt5PVzrOIq5u7Lt5CteTi+3UclXfEuCjHJaXquEElnHmCKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KP0QkcQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KP0QkcQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4013C433F1;
	Tue, 13 Feb 2024 17:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845611;
	bh=X6mnyXjCH4iopVWBxJOqNcK24PrLcxb3aW4hWrpqm7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KP0QkcQgWJkZT9yXeFXsR0qHTZNAb2DgvjAWmzXNAHhhq9ozJo8cOt+1ubLA/0krY
	 dqB8pMTsu2tONQnNcnpxstPBQx2LIrBtcdnTsy/Z9vsfII/M2w6Ns5YP7h8Vf5SU8F
	 Rg2iaH9zHEV5aUMSujokgd0OiVD4aoAIBlBA9EEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonard Dallmayr <leonard.dallmayr@mailbox.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 104/121] USB: serial: cp210x: add ID for IMST iM871A-USB
Date: Tue, 13 Feb 2024 18:21:53 +0100
Message-ID: <20240213171856.027054908@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


