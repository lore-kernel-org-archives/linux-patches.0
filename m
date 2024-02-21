Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C3E7D3EE;
	Wed, 21 Feb 2024 14:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524542; cv=none; b=e8dsOcL+Vrc2tzw87HFRSTKKoANbiUREBbRT2eyW/dNhlmzJPb5zE/BK9VCftPAtCL/Mo6p5rIBX5OgPyUXlobeRDJQbFxt/OPqC1STkGafdMATF4kcaguMOLW3G7vlDU81z7U0OB8h2oTVx3ig1Kz+UBiqJMUw8kCZsCJL3lIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524542; c=relaxed/simple;
	bh=ehFmc/qQy2LtbUW+zpIli2z++BY0P42g1TFuXbJ/UoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4GYKPvqfPn1FCpnHMKJG17Izp/G1plFLzC3rtH2Swqkk0sxCfDBS/+1c4oMjO/Td5iUx3UdsJcMy2MWfY1BzpW0M9C98YMaegLQrFcfcPFlmLALPGwY8xTDtSxp6Ai0FkZLhe+8yWZh+LRYgNabiHZnzlSNuhacSFzyrC2R5zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/jeUqk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/jeUqk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F076C433C7;
	Wed, 21 Feb 2024 14:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524541;
	bh=ehFmc/qQy2LtbUW+zpIli2z++BY0P42g1TFuXbJ/UoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/jeUqk4zrGgYMJK1QHGOEluDigCWTZ/mKlKCq3Ybv29D3OYu9E4D/jy5qtfKV7f/
	 2Le6df0wpwvSFISoMIFxsCGViUVcNLz6a6B+77t3pSfNmCwrC3v7FaKCDbjCKYjtCd
	 SfxuikEKVRk8FkzKPhiwy2TF9U33cEzINbJFvE7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leonard Dallmayr <leonard.dallmayr@mailbox.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 276/379] USB: serial: cp210x: add ID for IMST iM871A-USB
Date: Wed, 21 Feb 2024 14:07:35 +0100
Message-ID: <20240221130003.070182291@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -150,6 +150,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x85F8) }, /* Virtenio Preon32 */
 	{ USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
 	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
+	{ USB_DEVICE(0x10C4, 0x87ED) }, /* IMST USB-Stick for Smart Meter */
 	{ USB_DEVICE(0x10C4, 0x8856) },	/* CEL EM357 ZigBee USB Stick - LR */
 	{ USB_DEVICE(0x10C4, 0x8857) },	/* CEL EM357 ZigBee USB Stick */
 	{ USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB Device */


