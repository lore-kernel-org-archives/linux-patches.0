Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040510;
	b=N4WowY60bvCHbAutNV2pk1BahJnaa1EdstKStWmK+5xKWb56/wvnBeDPeEHY0ls4XhvF
	 09da5WOwq86LWlB9oXAzqZ+w5KtfT+Q7wVPBuaryQSvuYG3j1g0hf4epc0/+JszFi4Pjr
	 y8sR6HtfCt9DTqCQR7NIKtL/HQpz7tsSsHf2VAWvvvGrZLL5NiyHbRlAP/zF5S2zyIRgY
	 1sNkD5YpOmoAbm7rc+vDiSGEm23yzG99rR9OLsOe4oiFyxsCEkNeWlIZIl761lNmHnfOW
	 ZzV1QbEtM2VV0Mgq+TGZgvw4PeNjWQCDutmoq+BO2G1kVeS7Q+ugRumUehcn/EuPE0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a7Q43QlRU+6Z6rhant3spiveUA1xkmZ/ejUcSVIcOg4=;
	b=ebqcgTPgRTKkTK3B8m/bUdkzzVu2sDhnNd6Vxy/lx/1Ks/2QayWRi82YD1UvvEsRkSdL
	 ENqH5+Meo61Y6XsmipqmdEB67RLier4t7jBWmm6FP1NsHDlYu3HbMts+MPeD/B/hUjGwo
	 Gaypcukw2J9lk2X1o/YCwo8FbWlXtIijLYdWw/FiYME7qJq1RnrU4AcKiaOonhu0MVcmW
	 okIoupsS6+F0lAF5SHqytVu7lJWO570hD7FL6H4/BH+NLNspvufifPlPs1iZt1Ru4FXO0
	 L6aXpNyrBrxihBln/TgSmccxmbGglbSOfCbImTv2I6OdnVpLQa3NHcUfQV2yomawmoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e3Wj8lJr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C032C606A325;
	Wed, 18 Nov 2026 22:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e3Wj8lJr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E8E1F000C4;
	Wed, 18 Nov 2026 22:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040510;
	bh=a7Q43QlRU+6Z6rhant3spiveUA1xkmZ/ejUcSVIcOg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e3Wj8lJrkNnNMSswoVoL5Pko0eRiFmUzA7FXwYwveHNZDBHSALwkReMJy5yDtSMNv
	 H8TqMIkekebdRCK1gCnHuiO+1ldPSvmOZPWhJx4sUaoz0U73ORi3tLXLaYat8PsWNs
	 UiHWg+kDLY6owu/vVGFoa7eW/IRtZMNrEhdlpV7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2482/3318] ice: skip stats handling for channel VSIs on rebuild
Date: Wed, 18 Nov 2026 15:51:44 +0100
Message-ID: <20261118150435.869879485@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3af3fc401331e..8e957adde1ace 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3106,6 +3106,10 @@ ice_vsi_realloc_stat_arrays(struct ice_vsi *vsi)
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



