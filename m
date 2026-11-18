Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038099;
	b=f075Yk44K+bB52DHg6jeVs7mFDjZZ91jgxw8mUVAygXIMpwEPeddqCWgBtwwCgCr/tuq
	 T35zVJYzP6pLtpYAAmgO8WsQDAIilz8q8r/hZTqPDWa/mYOD3tDJGmWd9/U9jfctsVhnd
	 yTOpseKBu7ZDQ985Pp7VDRlxyhbiuY5qJIOnXcKNXQO2Eq69eUGFxR+sY1c5jrXaN38pb
	 ECGzKvhhn6FtD8jjCJlfEdW2fX9VgGyk3eJFVkk5LbSfdf+JcE7MwjHjycmd1vznYrdGD
	 WLEgg5cC1G//C3i79TWoCmSo9FGfqkLRhnIS2NtTH6CoiW9Al6ql+BHMeO1dyXDLx1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cTZDgt/dz+V75xkWg5lUoVN4uCGhWw/Lzr9hzX/PPuQ=;
	b=H4g/Ny+jFUGL0otHoZkiLjvJAQAA8/U1VLbPLBK0LWeIHi4MenvGkZh+6Pdn/xfJduks
	 Kxyc27Eh1or1eLuZPlJXiSsAW4Jbmj8NA0udbS8m8kFmyepNPfEedY0qO0M/JQgb8Q2I3
	 RnPON7YFAtLi5bhyYX7J46seXoX7BmLYWRZSe1bX9vU9HXted+hz1q6MqWAd2SD9ojqm4
	 Gw72EtolgBc3KULoYGs5JeKBCt/mevoEQf26Mb9+ru6aOTrA2C7tzDMHPAW/QvhIiSGI/
	 psmeuVZdL5enSgD1w+QBMTdryKiFWsHDYLJqFcWabYRYQx/9JnP/2GJTQDkWzIO1blA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kEpen2Z7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E500606A32A;
	Wed, 18 Nov 2026 21:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kEpen2Z7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3281F000C4;
	Wed, 18 Nov 2026 21:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038099;
	bh=cTZDgt/dz+V75xkWg5lUoVN4uCGhWw/Lzr9hzX/PPuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kEpen2Z7yqyaxvilsBi9Z5plKdPRBeHca8i//6UsHGpAF3ClR0D1Xi3z/BfY1ESuV
	 1D5i6QzEjqksa/6b5NnJ+BzoPZqfJUBIqODwOKvh9TdjRMyaiRyxQnMInMnAkiCZT8
	 fOZJW+9GUB2UM82QROprr3YrYUxL/dp5zpUOmCFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ali Resool Tuama <aliresool567@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1626/3318] USB: quirks: add USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE for GameSir G7 SE
Date: Wed, 18 Nov 2026 15:37:28 +0100
Message-ID: <20261118150410.515067273@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



