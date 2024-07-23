Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E7915746B;
	Tue, 23 Jul 2024 18:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759922; cv=none; b=mf59z2R1fPv0I3aZGR/FXyr5+qj1y8DVvw9MGYsJyLzdjR2tnfdCsLy/pBf5sDz/xqNfF8rqxE2hbBTkF31+8TDOSGc6a3Bw8cMxDAorypUl2hvvT2Nh1e310XNu7Da/oI2YkssEq1oIf6GzgSGYcdrks6xr9KWKDCC0DRvlQF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759922; c=relaxed/simple;
	bh=rZKVUqmff74tmTU3kXNZXOK061si2zsKe0xS19jRYws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kE6eNE5ZjGFBGz+NPf/H4foGX3whd/6hcQB03YTQ0jEhsajOgRlBP2UkXNoIzRA8fr3dyv7GadSlfHxPrphzjWJSCxfYfzxBpfNkLvofVVwxnjqOD9Gp6HvjLilfLIYzvkpPnClERkjjmCMd7PInLPk1Qe68Cqe8Nrw3hYJOj+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHedpYKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHedpYKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5373FC4AF0A;
	Tue, 23 Jul 2024 18:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759922;
	bh=rZKVUqmff74tmTU3kXNZXOK061si2zsKe0xS19jRYws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHedpYKZX8oDPkArcT/jqyhSTEPVlzqOKAwxRyeBjRwcwKTvh6PxNozjNNs4pFXyo
	 cyPJUfhMSHVyLZB8HIRHOQJLPVHmvJiGFKc57I1XB7ZLYfmBiGTuW9o7AcC2eokHJG
	 Arb1M+h7FjzVUDf5UHSxSanfmejWlRtS73qKZGCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Dalibard <ontake@ontake.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 044/163] HID: Ignore battery for ELAN touchscreens 2F2C and 4116
Date: Tue, 23 Jul 2024 20:22:53 +0200
Message-ID: <20240723180145.175233144@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Louis Dalibard <ontake@ontake.dev>

[ Upstream commit a3a5a37efba11b7cf1a86abe7bccfbcdb521764e ]

At least ASUS Zenbook 14 (2023) and ASUS Zenbook 14 Pro (2023) are affected.

The touchscreen reports a battery status of 0% and jumps to 1% when a
stylus is used.

The device ID was added and the battery ignore quirk was enabled for it.

[jkosina@suse.com: reformatted changelog a bit]
Signed-off-by: Louis Dalibard <ontake@ontake.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h   | 2 ++
 drivers/hid/hid-input.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 68b0f39deaa9a..8eb073dea3593 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -421,6 +421,8 @@
 #define I2C_DEVICE_ID_HP_SPECTRE_X360_13_AW0020NG  0x29DF
 #define I2C_DEVICE_ID_ASUS_TP420IA_TOUCHSCREEN 0x2BC8
 #define I2C_DEVICE_ID_ASUS_GV301RA_TOUCHSCREEN 0x2C82
+#define I2C_DEVICE_ID_ASUS_UX3402_TOUCHSCREEN 0x2F2C
+#define I2C_DEVICE_ID_ASUS_UX6404_TOUCHSCREEN 0x4116
 #define USB_DEVICE_ID_ASUS_UX550VE_TOUCHSCREEN	0x2544
 #define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
 #define I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN	0x261A
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 8bb16e9b94aa5..c9094a4f281e9 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -377,6 +377,10 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_ASUS_GV301RA_TOUCHSCREEN),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_ASUS_UX3402_TOUCHSCREEN),
+	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_ASUS_UX6404_TOUCHSCREEN),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN),
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ELAN, USB_DEVICE_ID_ASUS_UX550VE_TOUCHSCREEN),
-- 
2.43.0



