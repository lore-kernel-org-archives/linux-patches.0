Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104BF18DF89;
	Sun,  7 Sep 2025 20:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277061; cv=none; b=Qvqzsa/vVg01ORydrLhxy5nOfQCIBemqiVBcVL0ersxeLPQp7r+o+oFmVCu1FO2HJIBhVtopBDzR796+5KHujlYiKa1Ssn+iW5KhJPd+Hwuq248Wqba/gcFqCXaK2V3o/eSJEpdF6qcSWBy5kznRqLqo2m87exz2shxgVA7G91c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277061; c=relaxed/simple;
	bh=mptv2yhY5GXz8Vd14kjy6Aq8CfHJeFoVTQMY/kymrMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0dyNr3tozm1/SNQC86Oa8/eyGY+kUSePsaP/HVUIW9CDYToRBWHGNqhb1qlbMqSIZ+FVF6bYs7N4d9abcFpFDQ6Gb4deG06s0pHyQJE0qGWnyudnQFK6U3vBWu87y0IyCI0dq5oCOj1x7/85ym7rLPKdIrSTVIcUKo56f+HHFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DBdz8IZs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DBdz8IZs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CFFC4CEF0;
	Sun,  7 Sep 2025 20:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277060;
	bh=mptv2yhY5GXz8Vd14kjy6Aq8CfHJeFoVTQMY/kymrMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBdz8IZsEAS+huKlFbpaYXKnKf0cMGSEaWbhGFWMRnzAAzIFUBVM1F+Oo+kEmxaOJ
	 +oDJK9LxRnlWN4f1xDwwrfzsjcN6U6U9FkjJyMcvZqIps52E8FrQxEAMN1GPXRWOhD
	 ymeHsUbh0ZVfkf10OxnO3tQmi6UtL6WBg/RbVZgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radu Rendec <rrendec@redhat.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 071/175] net: vxlan: rename SKB_DROP_REASON_VXLAN_NO_REMOTE
Date: Sun,  7 Sep 2025 21:57:46 +0200
Message-ID: <20250907195616.515585259@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radu Rendec <rrendec@redhat.com>

[ Upstream commit 46e0ccfb88f02ab2eb20a41d519d6e4c028652f2 ]

The SKB_DROP_REASON_VXLAN_NO_REMOTE skb drop reason was introduced in
the specific context of vxlan. As it turns out, there are similar cases
when a packet needs to be dropped in other parts of the network stack,
such as the bridge module.

Rename SKB_DROP_REASON_VXLAN_NO_REMOTE and give it a more generic name,
so that it can be used in other parts of the network stack. This is not
a functional change, and the numeric value of the drop reason even
remains unchanged.

Signed-off-by: Radu Rendec <rrendec@redhat.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20241219163606.717758-2-rrendec@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1f5d2fd1ca04 ("vxlan: Fix NPD in {arp,neigh}_reduce() when using nexthop objects")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 4 ++--
 drivers/net/vxlan/vxlan_mdb.c  | 2 +-
 include/net/dropreason-core.h  | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 40f01a6aaed38..ce9dcd8e74a93 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2787,7 +2787,7 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 			dev_core_stats_tx_dropped_inc(dev);
 			vxlan_vnifilter_count(vxlan, vni, NULL,
 					      VXLAN_VNI_STATS_TX_DROPS, 0);
-			kfree_skb_reason(skb, SKB_DROP_REASON_VXLAN_NO_REMOTE);
+			kfree_skb_reason(skb, SKB_DROP_REASON_NO_TX_TARGET);
 			return NETDEV_TX_OK;
 		}
 	}
@@ -2810,7 +2810,7 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 		if (fdst)
 			vxlan_xmit_one(skb, dev, vni, fdst, did_rsc);
 		else
-			kfree_skb_reason(skb, SKB_DROP_REASON_VXLAN_NO_REMOTE);
+			kfree_skb_reason(skb, SKB_DROP_REASON_NO_TX_TARGET);
 	}
 
 	return NETDEV_TX_OK;
diff --git a/drivers/net/vxlan/vxlan_mdb.c b/drivers/net/vxlan/vxlan_mdb.c
index e1173ae134284..ec86d1c024834 100644
--- a/drivers/net/vxlan/vxlan_mdb.c
+++ b/drivers/net/vxlan/vxlan_mdb.c
@@ -1712,7 +1712,7 @@ netdev_tx_t vxlan_mdb_xmit(struct vxlan_dev *vxlan,
 		vxlan_xmit_one(skb, vxlan->dev, src_vni,
 			       rcu_dereference(fremote->rd), false);
 	else
-		kfree_skb_reason(skb, SKB_DROP_REASON_VXLAN_NO_REMOTE);
+		kfree_skb_reason(skb, SKB_DROP_REASON_NO_TX_TARGET);
 
 	return NETDEV_TX_OK;
 }
diff --git a/include/net/dropreason-core.h b/include/net/dropreason-core.h
index d59bb96c5a02c..02e7be19b0428 100644
--- a/include/net/dropreason-core.h
+++ b/include/net/dropreason-core.h
@@ -96,7 +96,7 @@
 	FN(VXLAN_VNI_NOT_FOUND)		\
 	FN(MAC_INVALID_SOURCE)		\
 	FN(VXLAN_ENTRY_EXISTS)		\
-	FN(VXLAN_NO_REMOTE)		\
+	FN(NO_TX_TARGET)		\
 	FN(IP_TUNNEL_ECN)		\
 	FN(TUNNEL_TXINFO)		\
 	FN(LOCAL_MAC)			\
@@ -441,8 +441,8 @@ enum skb_drop_reason {
 	 * entry or an entry pointing to a nexthop.
 	 */
 	SKB_DROP_REASON_VXLAN_ENTRY_EXISTS,
-	/** @SKB_DROP_REASON_VXLAN_NO_REMOTE: no remote found for xmit */
-	SKB_DROP_REASON_VXLAN_NO_REMOTE,
+	/** @SKB_DROP_REASON_NO_TX_TARGET: no target found for xmit */
+	SKB_DROP_REASON_NO_TX_TARGET,
 	/**
 	 * @SKB_DROP_REASON_IP_TUNNEL_ECN: skb is dropped according to
 	 * RFC 6040 4.2, see __INET_ECN_decapsulate() for detail.
-- 
2.50.1



