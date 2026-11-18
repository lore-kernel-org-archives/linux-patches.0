Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024983;
	b=L9IwmCPd5biMlsDXnzd5v8Auuq47EmpFtCgKzzlpCuxLdfrd6pl09V0lX1rS+cuJp3Oc
	 vSasAFKpwWuu6bUPTVufVVJjcSo2SaCxW3+i7Ez6KIdlMZTILTVOmqdPPVdsp8ylFwEO6
	 J6kXf3HGGJRfooM8Z6snUfiEhJzLhQ/d6kOgrV+DbIZVkf/iOqqbdgjQUkUx9BDOEsThj
	 Vl6AbKpZb4vEox0Ua/SWc+S+Y6inCJ3zr5hIc9GcMpHVn+zzMeqwpfADVatScWKuDwwdB
	 /QEvEVwxADQSRfiM/T8/VwNdDeGzU8yp8ky3L/VioiRVMpokmLG1F6z+EtS/ChuEGfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e5QuKuQAAzlr2Q2FM1PmWvtU6Sr6i2zPbKpzHM8/eXU=;
	b=JWJolEd0RDxUjbzbtKrr9t5345xo3ZHc63KV6Ad7GOk252df4WWe5wqjSDrS5+zbnWsv
	 Mqz0ehaengeXiHtlFG/DrI/UBfwW2naeyAZk7dNCsFv/2+u6EiQr1AA8jybdkPAY0yL2e
	 lpod4/1Y+2u+7+HuEXl0OD8y2EHPxfeRndumlmWx9jLLp4LqUvP09/N9EpuVxV50D1/hH
	 zoPnKrDxVnn/NM7dkyqVk4InxEL3h5+HJqU6A1gvvdBNu1nFgh4np43vJHhjVgQ2xMayB
	 px3S+U+ZjmhJezosqYTxIj8OeII3589V6M4Xlmr+C1XvUn/lTmEXV8ICHupSS6k2uyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ydGyzXsx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1293606A31C;
	Wed, 18 Nov 2026 18:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ydGyzXsx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7B11F000C4;
	Wed, 18 Nov 2026 18:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024982;
	bh=e5QuKuQAAzlr2Q2FM1PmWvtU6Sr6i2zPbKpzHM8/eXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ydGyzXsxhJR8ymOtCWSOCqTq0tmTFQ3bAoP1NvSGKZZhLhjNfXXqWXIcX6OIQVigh
	 Bl1hnF9IDGRvPDEhPZ162+EoWV8qlUCF4wORkW12UNLtcYkYSGS6rdDQNc5KgRwQ16
	 edudKlSFkX5o9B148wiaOev5ygdD688qMyjiugcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0911/2151] ice: skip stats handling for channel VSIs on rebuild
Date: Wed, 18 Nov 2026 15:44:06 +0100
Message-ID: <20261118150155.570012426@linuxfoundation.org>
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
index 80eb5c9f8a9b4..209a7c8580f2e 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3029,6 +3029,10 @@ ice_vsi_realloc_stat_arrays(struct ice_vsi *vsi)
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



