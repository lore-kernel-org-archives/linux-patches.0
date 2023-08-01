Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69740200A5
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0734C433C7;
	Tue,  1 Aug 2023 09:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882583;
	bh=9ONyQ4ihBn7mfC8UgUwyjEKAdvj/wr1Iu5ByNyvxK8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bmXlvjvLhPi+iqs2cCyaobF6zPV9N4DI7W/9k4eXk2GYZs3IqRtDStHQCK7WQHMcE
	 lb00880fdaq3t6S4EBqxELxpCQy6jGmlV4ipn7NkITmjVJAQK2NCtBRKh7D5VjlXfr
	 ZvTweZg1NnN1SDYVuoA3IzT5WlVBTxiL0PEprZII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaufmann Automotive GmbH <info@kaufmann-automotive.ch>,
	Oliver Neukum <oneukum@suse.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 158/228] USB: serial: simple: add Kaufmann RKS+CAN VCP
Date: Tue,  1 Aug 2023 11:20:16 +0200
Message-ID: <20230801091928.598424971@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oliver Neukum <oneukum@suse.com>

commit dd92c8a1f99bcd166204ffc219ea5a23dd65d64f upstream.

Add the device and product ID for this CAN bus interface / license
dongle. The device is usable either directly from user space or can be
attached to a kernel CAN interface with slcan_attach.

Reported-by: Kaufmann Automotive GmbH <info@kaufmann-automotive.ch>
Tested-by: Kaufmann Automotive GmbH <info@kaufmann-automotive.ch>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
[ johan: amend commit message and move entries in sort order ]
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/usb-serial-simple.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/serial/usb-serial-simple.c
+++ b/drivers/usb/serial/usb-serial-simple.c
@@ -63,6 +63,11 @@ DEVICE(flashloader, FLASHLOADER_IDS);
 					0x01) }
 DEVICE(google, GOOGLE_IDS);
 
+/* KAUFMANN RKS+CAN VCP */
+#define KAUFMANN_IDS()			\
+	{ USB_DEVICE(0x16d0, 0x0870) }
+DEVICE(kaufmann, KAUFMANN_IDS);
+
 /* Libtransistor USB console */
 #define LIBTRANSISTOR_IDS()			\
 	{ USB_DEVICE(0x1209, 0x8b00) }
@@ -124,6 +129,7 @@ static struct usb_serial_driver * const
 	&funsoft_device,
 	&flashloader_device,
 	&google_device,
+	&kaufmann_device,
 	&libtransistor_device,
 	&vivopay_device,
 	&moto_modem_device,
@@ -142,6 +148,7 @@ static const struct usb_device_id id_tab
 	FUNSOFT_IDS(),
 	FLASHLOADER_IDS(),
 	GOOGLE_IDS(),
+	KAUFMANN_IDS(),
 	LIBTRANSISTOR_IDS(),
 	VIVOPAY_IDS(),
 	MOTO_IDS(),


