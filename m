Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1CA2EA17E;
	Tue, 22 Jul 2025 13:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192326; cv=none; b=ZE6QNui6df2Wt4PXHjqWVLtvXNEhnvp2KzDRYqJk3+Vw/7lo3X5JRzhe8F/7M2RtF24cyUbEvWvFPXBor3Aq7ZluQ50arovx0w45TFc751Vi8/nADIKo4xskB28iBFScxfPjE4O1/KXqW4vywRQJ7gVRuHyPbqBtajA6TiKYzDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192326; c=relaxed/simple;
	bh=8Rpg1iwCCccploiEQkt77UJL2HFJPn9Ih22ZA0v4/O8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYW8KjHqPG0Wgo5ZWXTQJmpG/N2BC8+v25g0kMyj37WzfYEX+6p0y350bdZgLtcJoTx7IhStFA0DJQrHa5UfldQijqII7WH09TMP4kIqAILkMojLDsbTB/fIqo9sLLjNk97KqDi9SIu1L2iJA/I7oFlT2afdESoc5I8u5Zrpk04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FAxNTt0u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FAxNTt0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426B6C4CEEB;
	Tue, 22 Jul 2025 13:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192325;
	bh=8Rpg1iwCCccploiEQkt77UJL2HFJPn9Ih22ZA0v4/O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FAxNTt0u8NfZypVE4tSIUIIjmtarrr47aIC83gQzbFTzT6Leupf3wHAUhGk27jeWc
	 lktNvE+kufzOmzZXns2UcMvY2L1poczpP85LB+btZ6fvWoUaROBHT5TBhtIzAYptRD
	 ml9fYS9V/wk9RMG9R05RyLP0XKbNHfGI9+q85/FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Mann <rmann@ndigital.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 006/111] USB: serial: ftdi_sio: add support for NDI EMGUIDE GEMINI
Date: Tue, 22 Jul 2025 15:43:41 +0200
Message-ID: <20250722134333.621497188@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

From: Ryan Mann (NDI) <rmann@ndigital.com>

commit c980666b6958d9a841597331b38115a29a32250e upstream.

NDI (Northern Digital Inc.) is introducing a new product called the
EMGUIDE GEMINI that will use an FTDI chip for USB serial communications.
Add the NDI EMGUIDE GEMINI product ID that uses the NDI Vendor ID
rather than the FTDI Vendor ID, unlike older products.

Signed-off-by: Ryan Mann <rmann@ndigital.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ftdi_sio.c     |    2 ++
 drivers/usb/serial/ftdi_sio_ids.h |    3 +++
 2 files changed, 5 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -803,6 +803,8 @@ static const struct usb_device_id id_tab
 		.driver_info = (kernel_ulong_t)&ftdi_NDI_device_quirk },
 	{ USB_DEVICE(FTDI_VID, FTDI_NDI_AURORA_SCU_PID),
 		.driver_info = (kernel_ulong_t)&ftdi_NDI_device_quirk },
+	{ USB_DEVICE(FTDI_NDI_VID, FTDI_NDI_EMGUIDE_GEMINI_PID),
+		.driver_info = (kernel_ulong_t)&ftdi_NDI_device_quirk },
 	{ USB_DEVICE(TELLDUS_VID, TELLDUS_TELLSTICK_PID) },
 	{ USB_DEVICE(NOVITUS_VID, NOVITUS_BONO_E_PID) },
 	{ USB_DEVICE(FTDI_VID, RTSYSTEMS_USB_VX8_PID) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -204,6 +204,9 @@
 #define FTDI_NDI_FUTURE_3_PID		0xDA73	/* NDI future device #3 */
 #define FTDI_NDI_AURORA_SCU_PID		0xDA74	/* NDI Aurora SCU */
 
+#define FTDI_NDI_VID			0x23F2
+#define FTDI_NDI_EMGUIDE_GEMINI_PID	0x0003	/* NDI Emguide Gemini */
+
 /*
  * ChamSys Limited (www.chamsys.co.uk) USB wing/interface product IDs
  */


