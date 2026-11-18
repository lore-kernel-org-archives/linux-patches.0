Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050657;
	b=VYsxftYHma/JAZIhK8YH7YYjzw4uNatLLNedjKm3i1G4AfBxu2gCN3berubdVFV3dySq
	 hwFE9lLc46+0dFl8P+S0wwA4OddbmSdkoja8oRBreYWs8wGLeva7Y3ES/2QvChL9gL7AZ
	 vhcGMfrBUCO7qGE4cmllJKU8w0ZZ9uDj/TIsilJutWC7lZdxjdyuAYSMIxC+IDYKhLohH
	 fmu+TXxj/FYIqmTZPVV3nkl1PqcQBt0VdbCIyCKkRZhGqbTi0BwzGNdn0ulHaOecIQL1Q
	 Wz/lx48D5xA7BBeaXoTh++XfxJtMHEGrwfiz91mCn41EcH+0C3WYKmKv5f3lx6aDx0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O5ssRsauMUFsLdYdJrpUedoDmTiWfrT7yNadQT466gM=;
	b=BCV8xiXXPs5S6GhKlwlH9rPUs+P+NOd+4NCOiyzsyvblkBe7C7eE1DE29PYlW5CE5Bb0
	 RCpQYq4QCUGhYo3cLbKHk37F+YSe1Ztrc0z9fFW1StTs9PrBRXCH8OelMUVVRc4cXEYdF
	 lYEUSRl8wqCLOq/gGJE0wkRabn02SNd26JQwqjt6GtsJL2rw//gLL188CD2oBce6xIZiP
	 Ey2pNsYZDN8XsbwryszUQJESU5k1KMqdbKb9UmmNwtzbUvU2nim5jGb2c28B91EC4Tdfh
	 WXgLIx3rA5UoWhqnsYqCp+ADolcnAPVnD7sDRqehfZjmh+YyHCjmVsMjpzgY4wTAQQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wG6KnUTb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAD2606A325;
	Thu, 19 Nov 2026 01:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wG6KnUTb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE281F000C4;
	Thu, 19 Nov 2026 01:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050657;
	bh=O5ssRsauMUFsLdYdJrpUedoDmTiWfrT7yNadQT466gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wG6KnUTb20PuAJjtJmMjBVXbpS7RHzm+P6BaxlfCim6ujCweww948wBE6znQa6daI
	 gV9CVAQ5LAj8IDI5FpxSMBxaYQuS1rkpR0tr0Q7mGEU0hLGa/LGweyDIeZl73/qM9A
	 HIRjs14Uwsdwqn7Vos4KQAX35mCg5Lg1whVxp5Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Temerkhanov <sergey.temerkhanov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH 6.1 2785/2857] ice: Use more generic names for ice_ptp_tx fields
Date: Wed, 18 Nov 2026 16:03:39 +0100
Message-ID: <20261118150341.882025375@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Temerkhanov <sergey.temerkhanov@intel.com>

[ Upstream commit 6b5cbc8c4ec71e49dc8d2c393b105e8007a02b41 ]

Some supported devices have per-port timestamp memory blocks while
others have shared ones within quads. Rename the struct ice_ptp_tx
fields to reflect the block entities it works with

Signed-off-by: Sergey Temerkhanov <sergey.temerkhanov@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 50870d621160 ("ice: set in_use only after preparing Tx timestamp index")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 26 ++++++++++++------------
 drivers/net/ethernet/intel/ice/ice_ptp.h | 11 +++++-----
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index f2f1078166fc3..1b1d1e11a074c 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -651,14 +651,14 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 
 	for_each_set_bit(idx, tx->in_use, tx->len) {
 		struct skb_shared_hwtstamps shhwtstamps = {};
-		u8 phy_idx = idx + tx->quad_offset;
+		u8 phy_idx = idx + tx->offset;
 		u64 raw_tstamp, tstamp;
 		struct sk_buff *skb;
 		int err;
 
 		ice_trace(tx_tstamp_fw_req, tx->tstamps[idx].skb, idx);
 
-		err = ice_read_phy_tstamp(&pf->hw, tx->quad, phy_idx,
+		err = ice_read_phy_tstamp(&pf->hw, tx->block, phy_idx,
 					  &raw_tstamp);
 		if (err)
 			continue;
@@ -712,7 +712,7 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
  * @tx: Tx tracking structure to initialize
  *
  * Assumes that the length has already been initialized. Do not call directly,
- * use the ice_ptp_init_tx_e822 or ice_ptp_init_tx_e810 instead.
+ * use the ice_ptp_init_tx_* instead.
  */
 static int
 ice_ptp_alloc_tx_tracker(struct ice_ptp_tx *tx)
@@ -746,7 +746,7 @@ ice_ptp_flush_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 	u8 idx;
 
 	for (idx = 0; idx < tx->len; idx++) {
-		u8 phy_idx = idx + tx->quad_offset;
+		u8 phy_idx = idx + tx->offset;
 
 		spin_lock(&tx->lock);
 		if (tx->tstamps[idx].skb) {
@@ -759,7 +759,7 @@ ice_ptp_flush_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 
 		/* Clear any potential residual timestamp in the PHY block */
 		if (!pf->hw.reset_ongoing)
-			ice_clear_phy_tstamp(&pf->hw, tx->quad, phy_idx);
+			ice_clear_phy_tstamp(&pf->hw, tx->block, phy_idx);
 	}
 }
 
@@ -803,9 +803,9 @@ ice_ptp_release_tx_tracker(struct ice_pf *pf, struct ice_ptp_tx *tx)
 static int
 ice_ptp_init_tx_e822(struct ice_pf *pf, struct ice_ptp_tx *tx, u8 port)
 {
-	tx->quad = port / ICE_PORTS_PER_QUAD;
-	tx->quad_offset = (port % ICE_PORTS_PER_QUAD) * INDEX_PER_PORT;
-	tx->len = INDEX_PER_PORT;
+	tx->block = port / ICE_PORTS_PER_QUAD;
+	tx->offset = (port % ICE_PORTS_PER_QUAD) * INDEX_PER_PORT_E822;
+	tx->len = INDEX_PER_PORT_E822;
 
 	return ice_ptp_alloc_tx_tracker(tx);
 }
@@ -821,9 +821,9 @@ ice_ptp_init_tx_e822(struct ice_pf *pf, struct ice_ptp_tx *tx, u8 port)
 static int
 ice_ptp_init_tx_e810(struct ice_pf *pf, struct ice_ptp_tx *tx)
 {
-	tx->quad = pf->hw.port_info->lport;
-	tx->quad_offset = 0;
-	tx->len = INDEX_PER_QUAD;
+	tx->block = pf->hw.port_info->lport;
+	tx->offset = 0;
+	tx->len = INDEX_PER_PORT_E810;
 
 	return ice_ptp_alloc_tx_tracker(tx);
 }
@@ -856,7 +856,7 @@ static void ice_ptp_tx_tstamp_cleanup(struct ice_pf *pf, struct ice_ptp_tx *tx)
 			continue;
 
 		/* Read tstamp to be able to use this register again */
-		ice_read_phy_tstamp(hw, tx->quad, idx + tx->quad_offset,
+		ice_read_phy_tstamp(hw, tx->block, idx + tx->offset,
 				    &raw_tstamp);
 
 		spin_lock(&tx->lock);
@@ -2403,7 +2403,7 @@ s8 ice_ptp_request_ts(struct ice_ptp_tx *tx, struct sk_buff *skb)
 	if (idx >= tx->len)
 		return -1;
 	else
-		return idx + tx->quad_offset;
+		return idx + tx->offset;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 146df66bef6d8..2d038c008a3a6 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -114,8 +114,8 @@ struct ice_tx_tstamp {
  * @lock: lock to prevent concurrent write to in_use bitmap
  * @tstamps: array of len to store outstanding requests
  * @in_use: bitmap of len to indicate which slots are in use
- * @quad: which quad the timestamps are captured in
- * @quad_offset: offset into timestamp block of the quad to get the real index
+ * @block: which memory block (quad or port) the timestamps are captured in
+ * @offset: offset into timestamp block to get the real index
  * @len: length of the tstamps and in_use fields.
  * @init: if true, the tracker is initialized;
  * @calibrating: if true, the PHY is calibrating the Tx offset. During this
@@ -125,8 +125,8 @@ struct ice_ptp_tx {
 	spinlock_t lock; /* lock protecting in_use bitmap */
 	struct ice_tx_tstamp *tstamps;
 	unsigned long *in_use;
-	u8 quad;
-	u8 quad_offset;
+	u8 block;
+	u8 offset;
 	u8 len;
 	u8 init;
 	u8 calibrating;
@@ -134,7 +134,8 @@ struct ice_ptp_tx {
 
 /* Quad and port information for initializing timestamp blocks */
 #define INDEX_PER_QUAD			64
-#define INDEX_PER_PORT			(INDEX_PER_QUAD / ICE_PORTS_PER_QUAD)
+#define INDEX_PER_PORT_E822		16
+#define INDEX_PER_PORT_E810		64
 
 /**
  * struct ice_ptp_port - data used to initialize an external port for PTP
-- 
2.53.0



