Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043622;
	b=IiEmNNfzx+KExkt5jGvpemoxxi0IRWAHbVK7GBeymaKhY2VhIHVvwqoPJFbVGYZPPizO
	 HacFXN4BU3B3ZXkjkj790op404GjrZpiJcwkLkLKBnKGq7eimf+Z2yHl5wDJYfWq2CAs7
	 b3sK8OK9H0ZiSZ1eF3V/g7eXRH269iGCIbMf3jOJtGZygFOxteoEdx+uKWL+nB09E0/PJ
	 1GUkJePW/NmP9L8gngc7MKhE5me7K95iGceGMNAbLPfEDzCAczx8xu9zOcHnTBU8IFqSd
	 i4CA0uTUH+R4q4mmZUgEjtW5jJzRMh/y6Ywq/orJ2YPLtaACfMHEetVBT0ghZytvFLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I0bJMQe1KhFHzVwdVd+ei6UPJkQlpc0O1G+BGRsAXMk=;
	b=bpMyxeH6G3EhDi5JpXm4Pwgjt8sB2BESyHXvkZzWfN96SuacblBJZArTlhrWO6bLsOWn
	 DEWj9eUuwV9qMrdwWmq0qU2tenNFXFv1mFyd2HRYeQYC4cYe9/wngnaKqYgSf6AprVHJJ
	 1GLQogtkkmy2AmEUhNiPE299USKUNy1IPHPpXob+bObVSrgAQa9BgNleu9JIxDJ8OE2uK
	 EjQ9XNSOvCd0UuHpUzph2oshalr1d4KlzciftERu+Ap8kBD6kfz5UyWdT+BMg35/sVpfU
	 ueiHnTakfxDe0wmYH28skrCTBmkflnc/r7f9NiwnmmqR9zRvK9hZFdCJyIIUJmGyogA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HekKEydw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8763460A261C;
	Wed, 18 Nov 2026 23:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HekKEydw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFB31F000C5;
	Wed, 18 Nov 2026 23:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043622;
	bh=I0bJMQe1KhFHzVwdVd+ei6UPJkQlpc0O1G+BGRsAXMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HekKEydwBfPdjgvRQ4TqZt9PXE4BJ5n3S0rFANZJ6dT/Ncif4aZ4f+WJj360BSAP+
	 peNkICmUygfN+m1OC2fmc88Z+eMyE3M/Oge1RfcPkw8wUh6aAxTIoZe3pyRLiAHNhu
	 o2getAtw+ZwYsxl5hRh9xCxZy4LhL4k7XuTvHuxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Md Rabbani <rabbanyhmm@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0274/2857] net: stmmac: fix device node reference leaks in stmmac_mtl_setup()
Date: Wed, 18 Nov 2026 15:21:48 +0100
Message-ID: <20261118150211.292675677@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 8ea3fa9175686..f0ec83d7fed0b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -132,7 +132,6 @@ static struct stmmac_axi *stmmac_axi_setup(struct platform_device *pdev)
 static int stmmac_mtl_setup(struct platform_device *pdev,
 			    struct plat_stmmacenet_data *plat)
 {
-	struct device_node *q_node;
 	struct device_node *rx_node;
 	struct device_node *tx_node;
 	u8 queue = 0;
@@ -175,7 +174,7 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 		plat->rx_sched_algorithm = MTL_RX_ALGORITHM_SP;
 
 	/* Processing individual RX queue config */
-	for_each_child_of_node(rx_node, q_node) {
+	for_each_child_of_node_scoped(rx_node, q_node) {
 		if (queue >= plat->rx_queues_to_use)
 			break;
 
@@ -238,7 +237,7 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 	queue = 0;
 
 	/* Processing individual TX queue config */
-	for_each_child_of_node(tx_node, q_node) {
+	for_each_child_of_node_scoped(tx_node, q_node) {
 		if (queue >= plat->tx_queues_to_use)
 			break;
 
@@ -288,7 +287,6 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 out:
 	of_node_put(rx_node);
 	of_node_put(tx_node);
-	of_node_put(q_node);
 
 	return ret;
 }
-- 
2.53.0



