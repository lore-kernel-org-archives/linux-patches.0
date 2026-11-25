Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618110;
	b=vAP7TsiFEFYUaAmtSLidr1pEM3QtPwmb4C/L8Y87qnAzfmZJ5URGoIrLSf8ZJtL2bgzL
	 klIIGv7aU8q0KLIvtRqoUcAtVsTW8bkY1UDaEPNLbGg/ERLCcrWmhIPvoSEji53cUQzan
	 mdgFU9TSxS0jSN51yEm1IP8UE4Wvhf3YyR94HicDlCDYqojNdEZU6Q1PBVo7qgR/L16Rt
	 OROm6IF4cylJRaRASwK2CoaQL1aS1SxjIonMuC2xInFBF/N3/4I7kXdpp8nxDsz5775nx
	 bS9QmDvzZdJSRd7eeOINlSSzaAxZ5WrZws0AjJAGHfbtRLDtsevTmZlbTr7C0LzFzGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=85IHohoYj0PeFh+EdoRGXeNlrUzExoB1geccQjVVyBU=;
	b=IgjggirbdeTg7JAFnoTVdLFeVxLU2Dkn6dY32arg1AIrwW+fIH0hpnnPe2c9FjQnCXZx
	 3to82iZogMX3mEPzUY3w9swqqPjIOS+ngXLmFfZLatIaZcyeAVBVRCe70pXIx14bIq+b2
	 6Qpv5xhDyl+evK4OaTiUDtE5sK83T9Xwl+AA6aEibXraOLW9oUYfirqrVFSH9rIf4YJ6b
	 nKRgCPp23ScCicBgJvN3wdO8LhzHfYi3eUxkjTiQk2B1S+aCRLP12NlQyrVns0I1h/Shj
	 Zkg/X297y9j4pyDGCKcZh3sCzzX7k7Ms2dhwZ703Vve9RRcuGX8J0mDD9XFyjUalfDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tev/un7T";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EBF606A31E;
	Wed, 25 Nov 2026 14:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tev/un7T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622DB1F000CA;
	Wed, 25 Nov 2026 14:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618109;
	bh=85IHohoYj0PeFh+EdoRGXeNlrUzExoB1geccQjVVyBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tev/un7TMD7NVgihaBb/KtQ/njTPoQvjtU4nR+MJvaEIdY8rRq6CKn6TOGPta2t6K
	 iLE/uFexgxqdRioG1AqCWXwQrSi7GG0fT7hsTLRCOt3ayfvkzOmy9mXXiI3ggH09ef
	 RuBkum5ykYWBKpsot0DJNvSvp7jldaENPA28lzrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0176/1005] net: stmmac: re-apply taprio offload in __stmmac_open() and stmmac_resume()
Date: Wed, 25 Nov 2026 15:25:14 +0100
Message-ID: <20261125143825.864758039@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 23d96de472f735858a7dd227c77aebff21ea09f5 ]

The core soft reset issued by stmmac_init_dma_engine(), called from
stmmac_hw_setup(), clears the MTL_EST registers. Nothing re-applies the
taprio offload afterwards, so priv->est->enable stays true while the
hardware EST block is left disabled: taprio keeps being reported as
offloaded, the TX/XDP paths keep dropping frames larger than
priv->est->max_sdu[], and the programmed base time is stale.

Re-apply the offload from __stmmac_open() and stmmac_resume() after PTP
has been brought up. The base time is recomputed from the reserved base
time and the current PTP time, because the timestamp counter has been
re-initialised and the previously programmed base time cannot be reused.

Factor the recompute-and-program sequence into __stmmac_setup_est(),
which must be called with est_lock held, and into stmmac_setup_est(),
which takes the lock and re-applies the offload only when it is
currently enabled and PTP has been brought up. Use the same helper in
stmmac_adjust_time() so the PTP adjust path shares the base time
computation.

Only tc_taprio_configure() updates priv->est->enable: it is set when a
REPLACE succeeds and cleared on DESTROY or a programming failure. The
re-apply helpers leave it untouched, so the flag records that an offload
is installed rather than the current hardware programming state.
__stmmac_setup_est() only reprograms the EST block, and
stmmac_setup_est() replays the FPE mapping afterwards. On a failed
re-apply the open and resume callers abort, while stmmac_adjust_time()
keeps the offload configured.

The same reset also discards the FPE preemption programming, and on XGMAC
stmmac_dma_tx_mode() overwrites the queue-to-traffic-class map. Save the
preemptible traffic class mask in priv->est->pclass when a REPLACE
succeeds and replay the FPE mapping from stmmac_setup_est() as well.

Re-applying the offload is best-effort with respect to PTP:
stmmac_setup_est() does nothing when PTP was not enabled (for example
when clk_ptp_rate is 0), so a missing PTP reference clock does not by
itself fail ndo_open(). If re-applying the EST or FPE programming fails
while restoring the interface, the failure is fatal to the caller:
__stmmac_open() aborts the open, and stmmac_resume() takes the same error
path already used for a failed timestamp counter restore.

Since __stmmac_open() and stmmac_resume() now trust priv->est->enable,
also make tc_taprio_configure() consistent: hold est_lock across the
whole validate-and-program sequence, build the gate list in a temporary
buffer, and only commit it and enable EST after validation and hardware
programming succeed. A REPLACE rejected during validation then leaves the
currently installed schedule intact in both software and hardware, while
a hardware or FPE mapping failure disables EST instead of leaving a stale
enable flag behind. Reject cycle times whose seconds field would not fit
in priv->est->ctr[1].

Fixes: b60189e0392f ("net: stmmac: Integrate EST with TAPRIO scheduler API")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Tested-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20261029-stmmac-est-fixes-v5-3-85b830a795a9@oss.qualcomm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  1 +
 .../net/ethernet/stmicro/stmmac/stmmac_est.c  | 55 ++++++++++++
 .../net/ethernet/stmicro/stmmac/stmmac_est.h  |  8 ++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 11 ++-
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c  | 44 ++--------
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 88 ++++++++++++-------
 6 files changed, 139 insertions(+), 68 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index e782323df61ec..6f34cae04f19c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -239,6 +239,7 @@ struct stmmac_est {
 	u32 gcl[EST_GCL];
 	u32 gcl_size;
 	u32 max_sdu[MTL_MAX_TX_QUEUES];
+	u32 pclass;
 };
 
 struct stmmac_msi {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_est.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_est.c
index f15d4d046aa74..59e9a54e864d6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_est.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_est.c
@@ -80,6 +80,61 @@ static int est_configure(struct stmmac_priv *priv, struct stmmac_est *cfg,
 	return 0;
 }
 
+int __stmmac_setup_est(struct stmmac_priv *priv)
+{
+	struct timespec64 current_time, time;
+	ktime_t current_time_ns, basetime;
+	u64 cycle_time;
+	int err;
+
+	lockdep_assert_held(&priv->est_lock);
+
+	priv->ptp_clock_ops.gettimex64(&priv->ptp_clock_ops, &current_time,
+				       NULL);
+	current_time_ns = timespec64_to_ktime(current_time);
+
+	time.tv_nsec = priv->est->btr_reserve[0];
+	time.tv_sec = priv->est->btr_reserve[1];
+	basetime = timespec64_to_ktime(time);
+
+	cycle_time = (u64)priv->est->ctr[1] * NSEC_PER_SEC + priv->est->ctr[0];
+
+	time = stmmac_calc_tas_basetime(basetime, current_time_ns, cycle_time);
+	priv->est->btr[0] = (u32)time.tv_nsec;
+	priv->est->btr[1] = (u32)time.tv_sec;
+
+	err = stmmac_est_configure(priv, priv, priv->est,
+				   priv->plat->clk_ptp_rate, true);
+	if (err) {
+		netdev_err(priv->dev, "failed to re-configure EST\n");
+		return err;
+	}
+
+	return 0;
+}
+
+int stmmac_setup_est(struct stmmac_priv *priv)
+{
+	int ret = 0;
+
+	if (!priv->ptp_enabled)
+		return 0;
+
+	mutex_lock(&priv->est_lock);
+	if (priv->est && priv->est->enable) {
+		ret = __stmmac_setup_est(priv);
+		if (ret)
+			goto unlock;
+
+		ret = stmmac_fpe_map_preemption_class(priv, priv->dev, NULL,
+						      priv->est->pclass);
+	}
+unlock:
+	mutex_unlock(&priv->est_lock);
+
+	return ret;
+}
+
 static void est_irq_status(struct stmmac_priv *priv, struct net_device *dev,
 			   struct stmmac_extra_stats *x, u32 txqcnt)
 {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_est.h b/drivers/net/ethernet/stmicro/stmmac/stmmac_est.h
index f70221c9c84af..5e07b84957f35 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_est.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_est.h
@@ -4,6 +4,9 @@
  * stmmac EST(802.3 Qbv) handling
  */
 
+#ifndef __STMMAC_EST_H__
+#define __STMMAC_EST_H__
+
 #define EST_GMAC4_OFFSET		0x00000c50
 #define EST_XGMAC_OFFSET		0x00001050
 
@@ -65,3 +68,8 @@
 #define EST_GCL_DATA			0x00000034
 
 extern const struct stmmac_est_ops dwmac510_est_ops;
+
+int __stmmac_setup_est(struct stmmac_priv *priv);
+int stmmac_setup_est(struct stmmac_priv *priv);
+
+#endif /* __STMMAC_EST_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c74dcc2d37dbe..bd495ab5cd260 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -48,6 +48,7 @@
 #include "stmmac_ptp.h"
 #include "stmmac_fpe.h"
 #include "stmmac.h"
+#include "stmmac_est.h"
 #include "stmmac_pcs.h"
 #include "stmmac_xdp.h"
 #include <linux/reset.h>
@@ -4213,6 +4214,10 @@ static int __stmmac_open(struct net_device *dev,
 	if (ret)
 		goto ptp_error;
 
+	ret = stmmac_setup_est(priv);
+	if (ret)
+		goto est_error;
+
 	stmmac_init_coalesce(priv);
 
 	phylink_start(priv->phylink);
@@ -4234,7 +4239,7 @@ static int __stmmac_open(struct net_device *dev,
 
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
 		hrtimer_cancel(&priv->dma_conf.tx_queue[chan].txtimer);
-
+est_error:
 	stmmac_release_ptp(priv);
 ptp_error:
 	stmmac_stop_all_dma(priv);
@@ -8462,6 +8467,10 @@ int stmmac_resume(struct device *dev)
 		ret = stmmac_init_timestamping(priv);
 		if (ret)
 			goto error_stop_dma;
+
+		ret = stmmac_setup_est(priv);
+		if (ret)
+			goto error_stop_dma;
 	}
 
 init_coalesce:
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 9a32af00d7d2d..a37405534bebf 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -8,6 +8,7 @@
   Author: Rayagond Kokatanur <rayagond@vayavyalabs.com>
 *******************************************************************************/
 #include "stmmac.h"
+#include "stmmac_est.h"
 #include "stmmac_ptp.h"
 
 #define PTP_SAFE_TIME_OFFSET_NS	500000
@@ -54,8 +55,7 @@ static int stmmac_adjust_time(struct ptp_clock_info *ptp, s64 delta)
 	u32 sec, nsec;
 	u32 quotient, reminder;
 	int neg_adj = 0;
-	bool xmac, est_rst = false;
-	int ret;
+	bool xmac;
 
 	xmac = dwmac_is_xmac(priv->plat->core_type);
 
@@ -69,47 +69,21 @@ static int stmmac_adjust_time(struct ptp_clock_info *ptp, s64 delta)
 	nsec = reminder;
 
 	/* If EST is enabled, disabled it before adjust ptp time. */
-	if (priv->est && priv->est->enable) {
-		est_rst = true;
-		mutex_lock(&priv->est_lock);
-		priv->est->enable = false;
+	mutex_lock(&priv->est_lock);
+	if (priv->est && priv->est->enable)
 		stmmac_est_configure(priv, priv, priv->est,
 				     priv->plat->clk_ptp_rate, false);
-		mutex_unlock(&priv->est_lock);
-	}
+	mutex_unlock(&priv->est_lock);
 
 	write_lock_irqsave(&priv->ptp_lock, flags);
 	stmmac_adjust_systime(priv, priv->ptpaddr, sec, nsec, neg_adj, xmac);
 	write_unlock_irqrestore(&priv->ptp_lock, flags);
 
 	/* Calculate new basetime and re-configured EST after PTP time adjust. */
-	if (est_rst) {
-		struct timespec64 current_time, time;
-		ktime_t current_time_ns, basetime;
-		u64 cycle_time;
-
-		mutex_lock(&priv->est_lock);
-		priv->ptp_clock_ops.gettimex64(&priv->ptp_clock_ops,
-					       &current_time, NULL);
-		current_time_ns = timespec64_to_ktime(current_time);
-		time.tv_nsec = priv->est->btr_reserve[0];
-		time.tv_sec = priv->est->btr_reserve[1];
-		basetime = timespec64_to_ktime(time);
-		cycle_time = (u64)priv->est->ctr[1] * NSEC_PER_SEC +
-			     priv->est->ctr[0];
-		time = stmmac_calc_tas_basetime(basetime,
-						current_time_ns,
-						cycle_time);
-
-		priv->est->btr[0] = (u32)time.tv_nsec;
-		priv->est->btr[1] = (u32)time.tv_sec;
-		priv->est->enable = true;
-		ret = stmmac_est_configure(priv, priv, priv->est,
-					   priv->plat->clk_ptp_rate, true);
-		mutex_unlock(&priv->est_lock);
-		if (ret)
-			netdev_err(priv->dev, "failed to configure EST\n");
-	}
+	mutex_lock(&priv->est_lock);
+	if (priv->est && priv->est->enable)
+		__stmmac_setup_est(priv);
+	mutex_unlock(&priv->est_lock);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index c4daf014e885e..dab79d8a3bc2a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -966,11 +966,12 @@ static void tc_taprio_map_maxsdu_txq(struct stmmac_priv *priv,
 static int tc_taprio_configure(struct stmmac_priv *priv,
 			       struct tc_taprio_qopt_offload *qopt)
 {
-	u32 size, wid = priv->dma_cap.estwid, dep = priv->dma_cap.estdep;
+	u32 wid = priv->dma_cap.estwid, dep = priv->dma_cap.estdep;
 	struct netlink_ext_ack *extack = qopt->mqprio.extack;
 	struct timespec64 time, current_time, qopt_time;
 	ktime_t current_time_ns;
 	int err, i, ret = 0;
+	u32 *gcl = NULL;
 	u64 ctr;
 
 	if (qopt->base_time < 0)
@@ -1013,42 +1014,46 @@ static int tc_taprio_configure(struct stmmac_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
+	mutex_lock(&priv->est_lock);
+
 	if (qopt->cmd == TAPRIO_CMD_DESTROY)
 		goto disable;
 
-	if (qopt->num_entries > dep)
-		return -EINVAL;
-	if (!qopt->cycle_time)
-		return -ERANGE;
-	if (qopt->cycle_time_extension >= BIT(wid + 7))
-		return -ERANGE;
+	if (qopt->num_entries > dep) {
+		ret = -EINVAL;
+		goto error_unlock;
+	}
 
-	if (!priv->est) {
-		priv->est = devm_kzalloc(priv->device, sizeof(*priv->est),
-					 GFP_KERNEL);
-		if (!priv->est)
-			return -ENOMEM;
-	} else {
-		mutex_lock(&priv->est_lock);
-		memset(priv->est, 0, sizeof(*priv->est));
-		mutex_unlock(&priv->est_lock);
+	if (!qopt->cycle_time ||
+	    qopt->cycle_time > (u64)U32_MAX * NSEC_PER_SEC) {
+		ret = -ERANGE;
+		goto error_unlock;
 	}
 
-	size = qopt->num_entries;
+	if (qopt->cycle_time_extension >= BIT(wid + 7)) {
+		ret = -ERANGE;
+		goto error_unlock;
+	}
 
-	mutex_lock(&priv->est_lock);
-	priv->est->gcl_size = size;
-	priv->est->enable = qopt->cmd == TAPRIO_CMD_REPLACE;
-	mutex_unlock(&priv->est_lock);
+	gcl = kcalloc(qopt->num_entries, sizeof(*gcl), GFP_KERNEL);
+	if (!gcl) {
+		ret = -ENOMEM;
+		goto error_unlock;
+	}
 
-	for (i = 0; i < size; i++) {
+	for (i = 0; i < qopt->num_entries; i++) {
 		s64 delta_ns = qopt->entries[i].interval;
 		u32 gates = qopt->entries[i].gate_mask;
 
-		if (delta_ns > GENMASK(wid - 1, 0))
-			return -ERANGE;
-		if (gates > GENMASK(31 - wid, 0))
-			return -ERANGE;
+		if (delta_ns > GENMASK(wid - 1, 0)) {
+			ret = -ERANGE;
+			goto error_unlock;
+		}
+
+		if (gates > GENMASK(31 - wid, 0)) {
+			ret = -ERANGE;
+			goto error_unlock;
+		}
 
 		switch (qopt->entries[i].command) {
 		case TC_TAPRIO_CMD_SET_GATES:
@@ -1060,13 +1065,26 @@ static int tc_taprio_configure(struct stmmac_priv *priv,
 			gates &= ~BIT(0);
 			break;
 		default:
-			return -EOPNOTSUPP;
+			ret = -EOPNOTSUPP;
+			goto error_unlock;
 		}
 
-		priv->est->gcl[i] = delta_ns | (gates << wid);
+		gcl[i] = delta_ns | (gates << wid);
 	}
 
-	mutex_lock(&priv->est_lock);
+	if (!priv->est) {
+		priv->est = devm_kzalloc(priv->device, sizeof(*priv->est),
+					 GFP_KERNEL);
+		if (!priv->est) {
+			ret = -ENOMEM;
+			goto error_unlock;
+		}
+	} else {
+		memset(priv->est, 0, sizeof(*priv->est));
+	}
+	memcpy(priv->est->gcl, gcl, sizeof(*gcl) * qopt->num_entries);
+	priv->est->gcl_size = qopt->num_entries;
+
 	/* Adjust for real system time */
 	priv->ptp_clock_ops.gettimex64(&priv->ptp_clock_ops, &current_time,
 				       NULL);
@@ -1091,7 +1109,6 @@ static int tc_taprio_configure(struct stmmac_priv *priv,
 
 	ret = stmmac_est_configure(priv, priv, priv->est,
 				   priv->plat->clk_ptp_rate, true);
-	mutex_unlock(&priv->est_lock);
 	if (ret) {
 		netdev_err(priv->dev, "failed to configure EST\n");
 		goto disable;
@@ -1102,11 +1119,16 @@ static int tc_taprio_configure(struct stmmac_priv *priv,
 	if (ret)
 		goto disable;
 
+	priv->est->pclass = qopt->mqprio.preemptible_tcs;
+	priv->est->enable = true;
+
+	mutex_unlock(&priv->est_lock);
+	kfree(gcl);
+
 	return 0;
 
 disable:
 	if (priv->est) {
-		mutex_lock(&priv->est_lock);
 		priv->est->enable = false;
 		stmmac_est_configure(priv, priv, priv->est,
 				     priv->plat->clk_ptp_rate, false);
@@ -1116,10 +1138,12 @@ static int tc_taprio_configure(struct stmmac_priv *priv,
 			priv->xstats.mtl_est_txq_hlbf[i] = 0;
 			priv->xstats.mtl_est_txq_hlbs[i] = 0;
 		}
-		mutex_unlock(&priv->est_lock);
 	}
 
 	err = stmmac_fpe_map_preemption_class(priv, priv->dev, extack, 0);
+error_unlock:
+	mutex_unlock(&priv->est_lock);
+	kfree(gcl);
 
 	return qopt->cmd == TAPRIO_CMD_DESTROY ? err : ret;
 }
-- 
2.53.0



