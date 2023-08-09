Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7A31774E
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CDEC433C9;
	Wed,  9 Aug 2023 11:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579040;
	bh=vo4O3qNH5lZiNF4agQOgzAdB5eIIPYDt8mcspxOKJ+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arQEtuJXByCBK4zO1+nPYLwJQ6UB5nauOFX4doIICaujMn08UlWZFRBOPDYqP3f0l
	 xQObyEtqdBfEbPqFyROmuL1KMR3iHX6e81ldWf1AE5ICrbq/wgZhliCdzT55LLLqyd
	 8LO4EnCSyiC2MPIBSofbZhsMHn3bUqpGidhUXtdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davide Tronchin <davide.tronchin.94@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 054/204] USB: serial: option: add LARA-R6 01B PIDs
Date: Wed,  9 Aug 2023 12:39:52 +0200
Message-ID: <20230809103644.412349375@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
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

commit ffa5f7a3bf28c1306eef85d4056539c2d4b8eb09 upstream.

The new LARA-R6 product variant identified by the "01B" string can be
configured (by AT interface) in three different USB modes:

* Default mode (Vendor ID: 0x1546 Product ID: 0x1311) with 4 serial
interfaces

* RmNet mode (Vendor ID: 0x1546 Product ID: 0x1312) with 4 serial
interfaces and 1 RmNet virtual network interface

* CDC-ECM mode (Vendor ID: 0x1546 Product ID: 0x1313) with 4 serial
interface and 1 CDC-ECM virtual network interface
The first 4 interfaces of all the 3 USB configurations (default, RmNet,
CDC-ECM) are the same.

In default mode LARA-R6 01B exposes the following interfaces:
If 0: Diagnostic
If 1: AT parser
If 2: AT parser
If 3: AT parser/alternative functions

In RmNet mode LARA-R6 01B exposes the following interfaces:
If 0: Diagnostic
If 1: AT parser
If 2: AT parser
If 3: AT parser/alternative functions
If 4: RMNET interface

In CDC-ECM mode LARA-R6 01B exposes the following interfaces:
If 0: Diagnostic
If 1: AT parser
If 2: AT parser
If 3: AT parser/alternative functions
If 4: CDC-ECM interface

Signed-off-by: Davide Tronchin <davide.tronchin.94@gmail.com>
Link: https://lore.kernel.org/r/20230622092921.12651-1-davide.tronchin.94@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/option.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1154,6 +1154,10 @@ static const struct usb_device_id option
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x90fa),
 	  .driver_info = RSVD(3) },
 	/* u-blox products */
+	{ USB_DEVICE(UBLOX_VENDOR_ID, 0x1311) },	/* u-blox LARA-R6 01B */
+	{ USB_DEVICE(UBLOX_VENDOR_ID, 0x1312),		/* u-blox LARA-R6 01B (RMNET) */
+	  .driver_info = RSVD(4) },
+	{ USB_DEVICE_INTERFACE_CLASS(UBLOX_VENDOR_ID, 0x1313, 0xff) },	/* u-blox LARA-R6 01B (ECM) */
 	{ USB_DEVICE(UBLOX_VENDOR_ID, 0x1341) },	/* u-blox LARA-L6 */
 	{ USB_DEVICE(UBLOX_VENDOR_ID, 0x1342),		/* u-blox LARA-L6 (RMNET) */
 	  .driver_info = RSVD(4) },


