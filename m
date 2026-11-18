Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027559;
	b=JNSFjkaM9Zff8CM7Xg8v5Lp8ViEq1F564DYpQhqOhF3ssAmUnhDesWnnS8JFNJ3qdYm6
	 BngoapgO988t4mseRd2IANxqe1AQa5oR2C/Q+Y40qKDfvuyk1t9mhsVFFc+E3QEk/vji+
	 p3/XmpYIfGPbGT+z+Y/6q48gLnV6duB8PtmnCO1QMnO7umgYj84SFHkrVc+ZEg+gM7M2Q
	 jyofolZEazb7e/lm0kFUzMZ7rbvBuTGhvmu9AtoA5pMxiRZ/Dmw9JwCtI0XUhHjCavaeC
	 aB9czeGww6hG9V88fN6M2444mx427b+cXFyXCaFh/0Ek4jiKpGp9+2z0lIOdltF3NmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hVXhUtXJkW+APZOwl0O3Nk8t5gXM4P3YCicQHT9odoA=;
	b=lFP22emH0h9efJVgzbWoMhIRIgi+LFiMS++xtI6PrPwompRGBfG/EBH3dpPusmAteeMA
	 3MT43YkaPrvrTVsi94fX5r/jX8par8dURWBeVUq0cD7r/BG9o0TCZMgL6ZotxGbN1zRsm
	 1+UfmKPUbQVMM4xDvorLJt/CPY607Ga3YGfJl9r0P37WpPOnw04Unv7g9iV7wVHd3RlQz
	 fKrNdPr62gS2qL+ewCzdUEGgXdEDY4mEES/vzWM9lmwEI5i53gQYrPhMSbjMbz9QvbNe4
	 RXgD9cFegM286r+47DrzLF7RdZYfBRg5z2F0BJ+QmJLCPrqBNn8dQs3f2H38WJJgdNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SjFkGHKW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6048760A2606;
	Wed, 18 Nov 2026 18:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SjFkGHKW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97B31F000C5;
	Wed, 18 Nov 2026 18:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027559;
	bh=hVXhUtXJkW+APZOwl0O3Nk8t5gXM4P3YCicQHT9odoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SjFkGHKWO+5lOGQBBcfEWXRrEfXYWBl6yLMq+sDE2YX5LdY8kh/RVjX7Does8Ku3E
	 +DX6y+JAaCpB+MDQ8EHcJSxfz4rRQh32X2ve5JwBkJTET0TueqFL5GhxnbFGpss30O
	 7osiEGuvHf6hsp+KhjCIsrBI5YwD9EIB66sMJfAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1833/2151] ibmveth: disable the reset work before unregister in remove
Date: Wed, 18 Nov 2026 15:59:28 +0100
Message-ID: <20261118150228.574149594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Mingming Cao <mmc@linux.ibm.com>

[ Upstream commit 1412235447869922eb0ee041a31fab6176e60ab0 ]

ibmveth_remove() cancels the reset work before unregister_netdev(),
but NAPI keeps running until unregister closes the device and can
queue the reset again, on an interrupt enable failure, a bad
free_map entry or a bad RX slot. The reset can then run on the
adapter after free_netdev(), or reopen the device during unregister.

Use disable_work_sync(), which waits for a running reset and keeps
the work from being queued again. A bad RX slot also makes poll
spin, which can stall unregister; a later patch in this series
fixes that.

Found in review of the ibmveth multi-queue RX series and confirmed by
code inspection; it was not reproduced. Tested on a POWER10 LPAR with
unbind and bind cycles under traffic. No kernel selftests cover ibmveth.

Fixes: 2c91e2319ed9 ("net: ibmveth: Reset the adapter when unexpected states are detected")
Signed-off-by: Mingming Cao <mmc@linux.ibm.com>
Link: https://patch.msgid.link/20261013182926.30417-4-mmc@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmveth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index bf0e0dc5eb516..a0acebe69aa24 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1956,7 +1956,7 @@ static void ibmveth_remove(struct vio_dev *dev)
 	struct ibmveth_adapter *adapter = netdev_priv(netdev);
 	int i;
 
-	cancel_work_sync(&adapter->work);
+	disable_work_sync(&adapter->work);
 
 	for (i = 0; i < IBMVETH_NUM_BUFF_POOLS; i++)
 		kobject_put(&adapter->rx_buff_pool[i].kobj);
-- 
2.53.0



