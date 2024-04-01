Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD4F4653C;
	Mon,  1 Apr 2024 15:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986773; cv=none; b=p2v038cHzWnw1/CBeuCSRwwkp1v7ej/doE0bsskIFbG1gaxT+E/8B/q04jsncGBf9i0LyynOT3MDFIftpeEteAmOxofIDRdJgQAguTKeINxv14dd/wyvkivWuqH68Ht1L21gN3M9SjpwTcsW0JINLVXSyMVPfUglx8+ntSsyX14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986773; c=relaxed/simple;
	bh=+V36KjNOqXtVv4BXHPa4CvlZG3dxzYemJZa8YMxp8BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pn7BrOlwAabCkBwfxrLW6EbwpDQ9bhj4nHOms9W5CAemZyALcsL8brTqeEF4kVj+F2Q94BzMQsMicm9BoqlPAy0qNqJYh/yOo9Ukgjp3P7m4u8/O1HfdqzUF3v2TcLbK1Zm5oLNyShpUuSZuGTlK/2tqZJQgthH+Wya9zny+ZL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ms1NOWIi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ms1NOWIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC240C433C7;
	Mon,  1 Apr 2024 15:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986773;
	bh=+V36KjNOqXtVv4BXHPa4CvlZG3dxzYemJZa8YMxp8BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ms1NOWIif35q1/5NdR1SVOeiq6d7/iyHnjkDNpktoBJNfQA1z9mmfrn/w0BvDaP8P
	 29Z/oFYYqbvObcUuuyfTkJluUbn33D2ha5aPevLbFWsYS3c6OUxU802aai9fZHlKyV
	 pwHtI7VjkF/hEwn6UkAG2FNzoQ6p/m0syUzgiTK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20H=C3=A4ggstr=C3=B6m?= <christian.haggstrom@orexplore.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 081/399] USB: serial: cp210x: add ID for MGP Instruments PDS100
Date: Mon,  1 Apr 2024 17:40:47 +0200
Message-ID: <20240401152551.598735448@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index d339d81f6e8cf..2169b6549a260 100644
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



