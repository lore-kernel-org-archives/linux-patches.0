Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016041C6AB;
	Mon,  4 Mar 2024 21:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589221; cv=none; b=Z+SfUlIvrqMISbZDF2WvAcSKSAG2JNnPcP/sBIG4EKl+p+nIi9/6k09nEzCEPwviUmvTmuflPz8iwX1TBSSoc6+LTpdD8+tiYUWcQ7p4ht2bRN0PW3h7kbAHBWssXHxbjXnhYFAv3cROezcupgDY7riBQNJ8O8TaLtegW5XpCwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589221; c=relaxed/simple;
	bh=ybaH3riilrI6k2vdcY7OtCoj6O5NDh/eJRNhtMCCKRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mw8leZS0tFHceiDcL2K3YhEkPiNvXuAVfbU1z+g8btGbelCHJZ5wJ4jeTrcBs5TlZYWwkO7qoZa+akLkEISY4YOEy9V6uWJoQBA5l1KVT3d2IT02p0Jl2rmd0NJJXif4nSf3AH/u+sbXi9RVB4sbkcf5m2svcoKMBdd0/9JJutw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T07Lz6/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T07Lz6/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8BBC43394;
	Mon,  4 Mar 2024 21:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589220;
	bh=ybaH3riilrI6k2vdcY7OtCoj6O5NDh/eJRNhtMCCKRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T07Lz6/zAexEQZsyj9GuyagJHuDLiblMq+p14n2bzPv8J4GqiHTlVrVXcpMkBR2kX
	 QDt/d3KXYk7ZuIwV4xPC3kIQ9B+4yQo7QRM1+QBwolo155X5veDZ9WrkOVAl+MD8jc
	 VJ0+1VfqckaJubo7HIQKUNKgyylr4yfeTk9Q/+7s=
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
Subject: [PATCH 5.15 26/84] igb: extend PTP timestamp adjustments to i211
Date: Mon,  4 Mar 2024 21:23:59 +0000
Message-ID: <20240304211543.207855594@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9cdb7a856ab6c..1a1575e8577af 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -826,7 +826,7 @@ static void igb_ptp_tx_hwtstamp(struct igb_adapter *adapter)
 
 	igb_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval);
 	/* adjust timestamp for the TX latency based on link speed */
-	if (adapter->hw.mac.type == e1000_i210) {
+	if (hw->mac.type == e1000_i210 || hw->mac.type == e1000_i211) {
 		switch (adapter->link_speed) {
 		case SPEED_10:
 			adjust = IGB_I210_TX_LATENCY_10;
@@ -872,6 +872,7 @@ int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
 			ktime_t *timestamp)
 {
 	struct igb_adapter *adapter = q_vector->adapter;
+	struct e1000_hw *hw = &adapter->hw;
 	struct skb_shared_hwtstamps ts;
 	__le64 *regval = (__le64 *)va;
 	int adjust = 0;
@@ -891,7 +892,7 @@ int igb_ptp_rx_pktstamp(struct igb_q_vector *q_vector, void *va,
 	igb_ptp_systim_to_hwtstamp(adapter, &ts, le64_to_cpu(regval[1]));
 
 	/* adjust timestamp for the RX latency based on link speed */
-	if (adapter->hw.mac.type == e1000_i210) {
+	if (hw->mac.type == e1000_i210 || hw->mac.type == e1000_i211) {
 		switch (adapter->link_speed) {
 		case SPEED_10:
 			adjust = IGB_I210_RX_LATENCY_10;
-- 
2.43.0



