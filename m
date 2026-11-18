Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034009;
	b=qjtsz2wpoKaEYZIlSCJvIB3AZOFGe46w9gsqNWB3WjkCdpsudfE+qsuyLqKFBrchv/Ij
	 4ArO/Wo1pD08XSsVUNaSl7/YLFheVciHNvz22ov3oteeVMtN4H1bsZHEHhk07Hrb+q9Kz
	 LkEKhd4VATK4VMoWDqjOyC/s3gUHNrijk+8qEE9IDu2Mjn7uBzn5hGK/2onNzyi+MwUS1
	 A3iqfvgjajvp1WwxxhzLcokeecYDHjqgnG1+O+bULGHswu94zCk9bprqhAEiTx+287fGM
	 g1zLnCpfpnSAjOHWFvL1zck3WuekAMtf3JoJN6v/FJO/13wEwg39eT6vILRHfNKfvHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=is4OMLKdEXiZ2833jGKDlKPY0XVeoOb1bGesKbJTPvc=;
	b=uw5cUb5VePVSs7X5DYONsP7KKqZ7TDZ8xrFEsTLuhXEC2K3HsWAhtVUsSUt/c9DgN3Bo
	 UtXHEzSTGv0cds/iRK42Im7CyC2rEEwqEATzhUN5gt5kphkYniOUYzlZvt2PR8SZhKXyx
	 a65TIe8fTy5O2Wa6znzE7lbkkDfX+zcdDQ9wnsss/ysuyx4BpJrmcjLgj7VfJjhyfXJOE
	 pcLW+9XjseERrPWZ00x3G/Fdx44lxStEN2wKQhyc88aYaIm0dF3BKS9Da/85eTMbYk7V5
	 3X79OBMGXgfJgZoLJfc6HSgza6StPtEi0wjDf7tSog+ZZWWV8SibNIeojg8t0mgTk6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WBrE93HI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BABD606A31C;
	Wed, 18 Nov 2026 20:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WBrE93HI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5031F000C4;
	Wed, 18 Nov 2026 20:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034009;
	bh=is4OMLKdEXiZ2833jGKDlKPY0XVeoOb1bGesKbJTPvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WBrE93HI3MGqGoXGL9IMz0frAGDdfO52fuH7l0ae9sjoZ0l3D26YYnQiIq3rZ7id0
	 ebQNaR9yYHU/MKk4Wzrxtqbczm1smHGH8ZShq1pJUlH3DITIbP/8cafLiAPdSl2CzP
	 5LsGhJdHhF6w1ZaK1WzWLjvSnN7CzgDyaB65qn70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Ma <mapengyu@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0218/3318] HID: quirks: Add ALWAYS_POLL quirk for Beitong BTP-KP20D dongle
Date: Wed, 18 Nov 2026 15:14:00 +0100
Message-ID: <20261118150321.512345996@linuxfoundation.org>
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
index a429ec77ff4b6..0a714af21056e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -252,6 +252,9 @@
 #define USB_VENDOR_ID_BAANTO		0x2453
 #define USB_DEVICE_ID_BAANTO_MT_190W2	0x0100
 
+#define USB_VENDOR_ID_BEITONG		0x20dd
+#define USB_DEVICE_ID_BEITONG_KP20D	0x5159
+
 #define USB_VENDOR_ID_BELKIN		0x050d
 #define USB_DEVICE_ID_FLIP_KVM		0x3201
 
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index b95521c50d252..97722b8803ce6 100644
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



