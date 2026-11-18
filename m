Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046703;
	b=Jh/39HHBcziBrK339QNkZ9vvpIfPx5BzAfGPL8CMhHOQpvg1Bn5itC3gxxRlqfHB2Tz6
	 ZfiSqQQfer7Q+UMhL0XJb6Uo0UuTQwc29w1W/f8ViLiejMn/dcxddBrUugLs/NXveXBeb
	 o+GzNRGfB2EQlJFLiAgXKG55mcfzm3K2+wAbVMCBc1q/dlQWvzskCt6/ANoPoumteNSzR
	 Lv8/HMyj983NaQ34bEtXG7a+Mym2z60EHpv7IT+a2u4dYNx2koXwLrbd7XY6b7lufoZx9
	 JUkmqhW9DumAuk/IEf80PQxbeoPDKe1alYhXNe9HBFOXwgtY5ZwCtoZDoccByEpy/+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F6ZeCI5QW5i+BetHaZjA0Y5ZPADYIkXckU+TPtjktlQ=;
	b=NytSjWv3FSf7kUp3tYK/60JL3310yz+VcdvJ98olOKT/ql6L+YFgbPq+i7GXeQ+qdhpY
	 Hi90TMuXewF5VJrTi4McNn6CjPcC+HQhANBVq1pBXfaUbHLhbelJkWGi7PBwDtf/P309I
	 hilNYgqKOKeOwq3gW5haTblOUbrruzPZAFZDHYkHcFY6/0xzRRYdgZrE1o/1QYXKpMZE2
	 pwo6gpTXfsoN0FZXcYEi/PaVlHqqEJI+cJLpXajzBB74VFlpL8TmDQzfz1THIKwKM0MJy
	 gPRSNjlKnh2FJ+M++EOcWf47i+J6J7cniGqcegFfaBezeQGjVpkoI5NkaMsq5v05Ldw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lWrsctI9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2595C606A31C;
	Thu, 19 Nov 2026 00:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lWrsctI9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774E41F000C4;
	Thu, 19 Nov 2026 00:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046703;
	bh=F6ZeCI5QW5i+BetHaZjA0Y5ZPADYIkXckU+TPtjktlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lWrsctI9TJ2aUfcX0IJNpXawld3spBeJyxV48QyZtku5QGN69e12wdac3LGRJLvMs
	 9/BRSV6rYlFE6wgwn/p2WmMK0qvhos6MBnBSSuc23EoAvtp7oWSSr54cY7n8HwmNbp
	 GB53wdx3D4tS1lCEzLihCXnG96/JRjibjfkDnMHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ali Resool Tuama <aliresool567@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1373/2857] USB: quirks: add USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE for GameSir G7 SE
Date: Wed, 18 Nov 2026 15:40:07 +0100
Message-ID: <20261118150250.821872904@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Resool Tuama <aliresool567@gmail.com>

[ Upstream commit 40224df29729618ecd88c5c0077e71b1e82c7a3a ]

The GameSir G7 SE wired controller first enumerates as 3537:10a0 and
then re-enumerates in a mode it picks from how the host enumerated it.

When the configuration descriptor is fetched the Linux way, 9 bytes
followed by the full 80, the controller disconnects about 1 ms after
its string descriptors have been read, before SET_CONFIGURATION, and
comes back as 3537:1082, a generic HID gamepad without force feedback.

When the configuration descriptor is fetched in one 255-byte request,
as Windows does, it comes back as 3537:1010 in Xbox One (GIP) mode,
which xpad already supports, including rumble.

Skipping the device qualifier requests (USB_QUIRK_DEVICE_QUALIFIER)
makes no difference; the configuration descriptor request size alone
decides the mode. Add USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE for the 10a0
identity, as is already done for the ShanWan Wireless Gamepad.

Cc: stable <stable@kernel.org>
Assisted-by: claude-opus-5-5
Signed-off-by: Ali Resool Tuama <aliresool567@gmail.com>
Link: https://patch.msgid.link/20261002-master-v2-1-24b05d8792b5@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 23d5c30332ffb..ee439a2ddf316 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -607,6 +607,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* ezcap401 - BOS descriptor fetch hangs at SuperSpeed Plus */
 	{ USB_DEVICE(0x32ed, 0x0401), .driver_info = USB_QUIRK_NO_BOS },
 
+	/* GameSir G7 SE */
+	{ USB_DEVICE(0x3537, 0x10a0), .driver_info = USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE },
+
 	/* DELL USB GEN2 */
 	{ USB_DEVICE(0x413c, 0xb062), .driver_info = USB_QUIRK_NO_LPM | USB_QUIRK_RESET_RESUME },
 
-- 
2.53.0



