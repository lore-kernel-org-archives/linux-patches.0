Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B5417B515;
	Fri, 27 Sep 2024 12:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440167; cv=none; b=G9kXZWZxtjF9ggjaGwIQxDgyhbZZCojzFNsxF0pWCvFkxIRrBQbfyMuJX1eDJQNm/PT/Ky8MzPtdvndUg/iC6KShf+rtXRGa/hCsMa+FIU1GxEpnbXqZWOdtZYo5xAqBrH4CQswPBCrq8V2m9Vz9cznMjIClYeFJiTIjW7JsUl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440167; c=relaxed/simple;
	bh=+9ZTZ3wmBPm9NBuLdcExMX2TIMnr24ZsXhHiKZsm3LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5V4ghkC9O/2NJVY9f5XtpEj6Iz0vtlO40cl109sy7sW9LPJulLHft7zJ/+G7cMvh6mchZ8V7in3TWvwqN0BzQeJaNZXcsRvPMWeYZjewMJbr4GJPx7hCH6jgsMCtLFeqVTJiW5oY0SdXcKW818ISWJlnbqKyZ/1oM5Ju9Zqp8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZxLlhfa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZxLlhfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC824C4CEC6;
	Fri, 27 Sep 2024 12:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440167;
	bh=+9ZTZ3wmBPm9NBuLdcExMX2TIMnr24ZsXhHiKZsm3LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZxLlhfaH1PSrbBRdVWk2Hv2aQFU4cNFYNJvotFz7wVuStJbf+khcAr1S+/eysjcx
	 XoiM5kyfEu9Se/OmzVmn20JQqXhXcFlM3j4KhOiEy90pl8ct4NC1nQeTSoEc59j8hJ
	 M2oFXKg8Pd8K35aoglPw/zQEaNAdVJyHck9Z58Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao Xie <bigfoot@classfun.cn>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.10 57/58] USB: serial: pl2303: add device id for Macrosilicon MS3020
Date: Fri, 27 Sep 2024 14:23:59 +0200
Message-ID: <20240927121721.169761256@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


