Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689AE1B6CFA;
	Wed, 19 Feb 2025 09:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956760; cv=none; b=GH1hIwL02LXIbO7lWyq+HgEm9SQbK65zlDF1FTlxkf1zLyn4iKE7W71wNjM9jZPmAYHKpYARlNPUErjr90HyIG+fJE/dm+aRXy1Xqkepk5V+DR2f7UJLcG4vUOmr1Ij8XVlmBiUyBQkGwNvNAXTwtj6pGfJLnxj5PzAcXYdgVv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956760; c=relaxed/simple;
	bh=14f/wCGNDxj9iPUZGVRUOQvQmzYhRa2b5NYUIRSmmBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPMd+aD9+fZaehlBzHgaemfWp0aXYWv7RXUE68e+P2uYF8r1ULCi+rhYbqV4FLpxlZwY16PnbAh/FSs8DFZ8FP1YkhT90COsp/HtwU7nhr1msbw5gVcsq3S7hRMClhZ6wjPM5lqHC4vovbjrb0SXbTJDJaLcJFkfExBVINSUa/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rykh5hRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rykh5hRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CD3C4CED1;
	Wed, 19 Feb 2025 09:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956760;
	bh=14f/wCGNDxj9iPUZGVRUOQvQmzYhRa2b5NYUIRSmmBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rykh5hRjB7PuOWHKJ5XJChKquqsUPO7zHoTWi4i2NsLI8097t37xerajQQrwgy2Wm
	 A0fcDhw+HNtUJezR0XwBQpsRgvfdJIlqm6mMP6rbqDhnDkxD2EnxGg/aLZhb8m08+5
	 GSel8pQFqTl8YMvC2QXYWj6jmTDVJcYlDuzmcPL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Even Xu <even.xu@intel.com>,
	Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 291/578] HID: Wacom: Add PCI Wacom device support
Date: Wed, 19 Feb 2025 09:24:55 +0100
Message-ID: <20250219082704.459762257@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3551a6d3795e6..ce54b8354a7d4 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -4914,6 +4914,10 @@ static const struct wacom_features wacom_features_0x94 =
 	HID_DEVICE(BUS_I2C, HID_GROUP_WACOM, USB_VENDOR_ID_WACOM, prod),\
 	.driver_data = (kernel_ulong_t)&wacom_features_##prod
 
+#define PCI_DEVICE_WACOM(prod)						\
+	HID_DEVICE(BUS_PCI, HID_GROUP_WACOM, USB_VENDOR_ID_WACOM, prod),\
+	.driver_data = (kernel_ulong_t)&wacom_features_##prod
+
 #define USB_DEVICE_LENOVO(prod)					\
 	HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, prod),			\
 	.driver_data = (kernel_ulong_t)&wacom_features_##prod
@@ -5083,6 +5087,7 @@ const struct hid_device_id wacom_ids[] = {
 
 	{ USB_DEVICE_WACOM(HID_ANY_ID) },
 	{ I2C_DEVICE_WACOM(HID_ANY_ID) },
+	{ PCI_DEVICE_WACOM(HID_ANY_ID) },
 	{ BT_DEVICE_WACOM(HID_ANY_ID) },
 	{ }
 };
-- 
2.39.5



