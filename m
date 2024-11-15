Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64092EAD0;
	Fri, 15 Nov 2024 06:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653484; cv=none; b=isIaYVC44v85h3Hd7WLSuB2yCbkb7HibS3wDENY3g6Ugsb4KlmTvyjWKFFTgBIs4RugR52Mlj1VM+LYXpJgcc+1DRjrZu/j9KDl7IpNVVmqRhm1NLoRabDs3rbFoqVuMpl0YZOHiNBu62NnlrUYfLoNHQpdJQ4HZM3fMHUANWi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653484; c=relaxed/simple;
	bh=R/PWH5xYIJvddstxCVGRY8bl3DbgSRU6+oqqfy7Qk24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gS8tkKB9iq3TbNanMiDpDhHYuR0aabxuIeyK8YNJD12JJccAfCQ7oxIFbQFbY4jGz4ndTRrFdLNlRjNKVXlroIdeRv0iC5TeJLrI+cLxcq/Ybk9iTUU3p9vDMJag1PfEZU3TR090bVSwg9j+iwheYIjlX3RXWDmL4lBqZi2aZ5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMOnVF4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMOnVF4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA330C4CECF;
	Fri, 15 Nov 2024 06:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653484;
	bh=R/PWH5xYIJvddstxCVGRY8bl3DbgSRU6+oqqfy7Qk24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMOnVF4tBsW4yAmWIQPRrMqxpxmTYrcPv9pF39PeSSw/WP9qrosJ6wx8jiru+XJNS
	 E5YiRJCj4UGMFcGTbZjGe+tTrEhDNQZgkn3hN3G66i2PBWenB0M7KUjY3rnjaV1wBp
	 1aOmGE0Hk2VO3Vr2T7qpQYvLtbDISX/+/KjneX1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 08/48] HID: multitouch: Add quirk for HONOR MagicBook Art 14 touchpad
Date: Fri, 15 Nov 2024 07:37:57 +0100
Message-ID: <20241115063723.264420860@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

[ Upstream commit 7a5ab8071114344f62a8b1e64ed3452a77257d76 ]

The behavior of HONOR MagicBook Art 14 touchpad is not consistent
after reboots, as sometimes it reports itself as a touchpad, and
sometimes as a mouse.

Similarly to GLO-GXXX it is possible to call MT_QUIRK_FORCE_GET_FEATURE as a
workaround to force set feature in mt_set_input_mode() for such special touchpad
device.

[jkosina@suse.com: reword changelog a little bit]
Link: https://gitlab.freedesktop.org/libinput/libinput/-/issues/1040
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 7584e5a3aafeb..c2d79b2d6cdd2 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2093,6 +2093,11 @@ static const struct hid_device_id mt_devices[] = {
 		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
 			0x347d, 0x7853) },
 
+	/* HONOR MagicBook Art 14 touchpad */
+	{ .driver_data = MT_CLS_VTL,
+		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
+			0x35cc, 0x0104) },
+
 	/* Ilitek dual touch panel */
 	{  .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_ILITEK,
-- 
2.43.0



