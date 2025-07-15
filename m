Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641302E54BF;
	Tue, 15 Jul 2025 13:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587387; cv=none; b=Ms54EpEgoIhGAUqtGg5TTqUO/QfVYT8zDV9S1gsYo7SPQ8HwDUhNeWqc13x4KAwzomNVdqF3HXf2N3gM+MwYZSpuYoOF1AoN/ghnzB65+VUU42vG9R7kntVYH49KJgH6JHbl/1eoXj1mel7oC9YyVf8zgppzv/8H9rwvtd9bLJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587387; c=relaxed/simple;
	bh=WnBjYR7NO/E9jJgzbGi1N76BJpF1tljTjhAZC8IWGJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBLO+FIBtg4PHSYQX0/kOZ8kHdI2LHZJCymMkZW1siwhMxq4D8FV7fAxkbvCaiDEgJSXxYlizE9bDGgXzD4PPtYQ8vJk9FUkUz0xzdSqVjs894zjmTXfDPYJAgb6j2Dm7756lnG98QEB03B0kKjf5EhNqOfC4czXSe42zwTyZRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gdz2uWrd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gdz2uWrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7F3C4CEE3;
	Tue, 15 Jul 2025 13:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587387;
	bh=WnBjYR7NO/E9jJgzbGi1N76BJpF1tljTjhAZC8IWGJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gdz2uWrd/SQqfHm3YIUO1AAxOxYz957s9ToQO7Xr0WGQYL6u/AbqFWxdKimyF3jSr
	 tZJijhZ/LoLNhKVME92hD50ZbtpPwGEtdv4REfO+LCSzUnfoduNHpZdFcMACnK8jDg
	 oySMRKedshho7Dxaxd/g5v9acidAV72hqmDaTSCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 82/88] HID: quirks: Add quirk for 2 Chicony Electronics HP 5MP Cameras
Date: Tue, 15 Jul 2025 15:14:58 +0200
Message-ID: <20250715130757.863501480@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 21e0660179ee9..0bbba80d6c51c 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -297,6 +297,8 @@
 #define USB_DEVICE_ID_ASUS_AK1D		0x1125
 #define USB_DEVICE_ID_CHICONY_TOSHIBA_WT10A	0x1408
 #define USB_DEVICE_ID_CHICONY_ACER_SWITCH12	0x1421
+#define USB_DEVICE_ID_CHICONY_HP_5MP_CAMERA	0xb824
+#define USB_DEVICE_ID_CHICONY_HP_5MP_CAMERA2	0xb82c
 
 #define USB_VENDOR_ID_CHUNGHWAT		0x2247
 #define USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH	0x0001
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 7fca632ceea79..b37927f909412 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -738,6 +738,8 @@ static const struct hid_device_id hid_ignore_list[] = {
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



