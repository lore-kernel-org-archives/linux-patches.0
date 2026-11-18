Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038945;
	b=WXt/MjmXLUfiKjrk91Za2PYTn8b5+N1ccGLw5R0KsX81bFbufO4qJlmkbZD2LC4HOXR2
	 /mJ+acoP51x+VwcgTI5fy87rhUB+S7bXRuxh4Ch9cBm7id43byVRCJ2RCSCTbprp3XnLg
	 IP55jP5ZfGmYkLemYhZaLLGI61QSL8qhKd1nvPXowojM2+ljdRHs2CMHSAzXbRggG3VkW
	 CR1fXIF5Chp+160kbZxT2PVjfI+/cmsaq2AwOuJ2Wdt3yBIfzf/6wQOMH5fcJ5CxIvQfS
	 n8QgIDzM1+CQ6DRni+w1uaR4dhPJ5PnbIQt9Yb/J766+2NKkPcx3+TUA3INAjXQ2IEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bdx1VkBa29jh7cC6RS83wJ08uyiUHcH71sPygYgyTBI=;
	b=c3ttnBCtnvZRpVDIjrWUxGI+4W7TFzH3+wirYgx1P/FsnnpxfsW6jQIf1M5y/Sw6DxOf
	 JSID0MOccBrEGeKEuG1ysd/Idoq2nKnip60VqOtRD/o8nnhtsmhfTUaESvWaLxzNmW6ea
	 oYDfZYLAy3QubSlfYl4FwTD8UMHTevwMu4ManDT1+C5+GjZ+pNTjTmBzL8s4p9o8TAfC/
	 54jXIgbjvTtuyETWktE0tITddmrD9mGALhizxqKO5FKL0q0v9RtzLrTm5k5qwEMBMaEhz
	 bBjUJLE4fq8ZOYzCnBjnX7OSA/kHQv653eVANYMMw13PvBCevEfZ0iOeabg5g8/sypA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=prUuDROr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BF2606A31C;
	Wed, 18 Nov 2026 21:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=prUuDROr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011A41F000C4;
	Wed, 18 Nov 2026 21:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038945;
	bh=bdx1VkBa29jh7cC6RS83wJ08uyiUHcH71sPygYgyTBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=prUuDROrHFQ3m0s+BdVauKNIUqeX0jAuA0ctGTjp3p2Ez5NlguZZjzsj+Judy/XwT
	 OZM1ynlZC2gZnQa+nmsSVuC/PTPfz6ysSn/qK1Ln1josFAP5ui2Fz58hFo0DATAVAP
	 9XPtgK5nX3ZOe53g3EjQW5UHer2ayV/UOZTc44TQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Qin <hao.qin@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1925/3318] Bluetooth: btmtk: Remove the resetting step before downloading the fw
Date: Wed, 18 Nov 2026 15:42:27 +0100
Message-ID: <20261118150419.767905943@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Qin <hao.qin@mediatek.com>

[ Upstream commit 33634e2ab7c6369391e0ca4b9b97dc861e33d20e ]

Remove the resetting step before downloading the fw, as it may cause
other usb devices to fail to initialise when connected during boot
on kernels 6.11 and newer.

Signed-off-by: Hao Qin <hao.qin@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 7f3dfd1cd80d5..9ab4157be92f9 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -1002,13 +1002,6 @@ int btmtk_usb_setup(struct hci_dev *hdev)
 		break;
 	case 0x7922:
 	case 0x7925:
-		/* Reset the device to ensure it's in the initial state before
-		 * downloading the firmware to ensure.
-		 */
-
-		if (!test_bit(BTMTK_FIRMWARE_LOADED, &btmtk_data->flags))
-			btmtk_usb_subsys_reset(hdev, dev_id);
-		fallthrough;
 	case 0x7961:
 		btmtk_fw_get_filename(fw_bin_name, sizeof(fw_bin_name), dev_id,
 				      fw_version, fw_flavor);
@@ -1017,12 +1010,9 @@ int btmtk_usb_setup(struct hci_dev *hdev)
 						btmtk_usb_hci_wmt_sync);
 		if (err < 0) {
 			bt_dev_err(hdev, "Failed to set up firmware (%d)", err);
-			clear_bit(BTMTK_FIRMWARE_LOADED, &btmtk_data->flags);
 			return err;
 		}
 
-		set_bit(BTMTK_FIRMWARE_LOADED, &btmtk_data->flags);
-
 		/* It's Device EndPoint Reset Option Register */
 		err = btmtk_usb_uhw_reg_write(hdev, MTK_EP_RST_OPT,
 					      MTK_EP_RST_IN_OUT_OPT);
-- 
2.53.0



