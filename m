Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DBA303CBF;
	Tue, 30 Sep 2025 15:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245635; cv=none; b=fiXttJLPXdrbyNOsgSUz6jmlzNkNc/z8VU4Kv1w+8r19zoUdV/J3Pbh4+qY0BZVPK9CaNUHrNLMxw3M0CVE2/uVCQXShoBc7XH8ESNHjIkhObcC4Z/ZbU5RCxD/AC7G/TJMabRDI5dXMs3NLr003D1FeJ9WsZNch/pQocg0BZhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245635; c=relaxed/simple;
	bh=Q0pmRuFUw98c1XHxRudACg5d2mgKFnyVNspCIiz32w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DV5e7yYtSA87kHiOuSz9O68uOlYcH/6Xxd5wvgR1xnDT1Pc9b/wnzazc2VnqT2Qm2j6kFs28/zLCSJ1hUJQc8/42nLs8AdBPHWd2yTVO8tpYhlVV4rWu80Zd4eUaK9Y6aU/98qtQ5izEtJYwR86Cz7coKgkP2/kcwvSbTHcwtVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sH2XUkSX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sH2XUkSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF35FC4CEF0;
	Tue, 30 Sep 2025 15:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245635;
	bh=Q0pmRuFUw98c1XHxRudACg5d2mgKFnyVNspCIiz32w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sH2XUkSX8N6/QCCqfa2DkTF9Zc2pY/Jm1nLVrFfkfiK0A0wQN83309qqkXxkRHFfo
	 e+b/3jllN6DjxY/O5Lc0dtbb66zyYsnnuexrC06YOSthNfzc716KnLD1WGIgNP96Zk
	 VhzhCsN3aKks8x2po3bKpdlFgY01v6UfsyZAzGew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Czapnik <lukasz.czapnik@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Kamakshi Nellore <nellorex.kamakshi@intel.com>
Subject: [PATCH 6.1 67/73] i40e: fix idx validation in config queues msg
Date: Tue, 30 Sep 2025 16:48:11 +0200
Message-ID: <20250930143823.458040981@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Czapnik <lukasz.czapnik@intel.com>

[ Upstream commit f1ad24c5abe1eaef69158bac1405a74b3c365115 ]

Ensure idx is within range of active/initialized TCs when iterating over
vf->ch[idx] in i40e_vc_config_queues_msg().

Fixes: c27eac48160d ("i40e: Enable ADq and create queue channel/s on VF")
Cc: stable@vger.kernel.org
Signed-off-by: Lukasz Czapnik <lukasz.czapnik@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Kamakshi Nellore <nellorex.kamakshi@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2391,7 +2391,7 @@ static int i40e_vc_config_queues_msg(str
 		}
 
 		if (vf->adq_enabled) {
-			if (idx >= ARRAY_SIZE(vf->ch)) {
+			if (idx >= vf->num_tc) {
 				aq_ret = I40E_ERR_NO_AVAILABLE_VSI;
 				goto error_param;
 			}
@@ -2412,7 +2412,7 @@ static int i40e_vc_config_queues_msg(str
 		 * to its appropriate VSIs based on TC mapping
 		 */
 		if (vf->adq_enabled) {
-			if (idx >= ARRAY_SIZE(vf->ch)) {
+			if (idx >= vf->num_tc) {
 				aq_ret = I40E_ERR_NO_AVAILABLE_VSI;
 				goto error_param;
 			}


