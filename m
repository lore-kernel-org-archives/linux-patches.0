Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9B779FD;
	Thu, 11 Apr 2024 10:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831551; cv=none; b=XBLDOy00zzqtutyS2SrLelH+rMnAMCZ7heHU8tZUogz2uVqjLWqYMEJ1nA81DiB7tKE3ffKvYc+AmPPA8zWDLmzytWV+XB6Di5Ko1pACWb8LrJv6A5j4nxVWJitVdT5S+FSORHwdvwNmr0anVtldOrwJAhbXKVDgV9kFkGmYoh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831551; c=relaxed/simple;
	bh=EqBjhxEHnEM+yS2ewexytkt2HdE3ThEMSqQFpCHkxWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8wGljotaO9GXzzXDHY+yzGUl6gV+RZTt32T2vJsW1WZ22dpfgX+v6rtF7KQL3zpKkzPIC4rdxZBg9rf03lHkMM7I6LwieSZkyK2n7rbH0YG27gOqMhEolw/vT7WM29yRY5N9upGovCdNCWOol8lbWAQKtsABf17DmzOY+scP5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgmTeLnD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgmTeLnD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328EEC433C7;
	Thu, 11 Apr 2024 10:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831550;
	bh=EqBjhxEHnEM+yS2ewexytkt2HdE3ThEMSqQFpCHkxWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgmTeLnD64bFeSFA9KuyMuy7rkEDDRMcYEIyTMl8MYg1fiOek/aQmR5Dyp47qWM7u
	 j6XCdtbjvHwcv2w7VmarQJ+PAoBngJDj8hiXcMdxxs3LPOKyzIvyimq7h1OxUJUZjk
	 31obWyivQw6dz+ZRHg0/e9DOv2Kols+HNaxKwSxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vogelbacher <daniel@chaospixel.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/294] USB: serial: ftdi_sio: add support for GMC Z216C Adapter IR-USB
Date: Thu, 11 Apr 2024 11:53:29 +0200
Message-ID: <20240411095437.024096288@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4d7f4a4ab69fb..66aa999efa6d5 100644
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



