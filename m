Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175231EE02F;
	Tue, 30 Sep 2025 15:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246224; cv=none; b=mI+G+EIV62Gzok7+MAQ1gq91OhTA4JKsIES/VadebU3fp1jmAXTi5xYv0hBT8d/9ocbNZE6i7e6hBrOCTZJmcKfcrC9fmEcOX3ORwoN8fQpqlQo77eGywz11G5hK+p1yD3TN6+rzDXL71sXSX0Hp4Qd7Z/89NgmHDmNMvu/mUys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246224; c=relaxed/simple;
	bh=0f0n+iLkVO7WDQxuD5E/AJOrQBiRX5gSnk42rEN6xzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keyh32j6DpW98TUmvPpzqcahmwI3egeXVDJN9KGQG+PhRvdwNNFm1YPIn5rTs6PZVBatk2ELxEVJIabHV/irKkAWxw/+NAjzWY73prFvh/r86laEIzvJKKBnmQ2epZD4wSr/2AACb7c/hoF1Z+Sn3r90e7lANPrna56sDHNIanI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6eNjx8n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6eNjx8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9328AC4CEF0;
	Tue, 30 Sep 2025 15:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246224;
	bh=0f0n+iLkVO7WDQxuD5E/AJOrQBiRX5gSnk42rEN6xzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6eNjx8nxiZS+2koEL/EgOpYnKisCKD8idJ4a0NiVqkgWZCsv8HOGBwJ+RzgXaW42
	 lhmbQH2NXNAbffaW9tp2ZVBH2cPQuXtAP2vEcK7KnobBSnDO5GtvifFK8S14kCRwDP
	 LwZUXZ8nVmI1Kb6OHOgTmoqXgyA81aVMugvKO6Rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Czapnik <lukasz.czapnik@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Kamakshi Nellore <nellorex.kamakshi@intel.com>
Subject: [PATCH 6.12 69/89] i40e: fix idx validation in config queues msg
Date: Tue, 30 Sep 2025 16:48:23 +0200
Message-ID: <20250930143824.761673314@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Czapnik <lukasz.czapnik@intel.com>

commit f1ad24c5abe1eaef69158bac1405a74b3c365115 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2398,7 +2398,7 @@ static int i40e_vc_config_queues_msg(str
 		}
 
 		if (vf->adq_enabled) {
-			if (idx >= ARRAY_SIZE(vf->ch)) {
+			if (idx >= vf->num_tc) {
 				aq_ret = -ENODEV;
 				goto error_param;
 			}
@@ -2419,7 +2419,7 @@ static int i40e_vc_config_queues_msg(str
 		 * to its appropriate VSIs based on TC mapping
 		 */
 		if (vf->adq_enabled) {
-			if (idx >= ARRAY_SIZE(vf->ch)) {
+			if (idx >= vf->num_tc) {
 				aq_ret = -ENODEV;
 				goto error_param;
 			}


