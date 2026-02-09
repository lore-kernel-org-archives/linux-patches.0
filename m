Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C172D276028;
	Mon,  9 Feb 2026 14:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647863; cv=none; b=Cdob8M4MhikxXyqOT6yQdwVHIvduMr1QNUZhfwUv6tqFSuIr/WMmgQ2CtWmrhNHZh56ndmRdXaWxe2SB2Qd7flmf1nmcN9Ze2HeL98D9rNUAe/bXgqpgS0womEZdxPT4AnpEHj9VkXtIlIsmLTUiYEsLAlNqFLPfpWTimFNqHOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647863; c=relaxed/simple;
	bh=OJ9JbLqkEovKJcaQgheIRMN59WF6A0tf/OYpYxwSfZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFTAbKbNKXmPPLna5PTZEW6DjnVSgiKHrwRiRCqcSJ7uxy5homkqSPeosrJwy0FzX0r1bQJ3hyt5fPSbfCxPh7fAqOF6HQxv0f8SN50qEaNLz0QIito/zHh4TBfDhyXWW0eMKUdyRiWH5yr/s01u1tD2L1+3I3YbPkUGJFPPffs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G85HY2TU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G85HY2TU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BF4C116C6;
	Mon,  9 Feb 2026 14:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647863;
	bh=OJ9JbLqkEovKJcaQgheIRMN59WF6A0tf/OYpYxwSfZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G85HY2TUXNFhmLd5gZZCeclvbRZDBV3y+YLDvgaobFQGAWYCVnxKk4kqb3mqgaoqn
	 AO5rqRXG8LgQArKFL5RObjyFTUTmoTgPB72WMhegOA0RcezWrMv2MLhCc/jpj88Y2g
	 y4Y6y813RdR9g4+FSEIklG1mwRmsN8wRWW+quOl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Chiu <chris.chiu@canonical.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/113] HID: quirks: Add another Chicony HP 5MP Cameras to hid_ignore_list
Date: Mon,  9 Feb 2026 15:23:19 +0100
Message-ID: <20260209142312.000904961@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e0ac6dc07da09..c34d4ce211e34 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -313,6 +313,7 @@
 #define USB_DEVICE_ID_CHICONY_ACER_SWITCH12	0x1421
 #define USB_DEVICE_ID_CHICONY_HP_5MP_CAMERA	0xb824
 #define USB_DEVICE_ID_CHICONY_HP_5MP_CAMERA2	0xb82c
+#define USB_DEVICE_ID_CHICONY_HP_5MP_CAMERA3	0xb882
 
 #define USB_VENDOR_ID_CHUNGHWAT		0x2247
 #define USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH	0x0001
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 192b8f63baaab..b2a3ce7bfb6b6 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -763,6 +763,7 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BERKSHIRE, USB_DEVICE_ID_BERKSHIRE_PCWD) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_HP_5MP_CAMERA) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_HP_5MP_CAMERA2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_HP_5MP_CAMERA3) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CIDC, 0x0103) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYGNAL, USB_DEVICE_ID_CYGNAL_RADIO_SI470X) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYGNAL, USB_DEVICE_ID_CYGNAL_RADIO_SI4713) },
-- 
2.51.0



