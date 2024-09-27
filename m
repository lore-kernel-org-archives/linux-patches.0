Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF9718C334;
	Fri, 27 Sep 2024 12:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440203; cv=none; b=pg7hkUfeOP/xbngU9G+hB59PMFckkddtFPnH7nSaTZNG2pNRjSmMmoYhpgqgrv9LUNWy//e8LVuJYoqrZl+6gDuIk8RX3hV6jzYWIMKVkiqtgUejK+/w0OyeajtabY9WiVFeNq0ONKzhYARv2DeYX+vy07D8A24FwdoXnNcfXb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440203; c=relaxed/simple;
	bh=6mKtCDcaSTdAhhbQsOYak2S3Al73sV9lWTilmUnDeL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZDmDG7RHV1A2AejmEImztcB+QpYLe8oyNZfUrEWmNe8tDBvAEf2dykKCtK81cuwmFxrqnRIWc57JqArD7cXIaxQ7sf2vsR2rRAVjT25h7BtCyKjVDiikcSs5D5R7U93uwXhrr0z+hcL1wYCFJQ7XWGY5OBIcwbRzXXgh+JE8BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnrR59rn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnrR59rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4F4C4CEC4;
	Fri, 27 Sep 2024 12:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440203;
	bh=6mKtCDcaSTdAhhbQsOYak2S3Al73sV9lWTilmUnDeL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnrR59rn86EnM60c0mdi31gD2/2J3pklhP0saS3nUUbEb2uZwpY0MvwgeUhKFHQ7O
	 KTwqbA0eJ9X39elu6hCrKf+c4rUn0Mku4fx30pD7xXZ2VE4u03d2yDo4uBDduB8QO9
	 cjeKZxa4GGh2AVp48bR7bL+UHZ9TfGq0fNsiNi7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao Xie <bigfoot@classfun.cn>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.11 11/12] USB: serial: pl2303: add device id for Macrosilicon MS3020
Date: Fri, 27 Sep 2024 14:24:14 +0200
Message-ID: <20240927121715.721263673@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121715.213013166@linuxfoundation.org>
References: <20240927121715.213013166@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


