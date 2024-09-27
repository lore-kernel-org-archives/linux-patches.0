Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE9F1E507;
	Fri, 27 Sep 2024 12:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440408; cv=none; b=im+5tXem3uw0O46RhkFl4miDG9vzbfGJAZBjgdEwTdqveusuLi4lZJ+zTy+A8kt2g0OVJjn4zwroiWBIWTxF5gG6aZZDVEwpCuhGoAi3t1KXzlgZqAwnChYyeaqRsLdugxDG1kGxRG4YAqeG4UxdfZMUdNPsk6Ml5WbdkC4JuhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440408; c=relaxed/simple;
	bh=SqTQxNKA01Xd9/b/RenH9k3Hdu0Ik7BNMLEJ24LtVew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bjBWSv23Zdoi8vYtgd5Aiqn74cb3XhNe40z+CS5MjcavBMnVQXiLw1ahyqZpOVCDn1WQIeW3ytnqARFV1vdCSeo33avAvi5cvVbHwlId/v/zfGHFOJl3VQ4ZknW6CWw5ajccgDD33iYDRcu4mdi1PRbnRVAtkOS7LCjVYr21MlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtbH2Pw7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtbH2Pw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D607C4CEC4;
	Fri, 27 Sep 2024 12:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440408;
	bh=SqTQxNKA01Xd9/b/RenH9k3Hdu0Ik7BNMLEJ24LtVew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtbH2Pw7iOTq9q/Lrz0unEzaW94fOohwJr6MkUhGxTRzqpy66OLPbOGAFDEvy6Pwy
	 cRmy2Xj2R1fvD2XnRRtFZkykG8EqrCufkEnL7GGc5Z+x5LsssSivKxVLKotMuGfr6h
	 Y3rIC8boYwmpQeoy6/gkWfV9Nv72u+XnzWswMGFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao Xie <bigfoot@classfun.cn>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 72/73] USB: serial: pl2303: add device id for Macrosilicon MS3020
Date: Fri, 27 Sep 2024 14:24:23 +0200
Message-ID: <20240927121722.738781500@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
References: <20240927121719.897851549@linuxfoundation.org>
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


