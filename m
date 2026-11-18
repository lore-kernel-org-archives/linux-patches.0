Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016295;
	b=UI55ywKsE9YoxhwImlFdXTcKebAw+GWGMoaCxMS+0dWd5PTk9kgy+CSQamIx4Jz5sOmL
	 qkjwTUpCs406mLOH/8zH1lYTIvctM/A32BvRA64CBiCCGiW8Y7UAzndTFROUm0A25o66v
	 WcD5K6e4W3RBnQUmrcAvVLOwRsOymE8cnt1GOwDt51u1gSiIMCoZUTL3SH0rjJlonmxQE
	 ZLEEZGeVEtSh2wC0KTXt5E+AxcFxGRM0++hgnw/3eZGR8DlWghPYVhVMVr//2UseDvULr
	 3Wj2UAVLRKdBWKyZ7fTsyC+YokXU/CI3f2Ghoffm0bKn80jN1cE7CTl/5L2vKS4swUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M2MeXzmBhP6Ru+C2sg03MdUelTnp5+snlHdLipy4sEQ=;
	b=JIV3qE9DH1llMozNuy+yC3qq/hHgK7WGllok8VhOrTUV4RxWg6JBxIuNnX9sIFAhWcrR
	 gzhyx7m0z7fs317tEUBhzrUqnV9/xv/QYWkKG2MEFolh/cVicd4E1MnaxZaB6raC2m9vK
	 wMbk1kquxj2EEgZI0X6whIczPxf4SrBrBX0ifGfweJRUS8hlXvyqK8cp7dgGPEPhO/jna
	 mkvMcla3wHfH+2q7PVpjxrmhb3GrUMgv1wuZ5zCfvuUy214k1cgdyzijx96ZO6MLc9GDc
	 Sg8ajFtftWXgXh5/IVZOQQ00wyU2Jg5B63tz3a+xFDcwOKLAlUtjPUGkZDHkXUfFVEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oO4QeeKx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF0360A3803;
	Wed, 18 Nov 2026 15:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oO4QeeKx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D7E1F000CA;
	Wed, 18 Nov 2026 15:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016295;
	bh=M2MeXzmBhP6Ru+C2sg03MdUelTnp5+snlHdLipy4sEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oO4QeeKxkqKLU3rU9zzRTBx2DmC/HwWBJs9V0DeeKAC4gUFzvvDBmtW8wylYxZZFj
	 GC2yBG5qap+8apMojYWmhCxC7iToMuTwTYJGl0QKte6o9ZowCkDsTX2wH2UNXsGkYA
	 FMdYEBGNaJBB644elCLCGAN1Q4FhNUPYhjE+bGcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0479/2651] RDMA/hns: Fix the use of uninitialized variable
Date: Wed, 18 Nov 2026 15:28:39 +0100
Message-ID: <20261118150305.026811824@linuxfoundation.org>
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

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 653c5b4605f65355d3b3f1059784e56c77f146b3 ]

The variable 'i' is used without being initialized in active-backup
mode.

Fixes: d9023e461b73 ("RDMA/hns: Implement bonding init/uninit process")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20260914024800.132429-1-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_bond.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_bond.c b/drivers/infiniband/hw/hns/hns_roce_bond.c
index f2b12ae13a584..8d8272705fb72 100644
--- a/drivers/infiniband/hw/hns/hns_roce_bond.c
+++ b/drivers/infiniband/hw/hns/hns_roce_bond.c
@@ -81,7 +81,7 @@ static int hns_roce_set_bond_netdev(struct hns_roce_bond_group *bond_grp,
 {
 	struct net_device *active_dev;
 	struct net_device *old_dev;
-	int i, ret = 0;
+	int i = 0, ret = 0;
 
 	if (bond_grp->tx_type == NETDEV_LAG_TX_TYPE_ACTIVEBACKUP) {
 		rcu_read_lock();
@@ -89,7 +89,7 @@ static int hns_roce_set_bond_netdev(struct hns_roce_bond_group *bond_grp,
 			bond_option_active_slave_get_rcu(netdev_priv(bond_grp->upper_dev));
 		rcu_read_unlock();
 	} else {
-		for (i = 0; i < ROCE_BOND_FUNC_MAX; i++) {
+		for (; i < ROCE_BOND_FUNC_MAX; i++) {
 			active_dev = bond_grp->bond_func_info[i].net_dev;
 			if (active_dev &&
 			    ib_get_curr_port_state(active_dev) == IB_PORT_ACTIVE)
-- 
2.53.0



