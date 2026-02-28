Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93195340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301071; cv=none; b=EWbjikkzL4Nm689ct98+V33gVfuFRVkRdKo3R5zc7RiVXZTveXXHEQb1fkjL95XM7Jzq0a4l0CMFdYDW39Z2F+fFrWDMmuDjHuod6vJZ7a/HChDASZZjQbZXjvGjmvx4s6D38HUeoZCkVu5dvHXGqIT1pbC+soWwqz6/HUYITgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301071; c=relaxed/simple;
	bh=Dt/wMIymTdav/UUeeLS7H4kMK41+6TdhOpRB1a3sCa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UIW+/s4cEE2FoVjxfBGIuxT1jKCYPk9DvVtRwO1MAg+VSyC7SlbXltJ4/0yYnUyQF0dqeyZA1Pck7IOQkc2tfc2X60YioKvkOX2q9nsL65Pft7O+3wWN6NUfbxANUw3eaCjS3Aex0/vNSINgOrWrQncyzSH9EQ0NCpBOb6KgE4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iB15dS5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iB15dS5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039DEC116D0;
	Sat, 28 Feb 2026 17:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301071;
	bh=Dt/wMIymTdav/UUeeLS7H4kMK41+6TdhOpRB1a3sCa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iB15dS5w/1O4614QNgMcXrwApJboxGg6mD76ATmREanrOlDST4lJhY3NUbTdvn2UL
	 L4t0MBicTfVdDMnppUFBm477QjySzHx0yqQ2NMDl5JSwE6d3uej3cRxt6BG2EOM/S0
	 9AdcKMNPtVLLP0FuiBOfeATe7/C1QWJmYtvjcjnxeIAOaC4B8oNecTueHFmHk0QL8Y
	 /cTOeDkVdIewkUHDDf1NGZ+I8t/PAws4IxiO4wUAqsRghQMOomhBGwqzknvO17H5AA
	 Gnk+eZCiBO+mOLPFybrNW4Yr2GtuwO9rxpGW8H5G2CyqiPu/MAGQ0qN1wavTSxFUlR
	 cpD7Ww2pBRH2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hsiu-Ming Chang <cges30901@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 216/752] wifi: rtw88: rtw8821cu: Add ID for Mercusys MU6H
Date: Sat, 28 Feb 2026 12:38:47 -0500
Message-ID: <20260228174750.1542406-216-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hsiu-Ming Chang <cges30901@gmail.com>

[ Upstream commit 77653c327e11c71c5363b18a53fbf2b92ed21da4 ]

Add support for Mercusys MU6H AC650 High Gain Wireless Dual Band USB
Adapter V1.30. It is based on RTL8811CU, usb device ID is 2c4e:0105.

Signed-off-by: Hsiu-Ming Chang <cges30901@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20251205003245.5762-1-cges30901@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/rtw8821cu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821cu.c b/drivers/net/wireless/realtek/rtw88/rtw8821cu.c
index 7a0fffc359e25..8cd09d66655db 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821cu.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821cu.c
@@ -37,6 +37,8 @@ static const struct usb_device_id rtw_8821cu_id_table[] = {
 	  .driver_info = (kernel_ulong_t)&(rtw8821c_hw_spec) }, /* Edimax */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x7392, 0xd811, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&(rtw8821c_hw_spec) }, /* Edimax */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2c4e, 0x0105, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8821c_hw_spec) }, /* Mercusys */
 	{},
 };
 MODULE_DEVICE_TABLE(usb, rtw_8821cu_id_table);
-- 
2.51.0

