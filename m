Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C97511194;
	Wed, 30 Sep 2026 15:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782585; cv=none; b=VZvB2gl5c+rNhJknUaBsUv2AleJsPEUd4eHEKJrRDMc47bluV3x+XAoNGvCL8MJ6hjuZxrQnseKrAjm5o1f3Epp7tD85Uwm6eIu+pwDcaRzYfbc4CqLT+YTdHEAHeQ+TdH4ThLju0KA3quEdk+p1pNJCSu98L55Negg9JDYqjWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782585; c=relaxed/simple;
	bh=/3Lu1mB5hRSWiMbqiHSbjFZ5jt+m8+5t6DmBsZlwWIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bAeQa9Rnyp+8uFPh+z8MFh2u5otM0utDp+3XR+L2GzaxfAW9lmDRIl2shHWFBJrNyQTdhPzkIp3ZYGqNyU+O5TpD9KV/EZRXpnAshhj+g/hzIPj6CSEGE5sOIwgWBDXPUI9/tsANXNIthYnAtOUdHC3+CnJEO5FCsAMNplOLjeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FAYxc73g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FAYxc73g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F691F00899;
	Wed, 30 Sep 2026 15:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782569;
	bh=apXgr9+MNjAoOBFX3eOapk3/RT1UvO8M0timMSIRgX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FAYxc73gZxL/WLGfU11Uphu/0HVzXKLvIKrJykOQzb0j9P0lNfL7nhtq4Ptq/ATOi
	 hmS2X75hy6Jm9uovxifmtInwMMLYAaKQwR9oD56cewRB3bDok/ZIewyhWxv7RmeNi5
	 jknmL2HTd/Ua1bF70ABggrycfwivoCXsW+g+0MBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20K=C3=BCchler?= <uwe@kuechler.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/595] ALSA: usb-audio: Add quirk for Novation Mininova
Date: Wed, 30 Sep 2026 17:19:19 +0200
Message-ID: <20260930152349.159948485@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Küchler <uwe@kuechler.org>

[ Upstream commit b2e9d2cbbb71b00faf3e27fb741a27b9ad455edd ]

Add a device-specific quirk for the Novation Mininova synthesizer
(USB ID 1235:001e) to enable proper recognition and functionality
as a MIDI device.

Signed-off-by: Uwe Küchler <uwe@kuechler.org>
Link: https://patch.msgid.link/20260526162033.7513-1-uwe@kuechler.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks-table.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 119c0bde74464..75ce583f13153 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2814,6 +2814,14 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		}
 	}
 },
+{
+	USB_DEVICE(0x1235, 0x001e),
+	QUIRK_DRIVER_INFO {
+		/* .vendor_name = "Novation", */
+		/* .product_name = "Mininova", */
+		QUIRK_DATA_RAW_BYTES(0)
+	}
+},
 {
 	USB_DEVICE_VENDOR_SPEC(0x1235, 0x4661),
 	.driver_info = (unsigned long) & (const struct snd_usb_audio_quirk) {
-- 
2.53.0



