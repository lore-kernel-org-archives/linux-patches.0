Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805E31AAE08;
	Mon, 14 Oct 2024 14:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917176; cv=none; b=C8+4KpcRFJY5Q0S2HTZ7V/QvklhfLnCpmcLkYeRJm8n8r1fvmkZtSDK21xwq5hqjHDB6ukfDHGmimD7PsKq+4z8ruylbaDzT+2XcQSC2Yj+YB9Eulls/d8wsjkXY/iH7ZlMCqfsxGm557Y/ZTvDQeAXnuQpcjcyc4JLH6yUAKsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917176; c=relaxed/simple;
	bh=ZSdnEPpyH2WOgqcz+lpStYEk2GzFZbiF1bLzV6YLwNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8MbuHpvR3DqVF2LqRiycOrkUOq5GyenJfTMFebdBKtLPAyIlFmJOrjp3B+2fPvm6UZRbmX93dmYptHY8FkeX1+MYUJd0orhaVBMY7WwTVgFadoKVlBjrVtf5aiNtcdwM0Emj5ug9o3H1nF0ssGXJyuk+Ef3BsjC3hpx0OKGjQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3+oYLJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3+oYLJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC078C4CEC3;
	Mon, 14 Oct 2024 14:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917176;
	bh=ZSdnEPpyH2WOgqcz+lpStYEk2GzFZbiF1bLzV6YLwNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3+oYLJ86yPxv2kl9n/c5TL6XMHHvXXIv88TxyzmoC7LBi4WGhc8bNIxK+UvYOcfe
	 MUDYx41BkMAAKlrCNc/N57CoPCr75koPqx0sqfypyhsjBKNc/qLtdehtExFit3Eo6W
	 +b4Y3g77pwftUrbJQNll+sVjeoYmPSRDuMUyoct8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 172/213] hid-asus: add ROG Ally X prod ID to quirk list
Date: Mon, 14 Oct 2024 16:21:18 +0200
Message-ID: <20241014141049.680942936@linuxfoundation.org>
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

[ Upstream commit d1aa95e86f178dc597e80228cd9bd81fc3510f34 ]

The new ASUS ROG Ally X functions almost exactly the same as the previous
model, so we can use the same quirks.

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 3 +++
 drivers/hid/hid-ids.h  | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index fde6307d1db0c..84625e817ce95 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1282,6 +1282,9 @@ static const struct hid_device_id asus_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
 	    USB_DEVICE_ID_ASUSTEK_ROG_NKEY_ALLY),
 	  QUIRK_USE_KBD_BACKLIGHT | QUIRK_ROG_NKEY_KEYBOARD },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
+	    USB_DEVICE_ID_ASUSTEK_ROG_NKEY_ALLY_X),
+	  QUIRK_USE_KBD_BACKLIGHT | QUIRK_ROG_NKEY_KEYBOARD },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ASUSTEK,
 	    USB_DEVICE_ID_ASUSTEK_ROG_CLAYMORE_II_KEYBOARD),
 	  QUIRK_ROG_CLAYMORE_II_KEYBOARD },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 17f7d3a3f57b0..567000a5888b7 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -210,6 +210,7 @@
 #define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_KEYBOARD3	0x1a30
 #define USB_DEVICE_ID_ASUSTEK_ROG_Z13_LIGHTBAR		0x18c6
 #define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_ALLY		0x1abe
+#define USB_DEVICE_ID_ASUSTEK_ROG_NKEY_ALLY_X		0x1b4c
 #define USB_DEVICE_ID_ASUSTEK_ROG_CLAYMORE_II_KEYBOARD	0x196b
 #define USB_DEVICE_ID_ASUSTEK_FX503VD_KEYBOARD	0x1869
 
-- 
2.43.0



