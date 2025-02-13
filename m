Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71A813B58A;
	Thu, 13 Feb 2025 15:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459308; cv=none; b=bBJ97ph1E10I0Beg4tCyCqnOsrVvIhT6uiikqxJFHAmpBz8B4TnehHGMTqTKv/kCf6+YziLE8cUMDIOCNdhq3dV5Q9viiHy+zrHSsla3Ue8mQ85TyJ1wqm/gCUMQb3qpsLEXY8GVCfb+NDTWmIdsncgQ0+6FW37dznuemw6j4to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459308; c=relaxed/simple;
	bh=bjO7D7H+XgG+PMwKXHVEPhiqKoeBY8pn6RffDKfFX0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNyhOp7Gh7C52SwFZhd278eZ4Ogg5TuijYhE4LcOqjd/IEQBtqwLIpODDt22qUKbUCVtXPJrWDFIcPvXvciIZc4B3+g2eKxEU4b7FHY1Cg2yZs7q9yO+l9JcJ5U5eB3OqvFR8kAaM3KVTpLFc2969Su5UpDhms84WWJZf5l7+PA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g+LnH2tB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g+LnH2tB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA49BC4CED1;
	Thu, 13 Feb 2025 15:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459307;
	bh=bjO7D7H+XgG+PMwKXHVEPhiqKoeBY8pn6RffDKfFX0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+LnH2tByq7wm2e+rlXSIbcS0KcBSTBR2SjM/BqiabcJciGeqRLCzyCAI6yMoMucm
	 XiaGZjY667cjP4saOs059K7qC7pUCkxKdmjQTshIjQ7sA3VYGGD9wijuZm0vQS/4On
	 sPb2AkQAc/4kf1nPMC/fAbyahAWbTzq/xePUYeNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang Chieh Tseng <shangchieh.tseng@tsengsy.com>,
	Nick Morrow <usbwifi2024@gmail.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.13 226/443] wifi: mt76: mt7921u: Add VID/PID for TP-Link TXE50UH
Date: Thu, 13 Feb 2025 15:26:31 +0100
Message-ID: <20250213142449.334191836@linuxfoundation.org>
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
 


