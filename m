Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBA2281353;
	Thu, 13 Feb 2025 14:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457370; cv=none; b=DaKfkzUw5FlmHya5aBcpq9VGOz4uaF8GzBHa/dfjua3HD7RQevEXywbGofjsnhL5rPUrvqT01xD5ytofI0BzdoufM8HEoTCik3b6x3drE0sxB+kxHN12zaSKo/Q4NJrZHu26apG55S89uWa/YKulrdNSuV5MsDJqPn2n8lh49F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457370; c=relaxed/simple;
	bh=8IZ8HCxLyb6mb/BSqJvLUJ6KMSutbikiV1zKNVYTJ+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7j1vmcG5zqFCaD0hXY0TJJs5rQCoEk+orwr0lPEj3rTSXL+eKidAMbdycCUhB5wYohmtHQLuZgdGK7OK1NV3FeTpKcY2IPp7MJBlwO3+MMAg6mplDO3Caxwz5QQFhUKkC9vkMrM//nH6jJ6J0wIAVNETv7ly8HEQpFa0aPvOso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sr91kA+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sr91kA+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E0BC4CED1;
	Thu, 13 Feb 2025 14:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457369;
	bh=8IZ8HCxLyb6mb/BSqJvLUJ6KMSutbikiV1zKNVYTJ+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sr91kA+IAGb1T7/nzqU5tjRou0nngNhYFSpDE1PYL9vf0KIj/NVzVotRV2rABgRBa
	 mJnVvO5guVtU2zuaLCH3xU761Bd0DEh4KBuSW4cI+pwQmBYmc3Y3seiJm6Q3KrV7r2
	 r7IL/Qkfotf5qUb1HFsFILEbxKvFh1wnVCs3q5Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Even Xu <even.xu@intel.com>,
	Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/422] HID: Wacom: Add PCI Wacom device support
Date: Thu, 13 Feb 2025 15:23:27 +0100
Message-ID: <20250213142438.801358200@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5a599c90e7a2c..c7033ffaba391 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -4943,6 +4943,10 @@ static const struct wacom_features wacom_features_0x94 =
 	HID_DEVICE(BUS_I2C, HID_GROUP_WACOM, USB_VENDOR_ID_WACOM, prod),\
 	.driver_data = (kernel_ulong_t)&wacom_features_##prod
 
+#define PCI_DEVICE_WACOM(prod)						\
+	HID_DEVICE(BUS_PCI, HID_GROUP_WACOM, USB_VENDOR_ID_WACOM, prod),\
+	.driver_data = (kernel_ulong_t)&wacom_features_##prod
+
 #define USB_DEVICE_LENOVO(prod)					\
 	HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, prod),			\
 	.driver_data = (kernel_ulong_t)&wacom_features_##prod
@@ -5112,6 +5116,7 @@ const struct hid_device_id wacom_ids[] = {
 
 	{ USB_DEVICE_WACOM(HID_ANY_ID) },
 	{ I2C_DEVICE_WACOM(HID_ANY_ID) },
+	{ PCI_DEVICE_WACOM(HID_ANY_ID) },
 	{ BT_DEVICE_WACOM(HID_ANY_ID) },
 	{ }
 };
-- 
2.39.5



