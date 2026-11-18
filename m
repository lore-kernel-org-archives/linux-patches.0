Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016117;
	b=QJtG3y8X3uSHxpGLA8VEoPLkz4jV7pszeoUwT9GusVppARbHDhF8/mqfp+x40NftYc3d
	 SbdBkgVUVyzjv+oMqndpT2CHir6ueoCCa1H8AXfyrnZ232rcJb2hG8BzTuWo3JBaSpTLE
	 twfbTSwbA0qsArcfds3oUv0vCooqeqq9ImZMoRxaqjOa8wnWmKnHWysSmziuESoXnxMwF
	 5/MFnbx7mTqNcgd1evH/mBbNPtN+CoGHHl5dm0chRGt4ICxF1KenpBWIHGz0I9S49uIWe
	 4WxQ2qdFOOUgUiOBBoKR4iuPSc7TOpSYpK4sDeCfoE1yGQ3z67WKn1ReFN1GvZMk+Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016117;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mEwCm13hz80sbyef3kheXG300PSsdHHUwuctAsEQnmM=;
	b=oYnf576Y49OYOnd+7j/CJibCIxmKwRJdI+j76wL0vn5tut2LAETu5cP7Jpvnhf5khmCz
	 w9OEsq/X4XGNP3E8yIrDDmrtSk2B6SvrWfTdFrYIXFFA+8IgDomNJkyurV1g5QqJ5KrdB
	 LNZorbpvuhE8JOT7mEMqf6ehIufdDmcN4XsBFFHbj3gCwtVAeHSlvTtV7gO27xwULrQDS
	 WcCPHAy9AN72aey6gR1MABKIlDFBytD10lDRRjMXYYUclk6nyOvGDkbwj3bkxTD4Yi5Jj
	 WnGxgDnUSBOtvw2W18jSY87GqonACeyBgGTXGDg7DnsJOPgKxJcElVqc9xxn4FDbjwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ycw7RxfE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD88060A2620;
	Wed, 18 Nov 2026 15:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ycw7RxfE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281181F000C6;
	Wed, 18 Nov 2026 15:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016117;
	bh=mEwCm13hz80sbyef3kheXG300PSsdHHUwuctAsEQnmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ycw7RxfE22Oyvn/15VdrfIutN5MuMGmNwqza2AvpFBt/4aorT9JpjPoXQcdxUOYBC
	 geJimtj4Eh9LLLrObYjFYOu1LTVxBnIHpLegakC2LTPueusB2cr82E2HVz9ehalTq5
	 srVtS4mnhUvlt9ijubWGOSJCLM7r9uywyq0tUCoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aiman Najjar <aiman.najjar@hurranet.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0414/2651] HID: nintendo: add support for PDP Afterglow controller
Date: Wed, 18 Nov 2026 15:27:34 +0100
Message-ID: <20261118150302.740334089@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aiman Najjar <aiman.najjar@hurranet.com>

[ Upstream commit 3774b1dd8cbce8dd75dd677fd68c5a2dc70860c6 ]

Add support for the PDP Afterglow (0e6f:018c), a licensed pro controller.

Commit 9146038120a6 ("HID: nintendo: add support for HORI Wireless Switch
Pad") applied X/Y button swap to all Licensed Pro controllers which caused
the North/West buttons to come up swapped for PDP Afterflow. The swapped
layout seems to be specific to HORI, so restrict the quirk to HORI devices
and use the standard mapping for all other licensed pro controllers.

Fixes: 9146038120a6 ("HID: nintendo: add support for HORI Wireless Switch Pad")
Link: https://lore.kernel.org/all/20260527-hori-support-v2-1-195c2f832112@hectorzelaya.dev/
Signed-off-by: Aiman Najjar <aiman.najjar@hurranet.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h      |  1 +
 drivers/hid/hid-nintendo.c | 14 ++++++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 3b19b742d4dd1..042421c8399b6 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1170,6 +1170,7 @@
 #define USB_DEVICE_ID_PDP_PS4_JAGUAR	0x0173
 #define USB_DEVICE_ID_PDP_PS4_RIFFMASTER	0x024a
 #define USB_DEVICE_ID_PDP_PS5_RIFFMASTER	0x0249
+#define USB_DEVICE_ID_PDP_SWITCH_AFTERGLOW	0x018c
 
 #define USB_VENDOR_ID_PLANTRONICS	0x047f
 #define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3210_SERIES	0xc055
diff --git a/drivers/hid/hid-nintendo.c b/drivers/hid/hid-nintendo.c
index 43e0f2aaea3b5..b1fcf3e5767ba 100644
--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -434,8 +434,8 @@ static const struct joycon_ctlr_button_mapping procon_button_mappings[] = {
 	{ /* sentinel */ },
 };
 
-/* Licensed Pro Controllers (e.g. HORI) swap X/Y bits in the report */
-static const struct joycon_ctlr_button_mapping lic_procon_button_mappings[] = {
+/* HORI Licensed Pro Controllers swap X/Y bits in the report */
+static const struct joycon_ctlr_button_mapping lic_hori_procon_button_mappings[] = {
 	{ BTN_EAST,	JC_BTN_A,	},
 	{ BTN_SOUTH,	JC_BTN_B,	},
 	{ BTN_NORTH,	JC_BTN_Y,	},
@@ -1767,8 +1767,8 @@ static void joycon_parse_report(struct joycon_ctlr *ctlr,
 		joycon_report_left_stick(ctlr, rep);
 		joycon_report_right_stick(ctlr, rep);
 		joycon_report_dpad(ctlr, rep);
-		if (ctlr->ctlr_type == JOYCON_CTLR_TYPE_LIC_PRO)
-			joycon_report_buttons(ctlr, rep, lic_procon_button_mappings);
+		if (ctlr->hdev->vendor == USB_VENDOR_ID_HORI)
+			joycon_report_buttons(ctlr, rep, lic_hori_procon_button_mappings);
 		else
 			joycon_report_buttons(ctlr, rep, procon_button_mappings);
 	} else if (joycon_type_is_any_nescon(ctlr)) {
@@ -2212,8 +2212,8 @@ static int joycon_input_create(struct joycon_ctlr *ctlr)
 		joycon_config_left_stick(ctlr->input);
 		joycon_config_right_stick(ctlr->input);
 		joycon_config_dpad(ctlr->input);
-		if (ctlr->ctlr_type == JOYCON_CTLR_TYPE_LIC_PRO)
-			joycon_config_buttons(ctlr->input, lic_procon_button_mappings);
+		if (ctlr->hdev->vendor == USB_VENDOR_ID_HORI)
+			joycon_config_buttons(ctlr->input, lic_hori_procon_button_mappings);
 		else
 			joycon_config_buttons(ctlr->input, procon_button_mappings);
 	} else if (joycon_type_is_any_nescon(ctlr)) {
@@ -2905,6 +2905,8 @@ static const struct hid_device_id nintendo_hid_devices[] = {
 			 USB_DEVICE_ID_NINTENDO_N64CON) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_HORI,
 			 USB_DEVICE_ID_HORI_WIRELESS_SWITCH_PAD) },
+	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_PDP,
+			 USB_DEVICE_ID_PDP_SWITCH_AFTERGLOW) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, nintendo_hid_devices);
-- 
2.53.0



