Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E61BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E9DC433EF;
	Tue,  7 Mar 2023 18:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213757;
	bh=a0cFAltp+eLQqk0uTpKIVk/zAurYpeThSXjM+yNoyrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PNPrPShJsukodrSiNravyjGZTA3MjZqrTHbU4U+KPom/JZEC2IGnRYJEwZvbI4Iil
	 +5ivQ6RfpOGohRw6A4erY32VtyF0EQ5d7AvvxdyMVDH3kTifba7Mm6hSHkGRkDS+FD
	 KCcCBz4yTWjVXBfXhKBpYW8YoWgll3qpbSN9LF0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mia Kanashi <chad@redpilled.dev>,
	Andreas Grosse <andig.mail@t-online.de>,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 610/885] HID: uclogic: Add battery quirk
Date: Tue,  7 Mar 2023 17:59:04 +0100
Message-Id: <20230307170028.814838068@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit f60c377f52de37f8705c5fc6d57737fdaf309ff9 ]

Some UGEE v2 tablets have a wireless version with an internal battery
and their firmware is able to report their battery level.

However, there was not found a field on their descriptor indicating
whether the tablet has battery or not, making it mandatory to classify
such devices through the UCLOGIC_BATTERY_QUIRK quirk.

Tested-by: Mia Kanashi <chad@redpilled.dev>
Tested-by: Andreas Grosse <andig.mail@t-online.de>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-uclogic-params.c | 5 +++++
 drivers/hid/hid-uclogic-params.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/hid/hid-uclogic-params.c b/drivers/hid/hid-uclogic-params.c
index e052538a62fb3..23624d5b07b5a 100644
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -1222,6 +1222,11 @@ static int uclogic_params_ugee_v2_init_frame_mouse(struct uclogic_params *p)
  */
 static bool uclogic_params_ugee_v2_has_battery(struct hid_device *hdev)
 {
+	struct uclogic_drvdata *drvdata = hid_get_drvdata(hdev);
+
+	if (drvdata->quirks & UCLOGIC_BATTERY_QUIRK)
+		return true;
+
 	/* The XP-PEN Deco LW vendor, product and version are identical to the
 	 * Deco L. The only difference reported by their firmware is the product
 	 * name. Add a quirk to support battery reporting on the wireless
diff --git a/drivers/hid/hid-uclogic-params.h b/drivers/hid/hid-uclogic-params.h
index 10a05c7fd9398..b0e7f3807939b 100644
--- a/drivers/hid/hid-uclogic-params.h
+++ b/drivers/hid/hid-uclogic-params.h
@@ -20,6 +20,7 @@
 #include <linux/hid.h>
 
 #define UCLOGIC_MOUSE_FRAME_QUIRK	BIT(0)
+#define UCLOGIC_BATTERY_QUIRK		BIT(1)
 
 /* Types of pen in-range reporting */
 enum uclogic_params_pen_inrange {
-- 
2.39.2



