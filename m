Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214258;
	b=qzuRoKGkEhl1GvlYd/4Kg0xsG1iiEyLjyu3PTk5QBL9kY+PsOr4fZmYqD7VUJbPLZQYK
	 FIuaHp2rKR6BinZMVfxyqlFqeT/BsWRYfJbWl2WM7VAYdlbbsxbiS0z/sLP2NyOs6cGOs
	 BviqmhtpDrMtU/M3kflr8FGER+WFYeNKkJp2OEnlMc3VooLH3dmNPL9pvuu6k99MsdjAd
	 ifUENj9Bknu2szBboHfAOfx11m2va/CKcrDFVqtjUqoPW32bqln32LEdMmhCzbZfWqtUe
	 WWdO+1+GpCLlP53b9vwhX5ctZayaRIt9Hl5xYdAiva5qAx7RHqcQJt49fv2egLRyneQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ylUXIRcFrHFcpAW2Vac4HG58wVwWvv2UuYAtacNbvS4=;
	b=g1vHvwzG8twr6gbN4fcEHTJ0EJvRx+UsRcFJlG1teuBfhEE9K9d7JfjhF3nEj1pBs4l1
	 vagDxjsUagM4TV5ecJTSezzvLGKo6ZVOAHg3D4UQVsC7xZLrJRhCp1GeZgb2iAfS0CRtQ
	 6I6Ku3mwGaOt2uuTSkYiqUdT3ATFuK9Sc83OT6yxENWPSAJ9NCVNRc69J+UtnZtNgaBnW
	 ATuH7VfXEqHkmYSTamlRXV8XulotIV86ce8Pc/tbKo9oB01uUHONvDNy4pjId+kxYTAMT
	 6iXjhZIHLb+U2ezpZ2asxtaF8/n6CQWAsnx5Q408dqB49jV3OEUrRcsi/rPkkeNhrMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wX55M5QS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0305360A383C;
	Wed, 28 Oct 2026 19:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wX55M5QS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1B61F01825;
	Wed, 28 Oct 2026 19:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214257;
	bh=ylUXIRcFrHFcpAW2Vac4HG58wVwWvv2UuYAtacNbvS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wX55M5QS/eu7J7mks8vMqKRJ79glBwS3aMvjauk2AwuQRqzr4c3EAHOv/kYsFYxhT
	 Nu2ve4yPrxnQVdcMEBjoSswatMiNOxvG4+WdUYa1tvaFiya3tSqyCnGbYXkKDVCxll
	 VQtrFYs/u3JsUt032qwi5KDY0/AdreR73vQ4lhRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Jesse Brandeburg <jbrandeburg@cloudflare.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Saritha Sanigani <sarithax.sanigani@intel.com>
Subject: [PATCH 6.1 0794/1887] ice: fix Tx scheduler error handling in XDP callback
Date: Wed, 28 Oct 2026 17:48:10 +0100
Message-ID: <20261028170517.501694162@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Michal Kubiak <michal.kubiak@intel.com>

[ Upstream commit 0153f36041b8e52019ebfa8629c13bf8f9b0a951 ]

When the XDP program is loaded, the XDP callback adds new Tx queues.
This means that the callback must update the Tx scheduler with the new
queue number. In the event of a Tx scheduler failure, the XDP callback
should also fail and roll back any changes previously made for XDP
preparation.

The previous implementation had a bug that not all changes made by the
XDP callback were rolled back. This caused the crash with the following
call trace:

[  +9.549584] ice 0000:ca:00.0: Failed VSI LAN queue config for XDP, error: -5
[  +0.382335] Oops: general protection fault, probably for non-canonical address 0x50a2250a90495525: 0000 [#1] SMP NOPTI
[  +0.010710] CPU: 103 UID: 0 PID: 0 Comm: swapper/103 Not tainted 6.14.0-net-next-mar-31+ #14 PREEMPT(voluntary)
[  +0.010175] Hardware name: Intel Corporation M50CYP2SBSTD/M50CYP2SBSTD, BIOS SE5C620.86B.01.01.0005.2202160810 02/16/2022
[  +0.010946] RIP: 0010:__ice_update_sample+0x39/0xe0 [ice]

[...]

[  +0.002715] Call Trace:
[  +0.002452]  <IRQ>
[  +0.002021]  ? __die_body.cold+0x19/0x29
[  +0.003922]  ? die_addr+0x3c/0x60
[  +0.003319]  ? exc_general_protection+0x17c/0x400
[  +0.004707]  ? asm_exc_general_protection+0x26/0x30
[  +0.004879]  ? __ice_update_sample+0x39/0xe0 [ice]
[  +0.004835]  ice_napi_poll+0x665/0x680 [ice]
[  +0.004320]  __napi_poll+0x28/0x190
[  +0.003500]  net_rx_action+0x198/0x360
[  +0.003752]  ? update_rq_clock+0x39/0x220
[  +0.004013]  handle_softirqs+0xf1/0x340
[  +0.003840]  ? sched_clock_cpu+0xf/0x1f0
[  +0.003925]  __irq_exit_rcu+0xc2/0xe0
[  +0.003665]  common_interrupt+0x85/0xa0
[  +0.003839]  </IRQ>
[  +0.002098]  <TASK>
[  +0.002106]  asm_common_interrupt+0x26/0x40
[  +0.004184] RIP: 0010:cpuidle_enter_state+0xd3/0x690

Fix this by performing the missing unmapping of XDP queues from
q_vectors and setting the XDP rings pointer back to NULL after all those
queues are released.
Also, add an immediate exit from the XDP callback in case of ring
preparation failure.

Fixes: efc2214b6047 ("ice: Add support for XDP")
Reviewed-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Michal Kubiak <michal.kubiak@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Jesse Brandeburg <jbrandeburg@cloudflare.com>
Tested-by: Saritha Sanigani <sarithax.sanigani@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 46 ++++++++++++++++-------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 75fede7d31749..8db6e47decdb9 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2642,6 +2642,27 @@ static void ice_vsi_assign_bpf_prog(struct ice_vsi *vsi, struct bpf_prog *prog)
 		bpf_prog_put(old_prog);
 }
 
+/**
+ * ice_unmap_xdp_rings - Unmap XDP rings from interrupt vectors
+ * @vsi: the VSI with XDP rings being unmapped
+ */
+static void ice_unmap_xdp_rings(struct ice_vsi *vsi)
+{
+	int v_idx;
+
+	ice_for_each_q_vector(vsi, v_idx) {
+		struct ice_q_vector *q_vector = vsi->q_vectors[v_idx];
+		struct ice_tx_ring *ring;
+
+		ice_for_each_tx_ring(ring, q_vector->tx)
+			if (!ring->tx_buf || !ice_ring_is_xdp(ring))
+				break;
+
+		/* restore the value of last node prior to XDP setup */
+		q_vector->tx.tx_ring = ring;
+	}
+}
+
 /**
  * ice_prepare_xdp_rings - Allocate, configure and setup Tx rings for XDP
  * @vsi: VSI to bring up Tx rings used by XDP
@@ -2739,7 +2760,7 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog)
 	if (status) {
 		dev_err(dev, "Failed VSI LAN queue config for XDP, error: %d\n",
 			status);
-		goto clear_xdp_rings;
+		goto unmap_xdp_rings;
 	}
 
 	/* assign the prog only when it's not already present on VSI;
@@ -2755,6 +2776,8 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog)
 		ice_vsi_assign_bpf_prog(vsi, prog);
 
 	return 0;
+unmap_xdp_rings:
+	ice_unmap_xdp_rings(vsi);
 clear_xdp_rings:
 	ice_for_each_xdp_txq(vsi, i)
 		if (vsi->xdp_rings[i]) {
@@ -2772,6 +2795,7 @@ int ice_prepare_xdp_rings(struct ice_vsi *vsi, struct bpf_prog *prog)
 
 	devm_kfree(dev, vsi->xdp_rings);
 	vsi->xdp_rings = NULL;
+
 	return -ENOMEM;
 }
 
@@ -2786,7 +2810,7 @@ int ice_destroy_xdp_rings(struct ice_vsi *vsi)
 {
 	u16 max_txqs[ICE_MAX_TRAFFIC_CLASS] = { 0 };
 	struct ice_pf *pf = vsi->back;
-	int i, v_idx;
+	int i;
 
 	/* q_vectors are freed in reset path so there's no point in detaching
 	 * rings; in case of rebuild being triggered not from reset bits
@@ -2796,17 +2820,7 @@ int ice_destroy_xdp_rings(struct ice_vsi *vsi)
 	if (ice_is_reset_in_progress(pf->state) || !vsi->q_vectors[0])
 		goto free_qmap;
 
-	ice_for_each_q_vector(vsi, v_idx) {
-		struct ice_q_vector *q_vector = vsi->q_vectors[v_idx];
-		struct ice_tx_ring *ring;
-
-		ice_for_each_tx_ring(ring, q_vector->tx)
-			if (!ring->tx_buf || !ice_ring_is_xdp(ring))
-				break;
-
-		/* restore the value of last node prior to XDP setup */
-		q_vector->tx.tx_ring = ring;
-	}
+	ice_unmap_xdp_rings(vsi);
 
 free_qmap:
 	mutex_lock(&pf->avail_q_mutex);
@@ -2943,10 +2957,13 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 		xdp_ring_err = ice_vsi_determine_xdp_res(vsi);
 		if (xdp_ring_err) {
 			NL_SET_ERR_MSG_MOD(extack, "Not enough Tx resources for XDP");
+			goto resume_if;
 		} else {
 			xdp_ring_err = ice_prepare_xdp_rings(vsi, prog);
-			if (xdp_ring_err)
+			if (xdp_ring_err) {
 				NL_SET_ERR_MSG_MOD(extack, "Setting up XDP Tx resources failed");
+				goto resume_if;
+			}
 		}
 		/* reallocate Rx queues that are used for zero-copy */
 		xdp_ring_err = ice_realloc_zc_buf(vsi, true);
@@ -2962,6 +2979,7 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 			NL_SET_ERR_MSG_MOD(extack, "Freeing XDP Rx resources failed");
 	}
 
+resume_if:
 	if (if_running)
 		ret = ice_up(vsi);
 
-- 
2.53.0



