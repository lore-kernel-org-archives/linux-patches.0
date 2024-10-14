Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9CC49659;
	Mon, 14 Oct 2024 14:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917173; cv=none; b=h4PHr+99kgbgUnHNIzy6nO3RQksVS2VNEvuucju3ym4hRVix0kZts+sF6xbBPDWfeHMJlw/LapYEz7JWggiOMauisKAcU4mFsHaYGsypc8wRqhJ3qJgZDK6GM2jfmxD3xhbwkhtnmYSRkVD7RPEb/5duKlJ2X2UuJC+NrftUVeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917173; c=relaxed/simple;
	bh=jr6OJQ37+5hXYJtOlghNGcXCoeFcJDCIgs0TEhmLrZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6KvXhOHa/575e7cv0R+vtX3Ekl74EqqDL+1FkwHH0RJkAzTCYE2TumAyI3L2Quc6qlgpvvh88y+07brQit4Mj/6nWZ5jXYA547JrfMEcqP9ICFfFtFasxhqSncBWHDFpuZRKVguzdaBX2IiiJsGltCVwF8to0432p1tmThov1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSS6/yLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSS6/yLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC3DC4CEC3;
	Mon, 14 Oct 2024 14:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917172;
	bh=jr6OJQ37+5hXYJtOlghNGcXCoeFcJDCIgs0TEhmLrZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSS6/yLmTazeoH4bo/OQ+jkShU/Wx8lz8Ms5dVsuU9nx9UkBSwBABj000Ls0U1kbV
	 RCuM6EGFEGdmAqOnGy/pLLp+BUr/rxpMS710Put88z1W5sd1FPhNpotagdaOD1OCsg
	 HDtdAvUKnUMARbp2B7cHhIF4DUjIUEEjk2ktvexw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/213] HID: asus: add ROG Z13 lightbar
Date: Mon, 14 Oct 2024 16:21:17 +0200
Message-ID: <20241014141049.642699184@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit e901f10adb1f387fff1082297065a0da0191b83d ]

Add init of the lightbar which is a small panel on the back of the ASUS
ROG Z13 and uses the same MCU as keyboards.

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 3 +++
 drivers/hid/hid-ids.h  | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 0616df83adc75..fde6307d1db0c 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1276,6 +1276,9 @@ static const struct hid_device_id asus_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
 	    USB_DEVICE_ID_ASUSTEK_ROG_NKEY_KEYBOARD3),
 	  QUIRK_USE_KBD_BACKLIGHT | QUIRK_ROG_NKEY_KEYBOARD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
+	    USB_DEVICE_ID_ASUSTEK_ROG_Z13_LIGHTBAR),
+	  QUIRK_USE_KBD_BACKLIGHT | QUIRK_ROG_NKEY_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
 	    USB_DEVICE_ID_ASUSTEK_ROG_NKEY_ALLY),
 	  QUIRK_USE_KBD_BACKLIGHT | QUIRK_ROG_NKEY_KEYBOARD },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 1301d15e5680b..17f7d3a3f57b0 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -208,6 +208,7 @@
 #define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_KEYBOARD	0x1866
 #define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_KEYBOARD2	0x19b6
 #define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_KEYBOARD3	0x1a30
+#define USB_DEVICE_ID_ASUSTEK_ROG_Z13_LIGHTBAR		0x18c6
 #define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_ALLY		0x1abe
 #define USB_DEVICE_ID_ASUSTEK_ROG_CLAYMORE_II_KEYBOARD	0x196b
 #define USB_DEVICE_ID_ASUSTEK_FX503VD_KEYBOARD	0x1869
-- 
2.43.0



