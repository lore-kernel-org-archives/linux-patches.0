Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01637866C;
	Wed, 21 Feb 2024 13:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521360; cv=none; b=b5dJPBe/YWI2u/DQGzCPD/4MpgRoQy+Y4euCpe4M3iAlgvYaYdrIdFhiZ9bNZqdZZsBTtGyuYRzWq8o956lNY8PURnTbm+dUr9uUzs/394+C2J0jvHqOTPCfZYbj7UL+ZcR9KyYEajHQnY3C5T17yaurZm9Qlrh01ZHcjFN6tSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521360; c=relaxed/simple;
	bh=s5fdk2VWs5Aym1FqKLH1fkaZ+d5nmIMI/a0sgytaC10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lf6KZx0Ih1RTjzPOAx2ugog/AHhZSHBy4dhp9ESDUJIBP3FoYPXtLLwHM21KRRt7/lbSaMtOZkq6Eik/m5/p7k2M5sbsXXrR/ACic9JFFc7NCOodS5fRAVt5WxnCXpSlYYru5qgJNgvstdjiHZqClYbLdAIiMgLvzmkXjmSlMkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBGZfIxR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBGZfIxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BED3C433F1;
	Wed, 21 Feb 2024 13:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521360;
	bh=s5fdk2VWs5Aym1FqKLH1fkaZ+d5nmIMI/a0sgytaC10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBGZfIxR85RO2kzr2rK6tIGSX48OMW2eravnyDuhMNpFr8WVWl8CsIRwGf5IHLUbi
	 M+Y+lhhDFPT6PRjS+E7DvuapBDyk2we4Vg/ImmIID9s0j5tK/WQrU4OiEiuXR2uO2j
	 eM62UlfqeHNVCwIkfZ/IDNq6119EjSDZIFFbhXHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenm Chen <zenmchen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 093/202] wifi: rtl8xxxu: Add additional USB IDs for RTL8192EU devices
Date: Wed, 21 Feb 2024 14:06:34 +0100
Message-ID: <20240221125934.793327537@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zenm Chen <zenmchen@gmail.com>

[ Upstream commit 4e87ca403e2008b9e182239e1abbf6876a55eb33 ]

Add additional USB IDs found in the vendor driver from
https://github.com/Mange/rtl8192eu-linux-driver to support more
RTL8192EU devices.

Signed-off-by: Zenm Chen <zenmchen@gmail.com>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20231217123017.1982-1-zenmchen@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c    | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 780dab276829..9c5a7ea1479e 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -6366,6 +6366,18 @@ static const struct usb_device_id dev_table[] = {
 	.driver_info = (unsigned long)&rtl8192eu_fops},
 {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x818c, 0xff, 0xff, 0xff),
 	.driver_info = (unsigned long)&rtl8192eu_fops},
+/* D-Link DWA-131 rev C1 */
+{USB_DEVICE_AND_INTERFACE_INFO(0x2001, 0x3312, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192eu_fops},
+/* TP-Link TL-WN8200ND V2 */
+{USB_DEVICE_AND_INTERFACE_INFO(0x2357, 0x0126, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192eu_fops},
+/* Mercusys MW300UM */
+{USB_DEVICE_AND_INTERFACE_INFO(0x2c4e, 0x0100, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192eu_fops},
+/* Mercusys MW300UH */
+{USB_DEVICE_AND_INTERFACE_INFO(0x2c4e, 0x0104, 0xff, 0xff, 0xff),
+	.driver_info = (unsigned long)&rtl8192eu_fops},
 #endif
 { }
 };
-- 
2.43.0



