Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D53519DEA;
	Wed, 30 Sep 2026 18:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792603; cv=none; b=VAebEcS7xueQpgNe1kyfipzurziEbzaz6I3kL5lgYiQE9CmrfDxOMR2ZUNe6haBicorNTqdyThZuXtHUIlOPv9V5kVNoLYyWo34/Zqj8LEzXE04NtJhON11wsXxIL3ix7OKJjGCaYdNpLuZ35aQG+MBrbMInL7CEAZYA8HBSuj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792603; c=relaxed/simple;
	bh=ZW4axRNNpxltK/uuqqsSHKKdRNawJ7hJhkvhKUtskzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnHUnk2i70CSH9HxuMD2STvUL/PwiR+u5d9Y0a5YAjWWNI/Mi/E1sauCFgvhoRSmHIfibwP2DLkiGmQSuVTqwvvvoSmUosmwkIAEbrbWYCEwIOpm/yR6+PnQwdZFvRyqhSq9nJ9WfFyBjhtGV4BVV5cGZ1HsAVeZON0N9Th3dsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLp3oQdJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLp3oQdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF351F000FF;
	Wed, 30 Sep 2026 18:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792601;
	bh=X7+VDoVzjwshobcV/pG6p55MEmH3aa8tAyv3aiOsuCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLp3oQdJYFXBXktv73eb3xADgUkfBI85NZp6ASbSutOPPvlzhnRWL215y70peR6yR
	 LE1qN8o+5iMyhmSOZEXyzVpx/Rxk71yQa8d+1ENzVZsfbt0tbC4ONDqwAQudhCft0R
	 jz0SGNkRz6zXUwLtO6/euuGWu8Wqx032FbW+C1/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Carvalho <marcocarvalho.web@gmail.com>,
	Junjie Cao <junjie.cao@intel.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.15 714/752] HID: quirks: add ALWAYS_POLL quirk for SDINNOVATION gaming keyboard
Date: Wed, 30 Sep 2026 17:29:44 +0200
Message-ID: <20260930152413.677542237@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1116,6 +1116,9 @@
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
@@ -171,6 +171,7 @@ static const struct hid_device_id hid_qu
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X52_2), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X52_PRO), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_X65), HID_QUIRK_INCREMENT_USAGE_ON_DUPLICATE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_SDINNOVATION, USB_DEVICE_ID_SDINNOVATION_GAMING_KBD), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SEMICO, USB_DEVICE_ID_SEMICO_USB_KEYKOARD2), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SEMICO, USB_DEVICE_ID_SEMICO_USB_KEYKOARD), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SENNHEISER, USB_DEVICE_ID_SENNHEISER_BTD500USB), HID_QUIRK_NOGET },


