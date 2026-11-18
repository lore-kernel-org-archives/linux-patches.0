Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051328;
	b=t/RNcevwAgiBu1n+Haa0A4TyNy6Wqa357A0hy3L+bzGDhGGtOKhTUe3C9IYBsJaqnORJ
	 Eeh56SBDPsHe+a7ZRwyz2jZfrt7JUzJY1YPOn8Q4lxbOBwJP/V2pFAhetF/V89vkmKC1N
	 eGf/bZk5M2ZBx7rQfXL6Vt1GgSqmbeHvtW4tO6jSScaMzA7/tkRpYByjrb5iWypS1C3I3
	 C466rRnpLkjwpAYNcytDhTM7YTPlW4tsGrZFlLrj2oVGMj20nex39qR7LOKHB6LunvOs2
	 y+29HNxUdX9ootVwSB1wyVR609iRQ9PvVzfM9ZqKemxZ1eSvlIBZH47rwTBiBG7YiqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LnaYmbrVqApSKyZKb7drkYpy67uQRdbAEeVoQDM4XPU=;
	b=ZpcXsOkPMco/WrmBk/eESiu6+Px/r0Jvb9nqQ8HjCfxZea4Emm4eXk/otDjMTqbjzRs7
	 NoM9sBfZK+hl1hvPvfKcfDlwRzOh6+tAk6N31BifCsKllOV+ywFDg3bWkG2f+R7HsAAQb
	 5IQe9KIKfh6caXo77TNpK/XATysRl2DxfzcTLmvtBrE/6w6ozXJ81j0govTWJfZT9FhjA
	 FqZr29SQO27aSwIIEXERwUY15BvzokC9cBxPYeXmt++F5oFiDv7mnKn0riciQ33R2FTy6
	 FzxqAmObB2sy/JqaFtT/ISwDG/CzjP/B/d/mj9lzk2sHCgL+jKR5JC8qX3XUlZOqfhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=umuVVDo6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149D5606A325;
	Thu, 19 Nov 2026 01:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=umuVVDo6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F451F000C4;
	Thu, 19 Nov 2026 01:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051327;
	bh=LnaYmbrVqApSKyZKb7drkYpy67uQRdbAEeVoQDM4XPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=umuVVDo6l0AgffFyEGiM4iU78nLKky9hpXQroSwupFKySQxn4SiiNLXqhcLi2ozg4
	 8JVzJxoxOwwpbQDGN+j2s9G32pZFc+E2ReH7RHnzL029X1f/HOBFeOTda5dpxMnFl8
	 evAgb0g0zxGYL9hiDqJlWdTwn7CQ1elWCH+Z5pBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Ma <mapengyu@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0167/2214] HID: quirks: Add ALWAYS_POLL quirk for Beitong BTP-KP20D dongle
Date: Wed, 18 Nov 2026 15:30:43 +0100
Message-ID: <20261118150016.781017005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 924fd16c56174..d79a8188cd821 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -233,6 +233,9 @@
 #define USB_VENDOR_ID_BAANTO		0x2453
 #define USB_DEVICE_ID_BAANTO_MT_190W2	0x0100
 
+#define USB_VENDOR_ID_BEITONG		0x20dd
+#define USB_DEVICE_ID_BEITONG_KP20D	0x5159
+
 #define USB_VENDOR_ID_BELKIN		0x050d
 #define USB_DEVICE_ID_FLIP_KVM		0x3201
 
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 0654f8e257417..fbc145b732298 100644
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



