Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3669A230BF9;
	Mon, 10 Mar 2025 18:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630933; cv=none; b=SS+vJSvbSgbbRvIi7A2AtgdeEnQ+w9qMnr0rLzWBVo0sj6r8heg1fKyj39zJSxSQqWaqMIJQeo3OHYEU5CUxjofVdd+qTn3FnKjZdeh6T6u382eeQhU69gPPKJb3nCSsi99zQRO6+1VLgufeqzur4w3KWilweDrsgaaIvG+yJIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630933; c=relaxed/simple;
	bh=kPGuL+NwJ3pvr8T0Hc9mDHFrDL53KE57GAkio42+fjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpwtT35p45G/VjV6ytfmhGihNp/BaV803lMF02fOUBDCO5Utyc77huswYkR9mwIlWLhgkpfBTWnsp30W4C3AKcYqRCRVzzeYlUBYeXyjjkBeLUNOsmZQkZHNYzNHSRJfS5DxxZZF74N/wJnVDBt+D4/txk+MNSspnYZALRNO1Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ICj1DEtu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ICj1DEtu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AEDC4CEE5;
	Mon, 10 Mar 2025 18:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630932;
	bh=kPGuL+NwJ3pvr8T0Hc9mDHFrDL53KE57GAkio42+fjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ICj1DEtuUCN8j3qbtGFS9Jws+tSvs7l0hzLnH8n9ZoneQEb3Ovhy8Miti1wvL3wyf
	 /KmaDfs42fNkuqNuWrkSQrZ+L8cHbCkAQ9p8GoNDokFNj6S1P2Pr7YWBr8TvnnxzFZ
	 EVeYOGcIVxYm0PukP+clmGibGnkg52P4uWUgVnzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 584/620] usb: quirks: Add DELAY_INIT and NO_LPM for Prolific Mass Storage Card Reader
Date: Mon, 10 Mar 2025 18:07:10 +0100
Message-ID: <20250310170608.586282951@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miao Li <limiao@kylinos.cn>

commit ff712188daa3fe3ce7e11e530b4dca3826dae14a upstream.

When used on Huawei hisi platforms, Prolific Mass Storage Card Reader
which the VID:PID is in 067b:2731 might fail to enumerate at boot time
and doesn't work well with LPM enabled, combination quirks:
	USB_QUIRK_DELAY_INIT + USB_QUIRK_NO_LPM
fixed the problems.

Signed-off-by: Miao Li <limiao@kylinos.cn>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20250304070757.139473-1-limiao870622@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -338,6 +338,10 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0638, 0x0a13), .driver_info =
 	  USB_QUIRK_STRING_FETCH_255 },
 
+	/* Prolific Single-LUN Mass Storage Card Reader */
+	{ USB_DEVICE(0x067b, 0x2731), .driver_info = USB_QUIRK_DELAY_INIT |
+	  USB_QUIRK_NO_LPM },
+
 	/* Saitek Cyborg Gold Joystick */
 	{ USB_DEVICE(0x06a3, 0x0006), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },


