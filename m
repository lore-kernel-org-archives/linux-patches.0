Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A831FBEA8;
	Tue, 17 Jun 2025 16:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178932; cv=none; b=FyxTvKHVmqIY7C68ygVY1aoXJZBZ+9QK0zxpPSoImcPHSz/ETDtOYa9d3XI9ze+cfPEbYFYUuLkmtfkwjxAqPWDD93CMea0mC2LIgFS2jmUMu2MJNJmryMAfU9OC0z3vWbfR4+U9vxX/xTq4Pl7oFScimCGHBVEsVOvZOjVkxzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178932; c=relaxed/simple;
	bh=5qPsKGinyHwuCvXkxgmNIbpDfmTylHcePJVmPjnlcCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGuWPwhozBvBupuTo3p+m7YkoGkETSbMuLfA+7X8vaHSsrMqWunvvZdxvPnEc1/PlaBSEkTJShqm5rhlwpkx20zbbmgwiGkNa1BtqwTqB93iinhDj6fJ77BifRHvEH2ZNrFMUzwUtpknbx9Pv1ryychXZs5Q/Cd10cAN55KsSOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=prRIg0hz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="prRIg0hz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CB0C4CEE3;
	Tue, 17 Jun 2025 16:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178932;
	bh=5qPsKGinyHwuCvXkxgmNIbpDfmTylHcePJVmPjnlcCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prRIg0hzUQIFSqJMcM/VLbSzUQBbJiarSi7ci35jNDvHIswL8YLAxHVZUl2WHhJP9
	 XsCPUxfpPywJRVSpxvi/fffeT1H93U+ndE7alXBp9Qa+QH3+aTjj19bta2cCvvcesU
	 sOtF+uo1lvecwlNnvbFGu2AVUlWw1icN0rgENn1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 596/780] iavf: sprinkle netdev_assert_locked() annotations
Date: Tue, 17 Jun 2025 17:25:04 +0200
Message-ID: <20250617152515.758397059@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

[ Upstream commit 05702b5c949bd46243181833d4726f4c5e95f5e3 ]

Lockdep annotations help in general, but here it is extra good, as next
commit will remove crit lock.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 120f28a6f314 ("iavf: get rid of the crit lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c |  6 ++++++
 drivers/net/ethernet/intel/iavf/iavf_main.c    | 10 ++++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 288bb5b2e72ef..03d86fe80ad91 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -4,6 +4,8 @@
 #include <linux/bitfield.h>
 #include <linux/uaccess.h>
 
+#include <net/netdev_lock.h>
+
 /* ethtool support for iavf */
 #include "iavf.h"
 
@@ -1259,6 +1261,8 @@ static int iavf_add_fdir_ethtool(struct iavf_adapter *adapter, struct ethtool_rx
 	int count = 50;
 	int err;
 
+	netdev_assert_locked(adapter->netdev);
+
 	if (!(adapter->flags & IAVF_FLAG_FDIR_ENABLED))
 		return -EOPNOTSUPP;
 
@@ -1440,6 +1444,8 @@ iavf_set_adv_rss_hash_opt(struct iavf_adapter *adapter,
 	u64 hash_flds;
 	u32 hdrs;
 
+	netdev_assert_locked(adapter->netdev);
+
 	if (!ADV_RSS_SUPPORT(adapter))
 		return -EOPNOTSUPP;
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 4b6963ffaba5f..bf8c7baf2ab8a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1292,6 +1292,8 @@ static void iavf_configure(struct iavf_adapter *adapter)
  **/
 static void iavf_up_complete(struct iavf_adapter *adapter)
 {
+	netdev_assert_locked(adapter->netdev);
+
 	iavf_change_state(adapter, __IAVF_RUNNING);
 	clear_bit(__IAVF_VSI_DOWN, adapter->vsi.state);
 
@@ -1417,6 +1419,8 @@ void iavf_down(struct iavf_adapter *adapter)
 {
 	struct net_device *netdev = adapter->netdev;
 
+	netdev_assert_locked(netdev);
+
 	if (adapter->state <= __IAVF_DOWN_PENDING)
 		return;
 
@@ -3078,6 +3082,8 @@ static void iavf_disable_vf(struct iavf_adapter *adapter)
 	struct iavf_vlan_filter *fv, *fvtmp;
 	struct iavf_cloud_filter *cf, *cftmp;
 
+	netdev_assert_locked(adapter->netdev);
+
 	adapter->flags |= IAVF_FLAG_PF_COMMS_FAILED;
 
 	/* We don't use netif_running() because it may be true prior to
@@ -5194,6 +5200,8 @@ iavf_shaper_set(struct net_shaper_binding *binding,
 	struct iavf_ring *tx_ring;
 	int ret = 0;
 
+	netdev_assert_locked(adapter->netdev);
+
 	mutex_lock(&adapter->crit_lock);
 	if (handle->id >= adapter->num_active_queues)
 		goto unlock;
@@ -5222,6 +5230,8 @@ static int iavf_shaper_del(struct net_shaper_binding *binding,
 	struct iavf_adapter *adapter = netdev_priv(binding->netdev);
 	struct iavf_ring *tx_ring;
 
+	netdev_assert_locked(adapter->netdev);
+
 	mutex_lock(&adapter->crit_lock);
 	if (handle->id >= adapter->num_active_queues)
 		goto unlock;
-- 
2.39.5



