Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063259;
	b=3vl2pqgdCIcpcQvYCKu0NQfF0IMdzcqUT0iJ1zhOviDrDvJ+GFgQ66LaZMTf0bytVRu6
	 GDkBaWnDWEdcBEOc4l/c2tmPZznAjR/AVNZlDOo6fjcDEJMCvbVp/IUxO5bOAjfGmCAFY
	 g57mealyPpfrtl7lPbK+esF8tgQesSj8MXC96ZFissqPUsYuFnvEhz3tyCS08YPrTUF+A
	 ERl2yZDxle+bLOI5EtQhGNNxkzgDct2NCdaNRxRy2n61Vv2txt9pFaJNWkLzyK5eDDnZZ
	 rR+VRl2Aew5kuCM4ANuX8SDOKBmQd4XOYO8J2PWZGCqOsgqVDV3BMhj/eTDtg+VwaFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063259;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+n38DzSX5a0rLMiyJFVtPm7JBKfx2v6eLQePS6UeGUA=;
	b=AJZjQP1/S8REUAwJCWmljgzSYfdLwW0cxCqyu9HbAGSOCFKXgAafefwSWAct7JVbNllG
	 dWv9PjHwep7YKVCvDKLlEIojOvXr0RLAqT+OBSey06Ow6zo1z65jDg8O3VKUIh89B/g6d
	 /6OxQS7baD+J/+oM2hO5yLLG78N+chXuZUjQiR/bIg7TMGziPNHHI/CTxX2oFrbwXnhhZ
	 EKVcqiXdKAqW+zUe+ufI3TPruSNy0P1FL3M98Ez9IXwBY+bGe7QmnWt9eww+Q4dLrKaWO
	 j6WHAfhU/hsZuhpKyzT0KbYPS2U/LPWN91/6g+En8XjQj1wJXcE9PDSByTE8H32ha3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VnutTCUa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE481606D81F;
	Sat,  7 Nov 2026 14:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VnutTCUa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FA51F0089F;
	Sat,  7 Nov 2026 14:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063258;
	bh=+n38DzSX5a0rLMiyJFVtPm7JBKfx2v6eLQePS6UeGUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VnutTCUafdat0soyZ3hyo/Ac7+1XKacHzBtNI3ccXG8U48Z1a4mQAD0vetwx9zzSW
	 249z2/CbMwSds/oX3x29HZx9uhZc02qmIv/Z2DeK2Ak+Hy+jVH1uvaSsh6evKbpSMS
	 fkyqxZ8E4YuzrnXIOunV/TwO8ygCDtgWOjH/Uu4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ali Resool Tuama <aliresool567@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 459/869] USB: quirks: add USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE for GameSir G7 SE
Date: Sat,  7 Nov 2026 08:52:21 -0500
Message-ID: <20261107134909.247656005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0f804a52ab763..a8e5016fee982 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -613,6 +613,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* ezcap401 - BOS descriptor fetch hangs at SuperSpeed Plus */
 	{ USB_DEVICE(0x32ed, 0x0401), .driver_info = USB_QUIRK_NO_BOS },
 
+	/* GameSir G7 SE */
+	{ USB_DEVICE(0x3537, 0x10a0), .driver_info = USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE },
+
 	/* DELL USB GEN2 */
 	{ USB_DEVICE(0x413c, 0xb062), .driver_info = USB_QUIRK_NO_LPM | USB_QUIRK_RESET_RESUME },
 
-- 
2.53.0



