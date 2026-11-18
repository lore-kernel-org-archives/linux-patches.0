Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058069;
	b=AZ3gcbnpzVwpojgqpw6kHnxWnIFsbUnB70vm/VsrB0QkLIdp/v/ktcgLXzO/2VQYCs4j
	 6F4X8AZFYFxN+H+9vUUgrDiL9h8rNVPXu25GkDiIvkoGertzG/AQBGdfmo3m63EGhos+1
	 07BDwJKaMqMLWT6eT0g+haLBUAWTWck7+vj9ApHb+mISJBjmdPrZWLBw85YjqvecIO1wr
	 TxLwsHKQ+b5qgk85hwDO904kVuogoe7184M3XNk167EMyFQqbjS/v4HJA358Ietn93TwL
	 /sD6wi8Pmp7xzX7NYfOi1EQKdi1FFFJ6+VgFdqfLMjxpuNoQN2UAfGeRsIOoaCGbpcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ie7y+FpHXBAyM03ngNss3vuqdutSJdG7IWuygI/NeGI=;
	b=q6cdjUOefdegHH90gxda9sOwpyq3Fbzdw1QV7rXmiDmcx9woklXY7NsimZQuM6kzl1ws
	 OqAm3homxaBFWm3iJ8Dd7rv2KIL7MT8yFw+jcAfrtpCz7x11aCgGKH5LICxPsXpDq3rnA
	 p1KQ275q5iUzGF1W8gwe0xiuB/V0H403Eoka8QjD8w24g/Cb48kUh6j+w90cfqbwGKFhL
	 VRINTfnBgS6yuEzES8zQDeBualFg93UGM1B8HXTnJnCMBxyCVPzDIGrtyIWlqAGGslD04
	 jpmVpdOl7y2rvcI0KXopPRr4uBailKi9lGARvt47b0LdbiDU3GlQvC44iXq950RUGXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mln26YEI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EB4606A31C;
	Thu, 19 Nov 2026 03:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mln26YEI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98521F000C4;
	Thu, 19 Nov 2026 03:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058069;
	bh=ie7y+FpHXBAyM03ngNss3vuqdutSJdG7IWuygI/NeGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mln26YEIWi0RJ8X/BsMWnYVhPQkB0dtR97SCdr1jn1x6B2Sn9DxF2b8dShebE4NMZ
	 CfREuYRIm95Hrh/24KFKv/HUmtjt+bPNZPXi5YcsIKiX3ZmCZkbcQq1xQo4LCXKVHL
	 jiP5fcB3unQmG4i4YStUiSW77ownjP4KlEM6IemE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Tanz <gabor.tanz@gmail.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.10 0313/1848] HID: quirks: Always poll the Anne Pro 2 with product ID a292
Date: Wed, 18 Nov 2026 15:39:11 +0100
Message-ID: <20261118145925.344097465@linuxfoundation.org>
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

From: Gabor Tanz <gabor.tanz@gmail.com>

commit cbc13a78a89d087252947d0a51048e576cfcb3ef upstream.

The wired Anne Pro 2 identifying as 04d9:a292 stops delivering keyboard
input after a period of inactivity. Unplugging and reconnecting the
keyboard restores input.

Keeping ObinsKit running prevents the problem. A read-only userspace
reader that keeps USB HID interface 1 open also prevents it, as does
usbhid.quirks=0x04d9:0xa292:0x00000400 without either application running.

Commit ca28aff0e1dc ("HID: quirks: Always poll Obins Anne Pro 2
keyboard") added HID_QUIRK_ALWAYS_POLL for product ID a293.
The variant identifying as 04d9:a292 exhibits the same symptom.
Apply the quirk to this product ID as well.

Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Gabor Tanz <gabor.tanz@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h    |    1 +
 drivers/hid/hid-quirks.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -652,6 +652,7 @@
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A081	0xa081
 #define USB_DEVICE_ID_HOLTEK_ALT_MOUSE_A0C2	0xa0c2
 #define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A096	0xa096
+#define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A292	0xa292
 #define USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A293	0xa293
 
 #define USB_VENDOR_ID_IMATION		0x0718
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -102,6 +102,7 @@ static const struct hid_device_id hid_qu
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FIGHTING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HAPP, USB_DEVICE_ID_UGCI_FLYING), HID_QUIRK_BADPAD | HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A096), HID_QUIRK_NO_INIT_REPORTS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A292), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HOLTEK_ALT, USB_DEVICE_ID_HOLTEK_ALT_KEYBOARD_A293), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_LOGITECH_OEM_USB_OPTICAL_MOUSE_0A4A), HID_QUIRK_ALWAYS_POLL },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_ELITE_PRESENTER_MOUSE_464A), HID_QUIRK_MULTI_INPUT },


