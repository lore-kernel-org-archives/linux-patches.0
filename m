Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1139C14A4C7;
	Wed,  7 May 2025 18:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643431; cv=none; b=Vg9QRjEHC0Mu79ZHfmG/al5ggSTORiAr95n5n1DsSkre4u55Kz0skv8VZBhZXjQkTU15NnSDj/7gOy62OuAS8xjNZ2r1cTgDLrzlWjf1TwL/Mdxc+Vaib4IqyWzepYmEm0UcWFScY2bqSE7HSLBVV2DYO/iunx3Dfh9yRCoIv0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643431; c=relaxed/simple;
	bh=LT5JdDQQSfk9ElAvQez00u6dVsW7y+tKKP9rGJ3aVGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/7LEzFQAKsD4Zo0Q9N/ywWQIUNykic07stI4N5FZ6ekcaqKA9UjEIUW6SWA+KBWuJQQ0k2u4JSBH1Ep+S0vBev7bc7V17sRDMSlYCv+gJiHDjtJ7fKKwgRb8cV2ONAi7y/+c+UAByRoJrymioAy3/++WKiCqaRObksBdTg4Yrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSJIofXv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSJIofXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DFCC4CEE9;
	Wed,  7 May 2025 18:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643430;
	bh=LT5JdDQQSfk9ElAvQez00u6dVsW7y+tKKP9rGJ3aVGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSJIofXvzsI8vmiDf8mgj7CRYfkR4qTaAEEtSg84uo7oVOU3Nr923bN3zC+2qmkuB
	 632/Mo7q7A3ixaqE3q9yae4yLmgFamjjoxW6lgTxTMNR9RTPAt0YsNb6W+gD2lHAUa
	 qJWEEEygsQAN7Zj++SR6Av/hbDVcMyOSRxg+krK0=
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
Subject: [PATCH 5.15 28/55] ice: Check VF VSI Pointer Value in ice_vc_add_fdir_fltr()
Date: Wed,  7 May 2025 20:39:29 +0200
Message-ID: <20250507183800.175332154@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2ca8102e8f36e..3b87cc9dfd46e 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
@@ -2079,6 +2079,11 @@ int ice_vc_add_fdir_fltr(struct ice_vf *vf, u8 *msg)
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



