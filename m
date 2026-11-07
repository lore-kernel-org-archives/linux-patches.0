Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061057;
	b=crcPSG5GiQ1AEKGvmLhLwCnSl7JU3nCphwUlUxzOFH08O3c1lqXYOtdFJayoGrUhkQ3G
	 uZrLyivDAmUfGgU6ybBm8kniOX/QL4yewNEnbioBU03vNFkpgGUajnraNNEGqYFuPARTm
	 u4YDnlhPNfobNuHH58c9+HaXumw6Cn0bciYBhEWVL/SB4LwK+/piY9wdcP0zxxmf4uTfp
	 MYlmGSrXb4luaubetzB/EkAipKPJAYJ44D279AxZC+ua4qqTcyQT7ltP/+TFGmBL7rvra
	 PLhVkag+7qAHksZSfTNq9ArqNC6Il78Gfha9t8jtpbKVcslw5oW5PdfFnzuN4tPqcXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vrxarUSzikNWGt8kL+tmm2UBD3FLwmNC6n8ffTt5WbA=;
	b=BpDcf1olP0bnd46R6qmzgx0aqVrKem9CTb/vvTAPJJzwXwp7SyFSU3LIZanVsGpIjsR9
	 +yT2Wofr2dCrVv080kt25/MTLZuiZWjkL5zTL5fd2kLGiq9gsESzWk2RQRkKoO5SNOR5D
	 As27wA0JhgLPkrEaxPn6RVXY63tI4y8x2zkW4QUfTYAdfUMvX1wQBB+xlEEbmNAR6rekv
	 i/VOayk7iGtwdefAR9/Vuqif0lj5sjIy1c+AFUHM+5YnQQ7D1sP2f0AYGj9dNSHgCXv+u
	 ZwSNissWX/z49NH1uUA6x2MjXRFUOly6CzMv42JtkdoLIw7It1vWg7+nEIcPj/THpwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0B+4Z1zT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC90606A339;
	Sat,  7 Nov 2026 14:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0B+4Z1zT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21001F0089F;
	Sat,  7 Nov 2026 14:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061057;
	bh=vrxarUSzikNWGt8kL+tmm2UBD3FLwmNC6n8ffTt5WbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0B+4Z1zTsgkySiSPj0u7r4O3weeKxRM4/QSfVZZoEyzNhfHBvNYpuIpu2JSOl3f7T
	 +ktL6TIUhDJOZoVOYgmDxXKW25bXMfFjksANLIIPDhEvCEZSgJZg0teqGyPeTkwQUo
	 z6DLzPE/+TE7o7WU5ev3HBU69p+hCNjIJm5B4PtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Md Rabbani <rabbanyhmm@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0388/1536] net: stmmac: fix device node reference leaks in stmmac_mtl_setup()
Date: Sat,  7 Nov 2026 08:40:04 -0500
Message-ID: <20261107135008.508030303@linuxfoundation.org>
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

From: Md Rabbani <rabbanyhmm@gmail.com>

[ Upstream commit 317fe168f4c0fc30e5c375c22d9c8911940aea9b ]

In stmmac_mtl_setup(), q_node is shared across the RX and TX queue
parsing loops. When the RX queue loop breaks early because the number
of parsed queues reaches plat->rx_queues_to_use, q_node retains an
acquired reference count. If the error check passes
(queue == plat->rx_queues_to_use), execution proceeds directly to the
TX queue loop, where of_get_next_child() immediately overwrites q_node
with the first TX child, permanently leaking the retained RX child
device node reference.

Switch both loops to for_each_child_of_node_scoped() so child node
references are automatically dropped upon loop exit or early break,
and remove the now-unnecessary function-scoped q_node variable and
its manual of_node_put() at the exit label.

Signed-off-by: Md Rabbani <rabbanyhmm@gmail.com>
Link: https://patch.msgid.link/20260821055718.57-1-rabbanyhmm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index b79826a61ec47..8a1c20135f031 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -131,7 +131,6 @@ static struct stmmac_axi *stmmac_axi_setup(struct platform_device *pdev)
 static int stmmac_mtl_setup(struct platform_device *pdev,
 			    struct plat_stmmacenet_data *plat)
 {
-	struct device_node *q_node;
 	struct device_node *rx_node;
 	struct device_node *tx_node;
 	u8 queue = 0;
@@ -174,7 +173,7 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 		plat->rx_sched_algorithm = MTL_RX_ALGORITHM_SP;
 
 	/* Processing individual RX queue config */
-	for_each_child_of_node(rx_node, q_node) {
+	for_each_child_of_node_scoped(rx_node, q_node) {
 		if (queue >= plat->rx_queues_to_use)
 			break;
 
@@ -237,7 +236,7 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 	queue = 0;
 
 	/* Processing individual TX queue config */
-	for_each_child_of_node(tx_node, q_node) {
+	for_each_child_of_node_scoped(tx_node, q_node) {
 		if (queue >= plat->tx_queues_to_use)
 			break;
 
@@ -290,7 +289,6 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 out:
 	of_node_put(rx_node);
 	of_node_put(tx_node);
-	of_node_put(q_node);
 
 	return ret;
 }
-- 
2.53.0



