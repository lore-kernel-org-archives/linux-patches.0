Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270A72F39B1;
	Tue, 11 Nov 2025 01:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824361; cv=none; b=fOV50wAkTcTe0of+6xkr1jwJssTPfjF4dNT/kThowOpwogQOcf/Zuguprss2y9PTnkuJn+tbDghbckObcQaeG2oq1IT5K+mBcQlYbl9wKRQdOcXLd7PG8/o5aB6cEu1awu9KEgBoFlOCBbWrzuaAgNmithZDcZnTJRZ3XfHo7PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824361; c=relaxed/simple;
	bh=ekkgtDmTbeuJbIZ6JTXolfh2bRt5vQStnzF9l8H1a+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/fijHkEDYVGd5sFojEP4Zyagq3O00OSlS0XFa1hcuTDoH3FeHWaSjIWCyeDSLf303Lk0Zzuny97j/B1TZJCGUTVulmVMZ+JCSC+Cl2oTX5InC5Y+Lm+S9e/Qqarml7DcIDK4684/tX2RjiNif6+BT+36bGVDTnj34fF3j6lDA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KEsMX7Oe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KEsMX7Oe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7737C19422;
	Tue, 11 Nov 2025 01:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824361;
	bh=ekkgtDmTbeuJbIZ6JTXolfh2bRt5vQStnzF9l8H1a+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KEsMX7OeP/EoXjIDTsV8X27cXEPkue+z3AvFlt0NG/lDHEpK/tprcP2ZXvIujCyRA
	 C17zt1gh+gm/zXh8+9wUxMmAOzqX3B0NkGlcnKimPYDlecECHZGWdOLyyHKf3NFCB5
	 3e0XIe0+GCRi2D4xLgSKFVrCTjqtRnMS0LAKXF1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenm Chen <zenmchen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 480/849] wifi: rtw89: Add USB ID 2001:332a for D-Link AX9U rev. A1
Date: Tue, 11 Nov 2025 09:40:50 +0900
Message-ID: <20251111004548.047172543@linuxfoundation.org>
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

[ Upstream commit 2ffc73cdb8247dc09b6534c4018681a126c1d5f5 ]

Add USB ID 2001:332a for D-Link AX9U rev. A1 which is a RTL8851BU-based
Wi-Fi adapter.

Only managed mode and AP mode are tested and it works in both.

Signed-off-by: Zenm Chen <zenmchen@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250902035755.1969530-1-zenmchen@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/rtw8851bu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8851bu.c b/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
index c3722547c6b09..04e1ab13b7535 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8851bu.c
@@ -16,6 +16,9 @@ static const struct rtw89_driver_info rtw89_8851bu_info = {
 static const struct usb_device_id rtw_8851bu_id_table[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0bda, 0xb851, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8851bu_info },
+	/* D-Link AX9U rev. A1 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x332a, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&rtw89_8851bu_info },
 	/* TP-Link Archer TX10UB Nano */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x3625, 0x010b, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8851bu_info },
-- 
2.51.0



