Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5474B16A956;
	Tue, 30 Sep 2025 15:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245901; cv=none; b=Lx6CGDqDY60XQvh6s9fAh6Bd1LH7F0pE+uCfo9kqWeRF/2/YBviRT6zx/lA5xMLoZ1JCDQWu0KZsH1ccMbEpUBPLEZMh3XsO6ENEjIuiWpPV/ZvfwVCitPp234j5jy8bItLSiKqXJTuU7sAEc3Z+pchd3/Omka+VenKJhkiaD8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245901; c=relaxed/simple;
	bh=V3nFhUNwQ4oTKTpOZXCdWLTAPaH4riSdmHnKk0+t5eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFl+qcKGnIR/gMFAppktsu3M2+nO45UBs1rWf0tW1sSc2UsDvQzqOdxaQ5h3lkwr/3HdePy/gb3ko4CaUKDbhHMzwKqGDUatpRMTxPG8I6peL0msW9k/GklKWdTJOt+HwRvlyUAjHIV/2ZPjGtMYUI1hdhsyw6sm/VZjQO4H6eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPUY8xMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPUY8xMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1D0C4CEF0;
	Tue, 30 Sep 2025 15:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245901;
	bh=V3nFhUNwQ4oTKTpOZXCdWLTAPaH4riSdmHnKk0+t5eE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rPUY8xMwsUEAyruVz42D48W4vU4m97oZhMbpR9bVRvGo/jnkDB+wobLmpNSrKfhCN
	 UqGJwn05wbKRbUJid4r7KPL5V+vIZisxBRDtC2cZ6Ypf6KNabmFc1i3KGPGHLDKoMI
	 wkUzDKo5biKSWYs6SGVV8s9JspJoHPcxOZXEw04M=
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
Subject: [PATCH 6.6 56/91] i40e: fix idx validation in i40e_validate_queue_map
Date: Tue, 30 Sep 2025 16:47:55 +0200
Message-ID: <20250930143823.515308446@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2461,8 +2461,10 @@ static int i40e_validate_queue_map(struc
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


