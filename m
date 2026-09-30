Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CFA51C34D;
	Wed, 30 Sep 2026 19:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797030; cv=none; b=LIBNocyz3xeY0lrw2xf6OrGI/tqroFAJyhTh/FC8hYUvEdBp59QZeAPE6eyPDK/U3/ByL8LwSqxf8ojRnEq8GeiD7hmyv4Rc2ubfEubKz10/yK/r3nW9tKp9tbKARwgt+ZmZvNil0lHWviJI42L8v4gJzgJLpIVLx9ewWXKiesE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797030; c=relaxed/simple;
	bh=ezwJQc9IyFjsh0UYfZzZNsvZU3fS0gXe3mQWWSfkx/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUyiJ6BEChgwspSZ6t/6DDBJTRLv5f2ACd+miIbJwXY1AOjibWT8umzjLTBqAxIe2Vy8TVT4IfGsN8idxRSPbrGmz/B05I4F5+lYiMVcSff8V5lbDIfpbPqspctaawBia8Ko+v4vkpvWvgEg07aQK+a5VE5/BqjnGbkcEQZa+f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BONG66+F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BONG66+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627011F000FF;
	Wed, 30 Sep 2026 19:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797028;
	bh=HyEXhqLCJjsCDGmPvs9qN0uyH9tVsCbFlv6vsqqgpYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BONG66+FUAeQ1vUGFXwvc6smZP4GRCJ4qjOgOZlV/inRSeZX1AJMt9M1YZscCpkOT
	 MNie+RavxQBRJCPJEzqDtvC5wRAd8bPAFyPWCz8V2jxja9/iiITEo6Dp2qQx+rkOM7
	 pOJKWSXg1TjQqiLvE1d0McqF1vq4mJkPaqmEnsMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Carvalho <marcocarvalho.web@gmail.com>,
	Junjie Cao <junjie.cao@intel.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.6 1122/1193] HID: quirks: add ALWAYS_POLL quirk for SDINNOVATION gaming keyboard
Date: Wed, 30 Sep 2026 17:30:06 +0200
Message-ID: <20260930152459.162662736@linuxfoundation.org>
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

From: Junjie Cao <junjie.cao@intel.com>

commit cdb669a3b8f844aca71fc3224990157d61562165 upstream.

The SDINNOVATION gaming keyboard (USB ID 36ae:feab) stops reporting
input events after its RGB lighting mode is switched about twice.
Disabling USB autosuspend and unbinding the other HID interfaces make
no difference; the issue does not occur on Windows.

HID_QUIRK_ALWAYS_POLL alone resolves it, verified on 7.1.8 via
usbhid.quirks=0x36ae:0xfeab:0x400.

Reported-by: Marco Carvalho <marcocarvalho.web@gmail.com>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2514627
Cc: stable@vger.kernel.org
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h    |    3 +++
 drivers/hid/hid-quirks.c |    1 +
 2 files changed, 4 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1200,6 +1200,9 @@
 #define USB_DEVICE_ID_SAMSUNG_IR_REMOTE	0x0001
 #define USB_DEVICE_ID_SAMSUNG_WIRELESS_KBD_MOUSE	0x0600
 
+#define USB_VENDOR_ID_SDINNOVATION		0x36ae
+#define USB_DEVICE_ID_SDINNOVATION_GAMING_KBD	0xfeab
+
 #define USB_VENDOR_ID_SEMICO			0x1a2c
 #define USB_DEVICE_ID_SEMICO_USB_KEYKOARD	0x0023
 #define USB_DEVICE_ID_SEMICO_USB_KEYKOARD2	0x0027
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -182,6 +182,7 @@ static const struct hid_device_id hid_qu
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X52_2), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X52_PRO), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X65), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SDINNOVATION, USB_DEVICE_ID_SDINNOVATION_GAMING_KBD), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SEMICO, USB_DEVICE_ID_SEMICO_USB_KEYKOARD2), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SEMICO, USB_DEVICE_ID_SEMICO_USB_KEYKOARD), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SENNHEISER, USB_DEVICE_ID_SENNHEISER_BTD500USB), HID_QUIRK_NOGET },


