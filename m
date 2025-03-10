Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40DC22CBED;
	Mon, 10 Mar 2025 17:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627680; cv=none; b=Mr50nIVoWRwqYGh/vfYbng7Phup5wPfZ4F0cQRt873esMfl4kw7OAN7HA6kmq8PMjfHoWOhyg8j3bbsTHQZn2WWvid/+LA1dT6sedHzGK+S1QCGbiHMmnAHkpU2Sp7Yjyzc1QHwsOGlR/78epGd+t/r4Kw/m2rdTWvxInkreuio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627680; c=relaxed/simple;
	bh=E5sQnE7RdIpiJoY+tSE5stROOAqDyopH6U9uTGMaD5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMtLNloYCAx1l2pQ3AV6Wi/gL+dx2zHECQs2hmkeJPPm92p6jbrQyvgqwW34G1ftMRivJ7YGWtRl80y7WfCPGGJVIHOH2QqGs3KekdYr8dsD/MichIsnTNT51I3WJ91vRRQrESWnPyWWAA/Mrlgcf6I9vWYi6MIaEaJxabf13P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sivcqVnG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sivcqVnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78BBBC4CEE5;
	Mon, 10 Mar 2025 17:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627679;
	bh=E5sQnE7RdIpiJoY+tSE5stROOAqDyopH6U9uTGMaD5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sivcqVnGiz2I4nT7n2oPsuoBXTWdEaA90Uv4V8p0xM4OYmmaTGjHZWQ/lVbQ2KRsa
	 lIU+nk0/A54Xds0kiWaGdmFXGwvlTW4rAmOw1KaRmF6bE6UF3UCsJkgg7qcs+ESZC6
	 jyPhPjjPXJllFpX0ILOUgNkmftOEJiUw2Wx7Kqug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 211/269] usb: quirks: Add DELAY_INIT and NO_LPM for Prolific Mass Storage Card Reader
Date: Mon, 10 Mar 2025 18:06:04 +0100
Message-ID: <20250310170506.103193423@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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


