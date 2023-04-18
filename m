Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7622566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81EEC433EF;
	Tue, 18 Apr 2023 12:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681820916;
	bh=7cN3HYCw3m1iHVR5xnin62O9z4avQMyfpaPtkqvNJvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X8WRiu9gzOpHmqbN1LYmmxlTJiL48F8KBm7fSw67UG7x1fxen1b/oq1A1YewlxYhO
	 8v8GKLrmxe08YPdDXpl5dc5t459SOnxu7hTwE70w5SJUKR+9Z89uRr2mPkOU9hDMps
	 8pypoNoJLavMjgYodjqIfUOhMW0k7ltTJIfMjDcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Jan Koster <kjkoster@kjkoster.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 21/92] USB: serial: cp210x: add Silicon Labs IFS-USB-DATACABLE IDs
Date: Tue, 18 Apr 2023 14:20:56 +0200
Message-Id: <20230418120305.539763509@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Jan Koster <kjkoster@kjkoster.org>

commit 71f8afa2b66e356f435b6141b4a9ccf953e18356 upstream.

The Silicon Labs IFS-USB-DATACABLE is used in conjunction with for example
the Quint UPSes. It is used to enable Modbus communication with the UPS to
query configuration, power and battery status.

Signed-off-by: Kees Jan Koster <kjkoster@kjkoster.org>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -121,6 +121,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x10C4, 0x826B) }, /* Cygnal Integrated Products, Inc., Fasttrax GPS demonstration module */
 	{ USB_DEVICE(0x10C4, 0x8281) }, /* Nanotec Plug & Drive */
 	{ USB_DEVICE(0x10C4, 0x8293) }, /* Telegesis ETRX2USB */
+	{ USB_DEVICE(0x10C4, 0x82AA) }, /* Silicon Labs IFS-USB-DATACABLE used with Quint UPS */
 	{ USB_DEVICE(0x10C4, 0x82EF) }, /* CESINEL FALCO 6105 AC Power Supply */
 	{ USB_DEVICE(0x10C4, 0x82F1) }, /* CESINEL MEDCAL EFD Earth Fault Detector */
 	{ USB_DEVICE(0x10C4, 0x82F2) }, /* CESINEL MEDCAL ST Network Analyzer */


