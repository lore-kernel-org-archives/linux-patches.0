Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057568;
	b=V16sWw06bArsThpzF8bjmuXI7T8JOrnyTvBmQ8KeZInyWcVd9H/iu9X+qNRVLgEDoYHh
	 pb4zidvHHDQgVJV9waY4BwM8Xsw0fuP9LGmeZ2P9S/CGYH0YHSWERo7DnfS43lwpUaM/I
	 +BBj5AkKJdDhTF6bZPAAzjkiy49JkCv2mnrsUgGLuTJaIfWO8MI6iIXb5h5pqUFeH8m/6
	 XphJR/bmLRFz1c7Rxm5uLHGSt1h0GjPMxqMHR42QcXpgrPhTXngAU/fkP1lrenZv7Wu8k
	 ghuB2iZeW0OzDd5Bc4HvHx4KQSByosZpk5VAbkIKV5lNTMsz0GRgXiCwqrUNyHWRDeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rBFYhAuBnYGOWA0ivV7tUXEiaXPioc+BlaIQpDXHtPs=;
	b=3R4Le7YfxGrA3hqdwh3GpyYGyBWg+ZwPiqANSG6O4eoPMj2H5Rrb/JbN3aHMNNFSHAcu
	 7wZZmgckqPbQqslge8cPSw8mB4pR+Y09zqS9EiTedq8K6xlB4L1oCMxwieJ2XymiJyaKU
	 LTeKlklbw2u1gyjMr0wBx82FoZmCSi8AXScn72fx1lMH/mxIL8vAjhU0IYKGaBEEeu0Ki
	 z3pmhUzi+3on+NijTVV036Zse7g5/XWCKPQg9TjdmRrI9otx6+VeRpyjf7GbKQSLGV6hf
	 /2HquGHbardFtau3rNa5UTPcmb9adxuh5hIXjms37naNwuLlDwBoijWON0tBoTw1jFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hG7Bl9jU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4119D60A260B;
	Thu, 19 Nov 2026 03:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hG7Bl9jU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838C11F000C4;
	Thu, 19 Nov 2026 03:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057568;
	bh=rBFYhAuBnYGOWA0ivV7tUXEiaXPioc+BlaIQpDXHtPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hG7Bl9jUep93BjtSj7L2orilO28eVO56D2hU4rbm/Lizo6cwuCyFj4CCmyFw6xVoH
	 q3I95qqudtjB5ae00PuEQ5YmPo/aiCKorvcoKM20DDHcmoH9Ii97hu++ccVZOUyTa/
	 zYSBKC6wX4Q0vAlcGAwzupEsaz3BJGEKIZI5zxYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Ma <mapengyu@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0141/1848] HID: quirks: Add ALWAYS_POLL quirk for Beitong BTP-KP20D dongle
Date: Wed, 18 Nov 2026 15:36:19 +0100
Message-ID: <20261118145917.223485609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Ma <mapengyu@gmail.com>

[ Upstream commit bfff246b3a31cb45ec297ca5e2a77c1410b207ac ]

The BTP-KP20D dongle in Direct/HID mode (20dd:5159) re-enumerates every
few seconds because usbhid never submits its interrupt-IN URB: no HID
driver binds to the vendor-specific report descriptor, so the device is
never opened, and the firmware treats the idle endpoint as a lost link.

Add HID_QUIRK_ALWAYS_POLL to keep the interrupt-IN URB submitted from
probe time.

Signed-off-by: Aaron Ma <mapengyu@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 3 +++
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 553b7d84e5a2e..6b7b6f55a9532 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -229,6 +229,9 @@
 #define USB_VENDOR_ID_BAANTO		0x2453
 #define USB_DEVICE_ID_BAANTO_MT_190W2	0x0100
 
+#define USB_VENDOR_ID_BEITONG		0x20dd
+#define USB_DEVICE_ID_BEITONG_KP20D	0x5159
+
 #define USB_VENDOR_ID_BELKIN		0x050d
 #define USB_DEVICE_ID_FLIP_KVM		0x3201
 
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index cb3fbbc35ce4c..dc3acf69388c5 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -45,6 +45,7 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_CS682), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_CS692), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_UC100KM), HID_QUIRK_NOGET },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_BEITONG, USB_DEVICE_ID_BEITONG_KP20D), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_MULTI_TOUCH), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_PIXART_USB_OPTICAL_MOUSE), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_PIXART_USB_OPTICAL_MOUSE2), HID_QUIRK_ALWAYS_POLL },
-- 
2.53.0



