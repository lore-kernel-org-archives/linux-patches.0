Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC38B1F4C8E;
	Tue, 30 Sep 2025 15:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245378; cv=none; b=NDQbYu31M1w6051N1UnScGowfpwk8Z5xLF16mdiGaqhh1+B5tp8sX+oArT93tC/LnCf7agKo2bQNqZiDKXwueGhn5un+aQuuofjhlVbRlUvNakZO+la3fQ0UIXO7/3LgfXr/oGbhcT2In+ry01KLiXBNki/7KR6FqENlpWsratI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245378; c=relaxed/simple;
	bh=9bbeo31F/v9Vc6I6J6QOiFxN6UvnESYiQJsfPm32j+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rh8SN31oBoFfPNq8uCtdQ2XPbPuXR0+DFJ/s16N75YDaFFlWrA3Oe9CSNMPLa/9TostGELJhhwnMbVqsZTD/Q7w3KwGRpwntrPWkIykM+oIANBN+0Q2Ex6k9RtJIlMmz06QRiQVFRXaCSUtCFQOLoN1eXfHeW0o4M35bDk+AoqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNx0eiN3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNx0eiN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296C6C4CEF0;
	Tue, 30 Sep 2025 15:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245378;
	bh=9bbeo31F/v9Vc6I6J6QOiFxN6UvnESYiQJsfPm32j+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sNx0eiN39J6AmQ54gKXK9oGFcQXwpxe5jODcx+G3+XusjmLGIVhEAFW9xJqu4KXmC
	 dVsggvPrCuzFnUDqjXbEdzN8g2zgfhRHkxheCM1fQfOJ3nD+Zixrtv8aC6ZhZTUDw4
	 1vdB12XJjkB5dJE5XsyZbwDhP4uMevxc8eawRGps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Bronder <jsbronder@cold-front.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 5.15 150/151] i40e: increase max descriptors for XL710
Date: Tue, 30 Sep 2025 16:48:00 +0200
Message-ID: <20250930143833.580627102@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Bronder <jsbronder@cold-front.org>

[ Upstream commit aa6908ca3bd1e713fd6cd8d7193a008f060bf7d9 ]

In Tables 8-12 and 8-22 in the X710/XXV710/XL710 datasheet, the QLEN
description states that the maximum size of the descriptor queue is 8k
minus 32, or 8160.

Signed-off-by: Justin Bronder <jsbronder@cold-front.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20231113231047.548659-2-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 55d225670def ("i40e: add validation for ring_len param")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e.h         |    1 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c |   25 +++++++++++++++++++------
 2 files changed, 20 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -50,6 +50,7 @@
 #define I40E_MAX_VEB			16
 
 #define I40E_MAX_NUM_DESCRIPTORS	4096
+#define I40E_MAX_NUM_DESCRIPTORS_XL710	8160
 #define I40E_MAX_CSR_SPACE		(4 * 1024 * 1024 - 64 * 1024)
 #define I40E_DEFAULT_NUM_DESCRIPTORS	512
 #define I40E_REQ_DESCRIPTOR_MULTIPLE	32
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -1918,6 +1918,18 @@ static void i40e_get_drvinfo(struct net_
 		drvinfo->n_priv_flags += I40E_GL_PRIV_FLAGS_STR_LEN;
 }
 
+static u32 i40e_get_max_num_descriptors(struct i40e_pf *pf)
+{
+	struct i40e_hw *hw = &pf->hw;
+
+	switch (hw->mac.type) {
+	case I40E_MAC_XL710:
+		return I40E_MAX_NUM_DESCRIPTORS_XL710;
+	default:
+		return I40E_MAX_NUM_DESCRIPTORS;
+	}
+}
+
 static void i40e_get_ringparam(struct net_device *netdev,
 			       struct ethtool_ringparam *ring)
 {
@@ -1925,8 +1937,8 @@ static void i40e_get_ringparam(struct ne
 	struct i40e_pf *pf = np->vsi->back;
 	struct i40e_vsi *vsi = pf->vsi[pf->lan_vsi];
 
-	ring->rx_max_pending = I40E_MAX_NUM_DESCRIPTORS;
-	ring->tx_max_pending = I40E_MAX_NUM_DESCRIPTORS;
+	ring->rx_max_pending = i40e_get_max_num_descriptors(pf);
+	ring->tx_max_pending = i40e_get_max_num_descriptors(pf);
 	ring->rx_mini_max_pending = 0;
 	ring->rx_jumbo_max_pending = 0;
 	ring->rx_pending = vsi->rx_rings[0]->count;
@@ -1949,12 +1961,12 @@ static bool i40e_active_tx_ring_index(st
 static int i40e_set_ringparam(struct net_device *netdev,
 			      struct ethtool_ringparam *ring)
 {
+	u32 new_rx_count, new_tx_count, max_num_descriptors;
 	struct i40e_ring *tx_rings = NULL, *rx_rings = NULL;
 	struct i40e_netdev_priv *np = netdev_priv(netdev);
 	struct i40e_hw *hw = &np->vsi->back->hw;
 	struct i40e_vsi *vsi = np->vsi;
 	struct i40e_pf *pf = vsi->back;
-	u32 new_rx_count, new_tx_count;
 	u16 tx_alloc_queue_pairs;
 	int timeout = 50;
 	int i, err = 0;
@@ -1962,14 +1974,15 @@ static int i40e_set_ringparam(struct net
 	if ((ring->rx_mini_pending) || (ring->rx_jumbo_pending))
 		return -EINVAL;
 
-	if (ring->tx_pending > I40E_MAX_NUM_DESCRIPTORS ||
+	max_num_descriptors = i40e_get_max_num_descriptors(pf);
+	if (ring->tx_pending > max_num_descriptors ||
 	    ring->tx_pending < I40E_MIN_NUM_DESCRIPTORS ||
-	    ring->rx_pending > I40E_MAX_NUM_DESCRIPTORS ||
+	    ring->rx_pending > max_num_descriptors ||
 	    ring->rx_pending < I40E_MIN_NUM_DESCRIPTORS) {
 		netdev_info(netdev,
 			    "Descriptors requested (Tx: %d / Rx: %d) out of range [%d-%d]\n",
 			    ring->tx_pending, ring->rx_pending,
-			    I40E_MIN_NUM_DESCRIPTORS, I40E_MAX_NUM_DESCRIPTORS);
+			    I40E_MIN_NUM_DESCRIPTORS, max_num_descriptors);
 		return -EINVAL;
 	}
 


