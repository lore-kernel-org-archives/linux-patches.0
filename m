Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021281;
	b=zy4l+XtlUbaUgInA/kZIKReRZp6HjUYTiL9ddbdY4URrRzf8nk+9PGK6M77YdLf0kWfW
	 yPJVDqw7e3JasPmM7FkYOihouNl3Y0ynPrrfHVGlGRJ4j5CHgUrbktwuP+kZLGwjOKBXo
	 bLOSk55kYzlNe5ypCQnh2700DC1jwf1VQVo67IGcMdKDAeZpjtUSiulHeE5BvpKEfoRK/
	 p/0dXBahPxzcPgqPCL7MZyDvlo0BnT52ZFpo7i1YZmvGQP3UO5ZtLuwKsAwp6udtBNzk7
	 nsNtompS9NKawUPVUnvzMReBPHx5l8oCB/ryZNARraSDfHJgY1TXRAmvDdVQmBovhrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6eEiMfDcl1bGk0jwyB9PnCLBTGUmbjYT/O+9c+t+/7g=;
	b=c+H3I4h9VbHmfPcH3cVr1ZYsPEHU1PXdaCUMSTFnzFq5+XcUISbqxp3LrGxo4q45ncRe
	 AR8e6RTRODVvcqaN6EMo1RAohiIeEmhpZMDAXCaSoRgr0cVTs1ZUNnflKDD58SsQ9xCJ2
	 3PNaAU3o9l3uHcB/HpYGa8Qc4R2pOv97lfuo+bBwvidH/vBynsbi1O4MaYp4PxD5+zsj1
	 lqLZOc9MUlbJMpUgPkdAP354m8/6eeK83JzDYMcyWhOx6FRhE/LMHuOdiBpA8YrV5CUFc
	 Zc2F+GaX7sS1WGZvXLQHCwn/ISwrR+h+93JZrtT7w6oLBKcRaAy9o87avBC6xOeBWXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ALPUnMMm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6812B606A320;
	Wed, 18 Nov 2026 17:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ALPUnMMm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4AC1F000C4;
	Wed, 18 Nov 2026 17:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021281;
	bh=6eEiMfDcl1bGk0jwyB9PnCLBTGUmbjYT/O+9c+t+/7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ALPUnMMm5J9iqm+3ldKJwNYw9hGKBcx3Yq/Bgpp4NIPfBtIBZ+iSMt37EDAn4Gg9G
	 3yxgCBAjB7G/3VgINSZ3rgBn9qAO9NDsJJnJYo8J5mGRCVK8pO3aZ8EJM9YfRWpznh
	 ABt6UKD3Kl384Af3pHQ22mzLwSqj6bF7TdvrJfrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2251/2651] net: hix5hd2: serialize timeout recovery with interface teardown
Date: Wed, 18 Nov 2026 15:58:11 +0100
Message-ID: <20261118150406.484695137@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 87cce46329a811ea3fe108ac721e0a2400d0a3bb ]

The timeout worker calls the driver's close and open methods without
RTNL or a running-state check. A timeout queued before an interface is
closed can call close again after ndo_stop has disabled NAPI. The second
napi_disable() can then wait indefinitely. The worker can also race with
an ongoing close.

Take RTNL and skip recovery when the interface is no longer running.
Use the netdev core close and open helpers so a failed reopen leaves the
interface down, rather than leaving it marked running with NAPI disabled.

After unregister_netdev() has stopped the watchdog, drain the worker
before releasing its MDIO and descriptor resources. This wait is outside
RTNL, allowing an already queued worker to take RTNL, observe the down
state, and finish.

This issue was identified as part of our ongoing research while
reviewing kernel code.

Fixes: 57c5bc9ad7d7 ("net: hisilicon: add hix5hd2 mac driver")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/179203116093.2621539.3718842986255459438.G202@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
index 02282dc86faf4..12a5657653f85 100644
--- a/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
+++ b/drivers/net/ethernet/hisilicon/hix5hd2_gmac.c
@@ -12,6 +12,7 @@
 #include <linux/of_net.h>
 #include <linux/of_mdio.h>
 #include <linux/reset.h>
+#include <linux/rtnetlink.h>
 #include <linux/clk.h>
 #include <linux/circ_buf.h>
 
@@ -890,8 +891,13 @@ static void hix5hd2_tx_timeout_task(struct work_struct *work)
 	struct hix5hd2_priv *priv;
 
 	priv = container_of(work, struct hix5hd2_priv, tx_timeout_task);
-	hix5hd2_net_close(priv->netdev);
-	hix5hd2_net_open(priv->netdev);
+
+	rtnl_lock();
+	if (netif_running(priv->netdev)) {
+		dev_close(priv->netdev);
+		dev_open(priv->netdev, NULL);
+	}
+	rtnl_unlock();
 }
 
 static void hix5hd2_net_timeout(struct net_device *dev, unsigned int txqueue)
@@ -1283,6 +1289,7 @@ static void hix5hd2_dev_remove(struct platform_device *pdev)
 	struct hix5hd2_priv *priv = netdev_priv(ndev);
 
 	unregister_netdev(ndev);
+	cancel_work_sync(&priv->tx_timeout_task);
 	mdiobus_unregister(priv->bus);
 	mdiobus_free(priv->bus);
 
@@ -1290,7 +1297,6 @@ static void hix5hd2_dev_remove(struct platform_device *pdev)
 		hix5hd2_destroy_sg_desc_queue(priv);
 	hix5hd2_destroy_hw_desc_queue(priv);
 	of_node_put(priv->phy_node);
-	cancel_work_sync(&priv->tx_timeout_task);
 	free_netdev(ndev);
 }
 
-- 
2.53.0



