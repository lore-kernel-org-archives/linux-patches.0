Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE1130FF1D;
	Fri,  9 Jan 2026 11:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959497; cv=none; b=FoKUr7RKJLc7XLHObi2TnAAZ9M4v7kOT/TRFdfwHghV8euryTJ3YKCEZNY8AaQfeus8Fe8mqlidZUWjb8jicm+dRK7x3AOm8Tuku8YzGG1JhnElzbhIZ2YaQTWRP1exh0V0Wace1HP1oET4VgDPgVK4gYf2Mi2hIqjTisc7ZQ54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959497; c=relaxed/simple;
	bh=5lxM/lGA1FrMcdn50+ikdL4Q/YmdeQ15EYb9GjCWb9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSx1GhF4Mq8s9o/j6+LlDn4+Hm9IAvBSFPyu1/LeA/iQUxcJtHX8nsHj6oNqjPaFLJO07Ej5uZ93+wIhEg76UHw1N2JdkRsQps0R7YguQ+0opUoNWzVoQxW3hHGnLsYhzwGvl5IG2y73/8PD2FzhbdsUMXWAqy0ucpv81V3sZiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1soWA/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1soWA/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8662AC4CEF1;
	Fri,  9 Jan 2026 11:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959496;
	bh=5lxM/lGA1FrMcdn50+ikdL4Q/YmdeQ15EYb9GjCWb9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1soWA/ef9bj9Vjm0RLkd0ev+Yfq90WMjIE8kNh7vmT8SNr42i6GEew1EThyPqtxs
	 VeYtIEpr7/wC5/CI/Z0YN40k5ALBdZP8rJqtAB6FiZXLS9xiQV6TwcTTjBmCGHBnjC
	 1rT35PHAEd5XlriWXtSrQMFgunCZaCOQL16wbws8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenm Chen <zenmchen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.6 040/737] wifi: rtw88: Add USB ID 2001:3329 for D-Link AC13U rev. A1
Date: Fri,  9 Jan 2026 12:32:59 +0100
Message-ID: <20260109112135.503402951@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Zenm Chen <zenmchen@gmail.com>

commit b377dcd9a286a6f81922ae442cd1c743bc4a2b35 upstream.

Add USB ID 2001:3329 for D-Link AC13U rev. A1 which is a RTL8812CU-based
Wi-Fi adapter.

Compile tested only.

Cc: stable@vger.kernel.org # 6.6.x
Signed-off-by: Zenm Chen <zenmchen@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250929035719.6172-2-zenmchen@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/rtw8822cu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/realtek/rtw88/rtw8822cu.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822cu.c
@@ -21,6 +21,8 @@ static const struct usb_device_id rtw_88
 	  .driver_info = (kernel_ulong_t)&(rtw8822c_hw_spec) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x13b1, 0x0043, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&(rtw8822c_hw_spec) }, /* Alpha - Alpha */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x3329, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822c_hw_spec) }, /* D-Link AC13U rev. A1 */
 	{},
 };
 MODULE_DEVICE_TABLE(usb, rtw_8822cu_id_table);


