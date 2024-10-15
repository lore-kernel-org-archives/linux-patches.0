Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72EE1D0492;
	Tue, 15 Oct 2024 11:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993430; cv=none; b=GNMxwU+6aoPmfhyG0a2pA7XVQx7N3NTU8aMIGN5HS/vnH8eG3j1e71tHI6r9GVx2x3JcI7IHqmfB+G6xLjvYBU2hj/TjV8E6wV/iangrFcqWlT4q4/3Ktu9cO8NODEI2Y3FEq6pUdy/ca8FrMBzCQu7Q/DUsBuYf2gCOpCeGvzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993430; c=relaxed/simple;
	bh=nBHC2PMgITlShHTFCy9yldRTpEd780zV7ChpoJ2W6bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/+kZFsP3cmvMuLFPXlu+54WHrlXyoFE3S63MCSpMDB+9FjyCad5wvGi0/FaqDxMskAHC9tHuwNLyNEEJHlvjIkYJ4rMxaHE47k0sM/VNBFhKHnhFEXxZWd2eKevSwrqTPjSXZX1Ap5iuKtxoPmmVYVZwgU3lYjQLVgbV82MZiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekPjRdu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekPjRdu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E61C4CEC6;
	Tue, 15 Oct 2024 11:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993430;
	bh=nBHC2PMgITlShHTFCy9yldRTpEd780zV7ChpoJ2W6bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekPjRdu+ScUxwHKXraHPajZmBtQD6e912fP52yJGW9/aloc/ginYYtb20AhGx+0h+
	 2b5kTbLehgzD2aCXeJwiwCf+F1sHIOxK+AZO+hKXcriujkTh8qNg/mgHRSI7NbI9y1
	 08f948rDQ1O6zfNvi7wNWqPsu/rxp2o1SZ59dNlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 5.15 409/691] ice: Adjust over allocation of memory in ice_sched_add_root_node() and ice_sched_add_node()
Date: Tue, 15 Oct 2024 13:25:57 +0200
Message-ID: <20241015112456.577150347@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit 62fdaf9e8056e9a9e6fe63aa9c816ec2122d60c6 ]

In ice_sched_add_root_node() and ice_sched_add_node() there are calls to
devm_kcalloc() in order to allocate memory for array of pointers to
'ice_sched_node' structure. But incorrect types are used as sizeof()
arguments in these calls (structures instead of pointers) which leads to
over allocation of memory.

Adjust over allocation of memory by correcting types in devm_kcalloc()
sizeof() arguments.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_sched.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index 0b61fde449152..209e3a9d9b7ab 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -27,9 +27,8 @@ ice_sched_add_root_node(struct ice_port_info *pi,
 	if (!root)
 		return ICE_ERR_NO_MEMORY;
 
-	/* coverity[suspicious_sizeof] */
 	root->children = devm_kcalloc(ice_hw_to_dev(hw), hw->max_children[0],
-				      sizeof(*root), GFP_KERNEL);
+				      sizeof(*root->children), GFP_KERNEL);
 	if (!root->children) {
 		devm_kfree(ice_hw_to_dev(hw), root);
 		return ICE_ERR_NO_MEMORY;
@@ -180,10 +179,9 @@ ice_sched_add_node(struct ice_port_info *pi, u8 layer,
 	if (!node)
 		return ICE_ERR_NO_MEMORY;
 	if (hw->max_children[layer]) {
-		/* coverity[suspicious_sizeof] */
 		node->children = devm_kcalloc(ice_hw_to_dev(hw),
 					      hw->max_children[layer],
-					      sizeof(*node), GFP_KERNEL);
+					      sizeof(*node->children), GFP_KERNEL);
 		if (!node->children) {
 			devm_kfree(ice_hw_to_dev(hw), node);
 			return ICE_ERR_NO_MEMORY;
-- 
2.43.0



