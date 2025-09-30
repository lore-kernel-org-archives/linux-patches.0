Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C5A2264AB;
	Tue, 30 Sep 2025 14:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243964; cv=none; b=hbi8o4EoAUfXnj5UQeNCTtGCEipThYOVZ12a8qc2zjCwiZfZtoYZEjUG+6PI6XDy0vtmTMfxqBLR59PfykHOJOC1IHaTlX1nV2LQH7Tjam5KsW7lltFEiStH3k8dNRl+rkp3Ue/aT0J5QZLeLxhPT00hS/19U0Y72uuF4MoaZDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243964; c=relaxed/simple;
	bh=EWTqoFpxtN6EOgrkvulWkMQoV0CbXSw5sEkIUafdZvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DuCSEJBLTPut8nPQpdNpyCBZzYCNTvGet+iXT6gOSzt/krdEKWwI0OQecp0yvHCnblT076oRcWxPkcUXqh9RBLivjEpmWXdwGFCLuPFtc9VgV4VoeIHNKP8ioXxYo5fXC8RrpKkUePxDPYnK7zygF7szRwgHMwm6mHLVKzG0bPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=plkYlbpj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="plkYlbpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE90DC4CEF0;
	Tue, 30 Sep 2025 14:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243964;
	bh=EWTqoFpxtN6EOgrkvulWkMQoV0CbXSw5sEkIUafdZvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plkYlbpjOIzGRmOHB2WWDlLKmKl8+2uMwCH2oha8A7hy3qA2AAkvqAlpE+tcIjYEQ
	 NV9v9jzqOpqXSrJGGZrKpbkK3KBa8y68+SMRzfdM8DqVlU31c0J572ZKBHNzFsabGY
	 6y5A+KxiHLtvvIUKPgW4hXtgtCdDhlRHO/1C2hVw=
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
Subject: [PATCH 5.4 70/81] i40e: fix idx validation in i40e_validate_queue_map
Date: Tue, 30 Sep 2025 16:47:12 +0200
Message-ID: <20250930143822.626244346@linuxfoundation.org>
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

commit aa68d3c3ac8d1dcec40d52ae27e39f6d32207009 upstream.

Ensure idx is within range of active/initialized TCs when iterating over
vf->ch[idx] in i40e_validate_queue_map().

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
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2376,8 +2376,10 @@ static int i40e_validate_queue_map(struc
 	u16 vsi_queue_id, queue_id;
 
 	for_each_set_bit(vsi_queue_id, &queuemap, I40E_MAX_VSI_QP) {
-		if (vf->adq_enabled) {
-			vsi_id = vf->ch[vsi_queue_id / I40E_MAX_VF_VSI].vsi_id;
+		u16 idx = vsi_queue_id / I40E_MAX_VF_VSI;
+
+		if (vf->adq_enabled && idx < vf->num_tc) {
+			vsi_id = vf->ch[idx].vsi_id;
 			queue_id = (vsi_queue_id % I40E_DEFAULT_QUEUES_PER_VF);
 		} else {
 			queue_id = vsi_queue_id;


