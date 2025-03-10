Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A48233136;
	Mon, 10 Mar 2025 17:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626911; cv=none; b=qn8yR2jd06UHl2FyNigouJaASOY6XQ8dDoOxbyvUeu7WtltXX8anlI+07hTSDMEDF/uFEdzXiwwGzLiCIKZdS5okJwqyDyqLduVS7WsftZkP1zAFXMGvqH1+M+1EFa6Ggto7ataZS7RSnBSc4ybFeT4B7Zj+kIbUxf+9Ge40WiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626911; c=relaxed/simple;
	bh=bYuhZdSS65lc81U6Qym3rg2Lhorlgfl88WcSB/++4Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pc9KDPqzCj5AQv/BnkR2Q4pdHrE8uU3oWz2CdlknHwwye281zMKLgeM4i06tTvnLtTxpd0XPHRJORXeehLZN2I5WeKbisA7tQDjlaJykn7DkTdOnu7cv8LhjZc7WNiq/KZIEHuukrGbnvhJQ8csp0JvyMxduHNLEW5T4PMGO/S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1AYXRC4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1AYXRC4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551ABC4CEE5;
	Mon, 10 Mar 2025 17:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626911;
	bh=bYuhZdSS65lc81U6Qym3rg2Lhorlgfl88WcSB/++4Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1AYXRC4fhubfPVR2F0R5e22djYsVc3Rc2/P/lywhqvKIr2XDyZmiKUorTHKT2dpSz
	 5Cw0P4jmoteFeNM5KJ/kgOxCYGMCeELZ/N8YiPm2PIbTBHiH+ytk6DIiOIolNT3evv
	 ZLojwL8coOv4Ryx0VXmtS0QOAW/Ly8gB8nc0Ecew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 6.13 156/207] usb: quirks: Add DELAY_INIT and NO_LPM for Prolific Mass Storage Card Reader
Date: Mon, 10 Mar 2025 18:05:49 +0100
Message-ID: <20250310170453.995550192@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -341,6 +341,10 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0638, 0x0a13), .driver_info =
 	  USB_QUIRK_STRING_FETCH_255 },
 
+	/* Prolific Single-LUN Mass Storage Card Reader */
+	{ USB_DEVICE(0x067b, 0x2731), .driver_info = USB_QUIRK_DELAY_INIT |
+	  USB_QUIRK_NO_LPM },
+
 	/* Saitek Cyborg Gold Joystick */
 	{ USB_DEVICE(0x06a3, 0x0006), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },


