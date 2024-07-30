Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50501A76A4;
	Tue, 30 Jul 2024 17:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359802; cv=none; b=K1MIMtOwM4s5f8Gtralxf2pMLF2BRJmmyHGKdPw2gXl0mzQYPeNOAIkrayM75kbdG0o5Lwvxl/CBzXYjebWmOtU8BpNZq1SGkfAgmgJrvw7Bk9vYKyL0wCKQgIkz/TTLj7YMdn7FMkBJh2d0Iodt6GH6VVl5aLd9tsyX/gZe3sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359802; c=relaxed/simple;
	bh=BKolV4D9jRkK2M1Xj9zgzXHRwQrbRLmKlU1Xw1nbr88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwguwDcmNnYRPaA3mIAl6nYBV94HLpqP6ZTKSpg+Uv6iXCDDXtZRLTFMiz8IXcdUIjXAWzGzMUNCTkDYFUDqZ5etrigHKHem3upMg5RNZQqQUQDe+yHwzLVB+1wRiPxzKJI/q8GUZE3yuCWx2wcx2perdatMzotNMyoETHuGCR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XoDKOgFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XoDKOgFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4408CC32782;
	Tue, 30 Jul 2024 17:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359802;
	bh=BKolV4D9jRkK2M1Xj9zgzXHRwQrbRLmKlU1Xw1nbr88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XoDKOgFSF+3xh5DPsk2AlMJNWPJDdAdSjRq9Ig1YOGNhdm6MRzPCnR2q3ahzzBYKZ
	 +XhhQbM4hkrKTLME/4buiycVAcVEAP51Rx7N2qt/H+Q11qIXy+TYQLI98BavZT5hyv
	 zenJs5VXjVbvJyKMPSUYe++wCqXFaUnvtVMen/iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcin Szycik <marcin.szycik@linux.intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Simon Horman <horms@kernel.org>,
	Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 538/568] ice: Fix recipe read procedure
Date: Tue, 30 Jul 2024 17:50:45 +0200
Message-ID: <20240730151701.186305202@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wojciech Drewek <wojciech.drewek@intel.com>

[ Upstream commit 19abb9c2b900bad59e0a9818d6c83bb4cc875437 ]

When ice driver reads recipes from firmware information about
need_pass_l2 and allow_pass_l2 flags is not stored correctly.
Those flags are stored as one bit each in ice_sw_recipe structure.
Because of that, the result of checking a flag has to be casted to bool.
Note that the need_pass_l2 flag currently works correctly, because
it's stored in the first bit.

Fixes: bccd9bce29e0 ("ice: Add guard rule when creating FDB in switchdev")
Reviewed-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Sujai Buvaneswaran <sujai.buvaneswaran@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_switch.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index d2a2388d4fa0a..88ee2491312a5 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -2271,10 +2271,10 @@ ice_get_recp_frm_fw(struct ice_hw *hw, struct ice_sw_recipe *recps, u8 rid,
 		/* Propagate some data to the recipe database */
 		recps[idx].is_root = !!is_root;
 		recps[idx].priority = root_bufs.content.act_ctrl_fwd_priority;
-		recps[idx].need_pass_l2 = root_bufs.content.act_ctrl &
-					  ICE_AQ_RECIPE_ACT_NEED_PASS_L2;
-		recps[idx].allow_pass_l2 = root_bufs.content.act_ctrl &
-					   ICE_AQ_RECIPE_ACT_ALLOW_PASS_L2;
+		recps[idx].need_pass_l2 = !!(root_bufs.content.act_ctrl &
+					     ICE_AQ_RECIPE_ACT_NEED_PASS_L2);
+		recps[idx].allow_pass_l2 = !!(root_bufs.content.act_ctrl &
+					      ICE_AQ_RECIPE_ACT_ALLOW_PASS_L2);
 		bitmap_zero(recps[idx].res_idxs, ICE_MAX_FV_WORDS);
 		if (root_bufs.content.result_indx & ICE_AQ_RECIPE_RESULT_EN) {
 			recps[idx].chain_idx = root_bufs.content.result_indx &
-- 
2.43.0



