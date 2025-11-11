Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED79426D4DF;
	Tue, 11 Nov 2025 01:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824368; cv=none; b=M+25OD3RerstCYv2W0NISBRAdy5tGsajxBVLy6CWf0BSh7xGISfH7+bj+8VSr0NFnMsOTYWjRP1Dp9bGh1K0cJOW6NfmqiVRWdnNlkorZYsOhPdwbnWBF8jRsT5He6qiDtNW1P0oqg1wlWr8w7boa2sYCIcfoDk5ybIhsEN5JKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824368; c=relaxed/simple;
	bh=WuZN/xXx/gQ7rSkaI/P3uHOo6qAM0d7RZ31vhrcfazo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKvvwno4QG5x3g6EuSCRSgkccxJMCMk+QFKz2rwlbncwL2GRL3coWLdVuiueWd8XOcQW2eREr9GU3BcOV8kgw3rhbm6KDAZdQFAjAnxytje7w6qmhhZOEM/QyYclmEO2kAaWGuAB7g9JZQyKnP0ay16tb20CskdAb6mpHg1RnU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kh+fAM3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kh+fAM3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB0DC116D0;
	Tue, 11 Nov 2025 01:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824367;
	bh=WuZN/xXx/gQ7rSkaI/P3uHOo6qAM0d7RZ31vhrcfazo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kh+fAM3D6S+lSClTcloQDTYrGN+eFQJRZ17F4kxrTrG4Cdft16k5moQ9YYJ8A0E0j
	 2MhPR51xPh0fUkE+DP39gbhCDme7W9/Cp0xiuJ0tRa9ohfJo+3l7oLgYD1OzWFxU8/
	 X04pPITrKVmE/+HbzJU56Iy2Xn8ld2a8vY2hx1Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenm Chen <zenmchen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 481/849] wifi: rtw89: Add USB ID 2001:3327 for D-Link AX18U rev. A1
Date: Tue, 11 Nov 2025 09:40:51 +0900
Message-ID: <20251111004548.071378844@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zenm Chen <zenmchen@gmail.com>

[ Upstream commit 17002412a82feb21be040bd5577789049dfeebe2 ]

Add USB ID 2001:3327 for D-Link AX18U rev. A1 which is a RTL8832BU-based
Wi-Fi adapter.

Link: https://github.com/morrownr/rtw89/pull/17
Signed-off-by: Zenm Chen <zenmchen@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250903223100.3031-1-zenmchen@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/rtw8852bu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852bu.c b/drivers/net/wireless/realtek/rtw89/rtw8852bu.c
index b315cb997758a..0694272f7ffae 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8852bu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8852bu.c
@@ -30,6 +30,8 @@ static const struct usb_device_id rtw_8852bu_id_table[] = {
 	  .driver_info = (kernel_ulong_t)&rtw89_8852bu_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0db0, 0x6931, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8852bu_info },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x3327, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&rtw89_8852bu_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3574, 0x6121, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8852bu_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x35bc, 0x0100, 0xff, 0xff, 0xff),
-- 
2.51.0



