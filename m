Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340AC251783;
	Tue, 29 Apr 2025 18:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950545; cv=none; b=Zhs05fA1RiQvxZdMp+QNprxD7PrK9dRd92DAZD2OjO/Vi6OkJgheBiIbZ3IpeutgJHL2kjQH3qV4o31GFm4agAey599w+n34kQsMhf0hTHpW7+wN+5fMke5/wsRwm0xCDOwyMU/Km/eMJSx+NzWe28KWAj+L6mZ2TKBg+81xvp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950545; c=relaxed/simple;
	bh=hwxCKIe0Cs1wSQQvZxDGzuHrpI2bGqN66eLidgwvMpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5Mgc2TV6l5a+XAZXrdiWWWsJYH0/sf+X3IAyAgFRMtoMgHZzhukiudYoELr93IS2hDK+J8OJOl1pRhMqQ9R1pJ6/J9gL2w1UDWUdwjVIoe/MlFYtZRLNCDS2aPYMXCiVYLWls4yn7MdyiwssJZZUvpF18fGLXOOdBQahWhNHCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B8aIC2xH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B8aIC2xH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF6EC4CEE3;
	Tue, 29 Apr 2025 18:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950545;
	bh=hwxCKIe0Cs1wSQQvZxDGzuHrpI2bGqN66eLidgwvMpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8aIC2xH8NUPZN3kKBnXKC5h+BxuYM4cjKf7XVC0xql7Cr/Ky+El7fyBjjUDVPzP8
	 quGmIPSXVSPGJgvOlODCo2rvYYHMQk3MD6gy8HsVHZ1Ag1BxO17ob1oyYbeRDf4j1J
	 7Z47B8lI1xxnjKmYecQU/6pBanEh94lZznQH6pdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ehrenreich <michideep@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 099/204] USB: serial: ftdi_sio: add support for Abacus Electrics Optical Probe
Date: Tue, 29 Apr 2025 18:43:07 +0200
Message-ID: <20250429161103.484804037@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ehrenreich <michideep@gmail.com>

commit b399078f882b6e5d32da18b6c696cc84b12f90d5 upstream.

Abacus Electrics makes optical probes for interacting with smart meters
over an optical interface.

At least one version uses an FT232B chip (as detected by ftdi_sio) with
a custom USB PID, which needs to be added to the list to make the device
work in a plug-and-play fashion.

Signed-off-by: Michael Ehrenreich <michideep@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    5 +++++
 2 files changed, 7 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1093,6 +1093,8 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_602E_PID, 1) },
 	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_602E_PID, 2) },
 	{ USB_DEVICE_INTERFACE_NUMBER(ALTERA_VID, ALTERA_UB3_602E_PID, 3) },
+	/* Abacus Electrics */
+	{ USB_DEVICE(FTDI_VID, ABACUS_OPTICAL_PROBE_PID) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -443,6 +443,11 @@
 #define LINX_FUTURE_2_PID   0xF44C	/* Linx future device */
 
 /*
+ * Abacus Electrics
+ */
+#define ABACUS_OPTICAL_PROBE_PID	0xf458 /* ABACUS ELECTRICS Optical Probe */
+
+/*
  * Oceanic product ids
  */
 #define FTDI_OCEANIC_PID	0xF460  /* Oceanic dive instrument */


