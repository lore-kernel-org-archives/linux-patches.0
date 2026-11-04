Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829743;
	b=p9lxzSUmbhSZmH/y7zVXKb4HtEw4881HHZ1yS4EBXBICMdHGexX7P36kB5n3CxvMITA7
	 q07wtrgJDARgzAztDCx84ZawQhMMJxHQRQs6YBkVcWaVdWR1gNSGlAKRwDt2qifed/AcP
	 yvjvp+QpBnYEFQfmXewY3LUIjCYcxBKWSJXTRSN9/JiW+dw1jPkQEEU2zsgno4+Q4uztv
	 kU6RB2+1pa3/VokrW21wG+bdIy/tpJU77JPDTwb2JrlbvRr3EKoNNJhraclYbONuUkHao
	 ozR9OQ0k55lE/mLsI2vSszNWaT2ceDrz2Uuif63y1ZIINPs22EPxSgC6xmP/f/tw2Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829743;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d2EIXyg2OqPz7fOSMtsjhp6UXDMqvwZkNkpsdJKRvgY=;
	b=VLaPJGS2Uubv3Wi3ofzX9WPdKi7NMxS+7Ft3qHclQmJ6G85ElT8nueavxSOKEIK5awoa
	 zQ+oFdr266ZUaiUDbfkXIcyRDr4gzINNsiyF6WWa/0beUZMByttxJBLkrwOsR0e49MAAj
	 14zfrB8xGsNaWZa3coXiQVCLSE+A4MaB5w1PzMElGWXHtBGefGIq5AVrV8t13+FyZpDHm
	 XwLyLG0Hl47mj0XEMpw9xRZ3mOpJIBlSUyHB+QZes5V3eBlz8ccS9ctW2qOY1+HCjyBgd
	 UkPctPNslcWd68Bms2MFwYAFa7b3h1s+GTdxVwTEMnmBzuGTNYNm8KFpMwU2MJ6i+dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h5kdmDmN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930FB606BA25;
	Wed,  4 Nov 2026 22:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h5kdmDmN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323FA1F00A1C;
	Wed,  4 Nov 2026 22:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829743;
	bh=d2EIXyg2OqPz7fOSMtsjhp6UXDMqvwZkNkpsdJKRvgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h5kdmDmNbl+ofLeTWk1hn7UHk3oFHgPkzPHig94BomqXF4T7jsv3pXcY2GodS+qIv
	 n5FMXDqohs63dlKxGWDJ2KyrGYYe0VAXky9byEfFT9FLMzevaEOjyZgAiF+6VCduhW
	 vFGYG5n301x8AfnNrMDWuaaeG9c+bJFWNlf/8Dbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuxiang Lin <mclyxfdw@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0316/1005] HID: quirks: add ALWAYS_POLL quirk for AULA Mini 60 HE Pro Dongle
Date: Wed,  4 Nov 2026 16:00:49 -0500
Message-ID: <20261104211052.791174408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Yuxiang Lin <mclyxfdw@gmail.com>

[ Upstream commit 2884e21b18613708f050ec75330b265dd07ecc03 ]

The AULA Mini 60 HE Pro wireless keyboard dongle (USB ID
0c45:fefe) becomes unresponsive after roughly one minute of idle.
No error appears in dmesg; the only recovery is physically
replugging the dongle.

This has been reproduced across kernels 6.8, 6.14 and 7.1.3.

Testing shows HID_QUIRK_ALWAYS_POLL alone resolves the issue,
verified via usbhid.quirks=0x0c45:0xfefe:0x400.

Signed-off-by: Yuxiang Lin <mclyxfdw@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index c1a7f5558ccd1..5169713539bc3 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -748,6 +748,7 @@
 #define USB_DEVICE_ID_JESS_YUREX	0x1010
 #define USB_DEVICE_ID_ASUS_MD_5112	0x5112
 #define USB_DEVICE_ID_REDRAGON_ASURA	0x760b
+#define USB_DEVICE_ID_AULA_MINI_60_HE_PRO 0xfefe
 
 #define USB_VENDOR_ID_JESS2		0x0f30
 #define USB_DEVICE_ID_JESS2_COLOR_RUMBLE_PAD 0x0111
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 3de594ee25c38..8d2ac32c5ac12 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -113,6 +113,8 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_HP, USB_PRODUCT_ID_HP_PIXART_OEM_USB_OPTICAL_MOUSE_1f4a), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_IDEACOM, USB_DEVICE_ID_IDEACOM_IDC6680), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_INNOMEDIA, USB_DEVICE_ID_INNEX_GENESIS_ATARI), HID_QUIRK_MULTI_INPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_JESS, USB_DEVICE_ID_AULA_MINI_60_HE_PRO),
+		HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_PIXART_USB_OPTICAL_MOUSE_ID2), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M406), HID_QUIRK_MULTI_INPUT },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE, USB_DEVICE_ID_KYE_EASYPEN_M506), HID_QUIRK_MULTI_INPUT },
-- 
2.53.0



