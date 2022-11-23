Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC281C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:01:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5A7C433D7;
	Wed, 23 Nov 2022 09:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194061;
	bh=hvcud6CkPL+24ACJhOPu5m/hMilRA+lE2K6kETMhF8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9kqg6boDAFgQZMMqcKAtZONiI61IREjAWWChhTzBfCYTx4F1Iqk0B6yOMzPIpsl9
	 XKMlyaYkKim38zy8EEz91tV41hFyRWU+X2oxIZJ/hMpYKUpEwGmXTyvpgim0dNsqSf
	 ePMQuYBf4tkpYRvPdP8m7aqVckEvi4MEP3zvShQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davide Tronchin <davide.tronchin.94@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 61/88] USB: serial: option: add u-blox LARA-L6 modem
Date: Wed, 23 Nov 2022 09:50:58 +0100
Message-Id: <20221123084550.697317063@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Davide Tronchin <davide.tronchin.94@gmail.com>

commit c1547f12df8b8e9ca2686accee43213ecd117efe upstream.

Add LARA-L6 PIDs for three different USB compositions.

LARA-L6 module can be configured (by AT interface) in three different
USB modes:
* Default mode (Vendor ID: 0x1546 Product ID: 0x1341) with 4 serial
interfaces
* RmNet mode (Vendor ID: 0x1546 Product ID: 0x1342) with 4 serial
interfaces and 1 RmNet virtual network interface
* CDC-ECM mode (Vendor ID: 0x1546 Product ID: 0x1343) with 4 serial
interface and 1 CDC-ECM virtual network interface

In default mode LARA-L6 exposes the following interfaces:
If 0: Diagnostic
If 1: AT parser
If 2: AT parser
If 3: AT parser/alternative functions

In RmNet mode LARA-L6 exposes the following interfaces:
If 0: Diagnostic
If 1: AT parser
If 2: AT parser
If 3: AT parset/alternative functions
If 4: RMNET interface

In CDC-ECM mode LARA-L6 exposes the following interfaces:
If 0: Diagnostic
If 1: AT parser
If 2: AT parser
If 3: AT parset/alternative functions
If 4: CDC-ECM interface

Signed-off-by: Davide Tronchin <davide.tronchin.94@gmail.com>
[ johan: drop PID defines in favour of comments ]
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -165,6 +165,8 @@ static void option_instat_callback(struc
 #define NOVATELWIRELESS_PRODUCT_G2		0xA010
 #define NOVATELWIRELESS_PRODUCT_MC551		0xB001
 
+#define UBLOX_VENDOR_ID				0x1546
+
 /* AMOI PRODUCTS */
 #define AMOI_VENDOR_ID				0x1614
 #define AMOI_PRODUCT_H01			0x0800
@@ -1133,6 +1135,12 @@ static const struct usb_device_id option
 	  .driver_info = RSVD(4) },
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x90fa),
 	  .driver_info = RSVD(3) },
+	/* u-blox products */
+	{ USB_DEVICE(UBLOX_VENDOR_ID, 0x1341) },	/* u-blox LARA-L6 */
+	{ USB_DEVICE(UBLOX_VENDOR_ID, 0x1342),		/* u-blox LARA-L6 (RMNET) */
+	  .driver_info = RSVD(4) },
+	{ USB_DEVICE(UBLOX_VENDOR_ID, 0x1343),		/* u-blox LARA-L6 (ECM) */
+	  .driver_info = RSVD(4) },
 	/* Quectel products using Quectel vendor ID */
 	{ USB_DEVICE_AND_INTERFACE_INFO(QUECTEL_VENDOR_ID, QUECTEL_PRODUCT_EC21, 0xff, 0xff, 0xff),
 	  .driver_info = NUMEP2 },


