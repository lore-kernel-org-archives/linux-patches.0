Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030487;
	b=wRg/p/pzvcLpRDrjAL5TGi3Y6cURjLFPCtKTUMHBTtM3D+XxTBsr+v9YEwvxbZo07euf
	 AAO38dINE/oGHCPQtLZajckMXFanfcNpR9laI6lXuE+W0DwT23TnP/cc2sbe66EJM/WHd
	 xY0O+sbToYb2nuxHYgxMUpHPqxpZulHWw9UJP5vBhH6OFqRlUeq+ZBWWOK+nGhCDtlIvx
	 67v7f62B/xtkn/PddgXqTfnA8YB6wwKbsFlRzKRMknWKwUxTt/hEgBL+Ro20Ym1ekbz4i
	 WW3AOQS28yeiKycPhP7JMheruc/1GVGaIvJ5id6OWFqe6X+suwfmdTu7M6e7iE/9xmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ec5w6SCdYX0sCgxBaZ+jS+YnwgZuLWlb+uI6sQjSVHk=;
	b=r8ixSFJBcJgvm3lhVITsDdFaZoHHe2RkUC0MOckeM9VgD8UKngBPNX2dxL9IyJER/qhj
	 fyBX4jCjKLioeCNHbq5/PfmUAYmGP9vsJMeD+Fz4hqvMQ00MfmlDWGNiCPz1ke/QmFdoS
	 XlnPqyUNOuiO0ERRRIqzRuHtvUZl9nntDtPrdPkOuifP51FAuXR5JOda115BJ/hrUDg29
	 MgWjMf9pJYVfW+s0RhyqNG4/HO8DKquRKC0p5gWJ1Egtb4XJc5/EQjhx0eioCBzKZZWgq
	 OOPDJqX28VQ17HDRe9c1Fh5wQO2Ww4snT++DIcUPxu3BOpoKN0MgGujweTr1zN8mGFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EQPk7WaD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FECA606BB51;
	Wed, 18 Nov 2026 19:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EQPk7WaD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5201F000C5;
	Wed, 18 Nov 2026 19:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030487;
	bh=ec5w6SCdYX0sCgxBaZ+jS+YnwgZuLWlb+uI6sQjSVHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EQPk7WaD+iB3mjBKc6TFTHtXfjZJ1S2rAS6y89ucTT8/ooeD6Ia/Biw50oTrQ3hWT
	 sqiSANnkUOpouEn5vnL8o1+AAgEpt0Az976+c1yHJE2kJ2lzWo1LLl/mLJfiapYR6S
	 SzBVx6dIfvVtlVs9/E6yOsWFHomcbZq1y0niLd4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0721/1756] ice: skip stats handling for channel VSIs on rebuild
Date: Wed, 18 Nov 2026 15:47:28 +0100
Message-ID: <20261118150038.377326050@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

[ Upstream commit 3fca849c965333f387aa02dca02326ce3abd1305 ]

ice_vsi_alloc_stat_arrays() returns early for ICE_VSI_CHNL, so a channel
VSI never gets an entry in pf->vsi_stats[]. ice_vsi_realloc_stat_arrays()
dereferences that entry unconditionally, and ice_vsi_rebuild() calls it
before anything else, so the NULL is not filtered out anywhere.

The path is live. ice_prepare_for_reset() removes the queue channels only
for resets other than a PFR, so a PFR leaves the channel VSIs in place,
and ice_rebuild() then calls ice_rebuild_channels(), which rebuilds every
ICE_VSI_CHNL VSI it finds. A PF reset with ADQ (mqprio hardware offload)
configured thus dereferences NULL.

That combination is reset recovery on top of an active mqprio offload,
which is why it went unnoticed. It was found while refactoring this code,
not reported by a user.

I'm leaning towards removing our limited (compared to OOT ADQ) support,
but it's outside of this series. Bug could be triggered by:

  tc qdisc del dev "$IF" root 2>/dev/null || true
  tc qdisc add dev "$IF" root mqprio num_tc 2 \
    map 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 \
    queues 2@0 2@2 hw 1 mode channel
  sleep 3
  ethtool --reset "$IF" irq dma filter offload

Workqueue: ice ice_service_task [ice]
RIP: 0010:ice_vsi_rebuild+0x289/0x380 [ice]
 ice_rebuild_channels+0xd6/0x320 [ice]
 ice_rebuild+0x4f6/0x540 [ice]
 ice_do_reset+0x9f/0x1a0 [ice]
 ice_service_task+0x4a/0x460 [ice]

Fixes: 5995ef88e3a8 ("ice: realloc VSI stats arrays")
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Link: https://patch.msgid.link/20260925132636.123300-2-przemyslaw.kitszel@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 7d982a2b001c4..5505cdb131cdb 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2961,6 +2961,10 @@ ice_vsi_realloc_stat_arrays(struct ice_vsi *vsi)
 	u16 prev_rxq = vsi->alloc_rxq;
 	int i;
 
+	/* channel VSIs have no entry in pf->vsi_stats[] */
+	if (vsi->type == ICE_VSI_CHNL)
+		return 0;
+
 	vsi_stat = pf->vsi_stats[vsi->idx];
 
 	if (req_txq < prev_txq) {
-- 
2.53.0



