Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263E113DDDD;
	Thu, 11 Apr 2024 09:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829587; cv=none; b=m2W3RKRFqpXDo0V8RNpzBVQOADd0TGPw/ynULTH4UjLMxc6wleYAXcnHNe677HhjHrzetlmrrOlGZgDORFvoj2NbU/+LbQmZXFo22JH5zUKPZc/cXj46zF6RiUCo+UKu33Rba8fAxq8nFnT6cV9u6GRksogwya+alTysgxnPz2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829587; c=relaxed/simple;
	bh=Y/10cUnVgY6J/8XO2BgxyMSl+ZVP/UW4+IjcjlwFowk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMOWbR6BDlc5513YwjboflakPAH8Di3Usi1kSx64Hunu9/OgB7IIFzaRUu65gZTKw1V10wWLC8tqA6uw/Ty/Cb1vXjRIX/xJDQL16+Kx2QjXfdvQQoYrL/rCr6QiQYQQ+szlrMN3IjLIFwBpkKtrEgnbBiPgJsT65oL5P/n0XRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phSJPnQb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phSJPnQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B8FC433F1;
	Thu, 11 Apr 2024 09:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829587;
	bh=Y/10cUnVgY6J/8XO2BgxyMSl+ZVP/UW4+IjcjlwFowk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=phSJPnQbMlzq4N3p6z4bat6h17zkG88zxLm7yiUCQjh0X1RUU/SMy5IcqWXOB0tKz
	 7Vzu+lqXR6pt/bAQBjitZr5UTkXmWTAbOjtBp0jKY7ZkrvwagvAFpoeg1VIzWWoTXx
	 BJo1XHzUN98E4/s3C1XeN0IjI6ZMYN19pmDivHug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cameron Williams <cang1@live.co.uk>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 036/175] USB: serial: add device ID for VeriFone adapter
Date: Thu, 11 Apr 2024 11:54:19 +0200
Message-ID: <20240411095420.645697223@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cameron Williams <cang1@live.co.uk>

[ Upstream commit cda704809797a8a86284f9df3eef5e62ec8a3175 ]

Add device ID for a (probably fake) CP2102 UART device.

lsusb -v output:

Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.10
  bDeviceClass            0 [unknown]
  bDeviceSubClass         0 [unknown]
  bDeviceProtocol         0
  bMaxPacketSize0        64
  idVendor           0x11ca VeriFone Inc
  idProduct          0x0212 Verifone USB to Printer
  bcdDevice            1.00
  iManufacturer           1 Silicon Labs
  iProduct                2 Verifone USB to Printer
  iSerial                 3 0001
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x0020
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass      0 [unknown]
      bInterfaceProtocol      0
      iInterface              2 Verifone USB to Printer
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
Device Status:     0x0000
  (Bus Powered)

Signed-off-by: Cameron Williams <cang1@live.co.uk>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/cp210x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index b58ca66dc3aed..9901fd79b8a21 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -178,6 +178,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x10C4, 0xF004) }, /* Elan Digital Systems USBcount50 */
 	{ USB_DEVICE(0x10C5, 0xEA61) }, /* Silicon Labs MobiData GPRS USB Modem */
 	{ USB_DEVICE(0x10CE, 0xEA6A) }, /* Silicon Labs MobiData GPRS USB Modem 100EU */
+	{ USB_DEVICE(0x11CA, 0x0212) }, /* Verifone USB to Printer (UART, CP2102) */
 	{ USB_DEVICE(0x12B8, 0xEC60) }, /* Link G4 ECU */
 	{ USB_DEVICE(0x12B8, 0xEC62) }, /* Link G4+ ECU */
 	{ USB_DEVICE(0x13AD, 0x9999) }, /* Baltech card reader */
-- 
2.43.0



