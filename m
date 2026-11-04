Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831019;
	b=0L92EAcHc+VCJNbBPz2l8hpV7qyuIJ5ADVtEpl39/P38de3xpJ9BFjOUNEcfSLaPITUH
	 wxhNApOvt7L1hkvRQBuda+gsfoLmiE8e2gZtVyOpSZkACRWfiNmR0D+PYJnsPBGFjaxyh
	 +/zk6H6iF2pAPdlFOGdTu+yrri9jLd6pYz46ezdgI+I81sbHdEFdJ+wtkxuStX7jzjaH1
	 LrxtuRYCVSqaKv79QyfTOJKnszajsDFSSImKdRB7NfTiw56mn7MKg9FTkoPXWuoTQUJYo
	 jVHZc5syVx56NbU14Mg/W9XgCa3oCbW35HtBDM7LoSvoZOZiokIu+QbvxasvlrAy3uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+7YSLdJRubglEtZGDIKmcuYHSXt80hj75s170Tc0wJA=;
	b=l8lpxCWMxEauE6L+b/k7hDN2s/wTF8gSlN0MNtCZqSbQ8X9ePJlSA93vs++df/SjDIi/
	 EOrPZygZXgraqKSSzs0faVzWjOe3ux4axHGFNOYaIF7ktcyUgy2iYN/lgfhhDjxgtEb4w
	 NtbXey6wZwbss5Y62siiDt36MouAz4ViXrpaTZxD3KK46boH/Aw9G2H+JzjOctiy6KR69
	 a8AwmQjn7klR9FxTy6l+HnGv/vevdWqxdz955CFi0xJoWRPgLIgn5Wd960Lt8yzIHn4FI
	 /IGbYQZ3gjNXDtTyDnET9n/9h8cuiJxkxLpfpSW6GODJUYmbJt9aWd7G/FDnBcpEfVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JjGWZz+G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F65606A843;
	Wed,  4 Nov 2026 22:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JjGWZz+G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2241F000C1;
	Wed,  4 Nov 2026 22:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831019;
	bh=+7YSLdJRubglEtZGDIKmcuYHSXt80hj75s170Tc0wJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JjGWZz+GpP+dRnwkod5Dx5H5zVsT7gLOrjxvz7PqQQ4P4rWaPFRVx/t/r/kKvCH2L
	 NSbulJwJH/EQhdxdfrf8MJSy+A8yv0P7PVM7VRTCr9C+cGVTXoKIPpupVF6vzpRN/K
	 kO8Hs4okG/EbSjE0R0yy3LBS7DQ5no+ssQZDmyqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Md Rabbani <rabbanyhmm@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0459/1005] net: stmmac: fix device node reference leaks in stmmac_mtl_setup()
Date: Wed,  4 Nov 2026 16:03:12 -0500
Message-ID: <20261104211056.889487290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 0cb51935c4056..ceb913a3a6c69 100644
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



