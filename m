Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028291;
	b=18KoaQ30xl6t0BXADw1bVdgynI7h5usE2pgpXqLuhGlG/03JSRvU7HKXnLFzFMJTTeAm
	 0qonCRi446XkCWyF8MLEtcIrALypBQ2BxmEziBNAcHvMz9jm9aD27BLW90jYQpEPEUb4V
	 GbWQ/vlUobTjcTNHx5XqA2IEjERcDIjC1uaw69s/fw62qNUMJd3TdCPsM2mE4dLSTqT93
	 88bPmq4bNxX0A9v09MLiNNL8n8Q0oLe6DImWKn8zpfE6mcKSKhF0GSKOyN3tjmK/aKucQ
	 4FXJ8qV8vJx4qZQfhgYn4HHaZbOrg/MbBssV1ssMCB/8E0KMG/npw+YizkJKUfeqWKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RpZWSolEzGQOZC9atz3+oMeoRetucv3eyK5mEQTVzE8=;
	b=1nZr1sVk+QfOOyuivN7mfKeela+DFA1rvGXVi9jPa1VORHPhbRoP5KeDJgyxoXk6i0RE
	 VIeSljguySsdS+CS54xb3XwaxeAWEXvDUzYQ9kD6s9mYC52SKeRKHyPXmDt1uwkDDuy1q
	 rcvj9UZJupubcv1UYZfDS55Dc96Y36lNgc4Cx821Awi2Xt6yIuZMa1bZGC7mAhZwR8nmX
	 T8T7g8+UxJ/tkEfmJBR+AKEQLpiUG1QvjktJog+GQ1EWKjJ7OblOwcXQgHPAc0h/hWEBt
	 gd8TG56B/j6fi0xKEbOV5dn2KMzHLMzWXUbHGLJlVKaQ/6WBcjncU4ADvX/EDEvfoWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V09tEvzG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE75C606A31C;
	Wed, 18 Nov 2026 18:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V09tEvzG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229F61F000C4;
	Wed, 18 Nov 2026 18:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028291;
	bh=RpZWSolEzGQOZC9atz3+oMeoRetucv3eyK5mEQTVzE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V09tEvzGqKw1Kx9hgBvj9ZoYI0b769ay8tGtEi1fK2AkPRKBD+BXZRm0x/9TwoYZ2
	 pAyop/7l+GyHte9aItW1EcRM+Lg/tSBKJPoeVGbaxJRMZ7h9dHqGvKSRy2LE8VXBNv
	 h80fHiVJilo0Av315G2rWHKUeUi0Mba1LawhJl8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Kolacinski <karol.kolacinski@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Przemyslaw Korba <przemyslaw.korba@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2051/2151] ice: E822: keep Tx timestamps disabled during offset calibration
Date: Wed, 18 Nov 2026 16:03:06 +0100
Message-ID: <20261118150236.434340088@linuxfoundation.org>
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

From: Karol Kolacinski <karol.kolacinski@intel.com>

[ Upstream commit 56af436b90acce7eaa7531189c827773983f7d07 ]

Do not clear the tx.calibrating flag immediately after starting the PHY
timer in ice_ptp_port_phy_restart(). Instead, keep Tx timestamps
disabled until the offset verification work (ice_ptp_wait_for_offsets)
has confirmed that the Tx PHY offset is properly configured.

Previously, tx.calibrating was set to true, then immediately back to
false right after ice_start_phy_timer_e82x() returned. This allowed Tx
timestamp requests to be served during the window where offset
verification was still pending. Timestamps produced during this window
should have their valid bit cleared, but it is better to prevent requests
until the driver has confirmed calibration is complete.

Rename the tx.calibrating field to tx.disabled, and change where it is
cleared. Only clear it in ice_ptp_wait_for_offsets(), and only after Tx
offset configuration has completed successfully. This ensures that new Tx
timestamp requests are only accepted after the PHY has properly calibrated
the Tx offset.

If ice_start_phy_timer_e82x() fails, do not restore disabled to false.
The device is in a state where timestamps cannot succeed properly anyways.
A dev_err message is already logged on failure to start the timer at the
end of the function.

Renaming the field improves clarity and will better reflect the nature of
the flag in a future change that also applies disabling Tx timestamps in
software in a following commit.

Log a debug message while offset calibration is still pending, including
the specific Tx/Rx error codes to aid debugging stalled calibration.
This path is expected on every routine link-up: ov_work is first queued
with no delay and the vernier offset cannot be computed until at least
one packet has been transmitted, so the first several invocations
normally land here. Use dev_dbg() rather than a rate-limited warning to
avoid emitting KERN_WARNING on every link-up during normal operation.
Log a debug message when calibration completes successfully.

Note that sashiko review has previously complained that leaving the
disabled flag set "permanently" disables Tx timestamps if vernier
calibration never completes. This is true, but its important to realize
that timestamps would still fail regardless of whether the flag is set.
Until vernier calibration completes the device will not report valid
timestamps regardless. Thus, keeping the calibrating flag set simply
prevents new timestamp requests from software while it is known that the
hardware will not complete them.

Fixes: 3a7496234d17 ("ice: implement basic E822 PTP support")
Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Przemyslaw Korba <przemyslaw.korba@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20261027-reduction-v1-3-81237c67a361@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 37 +++++++++++++++++-------
 drivers/net/ethernet/intel/ice/ice_ptp.h |  6 ++--
 2 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index bd45cb07bef7f..d33cd5f5f21c3 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -368,7 +368,7 @@ ice_ptp_is_tx_tracker_up(struct ice_ptp_tx *tx)
 {
 	lockdep_assert_held(&tx->lock);
 
-	return tx->init && !tx->calibrating;
+	return tx->init && !tx->disabled;
 }
 
 /**
@@ -1134,6 +1134,7 @@ static int ice_ptp_check_tx_fifo(struct ice_ptp_port *port)
 static void ice_ptp_wait_for_offsets(struct kthread_work *work)
 {
 	struct ice_ptp_port *port;
+	unsigned long flags;
 	struct ice_pf *pf;
 	struct ice_hw *hw;
 	int tx_err;
@@ -1154,9 +1155,26 @@ static void ice_ptp_wait_for_offsets(struct kthread_work *work)
 	tx_err = ice_ptp_check_tx_fifo(port);
 	if (!tx_err)
 		tx_err = ice_phy_cfg_tx_offset_e82x(hw, port->port_num);
+	if (!tx_err) {
+		/* Tx offset has been configured, re-enable Tx timestamps */
+		spin_lock_irqsave(&port->tx.lock, flags);
+		if (port->tx.disabled) {
+			port->tx.disabled = false;
+			dev_dbg(ice_pf_to_dev(pf), "PTP Tx offset valid for port %u, Tx timestamps enabled\n",
+				port->port_num);
+		}
+		spin_unlock_irqrestore(&port->tx.lock, flags);
+	}
+
 	rx_err = ice_phy_cfg_rx_offset_e82x(hw, port->port_num);
 	if (tx_err || rx_err) {
-		/* Tx and/or Rx offset not yet configured, try again later */
+		/* Tx and/or Rx offset not yet configured, try again later.
+		 * This is expected during normal link-up: the vernier offset
+		 * calibration cannot complete until at least one packet has
+		 * been transmitted, so the first retries routinely land here.
+		 */
+		dev_dbg(ice_pf_to_dev(pf), "PTP offset not yet valid for port %u (tx_err=%d rx_err=%d)\n",
+			port->port_num, tx_err, rx_err);
 		kthread_queue_delayed_work(pf->ptp.kworker,
 					   &port->ov_work,
 					   msecs_to_jiffies(100));
@@ -1234,11 +1252,9 @@ ice_ptp_port_phy_restart(struct ice_ptp_port *ptp_port)
 		/* Start the PHY timer in Vernier mode */
 		kthread_cancel_delayed_work_sync(&ptp_port->ov_work);
 
-		/* temporarily disable Tx timestamps while calibrating
-		 * PHY offset
-		 */
+		/* Disable Tx timestamps until PHY calibration completes */
 		spin_lock_irqsave(&ptp_port->tx.lock, flags);
-		ptp_port->tx.calibrating = true;
+		ptp_port->tx.disabled = true;
 		spin_unlock_irqrestore(&ptp_port->tx.lock, flags);
 		ptp_port->tx_fifo_busy_cnt = 0;
 
@@ -1247,11 +1263,10 @@ ice_ptp_port_phy_restart(struct ice_ptp_port *ptp_port)
 		if (err)
 			break;
 
-		/* Enable Tx timestamps right away */
-		spin_lock_irqsave(&ptp_port->tx.lock, flags);
-		ptp_port->tx.calibrating = false;
-		spin_unlock_irqrestore(&ptp_port->tx.lock, flags);
-
+		/* Do not clear disabled flag here. Tx timestamp requests
+		 * remain disabled until ice_ptp_wait_for_offsets() has
+		 * verified that the Tx offset calibration has completed.
+		 */
 		kthread_queue_delayed_work(pf->ptp.kworker, &ptp_port->ov_work,
 					   0);
 		break;
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.h b/drivers/net/ethernet/intel/ice/ice_ptp.h
index 4e02f922c1ff8..0a5a1db66d614 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.h
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.h
@@ -104,8 +104,8 @@ enum ice_tx_tstamp_work {
  * @offset: offset into timestamp block to get the real index
  * @len: length of the tstamps and in_use fields.
  * @init: if true, the tracker is initialized;
- * @calibrating: if true, the PHY is calibrating the Tx offset. During this
- *               window, timestamps are temporarily disabled.
+ * @disabled: set to true when new Tx timestamp requests are disabled, such as
+ *            while the PHY Tx offset configuration has not yet completed.
  * @has_ready_bitmap: if true, the hardware has a valid Tx timestamp ready
  *                    bitmap register. If false, fall back to verifying new
  *                    timestamp values against previously cached copy.
@@ -120,7 +120,7 @@ struct ice_ptp_tx {
 	u8 offset;
 	u8 len;
 	u8 init : 1;
-	u8 calibrating : 1;
+	u8 disabled : 1;
 	u8 has_ready_bitmap : 1;
 	s8 last_ll_ts_idx_read;
 };
-- 
2.53.0



