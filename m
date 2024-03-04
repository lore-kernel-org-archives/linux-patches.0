Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5CE8F58;
	Mon,  4 Mar 2024 21:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588693; cv=none; b=JMjmVMAQUUy6DACbYnqKS0Z0Ni0dLrIZXHBOe8fAYGkT/lBk7xh48U4PD+SwmsR6/vqFi3i4bqcjqLMMW06X7SEaMXKhkAZpHD4g2Tov5Y709n6r2mBT3TG7YF+wDU+kFT7ChQMM20KSbhha7/7hQanWpVq+E6cQM2uORRzE01g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588693; c=relaxed/simple;
	bh=vFWHFC7JQVwAX2+WB5Tgvb0odCeDKemVzISMHkMdW5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYSDfzMpBk4NTRspqEwAkafDoEhsW5qpMdssgmqcyp2gdLsH/t6simiASYLrxpvgPQB4x7z66+YKvBdjnfRr046jxnP4gO420fmZ6S0BNYA0ZeR2IrGphV7oDD0L9Vyce7ne30L+hSk3U0cjJrfVPtZYmwRa05UsHq4lQvSj35Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aFucz2an; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aFucz2an"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59F7C433C7;
	Mon,  4 Mar 2024 21:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588693;
	bh=vFWHFC7JQVwAX2+WB5Tgvb0odCeDKemVzISMHkMdW5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aFucz2anqFFyIhS/eKyBIbILIVOV4xF3IJgc2rXELalIq5liK8vHc9sCXhKBuWJt5
	 fS60cc/xMW0Vs+ahQCMsbNYrpX/3/Xf4QyAgffaMNNhak4cOt8Ycrd0Bwxyy91bIAq
	 2dBmALkZGIHRR6BWws6WOxIxOM+oZGK07t6lkiI0=
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
Subject: [PATCH 6.1 060/215] igb: extend PTP timestamp adjustments to i211
Date: Mon,  4 Mar 2024 21:22:03 +0000
Message-ID: <20240304211558.883448099@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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
index 07171e574e7d7..36e62197fba0b 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -976,7 +976,7 @@ static void igb_ptp_tx_hwtstamp(struct igb_adapter *adapter)
 
 	igb_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval);
 	/* adjust timestamp for the TX latency based on link speed */
-	if (adapter->hw.mac.type == e1000_i210) {
+	if (hw->mac.type == e1000_i210 || hw->mac.type == e1000_i211) {
 		switch (adapter->link_speed) {
 		case SPEED_10:
 			adjust = IGB_I210_TX_LATENCY_10;
@@ -1022,6 +1022,7 @@ int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
 			ktime_t *timestamp)
 {
 	struct igb_adapter *adapter = q_vector->adapter;
+	struct e1000_hw *hw = &adapter->hw;
 	struct skb_shared_hwtstamps ts;
 	__le64 *regval = (__le64 *)va;
 	int adjust = 0;
@@ -1041,7 +1042,7 @@ int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
 	igb_ptp_systim_to_hwtstamp(adapter, &ts, le64_to_cpu(regval[1]));
 
 	/* adjust timestamp for the RX latency based on link speed */
-	if (adapter->hw.mac.type == e1000_i210) {
+	if (hw->mac.type == e1000_i210 || hw->mac.type == e1000_i211) {
 		switch (adapter->link_speed) {
 		case SPEED_10:
 			adjust = IGB_I210_RX_LATENCY_10;
-- 
2.43.0



