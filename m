Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017995;
	b=rK5/t7dvDOntYwJEElQWOo6Sty8v2iUWBAPuG2TcxZcsFKcvcp//W378aikn233uKVMo
	 zDKBEvshFPxbve4RDuqmiMGIO8uFVpp0wl6saBDV70KS5/BdlcCg1qwSNsaIygnel112B
	 8dI7xDS76zSbCCs2+SAcDRE879NaiWl5Hm/YKQng+fQuGI9U3D9/Q5eFIKkJ6azAhU6PN
	 Dch+OdTSWvVaU5LyHPKZuN8dHJpWi9UOKor84QvpWd9PGtqrFOInE2B9xmYkc0R0O+OW3
	 eDxYhKiDc4jkToxmc5DND2Ts9c7Jd36sKdl9m6xjatJcm/0C6P/bdGsdwsRbmjgHUdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Aa4Q8uwya315zGq0jZUpAEiGzDKjyND2juHfzTWIlXg=;
	b=VBRo4py4FomhpivR6G8XI+CSNKc3tQqUITWe3+5oKUaYKD3galZE6PRkizgV7HRJ5gM7
	 nZaeZD9frbVJYILeMxwGzRekibJzSBval3OHArBUbPOYZw9GxO5NHyZp+++C27KVWQG1F
	 Q2536Wh/uwcgrxEXLnUJhm3rvl8FVANeaMqgVMv94R1uPdNnwTUCjqn4Y/TDmPp9zX2j8
	 GaAV67lx0M5lBijOlJ68eePXQouBEdzOk/RavV0++/WrANWtZMVwmcKlcSryxObW5lh/j
	 x+nvVUFEw4DNsQfS1ERhwEITBPtVq1aF5OM5H7bq9ZuDdpx/O7uk9FB36DU1NsPNxJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PwaD91+m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8F1606A320;
	Wed, 18 Nov 2026 16:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PwaD91+m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3697A1F000C4;
	Wed, 18 Nov 2026 16:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017995;
	bh=Aa4Q8uwya315zGq0jZUpAEiGzDKjyND2juHfzTWIlXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PwaD91+mtxhRRgpNKCzZW4GcmmQ9/vxWOPEKvANT7ov+5xi5iERvlNYBcoy4EPY8o
	 O/XAuiSPVThuddd3V1OKc/1uTpZTN1ew1SYhsLFJbXx84H67dw5q47fdq8SB8jVZka
	 zTeuKL4l7gIJe2KbP7iF/xajsUgvbeNXOdAWKuK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1081/2651] ice: skip stats handling for channel VSIs on rebuild
Date: Wed, 18 Nov 2026 15:38:41 +0100
Message-ID: <20261118150326.912606691@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 9e08db376d3d0..31af378aa0e7a 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3031,6 +3031,10 @@ ice_vsi_realloc_stat_arrays(struct ice_vsi *vsi)
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



