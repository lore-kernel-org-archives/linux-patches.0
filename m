Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2280D6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1CCC433EF;
	Mon, 16 Jan 2023 16:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887088;
	bh=7JmoRvzaZ74f40X0w+90kcd+xiFw5s+9wkGJvem6B48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dui6gPB8mC+lkLYtK/W6AEWw05NMDi24K1/41m4B0oYnCugVApyThawzRME9CDPGn
	 snm0ZG6ysPqSS+Pm/32+S7ut/f++hrdHypDxAlI2f7o8URv1oJ8L0mRSWuQPVtnIJD
	 KgVBF/J6i1yQ55JjY4X6jQWp92H9ppit5IE4lObI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bruno Thomsen <bruno.thomsen@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 017/521] USB: serial: cp210x: add Kamstrup RF sniffer PIDs
Date: Mon, 16 Jan 2023 16:44:39 +0100
Message-Id: <20230116154848.051477017@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bruno Thomsen <bruno.thomsen@gmail.com>

commit e88906b169ebcb8046e8f0ad76edd09ab41cfdfe upstream.

The RF sniffers are based on cp210x where the RF frontends
are based on a different USB stack.

RF sniffers can analyze packets meta data including power level
and perform packet injection.

Can be used to perform RF frontend self-test when connected to
a concentrator, ex. arch/arm/boot/dts/imx7d-flex-concentrator.dts

Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/cp210x.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -196,6 +196,8 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x16DC, 0x0015) }, /* W-IE-NE-R Plein & Baus GmbH CML Control, Monitoring and Data Logger */
 	{ USB_DEVICE(0x17A8, 0x0001) }, /* Kamstrup Optical Eye/3-wire */
 	{ USB_DEVICE(0x17A8, 0x0005) }, /* Kamstrup M-Bus Master MultiPort 250D */
+	{ USB_DEVICE(0x17A8, 0x0011) }, /* Kamstrup 444 MHz RF sniffer */
+	{ USB_DEVICE(0x17A8, 0x0013) }, /* Kamstrup 870 MHz RF sniffer */
 	{ USB_DEVICE(0x17A8, 0x0101) }, /* Kamstrup 868 MHz wM-Bus C-Mode Meter Reader (Int Ant) */
 	{ USB_DEVICE(0x17A8, 0x0102) }, /* Kamstrup 868 MHz wM-Bus C-Mode Meter Reader (Ext Ant) */
 	{ USB_DEVICE(0x17F4, 0xAAAA) }, /* Wavesense Jazz blood glucose meter */


