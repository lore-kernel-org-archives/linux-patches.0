Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837C028DF1B;
	Wed,  7 May 2025 19:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644693; cv=none; b=bKZiE9S6X+ZgWhmciafo8XVQstv8VfRrOaW24SKRLZWM9+1tzuiU60PC2dfsG9/M+1WFE3+VOt5RyIKM6Jfj7sXhLBENS5gGD3jvjY0DehCaO43GqCW1fsRUgjkxMT170FMVvQGJmoKgkJNZcvd2SZdSpgcqP66FWclVa4dH/QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644693; c=relaxed/simple;
	bh=BK1w7YqXCVu+SJoACqqKzMcBUYPG5IL+RCWe5ImO5rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIprWtpY4I5K8VaTxNCIbALUtQMZwjjM+F0xle+JvwQtBLwy25MRdnpOAfla4fulg+KeJNTQO/cbBBBLP2X5C0CkY+SZ2Ppu/1OtEAQ6/I7HLXAB5E+3RPdPtk58ZTwAfqGggyIr6qaa2OoTOTLsRxftyYCekYdBGGRJUEnyznc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=soBdHLI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="soBdHLI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B78C4CEE2;
	Wed,  7 May 2025 19:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644693;
	bh=BK1w7YqXCVu+SJoACqqKzMcBUYPG5IL+RCWe5ImO5rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=soBdHLI/4Yh9hjjM1rsNPVUkSqRyP9vPdBUevaYZjGQz0+HSdwVHgaiiTlIhRAPa2
	 OEJhEc8B9UapoJOTawo7g7Yz4hfVLIfw/qKumm0uOS7Es2z0Dl+OcvhDkcJdG9iNNg
	 rxM4yihLEhwtLC0RX3yfK67pIiOuiGMe8WkeDAaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/164] ice: Check VF VSI Pointer Value in ice_vc_add_fdir_fltr()
Date: Wed,  7 May 2025 20:39:40 +0200
Message-ID: <20250507183824.822790552@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

[ Upstream commit 425c5f266b2edeee0ce16fedd8466410cdcfcfe3 ]

As mentioned in the commit baeb705fd6a7 ("ice: always check VF VSI
pointer values"), we need to perform a null pointer check on the return
value of ice_get_vf_vsi() before using it.

Fixes: 6ebbe97a4881 ("ice: Add a per-VF limit on number of FDIR filters")
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20250425222636.3188441-3-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
index 14e3f0f89c78d..ef755cee64ca9 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -2091,6 +2091,11 @@ int ice_vc_add_fdir_fltr(struct ice_vf *vf, u8 *msg)
 	pf = vf->pf;
 	dev = ice_pf_to_dev(pf);
 	vf_vsi = ice_get_vf_vsi(vf);
+	if (!vf_vsi) {
+		dev_err(dev, "Can not get FDIR vf_vsi for VF %u\n", vf->vf_id);
+		v_ret = VIRTCHNL_STATUS_ERR_PARAM;
+		goto err_exit;
+	}
 
 #define ICE_VF_MAX_FDIR_FILTERS	128
 	if (!ice_fdir_num_avail_fltr(&pf->hw, vf_vsi) ||
-- 
2.39.5



