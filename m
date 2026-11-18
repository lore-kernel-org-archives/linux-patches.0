Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032786;
	b=IRqO9FmLq0IIxpO0v2m0HZqeXwFrF9aiwl/3cOTQmcSJ/brwStbLe/pt6Wnyyu0twS1M
	 mRRUfzcvB9bzFtwLT5M3mOT4yUPBsAJpk0dqw3ktMfSmLlzu1Ym7UGWAdM1phURQiFfTT
	 zTcqaJuOQW5H00CGLdiA1l4AxYKNYCKY0V1FECmAVVJVCjNjOucA1xCz7eglSKa/qO5W8
	 gcj4csWqqjj2lhM+E5eKAjCrKO4hZG56/Ry8v4srNVgk912Wg9+lEhBFuM48qYOiHDjj5
	 m0eBKpQZKwX5ak1p4Fqrz/zWGtUVLSHoejNIhtONkWlZM67SwJ2PfpBkts18uBLM9Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QASfG7vQ8jYD/1BU7ZO+f9Db1yM61r17tZh3fngvHBs=;
	b=hPU0at6OUbEmDdSCgtX+wb6qOREgmqyulN9eDjBHe7Xb1Zei7CQXVw3IkLOBQSQpPxYF
	 Ec7csh55KpVaCYbzwh3je+4PkiuOjTbGjTuTjU24zrXPlITWMVE3bQMoqDszNJrZYs8BX
	 /Zh6qGoJUkat9dQYvybaq6wLsmEfIzCmL+vgViywOR4draix0Kqv18Ph0Qp/Fg4R0/jWA
	 RE1IJpmBy/7y1JKz9yYW/0KP8If3CIJJBytEGKgUBOSggn+QqpVajHdSlkUzaYqy0oKxO
	 bZveMBMEq7mCiFzsgKZMmMoQHdLi8wUmJDr3CrU6jvrDoreX8OUC4DkoTkoVNtVfLyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=klhu10Xb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ABF6606A31C;
	Wed, 18 Nov 2026 20:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=klhu10Xb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDEC1F000C4;
	Wed, 18 Nov 2026 20:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032786;
	bh=QASfG7vQ8jYD/1BU7ZO+f9Db1yM61r17tZh3fngvHBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=klhu10Xb6iXYivNabLEsZF7xPLezfOp51I0wA7ovLC15JMVDx4Oj1kZYvvEnNKkSy
	 9WuMh6+mVSYdp7juzoYlo46ZzslS1lJIjY92JQMuaWx2t9E3Fh8PdYbjxHX+ekCF1O
	 WLnxaP12RWcQG4AjU0SWBkuMLtrFm0OQW0DKehjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steen Hegelund <Steen.Hegelund@microchip.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1535/1756] net: sparx5: activate FDMA tx in start()
Date: Wed, 18 Nov 2026 16:01:02 +0100
Message-ID: <20261118150110.063799668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit cded2e0f1b0de5aa1ebd4bf42c3f1919b7adf6cd ]

The function sparx5_fdma_tx_activate() is responsible for configuring
the TX FDMA instance and activating the channel. TX activation has
previously been done in the xmit() function, when the first frame is
transmitted. Now that we have separate functions for starting and
stopping the FDMA, it seems reasonable to move the TX activation to the
start function. This change has no implications on the functionality.

Reviewed-by: Steen Hegelund <Steen.Hegelund@microchip.com>
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20250113-sparx5-lan969x-switch-driver-5-v2-3-c468f02fd623@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1df26063ab9b ("net: sparx5: fix tx DCB index drift in fdma xmit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
index b65074b358899..c21f643423275 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
@@ -215,7 +215,6 @@ int sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb)
 {
 	struct sparx5_tx *tx = &sparx5->tx;
 	struct fdma *fdma = &tx->fdma;
-	static bool first_time = true;
 	void *virt_addr;
 
 	fdma_dcb_advance(fdma);
@@ -236,12 +235,8 @@ int sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb)
 		     FDMA_DCB_STATUS_BLOCKO(0) |
 		     FDMA_DCB_STATUS_BLOCKL(skb->len + IFH_LEN * 4 + 4));
 
-	if (first_time) {
-		sparx5_fdma_tx_activate(sparx5, tx);
-		first_time = false;
-	} else {
-		sparx5_fdma_reload(sparx5, fdma);
-	}
+	sparx5_fdma_reload(sparx5, fdma);
+
 	return NETDEV_TX_OK;
 }
 
@@ -452,6 +447,7 @@ static u32 sparx5_fdma_port_ctrl(struct sparx5 *sparx5)
 int sparx5_fdma_start(struct sparx5 *sparx5)
 {
 	struct sparx5_rx *rx = &sparx5->rx;
+	struct sparx5_tx *tx = &sparx5->tx;
 
 	netif_napi_add_weight(rx->ndev,
 			      &rx->napi,
@@ -461,6 +457,7 @@ int sparx5_fdma_start(struct sparx5 *sparx5)
 	napi_enable(&rx->napi);
 
 	sparx5_fdma_rx_activate(sparx5, rx);
+	sparx5_fdma_tx_activate(sparx5, tx);
 
 	return 0;
 }
-- 
2.53.0



