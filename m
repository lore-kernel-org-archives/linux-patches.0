Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6FD645;
	Thu, 13 Feb 2025 15:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458849; cv=none; b=oOSMRgkxjh1R+Xc948RnJWJmH2P73UaayPTe4LjA9pBw2t8MKLr8gY8JBqY4KajJaFme1gF713C3dWdJJsBhmy5PnKz9sNynBphXRCyMlohuQ9FCychnUF3HIlccoMZpnkhIKPtOuwidY4ig/S8tqwrckJaAN1uHmXc2AY8pauc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458849; c=relaxed/simple;
	bh=+0jM1Ht1zY0ks8BXH5Af9VSyfrHRHBVeBwBzrVkP50k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkjUi0znLWnT4rG6pMNnmFgLKUCb37hxgZ4YcEP38mmJ+Fs5jhH5fw+38i/Fofh+MgDg2QTHUvBeZPmvsPHNfezIF6u+GvOcR6jwTrGxJk0+LxcX973/xnqv+5GrSu11XCR2lS0ATBuYlkwI/vbsVecOzHRuFIkNI8UT4iarOxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ia/ky4g6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ia/ky4g6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96BC5C4CED1;
	Thu, 13 Feb 2025 15:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458849;
	bh=+0jM1Ht1zY0ks8BXH5Af9VSyfrHRHBVeBwBzrVkP50k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ia/ky4g6heDNzcB2Mn6l/B2FoBwYq6x3gSEWGKrxXJ9YGeQlSewIim2p6N9/UPP6D
	 DEjvytfyJN962JjYx3dQxSDcwc2ScfS6VRi03vs2hy65h/S9qgfkq1nwlrzUwoOSmi
	 hP991hNDSntznztMxYMVxIUe5MxO+AHYPdUgz2Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Even Xu <even.xu@intel.com>,
	Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 067/443] HID: Wacom: Add PCI Wacom device support
Date: Thu, 13 Feb 2025 15:23:52 +0100
Message-ID: <20250213142443.204460279@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 5501a560fb07f..b60bfafc6a8fb 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -4946,6 +4946,10 @@ static const struct wacom_features wacom_features_0x94 =
 	HID_DEVICE(BUS_I2C, HID_GROUP_WACOM, USB_VENDOR_ID_WACOM, prod),\
 	.driver_data = (kernel_ulong_t)&wacom_features_##prod
 
+#define PCI_DEVICE_WACOM(prod)						\
+	HID_DEVICE(BUS_PCI, HID_GROUP_WACOM, USB_VENDOR_ID_WACOM, prod),\
+	.driver_data = (kernel_ulong_t)&wacom_features_##prod
+
 #define USB_DEVICE_LENOVO(prod)					\
 	HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, prod),			\
 	.driver_data = (kernel_ulong_t)&wacom_features_##prod
@@ -5115,6 +5119,7 @@ const struct hid_device_id wacom_ids[] = {
 
 	{ USB_DEVICE_WACOM(HID_ANY_ID) },
 	{ I2C_DEVICE_WACOM(HID_ANY_ID) },
+	{ PCI_DEVICE_WACOM(HID_ANY_ID) },
 	{ BT_DEVICE_WACOM(HID_ANY_ID) },
 	{ }
 };
-- 
2.39.5



