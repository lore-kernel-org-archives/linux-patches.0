Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774309;
	b=ebvFdScLP+XpaNRG89Vc01VPIc20hzH+uownK5AV4s5WTG1ZuG4xRa3BsGuZqZD23IJR
	 SQz/GjTZWKOiIawSOCLsdz08lXbZ0ja7lr3dALJ35wqg9O6bWVcQy40rwWGUJpMD7F3D9
	 zNsOPvjvuqmhZRITKrIr4/AGF7uohA5vhONzIb0Zm0nnZugPbHcSekMRSr0DCcKH4NWyY
	 uTKfJJWpaE/8mQG+nE/BQNuZNvN0rSKQtfVKaesdHOAAjeG2x5PN3DMgyJWwuFB1pKsNh
	 9t/K2wYcsn1jRoeBCBU4X6RkGEQnUNhHghJKC2TnefhkCm2LdAES64AwArgisEg+E/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=diQXITg7EocC3IquwNrDOtgp0yQmkvl7RvU7iPfaZfk=;
	b=qOOO3awLMMI55cYuUJMgwb9m8/pTBfdSjVjyE0lvzr7UAtuuY4jQFq7gKLvw//n4zdZ0
	 iG17ZnbWgdzPmkx+1zKfbCerHT83xUnRZ38zoH89ZVrXua5mwa0X7i0O20JP4B8OxgJke
	 lirO8mIQa0Ara2E8AQZ3HdyEGlfB4DigwVgFM2V84ApxVDaQZkDOr3laB0S9KbrDY0h+c
	 RQGWsygvVtOd8ODZ3SvxRmgtSpGckwym+/j2ToR8bQ4e/BsWVjs9JVCr24+QXL0CM6HXb
	 nsELW1FoDkz82V9NVwhGtuZx775NxI+QoegT/sK/2w+Gfru4OaBZxv1IqJuSwK19Q/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j9oyRlP8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2191A606A31B;
	Fri, 23 Oct 2026 16:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j9oyRlP8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0811F01825;
	Fri, 23 Oct 2026 16:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774309;
	bh=diQXITg7EocC3IquwNrDOtgp0yQmkvl7RvU7iPfaZfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9oyRlP8CRHA6/txLp1H7tLXrXvocV6YA/DmjA7DkvhE8Qg2tLceGgcQPxNoD09eg
	 73vkNRqINCtsq8HwTYopHexrNiJQq0RUTLdQ7z/hgRwYhAV6/NqaRpPOR17DTsOMSo
	 2FyApiDdUrpIFVpBGSm8h4pF9p9nP+Sj3e16dUOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.18 192/193] ice: fix crash in ethtool offline loopback test
Date: Fri, 23 Oct 2026 18:37:49 +0200
Message-ID: <20261023163718.762118805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Michal Schmidt <mschmidt@redhat.com>

commit a9c354e656597aededa027d63d2ff0973f6b033f upstream.

Since the conversion of ice to page pool, the ethtool loopback test
crashes:

 BUG: kernel NULL pointer dereference, address: 000000000000000c
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 PGD 1100f1067 P4D 0
 Oops: Oops: 0002 [#1] SMP NOPTI
 CPU: 23 UID: 0 PID: 5904 Comm: ethtool Kdump: loaded Not tainted 6.19.0-0.rc7.260128g1f97d9dcf5364.49.eln154.x86_64 #1 PREEMPT(lazy)
 Hardware name: [...]
 RIP: 0010:ice_alloc_rx_bufs+0x1cd/0x310 [ice]
 Code: 83 6c 24 30 01 66 41 89 47 08 0f 84 c0 00 00 00 41 0f b7 dc 48 8b 44 24 18 48 c1 e3 04 41 bb 00 10 00 00 48 8d 2c 18 8b 04 24 <89> 45 0c 41 8b 4d 00 49 d3 e3 44 3b 5c 24 24 0f 83 ac fe ff ff 44
 RSP: 0018:ff7894738aa1f768 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: 0000000000000700 RDI: 0000000000000000
 RBP: 0000000000000000 R08: ff16dcae79880200 R09: 0000000000000019
 R10: 0000000000000001 R11: 0000000000001000 R12: 0000000000000000
 R13: 0000000000000000 R14: 0000000000000000 R15: ff16dcae6c670000
 FS:  00007fcf428850c0(0000) GS:ff16dcb149710000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000000000000000c CR3: 0000000121227005 CR4: 0000000000773ef0
 PKRU: 55555554
 Call Trace:
  <TASK>
  ice_vsi_cfg_rxq+0xca/0x460 [ice]
  ice_vsi_cfg_rxqs+0x54/0x70 [ice]
  ice_loopback_test+0xa9/0x520 [ice]
  ice_self_test+0x1b9/0x280 [ice]
  ethtool_self_test+0xe5/0x200
  __dev_ethtool+0x1106/0x1a90
  dev_ethtool+0xbe/0x1a0
  dev_ioctl+0x258/0x4c0
  sock_do_ioctl+0xe3/0x130
  __x64_sys_ioctl+0xb9/0x100
  do_syscall_64+0x7c/0x700
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
  [...]

It crashes because we have not initialized libeth for the rx ring.

Fix it by treating ICE_VSI_LB VSIs slightly more like normal PF VSIs and
letting them have a q_vector. It's just a dummy, because the loopback
test does not use interrupts, but it contains a napi struct that can be
passed to libeth_rx_fq_create() called from ice_vsi_cfg_rxq() ->
ice_rxq_pp_create().

Fixes: 93f53db9f9dc ("ice: switch to Page Pool")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_base.c    |    5 ++++-
 drivers/net/ethernet/intel/ice/ice_ethtool.c |    4 ++++
 drivers/net/ethernet/intel/ice/ice_lib.c     |   15 ++++++++++-----
 3 files changed, 18 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_base.c
+++ b/drivers/net/ethernet/intel/ice/ice_base.c
@@ -124,6 +124,8 @@ static int ice_vsi_alloc_q_vector(struct
 	if (vsi->type == ICE_VSI_VF) {
 		ice_calc_vf_reg_idx(vsi->vf, q_vector);
 		goto out;
+	} else if (vsi->type == ICE_VSI_LB) {
+		goto skip_alloc;
 	} else if (vsi->type == ICE_VSI_CTRL && vsi->vf) {
 		struct ice_vsi *ctrl_vsi = ice_get_vf_ctrl_vsi(pf, vsi);
 
@@ -600,7 +602,8 @@ static int ice_vsi_cfg_rxq(struct ice_rx
 	u32 rx_buf_len;
 	int err;
 
-	if (ring->vsi->type == ICE_VSI_PF || ring->vsi->type == ICE_VSI_SF) {
+	if (ring->vsi->type == ICE_VSI_PF || ring->vsi->type == ICE_VSI_SF ||
+	    ring->vsi->type == ICE_VSI_LB) {
 		if (!xdp_rxq_info_is_reg(&ring->xdp_rxq)) {
 			err = __xdp_rxq_info_reg(&ring->xdp_rxq, ring->netdev,
 						 ring->q_index,
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1281,6 +1281,10 @@ static u64 ice_loopback_test(struct net_
 	test_vsi->netdev = netdev;
 	tx_ring = test_vsi->tx_rings[0];
 	rx_ring = test_vsi->rx_rings[0];
+	/* Dummy q_vector and napi. Fill the minimum required for
+	 * ice_rxq_pp_create().
+	 */
+	rx_ring->q_vector->napi.dev = netdev;
 
 	if (ice_lbtest_prepare_rings(test_vsi)) {
 		ret = 2;
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -107,10 +107,6 @@ static int ice_vsi_alloc_arrays(struct i
 	if (!vsi->rxq_map)
 		goto err_rxq_map;
 
-	/* There is no need to allocate q_vectors for a loopback VSI. */
-	if (vsi->type == ICE_VSI_LB)
-		return 0;
-
 	/* allocate memory for q_vector pointers */
 	vsi->q_vectors = devm_kcalloc(dev, vsi->num_q_vectors,
 				      sizeof(*vsi->q_vectors), GFP_KERNEL);
@@ -239,6 +235,8 @@ static void ice_vsi_set_num_qs(struct ic
 	case ICE_VSI_LB:
 		vsi->alloc_txq = 1;
 		vsi->alloc_rxq = 1;
+		/* A dummy q_vector, no actual IRQ. */
+		vsi->num_q_vectors = 1;
 		break;
 	default:
 		dev_warn(ice_pf_to_dev(pf), "Unknown VSI type %d\n", vsi_type);
@@ -2424,14 +2422,21 @@ static int ice_vsi_cfg_def(struct ice_vs
 		}
 		break;
 	case ICE_VSI_LB:
-		ret = ice_vsi_alloc_rings(vsi);
+		ret = ice_vsi_alloc_q_vectors(vsi);
 		if (ret)
 			goto unroll_vsi_init;
 
+		ret = ice_vsi_alloc_rings(vsi);
+		if (ret)
+			goto unroll_alloc_q_vector;
+
 		ret = ice_vsi_alloc_ring_stats(vsi);
 		if (ret)
 			goto unroll_vector_base;
 
+		/* Simply map the dummy q_vector to the only rx_ring */
+		vsi->rx_rings[0]->q_vector = vsi->q_vectors[0];
+
 		break;
 	default:
 		/* clean up the resources and exit */


