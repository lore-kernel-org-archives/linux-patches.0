Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5E12D5426;
	Tue, 15 Jul 2025 13:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586046; cv=none; b=s8FUz/SJwwY1rbZ0QBbzks+hZ4EDHO7lG/P1iCJs1ixDqnCEfLSKAE3SB2zzxIbEKB9x/Wf9zqcn9D22qSeVLn8NoVK806q4Q5OLWWYkesD8UvJayvgitDGkrCBkv1UA3wZ5b2rxGPMgfou84++HBlu9KDqiLS5Aptxw4QeACTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586046; c=relaxed/simple;
	bh=2kzOfcqn/6cO21Uu9nKMWsLX4LkcCtUWn6XgPwG8o0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6mkkGLnvot8/MJSistlW4kO/F/bWQ6KZbKkOtHiM+YqZj1px7AcBeZDQpP8F0KpQb/zfK+Td9yja9PIjxvQqwTiq70m/59B6+r0/44sM29TMEiJ0fBdO4mgqnQMMMUkq58nid7Vc/YAGhQCPyr+YyAyNIAl2Ws+DOvYFhTnc9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RlCKvt7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RlCKvt7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716D2C4CEE3;
	Tue, 15 Jul 2025 13:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586046;
	bh=2kzOfcqn/6cO21Uu9nKMWsLX4LkcCtUWn6XgPwG8o0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RlCKvt7Z73AI/esAVS/EJMX11h5//+0STutByJZKClZrH+JMocK/LWsloexHdA0GK
	 cr81PMpxVbpIkk3jFc2TH5p421ZllrAfrktG9sZec8JOddHnZALE5C6e4oohb7Mnqj
	 DJakfuFoSY2uG9PkQdd7dLNKtt1/K6tVbvfdjDzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/109] HID: quirks: Add quirk for 2 Chicony Electronics HP 5MP Cameras
Date: Tue, 15 Jul 2025 15:14:00 +0200
Message-ID: <20250715130803.043975194@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>

[ Upstream commit 54bae4c17c11688339eb73a04fd24203bb6e7494 ]

The Chicony Electronics HP 5MP Cameras (USB ID 04F2:B824 & 04F2:B82C)
report a HID sensor interface that is not actually implemented.
Attempting to access this non-functional sensor via iio_info causes
system hangs as runtime PM tries to wake up an unresponsive sensor.

Add these 2 devices to the HID ignore list since the sensor interface is
non-functional by design and should not be exposed to userspace.

Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 2 ++
 drivers/hid/hid-quirks.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index f344df00db03a..0d1d7162814f3 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -305,6 +305,8 @@
 #define USB_DEVICE_ID_ASUS_AK1D		0x1125
 #define USB_DEVICE_ID_CHICONY_TOSHIBA_WT10A	0x1408
 #define USB_DEVICE_ID_CHICONY_ACER_SWITCH12	0x1421
+#define USB_DEVICE_ID_CHICONY_HP_5MP_CAMERA	0xb824
+#define USB_DEVICE_ID_CHICONY_HP_5MP_CAMERA2	0xb82c
 
 #define USB_VENDOR_ID_CHUNGHWAT		0x2247
 #define USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH	0x0001
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index e4d80307b898c..80372342c176a 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -747,6 +747,8 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_AVERMEDIA, USB_DEVICE_ID_AVER_FM_MR800) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_AXENTIA, USB_DEVICE_ID_AXENTIA_FM_RADIO) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_BERKSHIRE, USB_DEVICE_ID_BERKSHIRE_PCWD) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_HP_5MP_CAMERA) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_HP_5MP_CAMERA2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CIDC, 0x0103) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYGNAL, USB_DEVICE_ID_CYGNAL_RADIO_SI470X) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYGNAL, USB_DEVICE_ID_CYGNAL_RADIO_SI4713) },
-- 
2.39.5



