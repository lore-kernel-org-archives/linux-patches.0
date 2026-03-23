Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04783B27D9;
	Mon, 23 Mar 2026 15:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278325; cv=none; b=nNi6z3ccxZ0dg+4en+GEFDtb++C1Fqf53dyKKOhnlXgykA8hE0m7QNFAz9XC2/rW64A8YIoWH4apapig93JJ3c0PP226D8D7io4/HAtH62NPAUdEuIldejMV25NVwmsRAIGXsjL5Rxc+AVD9BU6mi+I0eK0LG4+zoMKtaXWWRxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278325; c=relaxed/simple;
	bh=ygh+FxHCDKvR3ZVMKXY7yo8EPhrFxxWGivRHA+U3YIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQofjR2EQleg/wWfUhhdWC3PFe7xinfvxi9cjKPvgVJgB0aFZwaWaqlFQ/aVxsjeWgaA5k5ehg7eU23CJLpQcn+aj21MTlS9fbBUwV4NVPd2yw4xXmpflHjwCSt0otIiB/J8LNnLdQ9wVoe/Ud5FDzNg4K/hYQssGTQx4jQkifE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QzY2oEsb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QzY2oEsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F88C4CEF7;
	Mon, 23 Mar 2026 15:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278325;
	bh=ygh+FxHCDKvR3ZVMKXY7yo8EPhrFxxWGivRHA+U3YIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzY2oEsbc2g6a/XUkVrz4NKwbyCO844xdcUAgneYj/weyf5dKyeJfNVeRLI+oQIQr
	 tUvOjIbdggg3sxzbNq9oYUBL8JTyaLAjvSXNlTIiD+ev5EmtGeeTJ2LeBZLJaCQMEi
	 ccoEi9C8j0WcXGBFAX1zf2U1+tQQQwHkeMu+pNkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>
Subject: [PATCH 6.6 270/567] usb/core/quirks: Add Huawei ME906S-device to wakeup quirk
Date: Mon, 23 Mar 2026 14:43:10 +0100
Message-ID: <20260323134540.514625204@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Sandberg <cs@tuxedo.de>

commit 0326ff28d56b4fa202de36ffc8462a354f383a64 upstream.

Similar to other Huawei LTE modules using this quirk, this version with
another vid/pid suffers from spurious wakeups.

Setting the quirk fixes the issue for this device as well.

Cc: stable <stable@kernel.org>
Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260306172817.2098898-1-wse@tuxedocomputers.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -208,6 +208,10 @@ static const struct usb_device_id usb_qu
 	/* HP v222w 16GB Mini USB Drive */
 	{ USB_DEVICE(0x03f0, 0x3f40), .driver_info = USB_QUIRK_DELAY_INIT },
 
+	/* Huawei 4G LTE module ME906S  */
+	{ USB_DEVICE(0x03f0, 0xa31d), .driver_info =
+			USB_QUIRK_DISCONNECT_SUSPEND },
+
 	/* Creative SB Audigy 2 NX */
 	{ USB_DEVICE(0x041e, 0x3020), .driver_info = USB_QUIRK_RESET_RESUME },
 


