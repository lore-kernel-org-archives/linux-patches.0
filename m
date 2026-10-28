Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213462;
	b=y1RhZnTH1aaUEXP9kBSrPL38UvolxctV3jyfSGB80uLxBfp8cD4G2LZsMSmLqQZ8jLwM
	 4Od7UApQy6H4w2X6f0gjW5wPDdfSiZwzZbv/IGbmZJBrqgrzfxd9SO2xj19OJcVzglyoe
	 sDQoDl6bdhBhJSTzk9badMFPS19Z5+NA7zSC74T0IezDQV5xJWsAH2jiowe8yeqTZB5dF
	 L/6OGKvpwmDJ6rCaUUCu5j1mYg6sHDzcSF6OsqGCYMWBVfUwy7iLLB4jJW6AIRqoNtCSj
	 NeXyr91fzDbY55eSJo/c0pZKklOzhqTIPs17oYD54pAHkZMFsOtTWkGSwg1titL7bUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/LuXQus2Y5t1WgPqrUKU3u06tJQqrtJJmRaKfOE5cU4=;
	b=M4vngRfN5NbjyQuD7ALRgiisSgu6x8V5qk8/h/4qjn2k1bgI8jqOLGf1r8qVnT8/Hp3B
	 tFBFBE+jkZ45ZO2Swsc4hnkt54uHEw2tfN1t3G5anQDSSosPmbXBShKa3Dgd3aJ1AbFL8
	 6DWamoh+pvndhfkl93rYcyZLfvv2HLWGY5n8PecgHz8kyBe1FZLNk1MSxXh1qcbaPC1xn
	 P6UIW9BveAZfdAHnAuTJB2VcspbuOpLv4M5Y/sUVqAIudkHzJYXAvJlITC481b3lFD/jo
	 HrFK0ZD8blE6Sf2P1YMNpOgV6n/4nERcod5WhxPj8Q812oOLeMzZSD6YduVa4hYXYYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PoZlabuk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074E0606A31D;
	Wed, 28 Oct 2026 18:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PoZlabuk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571EE1F01825;
	Wed, 28 Oct 2026 18:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213461;
	bh=/LuXQus2Y5t1WgPqrUKU3u06tJQqrtJJmRaKfOE5cU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PoZlabuk8ybYbNjeC7pQQ6Ofolfck4jKDF5JurIcBfdFBOf0b0LdU/lI0x5RmgS3c
	 EkBIoUV8WDQzI1SmdkSIwgx+MbvWlSEgEDx3Q5gheSmo8Fe7KXIJXD4hFOy3tlwFc8
	 wl1Frxv9lIZ5W8RmM5NbGPBcDQz/d6Ud6bcE5Hc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0513/1887] ice: fix metadata_dst refcount handling on representor teardown
Date: Wed, 28 Oct 2026 17:43:29 +0100
Message-ID: <20261028170510.989112011@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 58858b8f14803a7eeac297b3ce20f3b21bf2ff66 ]

ice_eswitch_release_repr() uses metadata_dst_free() to release the
representor's metadata_dst.  metadata_dst_free() directly frees the
underlying memory without checking the dst_entry refcount.

When ice_eswitch_port_start_xmit() processes a packet, it takes a
reference via dst_hold() and attaches the metadata_dst to the skb.
If the representor is torn down while packets are still queued on
the lower device (e.g. in a qdisc), the metadata_dst is freed while
references are still held.

Use dst_release() instead, which correctly decrements the refcount
and only frees the object when all references are dropped.  The dst
subsystem already handles metadata_dst cleanup in dst_destroy() when
DST_METADATA is set.

Other drivers sharing this pattern (nfp, airoha, bnxt) already use
dst_release() for their metadata_dst lifecycle.

Fixes: f5396b8a663f7 ("ice: switchdev slow path")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260928230429.495442-5-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Adapted repr->dst access to vf->repr->dst in ice_eswitch_release_reprs(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_eswitch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_eswitch.c b/drivers/net/ethernet/intel/ice/ice_eswitch.c
index 7de4a8a4b563c..569d1b95ec1ef 100644
--- a/drivers/net/ethernet/intel/ice/ice_eswitch.c
+++ b/drivers/net/ethernet/intel/ice/ice_eswitch.c
@@ -235,7 +235,7 @@ ice_eswitch_release_reprs(struct ice_pf *pf, struct ice_vsi *ctrl_vsi)
 			continue;
 
 		ice_vsi_update_security(vsi, ice_vsi_ctx_set_antispoof);
-		metadata_dst_free(vf->repr->dst);
+		dst_release(&vf->repr->dst->dst);
 		vf->repr->dst = NULL;
 		ice_fltr_add_mac_and_broadcast(vsi, vf->hw_lan_addr.addr,
 					       ICE_FWD_TO_VSI);
-- 
2.53.0



