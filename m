Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F8F2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4947AC433EF;
	Sun, 22 Jan 2023 15:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400403;
	bh=GvcJkUCVzsApAy+NAUxylUDIkoHP5i43pkfkZ5bO/Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9uXgR8TKWMQYKfviVPW0nI2aunia9HN7EBPYtJOEC9RNHKEeR9I7L3ISbiDJA4zH
	 cMGjctQXuDev0kmcHCcfZOLx9hUNUncp9C/W4XlUNN+JGGsxzhn5YUAR7i4Ijtm3Kc
	 b56ORdDlsQj1Hyn/krNHaHo+FnspF0JinlpZRvcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Adler <michael.adler@siemens.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 62/98] USB: serial: cp210x: add SCALANCE LPE-9000 device id
Date: Sun, 22 Jan 2023 16:04:18 +0100
Message-Id: <20230122150232.086755570@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Adler <michael.adler@siemens.com>

commit 3f9e76e31704a325170e5aec2243c8d084d74854 upstream.

Add the USB serial console device ID for Siemens SCALANCE LPE-9000
which have a USB port for their serial console.

Signed-off-by: Michael Adler <michael.adler@siemens.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -64,6 +64,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x0846, 0x1100) }, /* NetGear Managed Switch M4100 series, M5300 series, M7100 series */
 	{ USB_DEVICE(0x08e6, 0x5501) }, /* Gemalto Prox-PU/CU contactless smartcard reader */
 	{ USB_DEVICE(0x08FD, 0x000A) }, /* Digianswer A/S , ZigBee/802.15.4 MAC Device */
+	{ USB_DEVICE(0x0908, 0x0070) }, /* Siemens SCALANCE LPE-9000 USB Serial Console */
 	{ USB_DEVICE(0x0908, 0x01FF) }, /* Siemens RUGGEDCOM USB Serial Console */
 	{ USB_DEVICE(0x0988, 0x0578) }, /* Teraoka AD2000 */
 	{ USB_DEVICE(0x0B00, 0x3070) }, /* Ingenico 3070 */


