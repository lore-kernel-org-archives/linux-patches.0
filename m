Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F3815E84
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="llItr2aM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3577AC433C8;
	Mon, 23 Oct 2023 11:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060882;
	bh=vqDQnmcGsyYfMiFbLJGDf25hgd8cJ5+5HbobVGJO81U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=llItr2aMC6SSxqeKgDHV3aMeVgixYRtAkC2duSrPztm0CAs+wsNJ0sDyICWnqumwQ
	 L36Bklw16hd8ZSRBWSQIlTG8G2+22H9FFTjwGpSYgEgnHRVoimS+TZ7HZEzR+3Md/u
	 txzIF6+g8+kcn5be+eoe0Gb6wDqYjmILtedLC2kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rain <rain@sunshowers.io>,
	Rahul Rameshbabu <sergeantsagara@protonmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/123] HID: multitouch: Add required quirk for Synaptics 0xcd7e device
Date: Mon, 23 Oct 2023 12:57:38 +0200
Message-ID: <20231023104821.055092863@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104817.691299567@linuxfoundation.org>
References: <20231023104817.691299567@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 0893b31e6f102..590b25460456b 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2081,6 +2081,10 @@ static const struct hid_device_id mt_devices[] = {
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



