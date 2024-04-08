Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC82E70CDA;
	Mon,  8 Apr 2024 13:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582223; cv=none; b=cj46DXu877QtGnnWtQ2APBH64w71cVS0SD9eZgSOI0Frk3xgrDlD/TVW2hPhZ+H4kpR2X8jSNBVpi80grNdemtCILxppOt3MYmhlg9ivguYvznMFL7zlwvhCEqtr9Qj1ZMhm2N9kG33ss5owFLujiLENkTcZLmW87U/b+APJJNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582223; c=relaxed/simple;
	bh=a7O8nGvMIsm8GK0cSK7qBmzaWf7L9WOijZ2wWz4ImLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPhFm1h+2KVpCYSYbX/nhZRP+6vmM/qTp+hDCeRi6h1Mo10xRn6VvDNfRNvbVIa5AlCmnL653NOyg8oeirxfaJZZdVJ9x0KIrPIK7HV1ydhwHtjBRTLpELe0op+6aNyT7tbETWyQ4RXNUtY5BTPD/qPXF1ZBTCVs8DTlOuQvocE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UhklFARm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UhklFARm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFD7C433F1;
	Mon,  8 Apr 2024 13:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582223;
	bh=a7O8nGvMIsm8GK0cSK7qBmzaWf7L9WOijZ2wWz4ImLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UhklFARm2pAt7HbvydKa/N8T2WGMpvTgLe8ReeehhI4YYkmNjuHdLhFaF4oPP2OVa
	 ki1jVnGhDKOBUx6Oe+lEr0vluZMh+TB3vqqWPWA46cUBAF2/HkAeyaVf8zIN+WgOp7
	 C4TGhYI1pW2j1exgIkdUg8ptK/khfFJu6b8lkTyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janaki Ramaiah Thota <quic_janathot@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Clayton Craft <clayton@craftyguy.net>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.6 076/252] Revert "Bluetooth: hci_qca: Set BDA quirk bit if fwnode exists in DT"
Date: Mon,  8 Apr 2024 14:56:15 +0200
Message-ID: <20240408125308.988543258@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 4790a73ace86f3d165bbedba898e0758e6e1b82d upstream.

This reverts commit 7dcd3e014aa7faeeaf4047190b22d8a19a0db696.

Qualcomm Bluetooth controllers like WCN6855 do not have persistent
storage for the Bluetooth address and must therefore start as
unconfigured to allow the user to set a valid address unless one has
been provided by the boot firmware in the devicetree.

A recent change snuck into v6.8-rc7 and incorrectly started marking the
default (non-unique) address as valid. This specifically also breaks the
Bluetooth setup for some user of the Lenovo ThinkPad X13s.

Note that this is the second time Qualcomm breaks the driver this way
and that this was fixed last year by commit 6945795bc81a ("Bluetooth:
fix use-bdaddr-property quirk"), which also has some further details.

Fixes: 7dcd3e014aa7 ("Bluetooth: hci_qca: Set BDA quirk bit if fwnode exists in DT")
Cc: stable@vger.kernel.org      # 6.8
Cc: Janaki Ramaiah Thota <quic_janathot@quicinc.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reported-by: Clayton Craft <clayton@craftyguy.net>
Tested-by: Clayton Craft <clayton@craftyguy.net>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_qca.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -7,7 +7,6 @@
  *
  *  Copyright (C) 2007 Texas Instruments, Inc.
  *  Copyright (c) 2010, 2012, 2018 The Linux Foundation. All rights reserved.
- *  Copyright (c) 2023 Qualcomm Innovation Center, Inc. All rights reserved.
  *
  *  Acknowledgements:
  *  This file is based on hci_ll.c, which was...
@@ -1882,17 +1881,7 @@ retry:
 	case QCA_WCN6750:
 	case QCA_WCN6855:
 	case QCA_WCN7850:
-
-		/* Set BDA quirk bit for reading BDA value from fwnode property
-		 * only if that property exist in DT.
-		 */
-		if (fwnode_property_present(dev_fwnode(hdev->dev.parent), "local-bd-address")) {
-			set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
-			bt_dev_info(hdev, "setting quirk bit to read BDA from fwnode later");
-		} else {
-			bt_dev_dbg(hdev, "local-bd-address` is not present in the devicetree so not setting quirk bit for BDA");
-		}
-
+		set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
 		hci_set_aosp_capable(hdev);
 
 		ret = qca_read_soc_version(hdev, &ver, soc_type);


