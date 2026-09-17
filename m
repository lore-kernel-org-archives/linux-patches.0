Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F44F49D59C;
	Thu, 17 Sep 2026 16:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664343; cv=none; b=msTLKyr1ArcYCI+H79YNnBFNgrOUrOUmUZyMLlBHr3ljEyjwU6j0nJYHfCHjMcG+3Efg/0s0B0p5t/N5f0mqvFOVh19wpSVe6DEv8sKVwpmmC9htkEthiIoSf+v4mqY3oodh2NdRaTM8l+KyUGDqx7w4leQAgKY9Cv7amcLsR3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664343; c=relaxed/simple;
	bh=OubzbjWV2hsqyDAqx21AFUSypQQhSUei9+xglZOqHRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJYUgkllh+tMfHkHXOnk3PSnmMmt3lGURjHZe7fu+Bia74QoEAmMSNTHm7FuQVcC60YwwegVzR0Kr07wFHKaRFc1g50BaWzu3jNnjPPHjYBKDHM7fWvCje5M6EiULzFbmh2kdbJtJegZ3RGo0W8M6AMFJO1HSIyXhcNnRf0Q5Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXAcOrlK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXAcOrlK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDE71F000FF;
	Thu, 17 Sep 2026 16:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664342;
	bh=WwBQB3l11ex7tuuOMFcmtMNznk3lmP0sp1ICeIg1Kv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JXAcOrlKAri+4TnDh+WzHAZE1hfZ+txQjJNGbfsRDQvc+jmkzBJ74lvHnWSgZ6YL7
	 B4sRHOiyZnEKzXd54Nj4GFvmfwYSeTF1n/Es/r9BM+c5UIEcnL1NtUG4gUWUBTfpK5
	 T7ZUW6G8vX8rA8V9X/v4Q/WAv28wl+AT+VXnzAZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillermo Servera Negre <guillem@gservera.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0301/1250] wifi: rtw89: 8851bu: add Mercusys MA60XNB (2c4e:0128)
Date: Thu, 17 Sep 2026 16:01:36 +0100
Message-ID: <20260917151600.275556548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 575e6a72bd68008b6795345113d3e94f3dccbf5d ]

Add the specific USB device ID which adapter tested fully functional on
Fedora 44 with kernel 7.0.8-200.fc44.x86_64 and linux-firmware
20260410-1.fc44.

Reported-by: Guillermo Servera Negre <guillem@gservera.com>
Tested-by: Guillermo Servera Negre <guillem@gservera.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260525011728.6836-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/rtw8851bu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8851bu.c b/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
index 04e1ab13b7535..10fcfade6151e 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
@@ -19,6 +19,9 @@ static const struct usb_device_id rtw_8851bu_id_table[] = {
 	/* D-Link AX9U rev. A1 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x332a, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8851bu_info },
+	/* Mercusys MA60XNB */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2C4E, 0x0128, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&rtw89_8851bu_info },
 	/* TP-Link Archer TX10UB Nano */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3625, 0x010b, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8851bu_info },
-- 
2.53.0



