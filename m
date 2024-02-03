Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A077D175BB;
	Sat,  3 Feb 2024 04:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933579; cv=none; b=sSlOZNkUZeVBQerEwmKGOdgfiGOstryn5mMCnRzfv8l7meMTbur8BBKz3FFq3w+W8c+9jQj7XZqeqMwL+RygP1UVjK38Q1o+ZjC7JzkKaxQpW2BcT5xDf5q0EXMv7jNRyVAtsO+CKavxuJ1B2qmd/+dPP6qlV79YfdWn5lbY+2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933579; c=relaxed/simple;
	bh=aGkC5sj/r7CJSOLLkcHQ0ozth5rgwx2aZbYbpHQfKt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtwiO47gTOlb/NWH8Wiq7ANlQcvEtM2+aFRxs9vpze+VBsy/R765eiqIyqI+fhgqYMZjMUM7quZSXVJ/yCQXQxtpV+g5t/14Sucjmcc1MXs7HdV3RWj1Xw1/Q/dVgq8ukQxJZCg0+sN8k4RCVr8SjaJfUjRRjBwIIDKvaHA/rpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0B1aIj55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0B1aIj55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFEBC433C7;
	Sat,  3 Feb 2024 04:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933579;
	bh=aGkC5sj/r7CJSOLLkcHQ0ozth5rgwx2aZbYbpHQfKt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0B1aIj55zqtgts9aJl+0K8St6vjEM3XzlA6ius/NtTTFdO94qJDJVpJ34adAlSo6D
	 jE2LSLOJnW7sCSpGruUhgzR8CAcdh5Ed4USpzK3VUxLcU7Zy+Pbpk1nf87BgWQTsEA
	 jcObbXODW9yr4VrBdwYQ54VL3vu+R+W6twTvf7W0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenm Chen <zenmchen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/322] wifi: rtl8xxxu: Add additional USB IDs for RTL8192EU devices
Date: Fri,  2 Feb 2024 20:03:57 -0800
Message-ID: <20240203035403.678313458@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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
index 5d102a1246a3..77b356fedd82 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -7959,6 +7959,18 @@ static const struct usb_device_id dev_table[] = {
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



