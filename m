Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC7A25D1F7;
	Tue, 30 Sep 2025 15:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245970; cv=none; b=Rfu7l4PIPxOMFgnw2MgUcejAmLzfjqwI5pEpWpyrC08vmtRyWUIkPomdI/LiKamSUF/6eGM4b41Md0/KO1rVYl92CjF5DVVwZz895hDFQL26rj9pMzbO4L7sYS+BCUk2J+CP9030BlW/rVkLlCBEFRvWqB16axB8DDgj1RgF+Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245970; c=relaxed/simple;
	bh=9VyryZ6EMbL5PFplDfGSWG+c9xosZSrplx4W3+/Az/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIsbgIbZqxZC/QVjUI5VU222UyvfcY/qvyk0Q8XKPmAO0EnLN7RdlhqM/I8dW6o5DWusB1qLzB++uyfZIiqUpY9hc2Xoj4aZktNA3m4ovFPdmRscb3Noy1ed+cOG7S7SefXkduR7NI0yIyVN3NdDi7/h30xb8c9BSFxfDXm/C4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQlqTvQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQlqTvQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137CCC116B1;
	Tue, 30 Sep 2025 15:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245970;
	bh=9VyryZ6EMbL5PFplDfGSWG+c9xosZSrplx4W3+/Az/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQlqTvQcUBCAAiVU6MtvWfTlkbNszw3/qsyL5x5jP3CP0QESVZ97RtG0t5NXRcnNQ
	 28AHzUOykU792Sa9VGSxC6tuzULpXhBwKIEl72kJxwKZHvm1sUSKCDEwmwa1ppv03K
	 HwMLVuF7M0OUEfp3GnB7csu/L7ObkW5yk6gu1HRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Kerem Karabay <kekrby@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 13/89] HID: multitouch: specify that Apple Touch Bar is direct
Date: Tue, 30 Sep 2025 16:47:27 +0200
Message-ID: <20250930143822.419910633@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

[ Upstream commit 45ca23c5ee8b2b3074377fecc92fa72aa595f7c9 ]

Currently the driver determines the device type based on the
application, but this value is not reliable on Apple Touch Bar, where
the application is HID_DG_TOUCHPAD even though this device is direct,
so add a quirk for the same.

Acked-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Kerem Karabay <kekrby@gmail.com>
Co-developed-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index ec676f26800ea..09a56adf619b7 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1341,6 +1341,13 @@ static int mt_touch_input_configured(struct hid_device *hdev,
 	if (td->serial_maybe)
 		mt_post_parse_default_settings(td, app);
 
+	/*
+	 * The application for Apple Touch Bars is HID_DG_TOUCHPAD,
+	 * but these devices are direct.
+	 */
+	if (cls->quirks & MT_QUIRK_APPLE_TOUCHBAR)
+		app->mt_flags |= INPUT_MT_DIRECT;
+
 	if (cls->is_indirect)
 		app->mt_flags |= INPUT_MT_POINTER;
 
-- 
2.51.0



