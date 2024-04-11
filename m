Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C6C14600E;
	Thu, 11 Apr 2024 10:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830549; cv=none; b=jWBjuPE+H4H5pUjE0uKXFb3NM1Evsi6HibKQYfwI97GiIaxHEEMBU76ZVTn6a4bMEuPAGKxajC7nBR6tlLaR1J9EaxzhbzZDp/rknOko9DJXUKYnxiuHUMSYBoRPVl8kqgrLI3mRPn5UHxNNE19louzR3pi8XJJ9R5QSJPw+8J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830549; c=relaxed/simple;
	bh=YBfrix0gpQngFfRjUSJDmtrMmVP2OBjF9rkzclbmQlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjVSx2fpTu6nmtrauJvZDag2Bm410/vjs9ilJ4RRrouScLOrXz7unq1H0sZxm/7F1Pm7hVhD5kTf3x+/R23Jy6bUlPCO8EiSUC6JGKmoPSvIkl0lwyj4bu8bElGh53TQ7fqqn91FbzCQYGa2h+27Om/z+PGyu/+SDCBClY3roNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c8GORcyb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c8GORcyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76634C433F1;
	Thu, 11 Apr 2024 10:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830548;
	bh=YBfrix0gpQngFfRjUSJDmtrMmVP2OBjF9rkzclbmQlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8GORcybc5i5LSaReCja7cjtfzuFKWb33ETIjrinI7ptNgk14pSXWDaSpUW8tABaP
	 EXhAXNIko4rM1Vo82nszxVhDoqIGqx7fc/VTIViOSOP4keOPKpuXcqEa4Z1LzEEBs8
	 ElQSl4tC8QQR+q6wyVdUFdP27hNm6LcRsEKXTPCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vogelbacher <daniel@chaospixel.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/215] USB: serial: ftdi_sio: add support for GMC Z216C Adapter IR-USB
Date: Thu, 11 Apr 2024 11:54:07 +0200
Message-ID: <20240411095426.042181600@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c97923858fce6..bfb0be4e70d5e 100644
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



