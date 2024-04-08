Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261867BB1B;
	Mon,  8 Apr 2024 13:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582425; cv=none; b=hWbdCA/0zZYCfKrHSy0ltFGJilSCyNeY0Wg3MdufmFBDSqls7pw4DMajf3nbJaLkj7SU1dwWzArLE2t03P3ZXm/nXSLIbJAioMxJJSExxC2+lrk+ZEuu/ZvOw3/0XDcE50d35kk5E7ioCOulY2nS7N14J4NwyIxGwbTg8E5E5VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582425; c=relaxed/simple;
	bh=w5dL1qtvu+u+wCvBgT4K9gSegKXtcZbFE7Lv3iIL8ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9o4ETEY70tiASw8GOzEramGz74ZCTpuZ9/AbrjH5kxt8iP2XmK+fB+WbxHj6L7CHg4Y3SZhbyYRzbodnVFKpJy04KKLgJXS/Y6B71Az1YRbgkMrQsTivpyHHzFcLwAuaBS1z7WIP3xGTUjvbO5hLDEda8VbTEBwS/RuC4P/fIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2uwMnms3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2uwMnms3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACEEC43394;
	Mon,  8 Apr 2024 13:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582424;
	bh=w5dL1qtvu+u+wCvBgT4K9gSegKXtcZbFE7Lv3iIL8ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2uwMnms3q8yCwjLLsrxJllnDSjCbBDD74+PP1LhIrY6zLa/3F4dgMN3MuRxm+ho0S
	 V4KfGGA404iZ7XcO0MzkC03vyMtJIZ8Z4lUOfA6EcGdTt5tdCD9JdcYIOsjXY2Mxhk
	 1I7hsrkbG491lWGcMDqKNBfUuljLPR25OkbJAhLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janaki Ramaiah Thota <quic_janathot@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Clayton Craft <clayton@craftyguy.net>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.8 073/273] Revert "Bluetooth: hci_qca: Set BDA quirk bit if fwnode exists in DT"
Date: Mon,  8 Apr 2024 14:55:48 +0200
Message-ID: <20240408125311.567326606@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1904,17 +1903,7 @@ retry:
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


