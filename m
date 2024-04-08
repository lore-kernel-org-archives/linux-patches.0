Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC31264CF2;
	Mon,  8 Apr 2024 13:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581416; cv=none; b=GTxW+0EA9vv83/Q8iuyru+2TfHzUMjeJRA8BFAjZOL2WY9o5CjXD2SLQJ1sR+Ov36mw07ACacC71r+xnAXn5H9U1fN6yEN4ZsRv+bfApTemDm7iOaRuiPbVvD9jj0+gZazX2Qlu9ON28AxIOiV0PJ2ULGl4HwidBJrXbwJc/Xxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581416; c=relaxed/simple;
	bh=uiGnyOYzI0Qjr4hCxdprat/ENVKjNIwDS8M2VFMPQ8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOFgbQ56E4owLH+6iRbQl1TyWngvUQzq+Iis60imIq2TP2UERxExm6ZzkwHb70XZEMlUEym1lM8nXIDGyHXFevquGPRo9QByjU7eWXJ0NgLfPGax3vgtN6e1tMK5bZlvmAaia4QRVNcS9ZU++PFtCD7tKStnVPo5PcGqjaEFf7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hm3c6FV1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hm3c6FV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B4FC433C7;
	Mon,  8 Apr 2024 13:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581416;
	bh=uiGnyOYzI0Qjr4hCxdprat/ENVKjNIwDS8M2VFMPQ8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hm3c6FV1zvwEGyCEqZqacwoTzk97KJJxCADmbLDTt8Z9d/RUmk8e9tSpqfsL1hHxC
	 5qLFhrb2d0kZNxv3jiG1e3wPs0f2sFC1hBmikEdVa2lzGI5XT7SN1ndBVSX8a4RorR
	 kh9yfyAlydJKmW5tcPMPwgAimzE8ZZM59bQ89Tmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vogelbacher <daniel@chaospixel.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/690] USB: serial: ftdi_sio: add support for GMC Z216C Adapter IR-USB
Date: Mon,  8 Apr 2024 14:48:33 +0200
Message-ID: <20240408125401.237753727@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vogelbacher <daniel@chaospixel.com>

[ Upstream commit 3fb7bc4f3a98c48981318b87cf553c5f115fd5ca ]

The GMC IR-USB adapter cable utilizes a FTDI FT232R chip.

Add VID/PID for this adapter so it can be used as serial device via
ftdi_sio.

Signed-off-by: Daniel Vogelbacher <daniel@chaospixel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/ftdi_sio.c     | 2 ++
 drivers/usb/serial/ftdi_sio_ids.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 2345208b7221c..1915b92c388fe 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1055,6 +1055,8 @@ static const struct usb_device_id id_table_combined[] = {
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_FALCONIA_JTAG_UNBUF_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	/* GMC devices */
+	{ USB_DEVICE(GMC_VID, GMC_Z216C_PID) },
 	{ }					/* Terminating entry */
 };
 
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 9a0f9fc991246..b2aec1106678a 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1599,3 +1599,9 @@
 #define UBLOX_VID			0x1546
 #define UBLOX_C099F9P_ZED_PID		0x0502
 #define UBLOX_C099F9P_ODIN_PID		0x0503
+
+/*
+ * GMC devices
+ */
+#define GMC_VID				0x1cd7
+#define GMC_Z216C_PID			0x0217 /* GMC Z216C Adapter IR-USB */
-- 
2.43.0



