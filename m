Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE818481CE;
	Mon,  1 Apr 2024 16:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988170; cv=none; b=NOkM0CnOGg3jPfBZIHAKvqqxjnh74BhfSP95r5MlN/We4JJH1PUXyvQ/bk7lo0xs3UKqrsN7p9tnVWZ3R/ESl4Vz5rj4HQmJOciiPjNTjCxxCfgL3qxp0Fn+WXNIrGGYujxW7eu9KCBfWhiF3Jb2YC1C8KxGyDE2o56r0vyPesk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988170; c=relaxed/simple;
	bh=bRO6Tzsf7I05K7uy+RjU1cbbbnBxV/L3U5X9eTTaqVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSZYQ9XAAI/DPz5efuVFjds/RH7RQ3VZ1HrUYAX6AFig4PCGL1jxOK/ptKODQenwukSEGEj2Y3GKkhtKozUuaQ5m40pTOvJ7fdToZcAPsPvKwvb4A6WL6gM5FSld+szohKLm8y1dq2eMoRNYp9TwJneP7nIbiWA5rcQH3RF3ow8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pnk4b/7X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pnk4b/7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3055C433C7;
	Mon,  1 Apr 2024 16:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988169;
	bh=bRO6Tzsf7I05K7uy+RjU1cbbbnBxV/L3U5X9eTTaqVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pnk4b/7XwpIHKb8dEzgLN9m5rdNN2IrRb0cTWkhHg2aOPXZ+GJBbXkRFwRywk+7ZG
	 3fNZ9XIk/zWeW9g0x/HFLU9gzVqh/JAA7EhNjXFsgC5HtaQdMEVc9hbXyS4NLRc51D
	 0DQtkhrFdxl2joTIcNW7gffJIwA/U2L82vcrujmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vogelbacher <daniel@chaospixel.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 077/432] USB: serial: ftdi_sio: add support for GMC Z216C Adapter IR-USB
Date: Mon,  1 Apr 2024 17:41:04 +0200
Message-ID: <20240401152555.419756405@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 13a56783830df..22d01a0f10fbc 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1077,6 +1077,8 @@ static const struct usb_device_id id_table_combined[] = {
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_FALCONIA_JTAG_UNBUF_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
+	/* GMC devices */
+	{ USB_DEVICE(GMC_VID, GMC_Z216C_PID) },
 	{ }					/* Terminating entry */
 };
 
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_sio_ids.h
index 21a2b5a25fc09..5ee60ba2a73cd 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -1606,3 +1606,9 @@
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



