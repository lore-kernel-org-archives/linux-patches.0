Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3958F7D;
	Tue, 30 Sep 2025 14:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243991; cv=none; b=gkFdMq+tdMuESiPQU/hy3XIqFz/AT0VR1mejpSUBs0OHSlb7IRQpU6Cdra51Q+w7DkxJKvXrgo12Jmd3SuvANKDpFJZfyEM5OkLKp1yhlqCNeWc9bp54+pCQHMFiQZAdpaOBebC8Ns+DJXvCy8qjLHxviMorpkT8UCgKINhyd6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243991; c=relaxed/simple;
	bh=709BWBZhJCd+qc7HNP/yD21ZWt40rVqPZu/cWsPx6Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIqIDGyDntKCKgfR89I0YR1GaJz9V8HHl+SGxwnaCFCI0Y4yjaXQd4aKfj1thOLA2xx/skwdnZpMi5otp801KKcITyiztCaJvhjTeGJNfiWS0NnSoUml7wu+5TiTUTawxZEgy37tmYmxYCazAc+iaNyqMme0gRg5IVKgzvRzQ7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Akhb04Hd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Akhb04Hd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9F5C4CEF0;
	Tue, 30 Sep 2025 14:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243991;
	bh=709BWBZhJCd+qc7HNP/yD21ZWt40rVqPZu/cWsPx6Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Akhb04HdnQ9Hf8M+5duBv3iszYhIYijF65evTemAr0Tktr6OF9H9EBN3PG0PwXU+Q
	 Z5+fPtOiMeugTM/IOg5rfs20TzQuDmnMLtthKrlzxfLPklSaATXgWNCGWHt6QXsR9U
	 Lk/6QoIvNRNA8L4wy2F7S9OQm+CGAixgsfxsQM/g=
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
Subject: [PATCH 5.4 78/81] i40e: fix idx validation in config queues msg
Date: Tue, 30 Sep 2025 16:47:20 +0200
Message-ID: <20250930143822.981890745@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2320,7 +2320,7 @@ static int i40e_vc_config_queues_msg(str
 		}
 
 		if (vf->adq_enabled) {
-			if (idx >= ARRAY_SIZE(vf->ch)) {
+			if (idx >= vf->num_tc) {
 				aq_ret = I40E_ERR_NO_AVAILABLE_VSI;
 				goto error_param;
 			}
@@ -2341,7 +2341,7 @@ static int i40e_vc_config_queues_msg(str
 		 * to its appropriate VSIs based on TC mapping
 		 */
 		if (vf->adq_enabled) {
-			if (idx >= ARRAY_SIZE(vf->ch)) {
+			if (idx >= vf->num_tc) {
 				aq_ret = I40E_ERR_NO_AVAILABLE_VSI;
 				goto error_param;
 			}


