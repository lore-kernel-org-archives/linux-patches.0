Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565D71DFE1E;
	Wed,  6 Nov 2024 12:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897871; cv=none; b=V1XK4UiSZ8ejOKhZO/g8HExMzit6Ff3K0r/qynQKXYANiO9tItVJZYE6QDggKMruH4sX7KvyT7Bl6lYFwswPXPA35xOJqomFCPcqeJBupnmYcfIv2uW17uxahlRpDE12JOiDyD+8buqIRz5WQ/w5CAZUwGR6JR3Yh0wwz12HawU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897871; c=relaxed/simple;
	bh=UsZVFBfv/m6azL45kOIvzukNiHDOe3bScD+Mv2GzXX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uSgK8eLLOYhTxmbQOA9jxIB6lXTiCbYj9mPBFtXDFtgXjoKbANx3xVEhCYyQR3uSDIQ6BdtyF5HxWu0uoGdGHuwyY1p3FCGD/nA/D4K1HxesoT+MAkIXmb/sjUBRveoa1UiZJcDtskiFx5oeBbgGR5274PGr2BZZZVona3Vo/lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XETZzGlx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XETZzGlx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06E9C4CECD;
	Wed,  6 Nov 2024 12:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897871;
	bh=UsZVFBfv/m6azL45kOIvzukNiHDOe3bScD+Mv2GzXX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XETZzGlxZb05IfimbWz+n40WS/FRPQG3x3xM5hatTAmhfDkjlEqFrsTlChtS1YojM
	 XOWNW0MPgko9f0oTmUTgVQUKZAjTUMiuxSQWhbfq+KErZdbnmUI2G/CLu3R1lvKndu
	 h5QMhEpiIfU6wrJS7TaWEUbfo1lgDRMp1C1hCyXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao Xie <bigfoot@classfun.cn>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.4 030/462] USB: serial: pl2303: add device id for Macrosilicon MS3020
Date: Wed,  6 Nov 2024 12:58:43 +0100
Message-ID: <20241106120332.262254813@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

From: Junhao Xie <bigfoot@classfun.cn>

commit 7d47d22444bb7dc1b6d768904a22070ef35e1fc0 upstream.

Add the device id for the Macrosilicon MS3020 which is a
PL2303HXN based device.

Signed-off-by: Junhao Xie <bigfoot@classfun.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/pl2303.c |    1 +
 drivers/usb/serial/pl2303.h |    4 ++++
 2 files changed, 5 insertions(+)

--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -112,6 +112,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(SMART_VENDOR_ID, SMART_PRODUCT_ID) },
 	{ USB_DEVICE(AT_VENDOR_ID, AT_VTKIT3_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_PRODUCT_ID) },
+	{ USB_DEVICE(MACROSILICON_VENDOR_ID, MACROSILICON_MS3020_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -165,3 +165,7 @@
 /* Allied Telesis VT-Kit3 */
 #define AT_VENDOR_ID		0x0caa
 #define AT_VTKIT3_PRODUCT_ID	0x3001
+
+/* Macrosilicon MS3020 */
+#define MACROSILICON_VENDOR_ID		0x345f
+#define MACROSILICON_MS3020_PRODUCT_ID	0x3020


