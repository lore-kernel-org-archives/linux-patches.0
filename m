Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D7E20E334;
	Tue, 30 Sep 2025 15:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245660; cv=none; b=Tt3mY1WTEjSupEhwewxwLXO/eiLLC7tS5+mywBK71TK3tmZjTbc7tUiilgIbWdGgxevDFIkY+BxyoIom0eYYcCnt9JflPSjLF5YVp4hkaD7SuHpMrHwiU0s5+YzUu3V+/32Umsd/La1IdPStzsjTNjcuSBosgtHNgzGXMINbaBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245660; c=relaxed/simple;
	bh=eyoS5/gXB/B+WYSrLqDtdjL51Y3kzrGw4wOJZWlfX0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SITBiithgfk0lbHO3zRRhKi8PRon766mLaeC0PrQCBjS1LGXYkUpbv1Qpl6bMm/tK9EK2rdZcnkFsLeqGJkmU1tArpgfH0z/+oIJi+SE4JQPAbE4wEkxaU3OjrpoUXD+XhwrQlfPOr403BRRt44JrCmBFVgMiDy7Y4p9qeezFdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jnYweD1g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jnYweD1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB43C4CEF0;
	Tue, 30 Sep 2025 15:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245660;
	bh=eyoS5/gXB/B+WYSrLqDtdjL51Y3kzrGw4wOJZWlfX0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jnYweD1gBR50QYH/W5UwleXCcW0hSTLaSSyfgF+c4UI95h1Ff5E25h/ccgqgs/WG4
	 SN9d/kmGQVZdx0FblmNM56KBrVU7BEaqXchUxqRWivRaqwydQHR3TaFS5Qx1Hw8BTx
	 0yNpqzfuSalWNyfipPTO6dUOwf+2TXDz4MLJgtOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Tissoires <bentiss@kernel.org>,
	Kerem Karabay <kekrby@gmail.com>,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 12/91] HID: multitouch: specify that Apple Touch Bar is direct
Date: Tue, 30 Sep 2025 16:47:11 +0200
Message-ID: <20250930143821.637000809@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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
index 8e9f71e69dd8c..d8fee341c096e 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1336,6 +1336,13 @@ static int mt_touch_input_configured(struct hid_device *hdev,
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



