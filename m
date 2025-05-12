Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4B7296FBD;
	Mon, 12 May 2025 18:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073222; cv=none; b=X4Ybp+D77BoVfdxow7+Udzm116limYj9/6VWBS4OPt/bRz6YA3GjeW42oN3eczE0AFJQz7kRSxp+x7slR9r78BemLEQNntKCiYuaFpiBBhtrwpiW1QPhJ0QH74r5IAoeGkdmWwNf65f9ZIr4z6nf2r4TzCt9l2oL6H6VIp+mFIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073222; c=relaxed/simple;
	bh=B+J0kCEBhRS2koS12gCnLpCrLSH7qK/JqciB7fETWqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXMkzcc7GFjmNiYZcE2Zg0gtmQIr0mv2c/ANOQe+sD9a3/LGhl6NSFjHAaNdDWQqvlzXqg/8xyJ2q/MmB/G+HVLnXb88V/eJpA/TbSZ5jaIm+MGl0WCVgFk87XNZc+NmqZ5BBfL6+/dSv26F/YCR4HaKVpeNM1cDhQrlszOimfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zKoBWtLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKoBWtLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF08AC4CEE7;
	Mon, 12 May 2025 18:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073222;
	bh=B+J0kCEBhRS2koS12gCnLpCrLSH7qK/JqciB7fETWqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zKoBWtLmRuSMFHh/HWWCvMw1HJFVUNAKt4aGfyg+yF6ii/bYK5AQrXz6cbS9Yga5E
	 M1a+p+ngbkyWi3b2oOo2zePUv70RRFunqBhJ+ZZeujw/D1HZtCyj/+Qo+N+tOZ8wPb
	 zcnU2yic1toGcD5wZWSC22aTp81QIaeqScmtTac8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Qin <hao.qin@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	"Geoffrey D. Bennett" <g@b4.vu>
Subject: [PATCH 6.12 157/184] Bluetooth: btmtk: Remove resetting mt7921 before downloading the fw
Date: Mon, 12 May 2025 19:45:58 +0200
Message-ID: <20250512172048.211959959@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Hao Qin <hao.qin@mediatek.com>

commit a7208610761ae9b3bc109ddc493eb7c332fca5b2 upstream.

Remove resetting mt7921 before downloading the fw, as it may cause
command timeout when performing the reset.

Signed-off-by: Hao Qin <hao.qin@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: "Geoffrey D. Bennett" <g@b4.vu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btmtk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -1329,7 +1329,6 @@ int btmtk_usb_setup(struct hci_dev *hdev
 		fwname = FIRMWARE_MT7668;
 		break;
 	case 0x7922:
-	case 0x7961:
 	case 0x7925:
 		/* Reset the device to ensure it's in the initial state before
 		 * downloading the firmware to ensure.
@@ -1337,7 +1336,8 @@ int btmtk_usb_setup(struct hci_dev *hdev
 
 		if (!test_bit(BTMTK_FIRMWARE_LOADED, &btmtk_data->flags))
 			btmtk_usb_subsys_reset(hdev, dev_id);
-
+		fallthrough;
+	case 0x7961:
 		btmtk_fw_get_filename(fw_bin_name, sizeof(fw_bin_name), dev_id,
 				      fw_version, fw_flavor);
 


