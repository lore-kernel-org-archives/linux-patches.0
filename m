Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021480;
	b=HGDT5q5DzoAinU/kTZBzpXZaAGctga/eLfxCQ4Hf07BMDuabAsSHI9uOs8rp9hirJRZU
	 Fn5keT4UhHAMZ36UUmZpIbbnYDYuWTbnyVCpwkUI1avOjb9PPWei82uK6R1zB/2I22ni8
	 bexzBgeFN/iiaV+hz3OGhJoyfuRxqsi7rgJnBz7N3+Yl3IkcgKjyw5y0yf2Xh+kXoIh1B
	 z92PUgVkEJ4WniXlcaUjzmHDfb6d1MqAUESqf+b/qBZAreIq3v7fqJJFOvpTe5vajB8fG
	 fo1vZz3x7AKY3fYXqA9FpfkoGGjqT5sr/0FFz9Y2U+88j3vsR5IXxLFv17V7gEOSXRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OCQCTx71EQNs6VJKgwKv/zXKO+bH6EMWO0e+5L+JFKE=;
	b=tdbcLEu4r92ZG4+I0r4UG2DGinIEKpxsL3bSnTo2w3Rp/RrZHjhtinNqf0X4HxCRbvgc
	 hrp6IO9QAYPSN4uiiwpIEHERwVOZqvlyhXc9UIhOVX6nu2gWhaIDfBumC5LoIccboEp1b
	 EUAL0DzcmezdUgraLW+sweM1NumIGJxmI07DrO8sFvqnYVrfJ245n9Kjnh+dJUm6iLmQg
	 knpLEt0g+FFCek5Jh/6zyCD8areEkzX8QF3S9CisNPkHIU3ydFiSVTDAuvCq5GxdhJjl4
	 RT8/a0Wp77+vovdLErpwFext1XKPeEiqhr/2QatHwxcT/O94qtx5MrGBUkUK5dJdxQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KIxHAkP4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86504606A32A;
	Wed, 18 Nov 2026 17:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KIxHAkP4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17651F000C4;
	Wed, 18 Nov 2026 17:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021480;
	bh=OCQCTx71EQNs6VJKgwKv/zXKO+bH6EMWO0e+5L+JFKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KIxHAkP4kgFRxiJwYW8dtEIb+ckheIecXK4rNg2iuuRl2HmcFbd7cm86e3vRQ2qtI
	 UUBckTFGM3tYz43SBOixWCp0QYES4U3Ml8klNiufeR7djEktrmRXdfExzkvqM3pn8J
	 aph/L1Cqfs3stCEKXdheyNygqQQ2cpncW+wJ4asE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingming Cao <mmc@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2271/2651] ibmveth: disable the reset work before unregister in remove
Date: Wed, 18 Nov 2026 15:58:31 +0100
Message-ID: <20261118150407.111317603@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 4665447997eaa..cee0e9783b2ab 100644
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



