Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EEA10A35;
	Mon,  4 Mar 2024 21:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588250; cv=none; b=TagDKlESENY/YYrMxjw6MKxjgzCRz1PBisDgw8KUtUqoXqI0YmPZVNFLEZsd0h8sOZGcnKJKvbygFNm/O7Rey8sbLoJWmy42mgIX2eTq0eYHAUfeKwAxhJ6nXwW7FNqstTmSUNngy4cjBo0M2czmBG62//e75RB2FRso5HkAzbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588250; c=relaxed/simple;
	bh=KUHpH/HqiukTRPXfm+de3jarokwpqEHspiFEI9Kbhqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eS97APoywOsuZ4DC9G0z3RlwK7YC/2NO+qhpDsfHx1B1db1RJYdcTn7bq7Dn7/96p28fuwME7ZzFnCF+yjIxnPiVEhGnIQ6xSaSjoxnec9I7ayNcsNdTABLMEXavUsJ5j7MRnhW3/GhZ3Wg1k6xgptK8AB25FL+qgpGawaJITBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vjVGUOWI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vjVGUOWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCE7C433F1;
	Mon,  4 Mar 2024 21:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588250;
	bh=KUHpH/HqiukTRPXfm+de3jarokwpqEHspiFEI9Kbhqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vjVGUOWIHZajeiAO6e+KdxYGO577/0Hd9hjGUxSgiokXv1hkgbJlLXvccNDlUKnT/
	 WVgHzfx/ooaf4ceKxpDecNR3SSbxGxAO4MWdnFpOnd8XFm3jNqJm4CoNs7RUZFAZ6o
	 U44YG+1oaYTGvu8HDKC1HTWkG0NHPxoxYH445ct0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.6 036/143] igb: extend PTP timestamp adjustments to i211
Date: Mon,  4 Mar 2024 21:22:36 +0000
Message-ID: <20240304211551.091703959@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 0bb7b09392eb74b152719ae87b1ba5e4bf910ef0 ]

The i211 requires the same PTP timestamp adjustments as the i210,
according to its datasheet. To ensure consistent timestamping across
different platforms, this change extends the existing adjustments to
include the i211.

The adjustment result are tested and comparable for i210 and i211 based
systems.

Fixes: 3f544d2a4d5c ("igb: adjust PTP timestamps for Tx/Rx latency")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://lore.kernel.org/r/20240227184942.362710-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_ptp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 319c544b9f04c..f945705561200 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -957,7 +957,7 @@ static void igb_ptp_tx_hwtstamp(struct igb_adapter *adapter)
 
 	igb_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval);
 	/* adjust timestamp for the TX latency based on link speed */
-	if (adapter->hw.mac.type == e1000_i210) {
+	if (hw->mac.type == e1000_i210 || hw->mac.type == e1000_i211) {
 		switch (adapter->link_speed) {
 		case SPEED_10:
 			adjust = IGB_I210_TX_LATENCY_10;
@@ -1003,6 +1003,7 @@ int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
 			ktime_t *timestamp)
 {
 	struct igb_adapter *adapter = q_vector->adapter;
+	struct e1000_hw *hw = &adapter->hw;
 	struct skb_shared_hwtstamps ts;
 	__le64 *regval = (__le64 *)va;
 	int adjust = 0;
@@ -1022,7 +1023,7 @@ int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
 	igb_ptp_systim_to_hwtstamp(adapter, &ts, le64_to_cpu(regval[1]));
 
 	/* adjust timestamp for the RX latency based on link speed */
-	if (adapter->hw.mac.type == e1000_i210) {
+	if (hw->mac.type == e1000_i210 || hw->mac.type == e1000_i211) {
 		switch (adapter->link_speed) {
 		case SPEED_10:
 			adjust = IGB_I210_RX_LATENCY_10;
-- 
2.43.0



