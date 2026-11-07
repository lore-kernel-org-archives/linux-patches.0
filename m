Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060975;
	b=EzZ11gRJIM2L40pasE/vpBgBEdlvH2M827fTACTJE/sdoK3ROgecOHxQOvPECFwTKmUB
	 ibCRL8NBIKVQmZaiK0n9nSdq8bksGOjK3/BzLYLhaHaUSlKU/HT3yv/aok1VhANBaf0bF
	 vxzi3QAEqwpkd9d+fpIgBNUVDCeY/HT/3ODTQ9Dz3kUWKh9gHz9hYh9MZQczBZMeYzEze
	 iH0QwNbqPQcs657mam4/YaH9lmMgK9F/BxNufx+U7OrFwibALbxgMPo73bKcdZpOCMs7w
	 Ag1i51kWjuqoq6B10CkZlpBHoVP7/uCuOr6BRqkNoFuftKGlNfBG7rjTADSM98COmhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zSG5d1QyUbo48w/Q/k+E23MT+5cl/bOSFL/SShtlEgU=;
	b=hZ7qfz81/L4nHMBLKIAK9Ft+QqGznH/PX3W9Aa/ncxIXRMfLEnfDI5r4jlU4PnLFZ4MR
	 IYAg8fQU6czY+hvvMnJ3vG/rOqzmJa+ZIuf8JHocV3xuSJB8boPZ4kvhyT22dte+SBarX
	 emsQjXg4p+0CVdKnNsYi1+hh8GP0PJUEZkA8+QyFerrMq8IzNEXm2z0/abJACx5qcpUwA
	 EWJNlQAYeT1aCZASO/Od3s1hsd1IUOUr+XXAw5/2OXTgiuxlYHoSm7j6H58/Q0OGLCoKa
	 iyOkNwTtifaHsiGRSdaTFRc56/ENzmqaL6T7iCqrU6x4QRdR1B8zXFjceWWRFn3pMBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nRryan4r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFD3606D83E;
	Sat,  7 Nov 2026 14:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nRryan4r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D3D1F008A1;
	Sat,  7 Nov 2026 14:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060974;
	bh=zSG5d1QyUbo48w/Q/k+E23MT+5cl/bOSFL/SShtlEgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nRryan4r19+tKCVTpSKCaGboi3CUcs65vWpjhukDyMM4Js6e6+MhNvcjTS/vXPxdt
	 UovJKmPuHblpHMuEuHuxxKZ5phcYyLmu60Gs4U6UpzGsTufp9pYr8yVifZJ5r9jsc+
	 mlAJ8SUZ9Yf5/VJnqdgWd4Bn4G90N06jRRld5ArQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0293/1536] Bluetooth: btrsi: Move set_bt_context after successful HCI registration
Date: Sat,  7 Nov 2026 08:38:29 -0500
Message-ID: <20261107135005.961168479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Chen Changcheng <chenchangcheng@kylinos.cn>

[ Upstream commit 290a3644609526f7ac12529cd1618042fa5a32db ]

In rsi_hci_attach(), ops->set_bt_context() stores the newly allocated
h_adapter into common->bt_adapter before hci_alloc_dev() and
hci_register_dev() are called. If either of these fails, h_adapter
is freed but common->bt_adapter remains a non-NULL dangling pointer.

This causes a deterministically reachable use-after-free when the
device operates in a BT+WiFi coexistence mode and CONFIG_RSI_COEX
is enabled. The following software-only trigger paths exist:

  1. SDIO driver .remove  (rsi_disconnect)
  2. USB  driver .disconnect (rsi_disconnect)
  3. SDIO driver .shutdown (rsi_shutdown)
  4. Hibernation .freeze  (rsi_freeze)

All four paths check:
    if (IS_ENABLED(CONFIG_RSI_COEX) && coex_mode > 1 && bt_adapter)
        rsi_bt_ops.detach(bt_adapter);  // use-after-free

coex_mode is set during rsi_91x_init(), before rsi_hci_attach() is
called, and is not cleared on attach failure. Since set_bt_context()
already wrote bt_adapter before the failure, the deinit paths see a
non-NULL dangling pointer and proceed to detach it.

Fix this by moving set_bt_context() after hci_register_dev() succeeds.
On failure paths bt_adapter stays NULL, and the deinit callers correctly
skip the detach call.

Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btrsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btrsi.c b/drivers/bluetooth/btrsi.c
index 6c1f584c8a337..0e2894e93e82e 100644
--- a/drivers/bluetooth/btrsi.c
+++ b/drivers/bluetooth/btrsi.c
@@ -117,7 +117,6 @@ static int rsi_hci_attach(void *priv, struct rsi_proto_ops *ops)
 		return -ENOMEM;
 
 	h_adapter->priv = priv;
-	ops->set_bt_context(priv, h_adapter);
 	h_adapter->proto_ops = ops;
 
 	hdev = hci_alloc_dev();
@@ -146,6 +145,8 @@ static int rsi_hci_attach(void *priv, struct rsi_proto_ops *ops)
 		goto err;
 	}
 
+	ops->set_bt_context(priv, h_adapter);
+
 	return 0;
 err:
 	h_adapter->hdev = NULL;
-- 
2.53.0



