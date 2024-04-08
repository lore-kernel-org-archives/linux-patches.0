Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FA7481A6;
	Mon,  8 Apr 2024 13:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581393; cv=none; b=jFO9uSvNYn+pNqVko4v7EpA88QP6jN/dKe7DtsPWwkcNUpAcZ9iLJBWPTfMyfNU+3G8VZI6xIkrjz9JVz/56Ee3EA+tfMhInv9QgXS7Aes+AOxWzjRTx87VbRKWyB5R3nIetweRF9A3mKEacMqfBSTMjOVID23Shmp6VP7XqaNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581393; c=relaxed/simple;
	bh=cTZQTlwF5dBfqGYDNXZWpTMr6+sdinOSMeDlUFWLJHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rece24DW60z/wmxTlYD6nt4t9RnNGufrcAzbHRUDiQ5uSaTL2/beCtb7BdFD4MOlK0q+zYxdcM+ESZe2BOld8y/+V21TxMtMjWn7lk7nQLgL/1tqn3ODvNX8vyEUXuLi6jHoqG9borucM/ZJjc6+syh1c0FvS9KpWm1C/howSDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ffh75CyN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ffh75CyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2914CC433C7;
	Mon,  8 Apr 2024 13:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581393;
	bh=cTZQTlwF5dBfqGYDNXZWpTMr6+sdinOSMeDlUFWLJHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ffh75CyNkTqnPrdm5tjdgMTMibe/uVYis2tw2dcN26YNFLnSGortxVdfhwuaVvA0c
	 ZucJydTQzgNhg/jgiWhkFMOoi7uLJTMhid4yliftfWLMXLSbl75HJlh3997RNbow7p
	 pzy3Lv3X/Dbyij/ppB8VhxfQhlgsY0qmtwcRZrFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/138] net: hns3: mark unexcuted loopback test result as UNEXECUTED
Date: Mon,  8 Apr 2024 14:57:07 +0200
Message-ID: <20240408125256.643421540@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 5bd088d6c21a45ee70e6116879310e54174d75eb ]

Currently, loopback test may be skipped when resetting, but the test
result will still show as 'PASS', because the driver doesn't set
ETH_TEST_FL_FAILED flag. Fix it by setting the flag and
initializating the value to UNEXECUTED.

Fixes: 4c8dab1c709c ("net: hns3: reconstruct function hns3_self_test")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index e22835ae8a941..9fce976a08f01 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -78,6 +78,9 @@ static const struct hns3_stats hns3_rxq_stats[] = {
 #define HNS3_NIC_LB_TEST_NO_MEM_ERR	1
 #define HNS3_NIC_LB_TEST_TX_CNT_ERR	2
 #define HNS3_NIC_LB_TEST_RX_CNT_ERR	3
+#define HNS3_NIC_LB_TEST_UNEXECUTED	4
+
+static int hns3_get_sset_count(struct net_device *netdev, int stringset);
 
 static int hns3_lp_setup(struct net_device *ndev, enum hnae3_loop loop, bool en)
 {
@@ -419,18 +422,26 @@ static void hns3_do_external_lb(struct net_device *ndev,
 static void hns3_self_test(struct net_device *ndev,
 			   struct ethtool_test *eth_test, u64 *data)
 {
+	int cnt = hns3_get_sset_count(ndev, ETH_SS_TEST);
 	struct hns3_nic_priv *priv = netdev_priv(ndev);
 	struct hnae3_handle *h = priv->ae_handle;
 	int st_param[HNAE3_LOOP_NONE][2];
 	bool if_running = netif_running(ndev);
+	int i;
+
+	/* initialize the loopback test result, avoid marking an unexcuted
+	 * loopback test as PASS.
+	 */
+	for (i = 0; i < cnt; i++)
+		data[i] = HNS3_NIC_LB_TEST_UNEXECUTED;
 
 	if (hns3_nic_resetting(ndev)) {
 		netdev_err(ndev, "dev resetting!");
-		return;
+		goto failure;
 	}
 
 	if (!(eth_test->flags & ETH_TEST_FL_OFFLINE))
-		return;
+		goto failure;
 
 	if (netif_msg_ifdown(h))
 		netdev_info(ndev, "self test start\n");
@@ -452,6 +463,10 @@ static void hns3_self_test(struct net_device *ndev,
 
 	if (netif_msg_ifdown(h))
 		netdev_info(ndev, "self test end\n");
+	return;
+
+failure:
+	eth_test->flags |= ETH_TEST_FL_FAILED;
 }
 
 static void hns3_update_limit_promisc_mode(struct net_device *netdev,
-- 
2.43.0



