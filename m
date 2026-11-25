Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621307;
	b=Rn9vOHFBqddNtqyszq1xxe/B53QjWLe8K6uS7IXNiaGC3nfVYIbli6uqDvn1BWYGcQXb
	 ACI0KJbhQNJWPVtepoYNAEYnex0H7nijkuYxowkpFA3Eh3y1QOqhOQiBr3oqiLVoUBItx
	 56qOGsCkugLQy8pGvB2ZkGW2AmCuzMetHUKbfZfqYdFXYDOg+mKZce3Y1K67tqrajQorK
	 cXFKrlO7Reh2VYiOAVEulLxa9+egSnZ2drO0gx5DMXatDntBvGw5q7bgB5e3uCopQrxqn
	 v6v+YvqJZaYkQs0TUAj1Cv+w64dqTfDql77wiLfLeMbjlZwW5tRVde3aPK3nQasDxog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0SFvvt2Y1zPiS1P5pJZcVJeOJBPrG0Bu3223nDuR8do=;
	b=YfQbDck9+XncOHEhet/kPHyMSNNeWSJgcYbZUuONjOrU4LsI0PuHRvbq34IKQoN0HZNK
	 X+PDExJwaYB9NhQacf7T/ky5f20o5CENsJHLSxzBwP1zQPUbk68ip13ASjoNBwmPQ4MvO
	 PGgclIXu17tJCtvfhPTePnJj3FBtBgUMCWRgMazuLwk9NuWg9T3dKcPrMbn3Qg9nSzIuL
	 2ZOdvxbvtRat/ZbLcFEky91NYFfrT71glmvJuNx1M/jHamhN4EjuBaSKH2bxQSQ07v2ct
	 FQ1Q/svy2D8ULxivLYZqvPf7t/TOmVP3VivBknGMjKVM+sd/VTe9MuaZnU+OGdYbwOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KHwclpwH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB21607DE8D;
	Wed, 25 Nov 2026 15:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KHwclpwH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71AEF1F000F4;
	Wed, 25 Nov 2026 15:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621307;
	bh=0SFvvt2Y1zPiS1P5pJZcVJeOJBPrG0Bu3223nDuR8do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KHwclpwHBalIZqYfBQMwU0iMCkSJoW8orWdrwgJglygz7qmS6kb9leb3qSm7NCvYh
	 42Qzq1uvBnXXGuI23BlnBh2N+CCsAYwH/g6txc25uPg+G7q9dT6mkjN0Nzrf0wmf9w
	 Gkf8tsb070e67G+ajs8SrBSqG/NeR/gkCBZUukmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ismail Tarim <ismailtarim7@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 185/990] Bluetooth: btmtk: fix error handling in btmtk_usb_isointf_init()
Date: Wed, 25 Nov 2026 15:25:52 +0100
Message-ID: <20261125143826.426807979@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5863b63f5d3f0..50e0ff30e8db2 100644
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



