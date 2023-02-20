Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA25663B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCC2C433EF;
	Mon, 20 Feb 2023 13:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900361;
	bh=raKm7d1i05TtGQ+T20xZSIPa5jEmuMULSkGn4+t/fNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wp8wfifitT0wBdAZ6ATz/jt3faWldgRN7TN83BRUL2cxkGOgYG+qevHwOHFVFk4mU
	 Y4LGFAnfhBLr/6ve8Li+1fVdyHT5wxr/ETbcD56oc3z410t56Q3vBOACWFB0gei8Sx
	 QEl9R1iBqDts1qr8yqzDc63yVbHPO9qlayhz2lR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miroslav Zatko <mzatko@mirexoft.com>,
	Dennis Wassenberg <dennis.wassenberg@secunet.com>,
	Mark Pearson <mpearson-lenovo@squebb.ca>
Subject: [PATCH 4.14 32/53] usb: core: add quirk for Alcor Link AK9563 smartcard reader
Date: Mon, 20 Feb 2023 14:35:58 +0100
Message-Id: <20230220133549.320752439@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Pearson <mpearson-lenovo@squebb.ca>

commit 303e724d7b1e1a0a93daf0b1ab5f7c4f53543b34 upstream.

The Alcor Link AK9563 smartcard reader used on some Lenovo platforms
doesn't work. If LPM is enabled the reader will provide an invalid
usb config descriptor. Added quirk to disable LPM.

Verified fix on Lenovo P16 G1 and T14 G3

Tested-by: Miroslav Zatko <mzatko@mirexoft.com>
Tested-by: Dennis Wassenberg <dennis.wassenberg@secunet.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dennis Wassenberg <dennis.wassenberg@secunet.com>
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20230208181223.1092654-1-mpearson-lenovo@squebb.ca
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -340,6 +340,9 @@ static const struct usb_device_id usb_qu
 	/* DJI CineSSD */
 	{ USB_DEVICE(0x2ca3, 0x0031), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Alcor Link AK9563 SC Reader used in 2022 Lenovo ThinkPads */
+	{ USB_DEVICE(0x2ce3, 0x9563), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* DELL USB GEN2 */
 	{ USB_DEVICE(0x413c, 0xb062), .driver_info = USB_QUIRK_NO_LPM | USB_QUIRK_RESET_RESUME },
 


