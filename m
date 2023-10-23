Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144D314263
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trrj8EYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B469C433C7;
	Mon, 23 Oct 2023 11:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059327;
	bh=k7sN8yHVXawPOo11DamZbl2/OB1S3TE71vIbLHUeBkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trrj8EYoJoZcBTxq1xeXhB9Q6ZAySy6Vb6Nl1yv+891XzDEhzJbIO5BziziKOHwaG
	 91KnnaSTS6cjsmWWAiZ0ZaPZB0LejAS10Wwd7WhEdQkxwHv/fSR3dXmZGbomP9vh2x
	 YZXrSBHpZsYvJ8L5lWoz/koNWL6pNwlz+/M3fTPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabian Vogt <fabian@ritter-vogt.de>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 140/241] HID: Add quirk to ignore the touchscreen battery on HP ENVY 15-eu0556ng
Date: Mon, 23 Oct 2023 12:55:26 +0200
Message-ID: <20231023104837.284378939@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabian Vogt <fabian@ritter-vogt.de>

[ Upstream commit b009aa38a380becd98cc4e01c9b7626a11cb4905 ]

Like various other devices using similar hardware, this model reports a
perpetually empty battery (0-1%).

Join the others and apply HID_BATTERY_QUIRK_IGNORE.

Signed-off-by: Fabian Vogt <fabian@ritter-vogt.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h   | 1 +
 drivers/hid/hid-input.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 8a310f8ff20f5..cc0d0186a0d95 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -425,6 +425,7 @@
 #define I2C_DEVICE_ID_HP_SPECTRE_X360_13T_AW100	0x29F5
 #define I2C_DEVICE_ID_HP_SPECTRE_X360_14T_EA100_V1	0x2BED
 #define I2C_DEVICE_ID_HP_SPECTRE_X360_14T_EA100_V2	0x2BEE
+#define I2C_DEVICE_ID_HP_ENVY_X360_15_EU0556NG		0x2D02
 
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 40a5645f8fe81..5e2f721855e59 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -406,6 +406,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_SPECTRE_X360_14T_EA100_V2),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_ENVY_X360_15_EU0556NG),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{}
 };
 
-- 
2.40.1



