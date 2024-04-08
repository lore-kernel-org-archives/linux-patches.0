Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C38364CF2;
	Mon,  8 Apr 2024 13:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581434; cv=none; b=XfoNZd2h0t0ZoeADHIk63E72Bvz/1hg9Vgc1Wn9UN1xFjwIxN4xfsJu/vwFHW5xS3zcTUAT73KYJQwHXek0gg16HOgvPMXGHY/1kyuxeFrzQnEpVj34ORzDtg/XlYsNRyLRFARHJW9xacRD10LpU0FkyVfUlc5vJtSMvPnXR6R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581434; c=relaxed/simple;
	bh=FShwbESrRW0uBhY/Y5AQ9wf1o8VKqH9B7Wj8f01oNU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WCwpDdFTreXUfdiyKYai+R0/p4WwGrqtdjX+gtJFxdCgNC/e0+Su2ILi36VxP6anngVMdkD9jgdRLxViC9VRfhFah+Ub2A6jzGpGtfEaJMBfRyAVVq9wTiydBQoPKGir9ZXawlIPqcm4oTKIxVX2Dm8wLt0UCXubKS096JEuFuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1YrI6Qrg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1YrI6Qrg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8ACFC433C7;
	Mon,  8 Apr 2024 13:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581434;
	bh=FShwbESrRW0uBhY/Y5AQ9wf1o8VKqH9B7Wj8f01oNU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1YrI6QrgQXmcVKUsnvTFzUG/KllMNo1fLgsf7oyNItuw0xAyPfUsnntGG6lGgXCj3
	 g+sRaggRqZa58HAJlAHSv5xrWBLlvnkqVw2jqh/KAdnyTN8FtnABJfpZEMj3iDbqPO
	 Rl5KYTR7I6swA0wXQjpGDAHBkmkTmbdzgpQsr5Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20H=C3=A4ggstr=C3=B6m?= <christian.haggstrom@orexplore.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/690] USB: serial: cp210x: add ID for MGP Instruments PDS100
Date: Mon,  8 Apr 2024 14:48:35 +0200
Message-ID: <20240408125401.300844631@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Häggström <christian.haggstrom@orexplore.com>

[ Upstream commit a0d9d868491a362d421521499d98308c8e3a0398 ]

The radiation meter has the text MGP Instruments PDS-100G or PDS-100GN
produced by Mirion Technologies. Tested by forcing the driver
association with

  echo 10c4 863c > /sys/bus/usb-serial/drivers/cp210x/new_id

and then setting the serial port in 115200 8N1 mode. The device
announces ID_USB_VENDOR_ENC=Silicon\x20Labs and ID_USB_MODEL_ENC=PDS100

Signed-off-by: Christian Häggström <christian.haggstrom@orexplore.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/cp210x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index bd72e9adc497a..ff814f9298db0 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -144,6 +144,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0x85EA) }, /* AC-Services IBUS-IF */
 	{ USB_DEVICE(0x10C4, 0x85EB) }, /* AC-Services CIS-IBUS */
 	{ USB_DEVICE(0x10C4, 0x85F8) }, /* Virtenio Preon32 */
+	{ USB_DEVICE(0x10C4, 0x863C) }, /* MGP Instruments PDS100 */
 	{ USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
 	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
 	{ USB_DEVICE(0x10C4, 0x87ED) }, /* IMST USB-Stick for Smart Meter */
-- 
2.43.0



