Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027160;
	b=KU+S2Z4fpARcEU3Zu4ZAlOzGZ1DYpLRHuqGi+vmPyNsYZe6Tt/U67zw1GxPB6jC6OTgg
	 2iqzdu51k6LxcAzkVPvSAY3HEhNxhiys2SvSiSInvErxSUHhzXXAey4UtTdfrdeH6Mcg9
	 C6gCyME6w18/3el11FMxKyVyRBoEYCqBqk8HrQWNA8gyYoagiDxMx/OKednx8XMFmXRJM
	 ZQjCtNG6ITdavq7G/mtGJobeAhPl7SJJhSqKbxpGHEjMezzIwGMhV7FuyI4tgV5OA5w6u
	 DJq6bpBgjrFe+xHYOZ1EHh2R4PUoTtoJSKn2dFTHyciOfbTsm7/yLGkp2geGckkSyBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cnCY7oDMiV5/28xd+Yrz5YTEfFlJReY0I8JmamQIXXw=;
	b=tGnNE8V2mHdAlSeD3SgetpgAgONk+bBn1P50oQjh7V9u9s7OpiF4/qW7h3rjexYmxSAj
	 yz7I4KBQFvIbZzyZIfhNFNfeOo9fFL1PTYdhqA3a/LBDI1KUBQ52gzFiMKWO0jMwzDlfn
	 0RCHb/WI3rM75N8gwDtZsy2w4mpcNIyFu3ywCEOAx/TezDSiMY7YHqvCGdIMDL34yc+HQ
	 EbVWhOt3HIg3yzG3LwA+x2PLhDWdAlcQ250Y5mmQzkOAPXcg2/iNe0oOVPnVFTpKz7UZP
	 ivqsdycvajcy24nL7zvVMZIPav28wzGyE1s4WNFKhvoH1F1zaMi5eSSiR9zfhk03+ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SHbrg4gH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE14D606A32F;
	Wed, 18 Nov 2026 18:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SHbrg4gH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C001F000C7;
	Wed, 18 Nov 2026 18:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027159;
	bh=cnCY7oDMiV5/28xd+Yrz5YTEfFlJReY0I8JmamQIXXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SHbrg4gHvuHCC3V7mvsMExmvKtIN7+mYzElXfp3lwJMN5eFQgH0NLbaZCSyYgiDT+
	 47gpsqrtfm9ExmPtxYogXfIqTuGTukXMes/Y88nejOyFuk8bHEXaZesG71cw8LBbGv
	 t8b3vLD31fqznwEqPLvBwQPr5msbZmicKH4pvui4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	Willy Tarreau <w@1wt.eu>,
	Atharva Vartak <atharva.a.vartak@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1649/2151] net/smc: hold a reference on net_device returned by pnet_find_base_ndev()
Date: Wed, 18 Nov 2026 15:56:24 +0100
Message-ID: <20261118150221.917669103@linuxfoundation.org>
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

From: Atharva Vartak <atharva.a.vartak@gmail.com>

[ Upstream commit e6435b2cc5fdf008cdb67ad9a811a266e8ac9c1e ]

pnet_find_base_ndev() resolves the base net_device for stacked devices
under RTNL, then drops the lock and returns the raw pointer without
taking a reference.  All three callers dereference the pointer after
RTNL has been released, creating a use-after-free window if the device
is concurrently unregistered.

Take a reference with netdev_hold() before dropping RTNL and add the
matching netdev_put() in every return path of the three callers:

  - smc_pnet_add_eth()
  - smc_pnet_find_roce_by_pnetid()
  - smc_pnet_find_ism_by_pnetid()

Found by code analysis, confirmed with a proof-of-concept that triggers
a KASAN slab-use-after-free report.

Fixes: 0afff91c6f5e ("net/smc: add pnetid support")
Fixes: 1619f770589a ("net/smc: add pnetid support for SMC-D and ISM")
Cc: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: Dust Li <dust.li@linux.alibaba.com>
Cc: Sidraya Jayagond <sidraya@linux.ibm.com>
Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: Tony Lu <tonylu@linux.alibaba.com>
Cc: Wen Gu <guwen@linux.alibaba.com>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Atharva Vartak <atharva.a.vartak@gmail.com>
Link: https://patch.msgid.link/20261007040009.137568-1-atharva.a.vartak@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_pnet.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/net/smc/smc_pnet.c b/net/smc/smc_pnet.c
index a3a1e1fde8eb6..f7118fae35ae3 100644
--- a/net/smc/smc_pnet.c
+++ b/net/smc/smc_pnet.c
@@ -30,7 +30,8 @@
 #include "smc_core.h"
 
 static struct net_device *__pnet_find_base_ndev(struct net_device *ndev);
-static struct net_device *pnet_find_base_ndev(struct net_device *ndev);
+static struct net_device *pnet_find_base_ndev(struct net_device *ndev,
+					      netdevice_tracker *tracker);
 
 static const struct nla_policy smc_pnet_policy[SMC_PNETID_MAX + 1] = {
 	[SMC_PNETID_NAME] = {
@@ -351,6 +352,7 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
 	struct smc_pnetentry *tmp_pe, *new_pe;
 	struct net_device *ndev, *base_ndev;
 	u8 ndev_pnetid[SMC_MAX_PNETID_LEN];
+	netdevice_tracker base_tracker;
 	bool new_netdev;
 	int rc;
 
@@ -360,10 +362,13 @@ static int smc_pnet_add_eth(struct smc_pnettable *pnettable, struct net *net,
 	rc = -EEXIST;
 	ndev = dev_get_by_name(net, eth_name);	/* dev_hold() */
 	if (ndev) {
-		base_ndev = pnet_find_base_ndev(ndev);
+		base_ndev = pnet_find_base_ndev(ndev, &base_tracker);
 		if (!smc_pnetid_by_dev_port(base_ndev->dev.parent,
-					    base_ndev->dev_port, ndev_pnetid))
+					    base_ndev->dev_port, ndev_pnetid)) {
+			netdev_put(base_ndev, &base_tracker);
 			goto out_put;
+		}
+		netdev_put(base_ndev, &base_tracker);
 	}
 
 	/* add a new netdev entry to the pnet table if there isn't one */
@@ -940,10 +945,13 @@ static struct net_device *__pnet_find_base_ndev(struct net_device *ndev)
  * (for instance with bonding slaves), just the first device
  * is used to reach a base device.
  */
-static struct net_device *pnet_find_base_ndev(struct net_device *ndev)
+static struct net_device *pnet_find_base_ndev(struct net_device *ndev,
+					      netdevice_tracker *tracker)
 {
 	rtnl_lock();
 	ndev = __pnet_find_base_ndev(ndev);
+	/* keep ndev alive after dropping RTNL, callers must netdev_put() */
+	netdev_hold(ndev, tracker, GFP_KERNEL);
 	rtnl_unlock();
 	return ndev;
 }
@@ -1080,17 +1088,20 @@ static void smc_pnet_find_roce_by_pnetid(struct net_device *ndev,
 {
 	u8 ndev_pnetid[SMC_MAX_PNETID_LEN];
 	struct net_device *base_ndev;
+	netdevice_tracker base_tracker;
 	struct net *net;
 
-	base_ndev = pnet_find_base_ndev(ndev);
+	base_ndev = pnet_find_base_ndev(ndev, &base_tracker);
 	net = dev_net(ndev);
 	if (smc_pnetid_by_dev_port(base_ndev->dev.parent, base_ndev->dev_port,
 				   ndev_pnetid) &&
 	    smc_pnet_find_ndev_pnetid_by_table(base_ndev, ndev_pnetid) &&
 	    smc_pnet_find_ndev_pnetid_by_table(ndev, ndev_pnetid)) {
 		smc_pnet_find_rdma_dev(base_ndev, ini);
+		netdev_put(base_ndev, &base_tracker);
 		return; /* pnetid could not be determined */
 	}
+	netdev_put(base_ndev, &base_tracker);
 	_smc_pnet_find_roce_by_pnetid(ndev_pnetid, ini, NULL, net);
 }
 
@@ -1098,13 +1109,16 @@ static void smc_pnet_find_ism_by_pnetid(struct net_device *ndev,
 					struct smc_init_info *ini)
 {
 	u8 ndev_pnetid[SMC_MAX_PNETID_LEN];
+	netdevice_tracker base_tracker;
 	struct smcd_dev *ismdev;
 
-	ndev = pnet_find_base_ndev(ndev);
+	ndev = pnet_find_base_ndev(ndev, &base_tracker);
 	if (smc_pnetid_by_dev_port(ndev->dev.parent, ndev->dev_port,
 				   ndev_pnetid) &&
-	    smc_pnet_find_ndev_pnetid_by_table(ndev, ndev_pnetid))
+	    smc_pnet_find_ndev_pnetid_by_table(ndev, ndev_pnetid)) {
+		netdev_put(ndev, &base_tracker);
 		return; /* pnetid could not be determined */
+	}
 
 	mutex_lock(&smcd_dev_list.mutex);
 	list_for_each_entry(ismdev, &smcd_dev_list.list, list) {
@@ -1118,6 +1132,7 @@ static void smc_pnet_find_ism_by_pnetid(struct net_device *ndev,
 		}
 	}
 	mutex_unlock(&smcd_dev_list.mutex);
+	netdev_put(ndev, &base_tracker);
 }
 
 /* PNET table analysis for a given sock:
-- 
2.53.0



