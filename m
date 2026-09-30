Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE683E3C74;
	Wed, 30 Sep 2026 19:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796585; cv=none; b=nLovSH0GAkfuvcdPmrTyKS/txZmJaQbEFqhvgM6NeuZy7cKSeLtV0R4N8W4vBtmcAH2XNJ0Y4KG1tzSWVS+TMxXRpZbNPCmnvDwu4u4y92BQ/2enBd8S1SppBYN9WRr71ecLN93Zfj+buBH6IhUbPIHCMURmeJ8Sav0fc5gk+xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796585; c=relaxed/simple;
	bh=hMqrloII7jeoIw92XvTQv05fm4/43IRXyNlAcZ/SmmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uw9u2R3iRJUVnQKrqwgxgAg3cE8IMEJzO2Dsw1DYW2O0B446CjU+fnrje3mKdW1mRxGW5nkBzFhbFB9mwtx3ryMT1otdEbNVRlaTDEJ+llM8bYyfi3dW+TJbbblfsmopvRdiuQCrDg7hjgfwbLsvJwWEBQQDYBhs0/DP3zBg6cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lyBMg9b2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lyBMg9b2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0241F000FF;
	Wed, 30 Sep 2026 19:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796584;
	bh=zQsv+QjAzci8FBO/wFQ0dnZmWkQgfBFU8I6kV+7mBYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lyBMg9b2bRtpHgHR/8gSo7pjQD19hs/MoOuh/h7phw3ecD7WSsGL0EQsoN554EBw7
	 ugFkzYdYcEEFFONMFh/pcAB4tOijHBFYTilhnPYhRSry8CyMUE8iYwNsAL4kNZUiJz
	 /Qa4OF72qjcvpOlrtwHDB+mcDdiF6Poxh32QFIlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Priego Verdugo <oscar.priegov@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0966/1193] HID: elecom: fix bus type for M-XGL20DLBK
Date: Wed, 30 Sep 2026 17:27:30 +0200
Message-ID: <20260930152455.707353749@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Oscar Priego Verdugo <oscar.priegov@gmail.com>

[ Upstream commit 8e2a4b458ad25e13422bb059758c30a6562aa9cf ]

The M-XGL20DLBK is matched as a USB device by hid-elecom, but
its entry in hid_have_special_driver[] uses HID_BLUETOOTH_DEVICE.

This prevents the special-driver quirk entry from matching the USB
device handled by hid-elecom. Use HID_USB_DEVICE there as well.

Fixes: 55633e681afb ("HID: elecom: add support for EX-G M-XGL20DLBK wireless mouse")
Signed-off-by: Oscar Priego Verdugo <oscar.priegov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-quirks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 39d81777cb7e2..2f086ac897605 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -416,7 +416,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 #endif
 #if IS_ENABLED(CONFIG_HID_ELECOM)
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_BM084) },
-	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XGL20DLBK) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XGL20DLBK) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_HT1MRBK_01AC) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_00FB) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELECOM, USB_DEVICE_ID_ELECOM_M_XT3URBK_018F) },
-- 
2.53.0



