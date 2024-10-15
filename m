Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D5A1E7C00;
	Tue, 15 Oct 2024 11:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992337; cv=none; b=mc4eIz6rDuPGBRPkDSBHEmXCMH9DtY+2o9tzWmzVhJr5V63d/ywAO+/2VpQYBj5qwifvF65tt4luU3KOTVHuy0IvChDQxELVTa8kLN1V6akOVemisvNBVfAM6hvHP5YlzHduhen7+ShYAlHkCJUUTmXQcaT1u2yqFBNYFxK8toE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992337; c=relaxed/simple;
	bh=7Sg5iwIPt50TDq8Nk3bOfx4+gRTioCYATzz2FkkZgj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfpegR78kYg7mempRLtDroU0jS5EHum5WlC4xw0YLK00wqs88zIjAuYI2J1sES8cib8kPN7Z2Hse/k24f0tXHEbEJ2hdFB+ptZjQPSOnAHaJGiLJ5dqHZHJhbwRfGZAfRS3xhOd72fFJwsoAG5flZ80i0f79mQXXC+y6gMgGDDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/MzaZVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/MzaZVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B579C4CEC6;
	Tue, 15 Oct 2024 11:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992337;
	bh=7Sg5iwIPt50TDq8Nk3bOfx4+gRTioCYATzz2FkkZgj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/MzaZVj5RQ8gPBplu/Yj7jvIJisTe2RFtOOP6mk60TLqjXWCrdqim0NKX4Mu7/sl
	 KbXHZEUNbjPpGZ+E1Kw84RaqfHuTvZgchSUtaKIEJvZOCSn5hMyTZDetmEspivMfV+
	 Lrm3DAb4R2h8I0a2tiFaHND3BgQIlN+el+CmS0ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao Xie <bigfoot@classfun.cn>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 088/691] USB: serial: pl2303: add device id for Macrosilicon MS3020
Date: Tue, 15 Oct 2024 13:20:36 +0200
Message-ID: <20241015112443.858393173@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
@@ -118,6 +118,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(SMART_VENDOR_ID, SMART_PRODUCT_ID) },
 	{ USB_DEVICE(AT_VENDOR_ID, AT_VTKIT3_PRODUCT_ID) },
 	{ USB_DEVICE(IBM_VENDOR_ID, IBM_PRODUCT_ID) },
+	{ USB_DEVICE(MACROSILICON_VENDOR_ID, MACROSILICON_MS3020_PRODUCT_ID) },
 	{ }					/* Terminating entry */
 };
 
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -171,3 +171,7 @@
 /* Allied Telesis VT-Kit3 */
 #define AT_VENDOR_ID		0x0caa
 #define AT_VTKIT3_PRODUCT_ID	0x3001
+
+/* Macrosilicon MS3020 */
+#define MACROSILICON_VENDOR_ID		0x345f
+#define MACROSILICON_MS3020_PRODUCT_ID	0x3020


