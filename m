Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139C41DE4C7;
	Wed, 19 Feb 2025 08:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955056; cv=none; b=dw7ijpm6DZYqiok6NKxLl5TAF8GWxMeYjFwXg9W+0uWHd/4uKaNeBNV71JnABljQqEl+DdJjqtGERBiRN6H2nu+4TPDoR7e9GQ9nWA0IqRNqZlAwr42Fdpa1Y5fPgfisSfeX98b0fVe5crTER/h157RpXs4rvT3s/jsKuz230ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955056; c=relaxed/simple;
	bh=3gDMKrQrFu56poaLT3Hf6VSB4llPy524KBTcneUnyL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHSstgZYXrysjIkJAvUAVzY8RsYnhrH3Qfi42A8B/DdmlZrQBhnxTqhIO/MaiLqUvigDxVxr7jxmp/f/gU8LybPzZV4WdSBtCz0adX5pMWuo2ZRSHjfXhmOVJeyEkM0p5LUbCNyKpybIvCgIC/ck0Y0Mfhe/MjFuwR66k/pPNoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xU0+A5VY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xU0+A5VY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDA3C4CED1;
	Wed, 19 Feb 2025 08:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955055;
	bh=3gDMKrQrFu56poaLT3Hf6VSB4llPy524KBTcneUnyL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xU0+A5VYrd9rYKH4j/3ZLkYjqxkuPwE39Oe/cYs7VQMDmNS/ZDOwcgcUZ3bV02Vxc
	 M6syzvRxe8EGea8yw4kPpv71b7QqYTu+LcZTw8vzWUVlA+8KvLV1GpIk5SCl0FpAYw
	 QfG3gFc5wkvI/jRwmo6Q7GvgcBF7Yry2/mwRDrEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Huang <huanglei@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 117/230] USB: quirks: add USB_QUIRK_NO_LPM quirk for Teclast dist
Date: Wed, 19 Feb 2025 09:27:14 +0100
Message-ID: <20250219082606.267789052@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lei Huang <huanglei@kylinos.cn>

commit e169d96eecd447ff7fd7542ca5fa0911f5622054 upstream.

Teclast disk used on Huawei hisi platforms doesn't work well,
losing connectivity intermittently if LPM is enabled.
Add quirk disable LPM to resolve the issue.

Signed-off-by: Lei Huang <huanglei@kylinos.cn>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20250212093829.7379-1-huanglei814@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -522,6 +522,9 @@ static const struct usb_device_id usb_qu
 	/* Blackmagic Design UltraStudio SDI */
 	{ USB_DEVICE(0x1edb, 0xbd4f), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Teclast disk */
+	{ USB_DEVICE(0x1f75, 0x0917), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Hauppauge HVR-950q */
 	{ USB_DEVICE(0x2040, 0x7200), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },


