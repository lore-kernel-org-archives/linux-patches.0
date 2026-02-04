Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA4227F749;
	Wed,  4 Feb 2026 14:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216789; cv=none; b=nW6MmpxlKErWsSLUUmKsUBvzkPwZ+AsiE7n7+kDCyoZffIzD3uZ2nKh+4fspgiK5LPnr0KcM7lNDJKrbUajaSUNomFlPTr+ZXLeJJ0cyGQb052GtjohrUx6IOfogD0WjRp88ZQR/RG0636encszyCGVhjcodmCtCJ8LENUPW6+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216789; c=relaxed/simple;
	bh=TRy+/3hnquhpm/3TbeK1IK/Bjgmaxz/JRam5wILkV80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCw95/xQdP8zyDylB+Nin71Cagi2AglQU+FuhFDeMeuMlGhpJHFIjmI16IKXn5YEhFMMQY6eIqYD1HcRFrM93+Baw8F2hvJPVngvS5z+OCZHCf7PAtR96de7b7LMGRGFFJr0A29eC1N0SJEU9zJqk+vlOWUYJ7CbaTvNtMx7cks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=es/5ZF5L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="es/5ZF5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BD4C19423;
	Wed,  4 Feb 2026 14:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216789;
	bh=TRy+/3hnquhpm/3TbeK1IK/Bjgmaxz/JRam5wILkV80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=es/5ZF5Lo7Q5ny3XIQXjbxS4vR3AOt/xhSROTt1Us4kLIkgkeQeLnsoL2h/Up9pdz
	 uKNzMTrWDF6Jg181meBzPeYLNMvKNzuHXruQfov9gHgPVJcGk1JqcWvI3bVP2a3Mlj
	 sXWli+JQxnrsB9eUXYq5ivqi24sv7YWud4x5C1CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 032/206] USB: serial: ftdi_sio: add support for PICAXE AXE027 cable
Date: Wed,  4 Feb 2026 15:37:43 +0100
Message-ID: <20260204143859.359452039@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Ethan Nelson-Moore <enelsonmoore@gmail.com>

commit c0afe95e62984ceea171c3ea319beaf84a21181c upstream.

The vendor provides instructions to write "0403 bd90" to
/sys/bus/usb-serial/drivers/ftdi_sio/new_id; see:
https://picaxe.com/docs/picaxe_linux_instructions.pdf

Cc: stable@vger.kernel.org
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    2 ++
 2 files changed, 3 insertions(+)

--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -828,6 +828,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE_INTERFACE_NUMBER(FTDI_VID, LMI_LM3S_DEVEL_BOARD_PID, 1) },
 	{ USB_DEVICE_INTERFACE_NUMBER(FTDI_VID, LMI_LM3S_EVAL_BOARD_PID, 1) },
 	{ USB_DEVICE_INTERFACE_NUMBER(FTDI_VID, LMI_LM3S_ICDI_BOARD_PID, 1) },
+	{ USB_DEVICE(FTDI_VID, FTDI_AXE027_PID) },
 	{ USB_DEVICE_INTERFACE_NUMBER(FTDI_VID, FTDI_TURTELIZER_PID, 1) },
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_USB60F) },
 	{ USB_DEVICE(RATOC_VENDOR_ID, RATOC_PRODUCT_ID_SCU18) },
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -89,6 +89,8 @@
 #define LMI_LM3S_EVAL_BOARD_PID		0xbcd9
 #define LMI_LM3S_ICDI_BOARD_PID		0xbcda
 
+#define FTDI_AXE027_PID		0xBD90 /* PICAXE AXE027 USB download cable */
+
 #define FTDI_TURTELIZER_PID	0xBDC8 /* JTAG/RS-232 adapter by egnite GmbH */
 
 /* OpenDCC (www.opendcc.de) product id */


