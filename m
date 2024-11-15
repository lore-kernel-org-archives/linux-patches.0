Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D01185B5B;
	Fri, 15 Nov 2024 06:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653308; cv=none; b=flxWjhIi/8lwsK43lfMMCDrqFjGbOaDqW8m0Zs/NSvhaRBvKzqNebu1dE52TMaAVuBsdW3wnOTjxqSCeRkaMHlk14OabaY1Ri/F7bJ7Z4Q6RXvbyoFB8so/V3EzKkq1X3PDLfyA8o1MWe+91no1opwidR6oq+BlWgiGHm2C8OhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653308; c=relaxed/simple;
	bh=GARmRt1KsD2PL9Mf+1+locIZ7/0Ob/eIJpUPn9hyoSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWSIKn7dYHf0Ts3GP9eEuJFK0O6Jy+BVH/+AKsdOq+D09RlTBgYcIFy0uMEtkbBgGTCSuFDBcAfqCTrvbC99qAWDFV6tGH/iaa7RjuYcFggSfYsKFZ7cPi42WJChHA81atZeJh9ApmH5dzr32fEEGGMH0uK/pPh25xHYppfSu/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UV2hDEwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UV2hDEwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD658C4CECF;
	Fri, 15 Nov 2024 06:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653305;
	bh=GARmRt1KsD2PL9Mf+1+locIZ7/0Ob/eIJpUPn9hyoSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UV2hDEwBoBusNylhYTlcv3GNIUmJrs+UnlhBNizNTmHQ8aK4/jbNM0lDxvs9kbW9b
	 CNUaGaocDUGWVayal7z4cv4Efep8T60qJq8/8sjkx9nrq3C4MLwTsdqx9Uiq08jRi1
	 /4NSCt6ctfe6rFMz7SLjGBVhBzLzoRpWNlQmlYuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kenneth Albanowski <kenalba@chromium.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 47/63] HID: multitouch: Add quirk for Logitech Bolt receiver w/ Casa touchpad
Date: Fri, 15 Nov 2024 07:38:10 +0100
Message-ID: <20241115063727.610053832@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenneth Albanowski <kenalba@chromium.org>

[ Upstream commit 526748b925185e95f1415900ee13c2469d4b64cc ]

The Logitech Casa Touchpad does not reliably send touch release signals
when communicating through the Logitech Bolt wireless-to-USB receiver.

Adjusting the device class to add MT_QUIRK_NOT_SEEN_MEANS_UP to make
sure that no touches become stuck, MT_QUIRK_FORCE_MULTI_INPUT is not
needed, but harmless.

Linux does not have information on which devices are connected to the
Bolt receiver, so we have to enable this for the entire device.

Signed-off-by: Kenneth Albanowski <kenalba@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h        | 1 +
 drivers/hid/hid-multitouch.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 25f96494700d8..92cff3f2658cf 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -869,6 +869,7 @@
 #define USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_LIGHTSPEED_1	0xc539
 #define USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_LIGHTSPEED_1_1	0xc53f
 #define USB_DEVICE_ID_LOGITECH_NANO_RECEIVER_POWERPLAY	0xc53a
+#define USB_DEVICE_ID_LOGITECH_BOLT_RECEIVER	0xc548
 #define USB_DEVICE_ID_SPACETRAVELLER	0xc623
 #define USB_DEVICE_ID_SPACENAVIGATOR	0xc626
 #define USB_DEVICE_ID_DINOVO_DESKTOP	0xc704
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 871d7417824b8..24da739647635 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2137,6 +2137,10 @@ static const struct hid_device_id mt_devices[] = {
 		HID_DEVICE(BUS_BLUETOOTH, HID_GROUP_MULTITOUCH_WIN_8,
 			USB_VENDOR_ID_LOGITECH,
 			USB_DEVICE_ID_LOGITECH_CASA_TOUCHPAD) },
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
+		HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8,
+			USB_VENDOR_ID_LOGITECH,
+			USB_DEVICE_ID_LOGITECH_BOLT_RECEIVER) },
 
 	/* MosArt panels */
 	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
-- 
2.43.0



