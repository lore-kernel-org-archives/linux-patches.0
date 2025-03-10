Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5490817CA12;
	Mon, 10 Mar 2025 17:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629227; cv=none; b=Nhe0BD0Ed2DWwZi5L4j7RKZyD1yJUidHOxUTsYEJNpaCNx0ejwod20FanFR8XNHfRmUDa3K8XAIcAfEejfTvtY/WLjrFy1PYLp3WAyMZfuiYkQmcmAkGw3jks4Owq3Dj2aoMGohO4cm88z5XfS5scKIgeuxOwqxj5G9Oi5Dq5AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629227; c=relaxed/simple;
	bh=DHXA/iyvxg1z4jTz7Q+MjN/Sf3QkZcN4KmKCHUm05xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSBV2T71d5B6i7oJ3mkDMrCl48z6QZQIlMTxkY3GyiIGDFgpHQm9wD/LdOLvVQ3aaaDDSExtLbjDtNArgqggamBS23dudPKwOuviy+WxGM23B+jl+n5sVY1BWLeMT6+G37gRL4lJVEcKalZCe3HSvv9HP8b+XfGXXElL5FYvqZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g8ECYYFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g8ECYYFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5709C4CEE5;
	Mon, 10 Mar 2025 17:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629227;
	bh=DHXA/iyvxg1z4jTz7Q+MjN/Sf3QkZcN4KmKCHUm05xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8ECYYFUnUrw1BJ1vFJDj6/q4rV/z1Hke34NXSpjDNm+YxKcb2PINNhjMtP+NnKLz
	 C4q95A6rc/54f2yIVmO2Kksj0iHQz26AwKDM1J6ZElVIDxeFgABmWVY7bwK+mc54Ea
	 kPuDNJcAmGfK01VVU5xLgGFiSGhYWf3xDVke8bxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Even Xu <even.xu@intel.com>,
	Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 214/620] HID: Wacom: Add PCI Wacom device support
Date: Mon, 10 Mar 2025 18:01:00 +0100
Message-ID: <20250310170554.073167486@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Even Xu <even.xu@intel.com>

[ Upstream commit c4c123504a65583e3689b3de04a61dc5272e453a ]

Add PCI device ID of wacom device into driver support list.

Signed-off-by: Even Xu <even.xu@intel.com>
Tested-by: Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_wac.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 9a82cd124918f..a5e6c16c883dc 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -4882,6 +4882,10 @@ static const struct wacom_features wacom_features_0x94 =
 	HID_DEVICE(BUS_I2C, HID_GROUP_WACOM, USB_VENDOR_ID_WACOM, prod),\
 	.driver_data = (kernel_ulong_t)&wacom_features_##prod
 
+#define PCI_DEVICE_WACOM(prod)						\
+	HID_DEVICE(BUS_PCI, HID_GROUP_WACOM, USB_VENDOR_ID_WACOM, prod),\
+	.driver_data = (kernel_ulong_t)&wacom_features_##prod
+
 #define USB_DEVICE_LENOVO(prod)					\
 	HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, prod),			\
 	.driver_data = (kernel_ulong_t)&wacom_features_##prod
@@ -5051,6 +5055,7 @@ const struct hid_device_id wacom_ids[] = {
 
 	{ USB_DEVICE_WACOM(HID_ANY_ID) },
 	{ I2C_DEVICE_WACOM(HID_ANY_ID) },
+	{ PCI_DEVICE_WACOM(HID_ANY_ID) },
 	{ BT_DEVICE_WACOM(HID_ANY_ID) },
 	{ }
 };
-- 
2.39.5



