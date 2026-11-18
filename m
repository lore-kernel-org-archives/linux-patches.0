Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034305;
	b=v+yS402FybJ8l0DBmCoOHtreple2XF1j0PHmd10RzML/phMyWhGIGngtZ7x7pmr6qBIK
	 3is70N6r4MScwYc0YuFPtjswrM//mznNCCQMArtPB8Vhu2uwsohm0Hl89wirhihUusCUI
	 6qS+zH7Gq5KPrTUHqc0KBTx6JfHsv9GeKmtWBnc+6vSpvpwNqiKGPv7kav8vHvCPYMlv1
	 uvMX/tAaGUs7bk7uv2g2XV2VLiCPNF2PkNY03kUCV2m+KNM5dRbUvGOC2r8HnHSezqMs7
	 knaxQwN+z/dcrW1k472wRt+8DrFdaP9WhqHBbFemuFRtsUUz/0VAjkb76qbSu18xwmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MUNIRLrz4QPT7yKwyHjCbUbkj9bs+dQrlt/qGMw/XWg=;
	b=eejnCOxExXic0OfXR1XnxRi9fZoxvMaI+PKPBmFG2kObTiBDWVancS0ytW4xqXFUSA2G
	 0JaJ76bf+8OECMoJLThf1MLwMlKz/ul8tBDquG70rolhdIQG0pMT1px4KTECiLrgh2HLF
	 xdlbFMBhJ8NOb9jJKZgc/65tQH1n/5IRs/9P4Lehfg+vfrJLRgAUtCVgy1aJc1dZFPHDR
	 bkV3Z44WhRTx3fI341h9M/QxXype8IfYQ2WClIKeG9fuZnDclIOY/+G8rNWBZbswrhaUF
	 IBkb7jZ0aNq1g1it5xNP0felrG9LZWET1QJYW61vIZzBdntNn1zyfG9Ykl3VwdfS5xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hFmfR8ey;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4016606A320;
	Wed, 18 Nov 2026 20:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hFmfR8ey
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECDE1F000C4;
	Wed, 18 Nov 2026 20:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034305;
	bh=MUNIRLrz4QPT7yKwyHjCbUbkj9bs+dQrlt/qGMw/XWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hFmfR8eyUB/hshgdnI+jv6W9oG9CnUcOnCO6hYqRRSFCkuhp5fwlzK2hhECouRBdI
	 fi150xKe7j24gxyzs461T/hsbFh7pVxINqHZd1o3pn1TDcZscvMoZ+gnvXODNKZfS2
	 cLeFm4hMEZROk705LaDBMV78BpUxKSk3L6Ei7uNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Md Rabbani <rabbanyhmm@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0321/3318] net: stmmac: fix device node reference leaks in stmmac_mtl_setup()
Date: Wed, 18 Nov 2026 15:15:43 +0100
Message-ID: <20261118150325.493162871@linuxfoundation.org>
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
index 1888a549983c6..ac08ecab54d6d 100644
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



