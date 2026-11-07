Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064623;
	b=bUqwKONJ6/0boE/8MoGdQPtHmDwGdJ9kUjnJrg0b+wGo7kiOEnzgE8eIPdJTFfm/OvT3
	 XLFGyoYv6WrRNXEbngkYaZddR6fDua2l2b2bocH/zs190GuA2xVbACCbnfkPU2NnJoGkD
	 PUjZMmJYehq+5q+8V5eftSCUpalrKO3DQSiGH/CkO0QxkKcG6gJBidkNaV9iYSn25YZjE
	 chfBeCFgXdCamWBMHIA5QJJ4fW1P2k3fHaK7UPw/y60slQSOf++gFvw590gnY8sVIUThB
	 mDeRRLPNCaxuBnVAtrGGVMNvS/R9vtfK+uZB4Ua6MwfKXqc1m2DsXblPEVvXZZ2vGLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064623;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=axpHqBWsMUgU2JLJ1UNRqooeiq5uYx77CXnJLOeMMO0=;
	b=DB881Zy67Ex1WXV60XrF0Vic4ZtMmMoY+O2F3EVDyjAP/GFxr7WkbkBk4Jh1f7CuFYpm
	 3OQURNUdePvwG7vqx24ctOul4SOm1Ya6t9xVjFt83XL8DTUncMoFmQfz3kjiYiMhOgRhU
	 kpA7nDKSSYBTMmyPebmPodq67MAcA1lQSN2tat6zIInw77M+/5zAgOz7whcsYrN/BekHR
	 eaKaDCDhCanB2B9k61nfSp1iJZyVV2coKKk6Mmqj4V+2eZm/JS8raJoPX+as/rjn44MrZ
	 LhhsOIVJK/RzDe3VoDALBsgIx80facv4bYV1DbpHSCyq3TSHHsEquyehY0cF/jfFd+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZT+akseS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF8D606A9DE;
	Sat,  7 Nov 2026 15:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZT+akseS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1D71F0089F;
	Sat,  7 Nov 2026 15:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064623;
	bh=axpHqBWsMUgU2JLJ1UNRqooeiq5uYx77CXnJLOeMMO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZT+akseSbQScLh5syINAJDzJRtMlDwhw9/YWN0JX3XyQXZysXhioDNM/tImOLGx06
	 Sa6CW+1NYBzsuLMApYIAzsbg8PvyAE3iiIRAB8l4lJ7/suxlK0IEZURKjnTl3Fljak
	 peMmf2GfHCC6Q8sQDwsQ0PaThGPJQov17fQkTTpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ali Resool Tuama <aliresool567@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0625/1257] USB: quirks: add USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE for GameSir G7 SE
Date: Sat,  7 Nov 2026 08:48:41 -0500
Message-ID: <20261107134956.556392314@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b5b577f0b931c..a4bcbe9c913cf 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -612,6 +612,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* ezcap401 - BOS descriptor fetch hangs at SuperSpeed Plus */
 	{ USB_DEVICE(0x32ed, 0x0401), .driver_info = USB_QUIRK_NO_BOS },
 
+	/* GameSir G7 SE */
+	{ USB_DEVICE(0x3537, 0x10a0), .driver_info = USB_QUIRK_WINDOWS_CONFIG_REQ_SIZE },
+
 	/* DELL USB GEN2 */
 	{ USB_DEVICE(0x413c, 0xb062), .driver_info = USB_QUIRK_NO_LPM | USB_QUIRK_RESET_RESUME },
 
-- 
2.53.0



