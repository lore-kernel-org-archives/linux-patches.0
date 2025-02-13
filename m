Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3E3281349;
	Thu, 13 Feb 2025 14:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457752; cv=none; b=UHDYzyMD2uNe1KwIZDyXzqixFfl3pjFnh1KkLFEQnfYwmSWCZWdAzRQ8/ZYOAmI+gI9mSLJjuSRrpAwKxF6H/rKMayZsBtebUe2wG1M0L6SijZKbs/PTk49EZBAPj3NOF5zouGXbaKbRqjbJ1UE1UH5zM3U2Vc8lH9pEzSm5qW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457752; c=relaxed/simple;
	bh=0ZluBQLZ1ONFZWfkNGR3ZNiigeQAx1bTjLDr+OwoaNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xp9+UE8kFJUGn6NeUXs+9xWcy4lY0nBnOEQnRIlUbOuxjjdkzWr3Wf1VWGXCJojb8ibbTxmgRnfxnVDsJIQapvkRhFbM1wMBoWBc/layD6LCX/K7At/srCqb3/+jp1+gco2Agy/gAhPX5DJtQZCQpGSdyYBti8jnJq01C/4TTHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mkm2sx5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mkm2sx5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF51C4CED1;
	Thu, 13 Feb 2025 14:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457752;
	bh=0ZluBQLZ1ONFZWfkNGR3ZNiigeQAx1bTjLDr+OwoaNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mkm2sx5z2lr3Gcd1Jl7K/pVzcPg7Um8XRMm16SFi1akyag7XuFFtNw3zHOV8piQUX
	 ToqhKurbgPvaOXXIps4obb7ANEl8jK5jfxs/St2ppOQXUG4ETI0XDtw3hPqBMTVJF1
	 +f9cgaIu6abMRnL9cK3a+i+oaQ9itV0HTsbAuwzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang Chieh Tseng <shangchieh.tseng@tsengsy.com>,
	Nick Morrow <usbwifi2024@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.12 204/422] wifi: mt76: mt7921u: Add VID/PID for TP-Link TXE50UH
Date: Thu, 13 Feb 2025 15:25:53 +0100
Message-ID: <20250213142444.414765043@linuxfoundation.org>
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

From: Nick Morrow <usbwifi2024@gmail.com>

commit 47d9a8ba1d7f31c674b6936b3c34ee934aa9b420 upstream.

Add VID/PID 35bc/0107 for recently released TP-Link TXE50UH USB WiFi adapter.

Tested-by: Shang Chieh Tseng <shangchieh.tseng@tsengsy.com>
Signed-off-by: Nick Morrow <usbwifi2024@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/e797f105-9ca8-41e9-96de-7d25dec09943@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/usb.c
@@ -21,6 +21,9 @@ static const struct usb_device_id mt7921
 	/* Netgear, Inc. [A8000,AXE3000] */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0846, 0x9060, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)MT7921_FIRMWARE_WM },
+	/* TP-Link TXE50UH */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x35bc, 0x0107, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t)MT7921_FIRMWARE_WM },
 	{ },
 };
 


