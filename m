Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CDB2EAB6E;
	Tue, 22 Jul 2025 14:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193245; cv=none; b=KZ8qFXlVIPiyDc+Nfc+Z2fYEiAKZlh6enpjf3AOOkb2vjKSVarFu8jlNDgLVfTeS1HYhEMMLN1QyArv2vtWJBmdjZwCvQV1N3AmIWgp28u1cB0yafEWbIzSpTy2o6843j6ZK7FtjEZkU5z/zELPCD6phEyhSMpdoqDqDEetFAzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193245; c=relaxed/simple;
	bh=tXWDLrNHhDx8d9wKmKXqoFEE+GdrwNv9fe9LjxesP58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrHoCmrAYbXhHqLKfnkNzhGujSULJQUO84ZtMmfLM99fhXZeaxnvawyWLpsLKhYFDMivGSD0XBy7gvYksBicYVHqBPmjrG+FMjvIt4/z5k7qoL8Ju+ZDs3c1wKNMiU6kR4HQdSIiIErgRCyPM0w5wvlpsFLdpoob2RhEdfFb5rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cRHoyh0u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cRHoyh0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0644C4CEF5;
	Tue, 22 Jul 2025 14:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193245;
	bh=tXWDLrNHhDx8d9wKmKXqoFEE+GdrwNv9fe9LjxesP58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRHoyh0uo9nlbTCG8fVISZ7pTC1zwiwxwWqZiSeNL9UXupcVeb9UXlcj/Xild8Puz
	 P8sH0UNyiRHma2HfQudGZIQSBGNKceAgdm5u2ImU1SKtnbYM9H6s7frpwNWzaPaEns
	 rOrsHR3ENDL+d1NhACsHGTUi+25c4LMTawaVlh/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Mann <rmann@ndigital.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.15 006/187] USB: serial: ftdi_sio: add support for NDI EMGUIDE GEMINI
Date: Tue, 22 Jul 2025 15:42:56 +0200
Message-ID: <20250722134345.993952623@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


