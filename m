Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EA12210F2;
	Thu, 12 Dec 2024 16:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020188; cv=none; b=iViU3gNu2E9EyN2VQCjZoELtv3ZfPmhH8Ih2KzfoajaOet1B18Lz6w4fFhZjFM34OOlg+T9SfR6t9bwnSn3HkwI6mP57cw0ou7abSpWTn97jRk55Pr4P+CxDE+o0dYaA0jJVeSNXXV95t2VsZAp9sRIsYo+SKBqIhonV4uaZbQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020188; c=relaxed/simple;
	bh=p3wc7KMPmbmkijJo5Y7p/i4F5JDnowj6dyAT4VAw5qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gqX3/hGB+JR6wYbTMF24+vv2iVfDucbVuZjm/BA5axtXDFrRAV2OMS8O3BrAX8U0P2kJMWCD8n4wlw+1S1oNJ7WEXNKJoiVfvqrq3aPu75rifiHCORunDGmJqUKszWFxHvYsS3U8edOgVTAozarSx2hQKdStC76X4mh5Yy7EOsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xur1fsir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xur1fsir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593E3C4CECE;
	Thu, 12 Dec 2024 16:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020187;
	bh=p3wc7KMPmbmkijJo5Y7p/i4F5JDnowj6dyAT4VAw5qA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xur1fsirvaxuk9dERDozGjGhmBHo+4J/NiI7C3BDolGCl18bRqFN81b4L2oylpEF5
	 xqH5yiPqZvnW0f7PoT2YUOT7XgYZkUG+5sX9OeCOZpx02bR6TGD7KESAqMEwmZA9XL
	 rsVNdi5aLTckga3RaJMZywwCe/E1ij42fQzz5rNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filip Brozovic <fbrozovic@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.1 401/772] serial: 8250_fintek: Add support for F81216E
Date: Thu, 12 Dec 2024 15:55:46 +0100
Message-ID: <20241212144406.486614046@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filip Brozovic <fbrozovic@gmail.com>

commit 166105c9030a30ba08574a9998afc7b60bc72dd7 upstream.

The F81216E is a LPC/eSPI to 4 UART Super I/O and is mostly compatible with
the F81216H, but does not support RS-485 auto-direction delays on any port.

Signed-off-by: Filip Brozovic <fbrozovic@gmail.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20241110111703.15494-1-fbrozovic@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_fintek.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_fintek.c
+++ b/drivers/tty/serial/8250/8250_fintek.c
@@ -21,6 +21,7 @@
 #define CHIP_ID_F81866 0x1010
 #define CHIP_ID_F81966 0x0215
 #define CHIP_ID_F81216AD 0x1602
+#define CHIP_ID_F81216E 0x1617
 #define CHIP_ID_F81216H 0x0501
 #define CHIP_ID_F81216 0x0802
 #define VENDOR_ID1 0x23
@@ -158,6 +159,7 @@ static int fintek_8250_check_id(struct f
 	case CHIP_ID_F81866:
 	case CHIP_ID_F81966:
 	case CHIP_ID_F81216AD:
+	case CHIP_ID_F81216E:
 	case CHIP_ID_F81216H:
 	case CHIP_ID_F81216:
 		break;
@@ -181,6 +183,7 @@ static int fintek_8250_get_ldn_range(str
 		return 0;
 
 	case CHIP_ID_F81216AD:
+	case CHIP_ID_F81216E:
 	case CHIP_ID_F81216H:
 	case CHIP_ID_F81216:
 		*min = F81216_LDN_LOW;
@@ -250,6 +253,7 @@ static void fintek_8250_set_irq_mode(str
 		break;
 
 	case CHIP_ID_F81216AD:
+	case CHIP_ID_F81216E:
 	case CHIP_ID_F81216H:
 	case CHIP_ID_F81216:
 		sio_write_mask_reg(pdata, FINTEK_IRQ_MODE, IRQ_SHARE,
@@ -263,7 +267,8 @@ static void fintek_8250_set_irq_mode(str
 static void fintek_8250_set_max_fifo(struct fintek_8250 *pdata)
 {
 	switch (pdata->pid) {
-	case CHIP_ID_F81216H: /* 128Bytes FIFO */
+	case CHIP_ID_F81216E: /* 128Bytes FIFO */
+	case CHIP_ID_F81216H:
 	case CHIP_ID_F81966:
 	case CHIP_ID_F81866:
 		sio_write_mask_reg(pdata, FIFO_CTRL,
@@ -297,6 +302,7 @@ static void fintek_8250_set_termios(stru
 		goto exit;
 
 	switch (pdata->pid) {
+	case CHIP_ID_F81216E:
 	case CHIP_ID_F81216H:
 		reg = RS485;
 		break;
@@ -346,6 +352,7 @@ static void fintek_8250_set_termios_hand
 	struct fintek_8250 *pdata = uart->port.private_data;
 
 	switch (pdata->pid) {
+	case CHIP_ID_F81216E:
 	case CHIP_ID_F81216H:
 	case CHIP_ID_F81966:
 	case CHIP_ID_F81866:
@@ -438,6 +445,11 @@ static void fintek_8250_set_rs485_handle
 			uart->port.rs485_supported = fintek_8250_rs485_supported;
 		break;
 
+	case CHIP_ID_F81216E: /* F81216E does not support RS485 delays */
+		uart->port.rs485_config = fintek_8250_rs485_config;
+		uart->port.rs485_supported = fintek_8250_rs485_supported;
+		break;
+
 	default: /* No RS485 Auto direction functional */
 		break;
 	}


