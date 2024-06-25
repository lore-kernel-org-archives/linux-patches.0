Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39CC14A092;
	Tue, 25 Jun 2024 09:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309453; cv=none; b=BfcJVR4r0p9xRTXhuJXw+hJ0xyYmCPIyjMxnADdjpHDHzZqnV7mpt3phUc2wvpWRkTSFokVSLPErqx8u9lQ3DRB0pt1C42R9MPk+CTrp/RcIvJqYndsohSoD0YudXsNiXSNj3QaP+uiahZO1kCOT+enWNsoP63ft8cdP4COuzyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309453; c=relaxed/simple;
	bh=Jcb93Vkw0hthwXq0pe9BUfqDDaGa8EswqA2RAVjl32Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrUXuLk7Rem0QIfLbuKo8X7tcSZsPKEqDBNYKjoojOVsQqMkJ0sMBO2KlYZQmcTMYuBEeFbOboL/uI9FyEd7dvIhenFT+vonX5kNVSalZIhnGIAlR/RsUv/1GDQ9Cp+7PIhyxp/HHMbcfxYuDKQCdurvZcqzmBPB+RJdQD1Bnuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BroCx+zV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BroCx+zV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798AAC32781;
	Tue, 25 Jun 2024 09:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309452;
	bh=Jcb93Vkw0hthwXq0pe9BUfqDDaGa8EswqA2RAVjl32Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BroCx+zVh/Olo7fcjKdXqgfx5zkGqyejjMC3dUKD73sk7tcbxZNKOHSoYqpHTFtg3
	 HNyaHMNYhG1FaOnoEnXrQj4F3aUi58XkwleMFfLIIltOWKuoCgbKIaQNuV/dC/aHEP
	 Cr/Rpxuhp8GFR4O5Kj/iu2EPFcv6UNX4RFWh/O9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean OBrien <seobrien@chromium.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/131] HID: Add quirk for Logitech Casa touchpad
Date: Tue, 25 Jun 2024 11:32:55 +0200
Message-ID: <20240625085526.714722023@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean O'Brien <seobrien@chromium.org>

[ Upstream commit dd2c345a94cfa3873cc20db87387ee509c345c1b ]

This device sometimes doesn't send touch release signals when moving
from >=4 fingers to <4 fingers. Using MT_QUIRK_NOT_SEEN_MEANS_UP instead
of MT_QUIRK_ALWAYS_VALID makes sure that no touches become stuck.

MT_QUIRK_FORCE_MULTI_INPUT is not necessary for this device, but does no
harm.

Signed-off-by: Sean O'Brien <seobrien@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h        | 1 +
 drivers/hid/hid-multitouch.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 405d88b08908d..97745a1f9c6f1 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -802,6 +802,7 @@
 #define USB_DEVICE_ID_LOGITECH_AUDIOHUB 0x0a0e
 #define USB_DEVICE_ID_LOGITECH_T651	0xb00c
 #define USB_DEVICE_ID_LOGITECH_DINOVO_EDGE_KBD	0xb309
+#define USB_DEVICE_ID_LOGITECH_CASA_TOUCHPAD	0xbb00
 #define USB_DEVICE_ID_LOGITECH_C007	0xc007
 #define USB_DEVICE_ID_LOGITECH_C077	0xc077
 #define USB_DEVICE_ID_LOGITECH_RECEIVER	0xc101
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 3816fd06bc953..17efe6e2a1a44 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2084,6 +2084,12 @@ static const struct hid_device_id mt_devices[] = {
 			   USB_VENDOR_ID_LENOVO,
 			   USB_DEVICE_ID_LENOVO_X12_TAB) },
 
+	/* Logitech devices */
+	{ .driver_data = MT_CLS_NSMU,
+		HID_DEVICE(BUS_BLUETOOTH, HID_GROUP_MULTITOUCH_WIN_8,
+			USB_VENDOR_ID_LOGITECH,
+			USB_DEVICE_ID_LOGITECH_CASA_TOUCHPAD) },
+
 	/* MosArt panels */
 	{ .driver_data = MT_CLS_CONFIDENCE_MINUS_ONE,
 		MT_USB_DEVICE(USB_VENDOR_ID_ASUS,
-- 
2.43.0



