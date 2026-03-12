Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A0F35DA6A;
	Thu, 12 Mar 2026 20:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346989; cv=none; b=Oj/N3YFK72rANso2LrruKs4kd589QYHovXLiq8A5jzpNwkDBdIuREf2WpT403N4oCgpnEmre3gwLATvIx/pZdULL5wqxYm6knd7G9C/YpBC6gan3/vb9AUfrwHw/coOF1WwTHdyb3GHsYd2gkUz3b4VKYExm/v4x8if2fokRjdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346989; c=relaxed/simple;
	bh=XnWcQ50rPKCV61W2PiTJKbi1zJKSb5K0uURFXFLiL9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AYYKxfzMPv47I7aWw+aAUO85dBt3w4/NRjNQ8IsgZuDXWgPGlqkqq0vPhgtweXBZRQ/+44IFgVQlxKhj6hMMPN/UAOxlItOCr7H1oHvIOW/9yRzTokWz2jrzgvAdzw6H8Pv/9LyMDOfAlyKfgbidtIkqzfWvHnUznadF8UR/Qfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPIe2xAT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPIe2xAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A688C4CEF7;
	Thu, 12 Mar 2026 20:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346988;
	bh=XnWcQ50rPKCV61W2PiTJKbi1zJKSb5K0uURFXFLiL9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPIe2xATBlpfo3GmgNpp3pQ2hJavFrIE0hOHd5xrGxnUEMkrDkL0V2m+3wUb7lbkX
	 6cJ7F6jI07Ag/AQ7WgNbBwFdlcRXLEy2rtHc4qo0+ZhSo2vaOlP2c9w5V0Am/9qZsv
	 dLOZ2HVuS3W+O6YW90TBIGGzA74zoOzbclYGFUwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Kerem Karabay <kekrby@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 174/265] HID: multitouch: Get the contact ID from HID_DG_TRANSDUCER_INDEX fields in case of Apple Touch Bar
Date: Thu, 12 Mar 2026 21:09:21 +0100
Message-ID: <20260312201024.588757767@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Kerem Karabay <kekrby@gmail.com>

[ Upstream commit f41d736acc039d86512951f4e874b0f5e666babf ]

In Apple Touch Bar, the contact ID is contained in fields with the
HID_DG_TRANSDUCER_INDEX usage rather than HID_DG_CONTACTID, thus differing
from the HID spec. Add a quirk for the same.

Acked-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Kerem Karabay <kekrby@gmail.com>
Co-developed-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: a2e70a89fa58 ("HID: multitouch: new class MT_CLS_EGALAX_P80H84")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index c3a914458358c..b7c2640a61b4a 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -72,6 +72,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_FORCE_MULTI_INPUT	BIT(20)
 #define MT_QUIRK_DISABLE_WAKEUP		BIT(21)
 #define MT_QUIRK_ORIENTATION_INVERT	BIT(22)
+#define MT_QUIRK_APPLE_TOUCHBAR		BIT(23)
 
 #define MT_INPUTMODE_TOUCHSCREEN	0x02
 #define MT_INPUTMODE_TOUCHPAD		0x03
@@ -621,6 +622,7 @@ static struct mt_application *mt_find_application(struct mt_device *td,
 static struct mt_report_data *mt_allocate_report_data(struct mt_device *td,
 						      struct hid_report *report)
 {
+	struct mt_class *cls = &td->mtclass;
 	struct mt_report_data *rdata;
 	struct hid_field *field;
 	int r, n;
@@ -645,7 +647,11 @@ static struct mt_report_data *mt_allocate_report_data(struct mt_device *td,
 
 		if (field->logical == HID_DG_FINGER || td->hdev->group != HID_GROUP_MULTITOUCH_WIN_8) {
 			for (n = 0; n < field->report_count; n++) {
-				if (field->usage[n].hid == HID_DG_CONTACTID) {
+				unsigned int hid = field->usage[n].hid;
+
+				if (hid == HID_DG_CONTACTID ||
+				   (cls->quirks & MT_QUIRK_APPLE_TOUCHBAR &&
+				   hid == HID_DG_TRANSDUCER_INDEX)) {
 					rdata->is_mt_collection = true;
 					break;
 				}
@@ -823,6 +829,14 @@ static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 						     EV_KEY, BTN_TOUCH);
 			MT_STORE_FIELD(tip_state);
 			return 1;
+		case HID_DG_TRANSDUCER_INDEX:
+			/*
+			 * Contact ID in case of Apple Touch Bars is contained
+			 * in fields with HID_DG_TRANSDUCER_INDEX usage.
+			 */
+			if (!(cls->quirks & MT_QUIRK_APPLE_TOUCHBAR))
+				return 0;
+			fallthrough;
 		case HID_DG_CONTACTID:
 			MT_STORE_FIELD(contactid);
 			app->touches_by_report++;
-- 
2.51.0



