Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFF928725B;
	Mon,  9 Feb 2026 14:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648639; cv=none; b=Jo1apFx2VjYuKuYl37bieBCbhDr/AVvv6wJBv3cSA20YmcTJeWTxdfRHlFgGJStog+CryZBZSiTC9r069gxTNQbJQp1jdYH6WFeMUo0Iwj9QEEOCiddZhQc+YAbH/+iODCmsM0yv+1n93zpqvZMyDulw/dhpcRJ0cBjzz/3h/Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648639; c=relaxed/simple;
	bh=Dj52CyGDlR/FWxV16evXYJKQJpZHWP4s/5vy2ZysS20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABgjsAt59R8fNA5mud7yxobLVttwFc83GMrqv01Bpujti83P8UF65EBOZAvZmooekB4PEzEXFL1tnWUInSpVz8ncBTeR0IhGncM9KKVafk8hYJ2ti358uqy8LgF4lGCrdbByJTRxk0E26r8r/teMvzlOc02ZXAxJR8j7iFiopG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fb+yDhGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fb+yDhGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EDBEC116C6;
	Mon,  9 Feb 2026 14:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648639;
	bh=Dj52CyGDlR/FWxV16evXYJKQJpZHWP4s/5vy2ZysS20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fb+yDhGAT5mCEeCn6KcaGRhWIZ9eWTXVLgz4TeqQpWHq5SES+HXKM5K+0w4waLdAZ
	 ehk4JMp4he2ShztIx3TNQwqxtEeMEYU5ZvF0FnfjT6DrFb8uVLwDrgFtbUXPjObtFe
	 IrnpaIiaolR+mhyrJSkHe7ARXF/vomKm8mCF3pwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Chiu <chris.chiu@canonical.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/41] HID: quirks: Add another Chicony HP 5MP Cameras to hid_ignore_list
Date: Mon,  9 Feb 2026 15:24:34 +0100
Message-ID: <20260209142257.285975059@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
References: <20260209142256.797267956@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Chiu <chris.chiu@canonical.com>

[ Upstream commit c06bc3557542307b9658fbd43cc946a14250347b ]

Another Chicony Electronics HP 5MP Camera with USB ID 04F2:B882
reports a HID sensor interface that is not actually implemented.

Add the device to the HID ignore list so the bogus sensor is never
exposed to userspace. Then the system won't hang when runtime PM
tries to wake the unresponsive device.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 8850a5e5ae0e9..a933e8a94b1e3 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -280,6 +280,7 @@
 #define USB_DEVICE_ID_CHICONY_ACER_SWITCH12	0x1421
 #define USB_DEVICE_ID_CHICONY_HP_5MP_CAMERA	0xb824
 #define USB_DEVICE_ID_CHICONY_HP_5MP_CAMERA2	0xb82c
+#define USB_DEVICE_ID_CHICONY_HP_5MP_CAMERA3	0xb882
 
 #define USB_VENDOR_ID_CHUNGHWAT		0x2247
 #define USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH	0x0001
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 0d15148d52533..dffec116b8fad 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -738,6 +738,7 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BERKSHIRE, USB_DEVICE_ID_BERKSHIRE_PCWD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_HP_5MP_CAMERA) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_HP_5MP_CAMERA2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_HP_5MP_CAMERA3) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CIDC, 0x0103) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYGNAL, USB_DEVICE_ID_CYGNAL_RADIO_SI470X) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYGNAL, USB_DEVICE_ID_CYGNAL_RADIO_SI4713) },
-- 
2.51.0



