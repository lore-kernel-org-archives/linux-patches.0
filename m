Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735901487CD;
	Thu, 12 Dec 2024 15:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016985; cv=none; b=kYkIrwOem0lPa0U2dZS+Xcg+qrnvSlTrLFu7vJsGKN8541TuEugKLFjWrQy8vwtWU7pwHB8dEpdr/rwTfbLU8O3kv0BFyarQGyCTA36Vnv4hCzEdMdI3zqMDaU0z4avCd6lhNEl7ECfehtPqsmD7aULAiYG41Mokurd0nZnnnVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016985; c=relaxed/simple;
	bh=CXOHtPLZ3nyTgnpyF+DGvZoNagXK7EHOrcZMIImIlRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCXn6GTSkFPnsBzcVv8IBOa70nWAZgJj+pDcoI3v7b7l46UveuTSh6M3cgtSwJ9ItAsR1E4buiTyYRfz4l+cgvlyHrgC3baekCqZzz5O/7FvdG0lLRnLV8NpBtHE7koPdK1AWcx/wbf/EmEscO+baLjTl9Ccsvl7H5RrITq3wI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNZa4kxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNZa4kxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E5DC4CECE;
	Thu, 12 Dec 2024 15:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016985;
	bh=CXOHtPLZ3nyTgnpyF+DGvZoNagXK7EHOrcZMIImIlRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNZa4kxAOvmTxQ0BiHofiMlVx7xuUkM+wK+V9juV97hd/a+q1JcB/Zq653uRbKKoo
	 rh7jbWEnmhvXgBO9xbax4he6KwhFjziNoNQtTG3QPjRLk0MFsmuAUnaS4tqplcRcNv
	 zUUEPvKSsZ3qdhSyRHNS8OcXJQVYel2Ps9JRRhKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiande Lu <jiande.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 349/466] Bluetooth: btusb: Add 3 HWIDs for MT7925
Date: Thu, 12 Dec 2024 15:58:38 +0100
Message-ID: <20241212144320.577288619@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiande Lu <jiande.lu@mediatek.com>

[ Upstream commit de7dcf9d1df4b0009735756d0a2adff09c3f21d4 ]

Add below HWIDs for MediaTek MT7925 USB Bluetooth chip.
VID 0x0489, PID 0xe14f
VID 0x0489, PID 0xe150
VID 0x0489, PID 0xe151

Patch has been tested successfully and controller is recognized
device pair successfully.

MT7925 module bring up message as below.
Bluetooth: Core ver 2.22
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
Bluetooth: hci0: HW/SW Version: 0x00000000, Build Time: 20240816133202
Bluetooth: hci0: Device setup in 286558 usecs
Bluetooth: hci0: HCI Enhanced Setup Synchronous Connection command is advertised, but not supported.
Bluetooth: hci0: AOSP extensions version v1.00
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: BNEP socket layer initialized
Bluetooth: MGMT ver 1.22
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11

Signed-off-by: Jiande Lu <jiande.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 9208b5b7fc86f..11755cb1eb163 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -654,6 +654,12 @@ static const struct usb_device_id quirks_table[] = {
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x0489, 0xe139), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0489, 0xe14f), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0489, 0xe150), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
+	{ USB_DEVICE(0x0489, 0xe151), .driver_info = BTUSB_MEDIATEK |
+						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3602), .driver_info = BTUSB_MEDIATEK |
 						     BTUSB_WIDEBAND_SPEECH },
 	{ USB_DEVICE(0x13d3, 0x3603), .driver_info = BTUSB_MEDIATEK |
-- 
2.43.0



