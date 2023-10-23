Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6391715EB8
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nd5kMo6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3837C433C9;
	Mon, 23 Oct 2023 11:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061805;
	bh=1dwWgPxRyijTVEBOs+48TZeIElb7x4cuJnELGUANJKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nd5kMo6F32gISDUsyNQFX0OJ/bVw7Y8qZOG3x7l2mOqE3Wwtgwjn6g/YIctqQajPt
	 mf6a9QL6RvWLN0V3TqbcHA12W7UOlRJl6Fq+C6/MePAYPMc0npGo4VwFguIdlbsJOu
	 ZZZAX359/hQxcfb+12UbXZBI3YFztfTzTFhMbPiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rain <rain@sunshowers.io>,
	Rahul Rameshbabu <sergeantsagara@protonmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 170/202] HID: multitouch: Add required quirk for Synaptics 0xcd7e device
Date: Mon, 23 Oct 2023 12:57:57 +0200
Message-ID: <20231023104831.453230038@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Rameshbabu <sergeantsagara@protonmail.com>

[ Upstream commit 1437e4547edf41689d7135faaca4222ef0081bc1 ]

Register the Synaptics device as a special multitouch device with certain
quirks that may improve usability of the touchpad device.

Reported-by: Rain <rain@sunshowers.io>
Closes: https://lore.kernel.org/linux-input/2bbb8e1d-1793-4df1-810f-cb0137341ff4@app.fastmail.com/
Signed-off-by: Rahul Rameshbabu <sergeantsagara@protonmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index dc7c33f6b2c4e..84b12599eaf69 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2058,6 +2058,10 @@ static const struct hid_device_id mt_devices[] = {
 			USB_DEVICE_ID_MTP_STM)},
 
 	/* Synaptics devices */
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
+		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
+			USB_VENDOR_ID_SYNAPTICS, 0xcd7e) },
+
 	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
 		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
 			USB_VENDOR_ID_SYNAPTICS, 0xce08) },
-- 
2.40.1



