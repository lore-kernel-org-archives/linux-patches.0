Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621187;
	b=GdKppzuNDzWrinltG4QR0qXemtXieLZrnzdVdw7q5l3KeGp6GCEE9phw25busw+Ba/Wn
	 auNPIhwQLhafSAEcK12QJm+awjZ4w2QNcz9VIlmlVKDIjRVAHaFNNfJNprCzhpIIQ69RW
	 t6UgZjCygftYx0SyOOXlxOrJFvUdyhMf1t58aw8T7O3LB/1BVYDxUhUldI8AfI+ylu7a8
	 ZVoPVoRME2Tj/2ClZrq+6UQQ8M1qo2rJgd9yRslnYlRuEhJVFDJSV7SJqkTVahq9/F79i
	 9Vsl/MzcOUWWDvs1wqw+hA4zixSrYiWa08hmALKzqHaH8SQmOcN6oneG2lmtYr26jNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621187;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zEWGT+NnIwPdiFOolhbyBJ76J4Bv+nGEmUrFU/Thj9E=;
	b=ZVQ+m3ENlzx4S2X5IvZ4TN8G/1UUSEVAittk7McD2wL/vEKx8nr2xzpa8XZvoeKb9nFq
	 Jd1I7xieaqJu6GmYTE80JhtBdShEWi4Ba83Wvr9n0Di1TeFZedEWPZ8c6qTaQO9TB7NMX
	 tjWAmGzFepZBflvnHEB5OWpaYiDFMI7V6/bmjzAw7YeNdy6bkQQzAdeQ1f9EUnzYym7Qm
	 tKkfmzLwZcqNpwlhp5M7On4GKyxq6JRtnfl/Mf42sbDDbafz+eRMRsu3Oe0IynmgVjC2h
	 70qYYA9vwftEarpixzB48AeuK0wc+l4VFo+vxrEgCzTzrLoezwoGKHNdT4Tz1frpQCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eGWxkx4N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9440F606A6BA;
	Wed, 25 Nov 2026 15:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eGWxkx4N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6731F000EB;
	Wed, 25 Nov 2026 15:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621187;
	bh=zEWGT+NnIwPdiFOolhbyBJ76J4Bv+nGEmUrFU/Thj9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eGWxkx4N871R+S1sWi59xvMfcRv4ikvvxb2cmx44/yo4IIutKKCeUIrFUUsJIqmGO
	 62j7LXcMKyKo5STVBA2RlsKhSwdq8uqzEnpKABxqU3p9x+2nJejptKcO6aUtWBgpSX
	 vt7posdlgD7nGIu+ASW6dqHdnm1NyRO1+QHkyukA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Austin <alex.austin@amd.com>,
	Alejandro Lucero <alucerop@amd.com>,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 148/990] sfc: ptp: serialize host and MC synchronization transactions
Date: Wed, 25 Nov 2026 15:25:15 +0100
Message-ID: <20261125143825.556879449@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Alex Austin <alex.austin@amd.com>

[ Upstream commit f707347b33feebdd67633bccea52f96807c18d6e ]

efx_ptp_synchronize() clears the MC-ready DMA flag before
efx_mcdi_rpc_start() acquires the MCDI interface, and processes results
into ptp->timeset[] after efx_mcdi_rpc_finish() has released it. The PPS
worker and the hwtstamp enable path can therefore clobber each other's
handshake flag and timesets.

Hold a PHC mutex across the whole transaction and over the clock
operations, so efx_phc_settime() reads and adjusts atomically and
current_adjfreq is consistently read and written under one lock. Also
bail out when efx_mcdi_rpc_start() fails rather than finishing an RPC
that was never acquired.

Fixes: 7c236c43b838 ("sfc: Add support for IEEE-1588 PTP")
Signed-off-by: Alex Austin <alex.austin@amd.com>
Reviewed-by: Alejandro Lucero <alucerop@amd.com>
Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
Link: https://patch.msgid.link/20261026123023.3566549-3-alex.austin@amd.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ptp.c | 81 +++++++++++++++++++++++-----------
 1 file changed, 55 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index dbd7281f44b3e..f8a88133b15b1 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -36,6 +36,7 @@
 #include <linux/errno.h>
 #include <linux/ktime.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/pps_kernel.h>
 #include <linux/ptp_clock_kernel.h>
 #include "net_driver.h"
@@ -272,6 +273,8 @@ struct efx_ptp_rxfilter {
  * frequency adjustment into a fixed point fractional nanosecond format.
  * @current_adjfreq: Current ppb adjustment.
  * @phc_clock: Pointer to registered phc device (if primary function)
+ * @phc_lock: Serializes PHC commands and synchronization, and protects
+ *	      @current_adjfreq
  * @phc_clock_info: Registration structure for phc device
  * @pps_work: pps work task for handling pps events
  * @pps_workwq: pps work queue
@@ -331,6 +334,7 @@ struct efx_ptp_data {
 	unsigned int adjfreq_ppb_shift;
 	s64 current_adjfreq;
 	struct ptp_clock *phc_clock;
+	struct mutex phc_lock;
 	struct ptp_clock_info phc_clock_info;
 	struct work_struct pps_work;
 	struct workqueue_struct *pps_workwq;
@@ -1008,7 +1012,14 @@ efx_ptp_process_times(struct efx_nic *efx, MCDI_DECLARE_STRUCT_PTR(synch_buf),
 	return 0;
 }
 
-/* Synchronize times between the host and the MC */
+/* Synchronize times between the host and the MC.
+ *
+ * The MC serializes PTP requests, so MC_CMD_PTP_OP_ADJUST cannot be applied
+ * while MC_CMD_PTP_OP_SYNCHRONIZE is collecting timesets. This holds across
+ * functions of a controller, which share the clock but adjust it only through
+ * the function that registered it, so a secondary function can capture here
+ * without serializing against the primary.
+ */
 static int efx_ptp_synchronize(struct efx_nic *efx, unsigned int num_readings)
 {
 	struct efx_ptp_data *ptp = efx->ptp_data;
@@ -1027,11 +1038,14 @@ static int efx_ptp_synchronize(struct efx_nic *efx, unsigned int num_readings)
 	MCDI_SET_QWORD(synch_buf, PTP_IN_SYNCHRONIZE_START_ADDR,
 		       ptp->start.dma_addr);
 
+	mutex_lock(&ptp->phc_lock);
+
 	/* Clear flag that signals MC ready */
 	WRITE_ONCE(*start, 0);
 	rc = efx_mcdi_rpc_start(efx, MC_CMD_PTP, synch_buf,
 				MC_CMD_PTP_IN_SYNCHRONIZE_LEN);
-	EFX_WARN_ON_ONCE_PARANOID(rc);
+	if (rc)
+		goto out;
 
 	/* Wait for start from MCDI (or timeout) */
 	timeout = jiffies + msecs_to_jiffies(MAX_SYNCHRONISE_WAIT_MS);
@@ -1062,11 +1076,13 @@ static int efx_ptp_synchronize(struct efx_nic *efx, unsigned int num_readings)
 			++ptp->no_time_syncs;
 	}
 
+out:
 	/* Increment the bad syncs counter if the synchronize fails, whatever
 	 * the reason.
 	 */
 	if (rc != 0)
 		++ptp->bad_syncs;
+	mutex_unlock(&ptp->phc_lock);
 
 	return rc;
 }
@@ -1569,6 +1585,7 @@ int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel)
 	if (!efx->ptp_data)
 		return -ENOMEM;
 
+	mutex_init(&ptp->phc_lock);
 	ptp->efx = efx;
 	ptp->channel = channel;
 
@@ -1640,6 +1657,7 @@ int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel)
 	efx_nic_free_buffer(efx, &ptp->start);
 
 fail1:
+	mutex_destroy(&ptp->phc_lock);
 	kfree(efx->ptp_data);
 	efx->ptp_data = NULL;
 
@@ -1694,6 +1712,7 @@ void efx_ptp_remove(struct efx_nic *efx)
 	destroy_workqueue(efx->ptp_data->workwq);
 
 	efx_nic_free_buffer(efx, &efx->ptp_data->start);
+	mutex_destroy(&efx->ptp_data->phc_lock);
 	kfree(efx->ptp_data);
 	efx->ptp_data = NULL;
 }
@@ -2105,23 +2124,23 @@ static int efx_phc_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 	MCDI_SET_QWORD(inadj, PTP_IN_ADJUST_FREQ, adjustment_ns);
 	MCDI_SET_DWORD(inadj, PTP_IN_ADJUST_SECONDS, 0);
 	MCDI_SET_DWORD(inadj, PTP_IN_ADJUST_NANOSECONDS, 0);
+	mutex_lock(&ptp_data->phc_lock);
 	rc = efx_mcdi_rpc(efx, MC_CMD_PTP, inadj, sizeof(inadj),
 			  NULL, 0, NULL);
-	if (rc != 0)
-		return rc;
-
-	ptp_data->current_adjfreq = adjustment_ns;
-	return 0;
+	if (!rc)
+		ptp_data->current_adjfreq = adjustment_ns;
+	mutex_unlock(&ptp_data->phc_lock);
+	return rc;
 }
 
-static int efx_phc_adjtime(struct ptp_clock_info *ptp, s64 delta)
+static int _efx_phc_adjtime(struct efx_ptp_data *ptp_data, s64 delta)
+	__must_hold(&ptp_data->phc_lock)
 {
-	u32 nic_major, nic_minor;
-	struct efx_ptp_data *ptp_data = container_of(ptp,
-						     struct efx_ptp_data,
-						     phc_clock_info);
-	struct efx_nic *efx = ptp_data->efx;
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_PTP_IN_ADJUST_LEN);
+	struct efx_nic *efx = ptp_data->efx;
+	u32 nic_major, nic_minor;
+
+	lockdep_assert_held(&ptp_data->phc_lock);
 
 	efx->ptp_data->ns_to_nic_time(delta, &nic_major, &nic_minor);
 
@@ -2134,6 +2153,18 @@ static int efx_phc_adjtime(struct ptp_clock_info *ptp, s64 delta)
 			    NULL, 0, NULL);
 }
 
+static int efx_phc_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct efx_ptp_data *ptp_data = container_of(ptp, struct efx_ptp_data,
+						  phc_clock_info);
+	int rc;
+
+	mutex_lock(&ptp_data->phc_lock);
+	rc = _efx_phc_adjtime(ptp_data, delta);
+	mutex_unlock(&ptp_data->phc_lock);
+	return rc;
+}
+
 static int efx_phc_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
 {
 	struct efx_ptp_data *ptp_data = container_of(ptp,
@@ -2165,23 +2196,21 @@ static int efx_phc_settime(struct ptp_clock_info *ptp,
 {
 	/* Get the current NIC time, efx_phc_gettime.
 	 * Subtract from the desired time to get the offset
-	 * call efx_phc_adjtime with the offset
+	 * call _efx_phc_adjtime with the offset
 	 */
+	struct efx_ptp_data *ptp_data = container_of(ptp, struct efx_ptp_data,
+						  phc_clock_info);
+	struct timespec64 time_now, delta;
 	int rc;
-	struct timespec64 time_now;
-	struct timespec64 delta;
 
+	mutex_lock(&ptp_data->phc_lock);
 	rc = efx_phc_gettime(ptp, &time_now);
-	if (rc != 0)
-		return rc;
-
-	delta = timespec64_sub(*e_ts, time_now);
-
-	rc = efx_phc_adjtime(ptp, timespec64_to_ns(&delta));
-	if (rc != 0)
-		return rc;
-
-	return 0;
+	if (!rc) {
+		delta = timespec64_sub(*e_ts, time_now);
+		rc = _efx_phc_adjtime(ptp_data, timespec64_to_ns(&delta));
+	}
+	mutex_unlock(&ptp_data->phc_lock);
+	return rc;
 }
 
 static int efx_phc_enable(struct ptp_clock_info *ptp,
-- 
2.53.0



