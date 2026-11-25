Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624342;
	b=IP9Y/u6sIh3PZpv0O9ecOH+GtjT/gvkYqwfWHiKVIdq2K2wPpQYPajPtuoS1TwAI1e2N
	 dyyLX/reQf3ugA5WmY442+Uz2mf/bPdKEFAIdGAbH8VqHeKCEusNbnr3dOY3tXkQ1gvCC
	 QET3CTE9b/AALw4tAnydwGShieErpSyprvUjHzlFMWnUNaVgiJnsAw5FMTbjb6Uk9l/Yi
	 2HBvO0pnwYhyBDUQrJM6Qd1NTS1Eq+jJcYz20oS2mbRMQOWWPUHgmvR8NXS1iEX1NUhPG
	 keB0PZhSV0946MhXsX3nT5JaDa4bvbbk/HQ7hnti2X+TiZPWnybDcRSxB9nSXEDp+wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qsaqVOqPxyfD+S0s/UusCiF5G/o0whfzuaqGLSrmCC4=;
	b=Kg1KlLFLWjEIOFXpUcdebT4Oyzo/jZzMTobJ1RE3JWnOtzJ+G6E0MKhf9jvqL3qaZzZU
	 7WB9Oxtz2PaMtP/6VSRFh2y/YlvaSOK+Ti+ri1Fgpz4TSALDC2un5sCLt/2K9xYFQtCy2
	 NdwpOtg5Y06YuQ0CJuBLl+7BfYtplUDnVFoDY3bJDoMcI5e65lJgOtG0tH5tCowohjVev
	 CgkHSo301jWhitLPcMSs0pbp2kfl2RPE6MneNsgYxZuJ5FxDvgUSyOFsKK+j3lWIMtZwl
	 1B49/sI2LcLtTwZ04shCFO2A8tXDwVQ59Ri22KGrs58JkY/SBvzWgGZWDtokuNCu+9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iJ40R7Ks;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B22606A33A;
	Wed, 25 Nov 2026 16:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iJ40R7Ks
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51EFB1F000CF;
	Wed, 25 Nov 2026 16:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624341;
	bh=qsaqVOqPxyfD+S0s/UusCiF5G/o0whfzuaqGLSrmCC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJ40R7KsG/A3dYwIAiMGPvBcv0mCvd9R6Y/LuOgjkpx9A5jTXrB6DP4EF4z7/DCWk
	 ZpPsp6Z+7aixfE3tyTH/JUcTsIJFnsPSBA4tP1GEmKAnxzVBcrMePaOLtloBWCEjca
	 G4SB/yqXF/9g+RN4jSlFx8hGxght4tDrZNhGzZsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ismail Tarim <ismailtarim7@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 161/816] Bluetooth: btmtk: fix error handling in btmtk_usb_isointf_init()
Date: Wed, 25 Nov 2026 15:28:29 +0100
Message-ID: <20261125143852.922901694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ismail Tarim <ismailtarim7@gmail.com>

[ Upstream commit 3b70dd827b27bfadd89e7b1a2d422b04da38797c ]

btmtk_usb_isointf_init() submits the ISO interrupt IN URB and then
sends the vendor command 0xfd98. If that command fails, the function
returns an error without killing the URB it has just submitted. The
caller then leaves BTMTK_ISOPKT_RUNNING clear, so the driver treats the
ISO path as inactive while its RX URB is still in flight, and
btmtk_usb_suspend() skips killing it. Kill the anchored URBs on this
path, as the URB submission failure path already does.

The return value of __set_mtk_intr_interface() is also ignored: a
failure to select the ISO alternate setting or to find its endpoints
is logged, but the function goes on to submit the URB. Return the
error instead.

Fixes: ceac1cb0259d ("Bluetooth: btusb: mediatek: add ISO data transmission functions")
Signed-off-by: Ismail Tarim <ismailtarim7@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index cff351968d610..a01cfbe72d224 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -1358,7 +1358,9 @@ static int btmtk_usb_isointf_init(struct hci_dev *hdev)
 
 	spin_lock_init(&btmtk_data->isorxlock);
 
-	__set_mtk_intr_interface(hdev);
+	err = __set_mtk_intr_interface(hdev);
+	if (err < 0)
+		return err;
 
 	err = btmtk_submit_intr_urb(hdev, GFP_KERNEL);
 	if (err < 0) {
@@ -1370,6 +1372,7 @@ static int btmtk_usb_isointf_init(struct hci_dev *hdev)
 	skb = __hci_cmd_sync(hdev, 0xfd98, sizeof(iso_param), &iso_param,
 			     HCI_INIT_TIMEOUT);
 	if (IS_ERR(skb)) {
+		usb_kill_anchored_urbs(&btmtk_data->isopkt_anchor);
 		bt_dev_err(hdev, "Failed to apply iso setting (%ld)", PTR_ERR(skb));
 		return PTR_ERR(skb);
 	}
-- 
2.53.0



