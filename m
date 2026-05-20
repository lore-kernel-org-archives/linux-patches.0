Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83A33F0A83;
	Wed, 20 May 2026 17:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299665; cv=none; b=QBEm9fF1wnUptCMOKnZCIS+DVlK0eF6f1I9c0OfMys15kH8SDs53G+mKlsf5wLciiqRTZ0wSv1uQv0O5je6Rb6cndqCK5T1lWb+Q/4E9hPs6EAsq/Twm+vgSbnOivM79ccoj0Do67Ral0s1tZmkui6c98ezHDUr607YOhSF8RNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299665; c=relaxed/simple;
	bh=/Mp6kZPzz1cO1tJEin+HrkFJvMnrP/0w4yj3624xYMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnJhSkDJoriAm20vIiOWeXE/fN9lLZvbtdB3PB3e9cMdunClAlf42h2B8OzWhweCzcsM0OiKlYdU0wjfXl+rDlP0AMWXALgXzAZ8vGHgdehuy8QrE3nIPVnLCqjQM+HHn5QWj6Q3U87Vke6WiGS6cQJY7tDbDsBCaJlBOvQOCps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iNwRfK/y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iNwRfK/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487281F000E9;
	Wed, 20 May 2026 17:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299663;
	bh=Xe5JX+Dk2xVu+7u0UfF3UnozZuIeSX3nwBr30Snh8sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iNwRfK/yBYhV1hNebu8fXCWRVrEpg9C9nCmDO2+ty/Ai3WlZJSO8Fm1PzFqT0xot+
	 DE/7Z1E+X2QBE88f1W3DLEwnrnCc9Or4vnHk3PkZ0IsX5mkwXETDYp5LP/mW7TYpiO
	 LcW/uVPrJL0fzAGeAizcurJb63VI5h6NB1uvCmys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Simon Horman <horms@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 841/957] iavf: rename IAVF_VLAN_IS_NEW to IAVF_VLAN_ADDING
Date: Wed, 20 May 2026 18:22:04 +0200
Message-ID: <20260520162152.801361758@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Oros <poros@redhat.com>

[ Upstream commit 70d62b669f1f9080a25278fc90b64309f4ae8959 ]

Rename the IAVF_VLAN_IS_NEW state to IAVF_VLAN_ADDING to better
describe what the state represents: an ADD request has been sent to
the PF and is waiting for a response.

This is a pure rename with no behavioral change, preparing for a
cleanup of the VLAN filter state machine.

Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260427-jk-iwl-net-petr-oros-fixes-v1-1-cdcb48303fd8@intel.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: f2ce65b9b917 ("iavf: stop removing VLAN filters from PF on interface down")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf.h          | 2 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index e9fb0a0919e37..47a862ca5e2c3 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -158,7 +158,7 @@ struct iavf_vlan {
 enum iavf_vlan_state_t {
 	IAVF_VLAN_INVALID,
 	IAVF_VLAN_ADD,		/* filter needs to be added */
-	IAVF_VLAN_IS_NEW,	/* filter is new, wait for PF answer */
+	IAVF_VLAN_ADDING,	/* ADD sent to PF, waiting for response */
 	IAVF_VLAN_ACTIVE,	/* filter is accepted by PF */
 	IAVF_VLAN_DISABLE,	/* filter needs to be deleted by PF, then marked INACTIVE */
 	IAVF_VLAN_INACTIVE,	/* filter is inactive, we are in IFF_DOWN */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index 291b21230b65f..9dab61f198c0d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -746,7 +746,7 @@ static void iavf_vlan_add_reject(struct iavf_adapter *adapter)
 
 	spin_lock_bh(&adapter->mac_vlan_list_lock);
 	list_for_each_entry_safe(f, ftmp, &adapter->vlan_filter_list, list) {
-		if (f->state == IAVF_VLAN_IS_NEW) {
+		if (f->state == IAVF_VLAN_ADDING) {
 			list_del(&f->list);
 			kfree(f);
 			adapter->num_vlan_filters--;
@@ -811,7 +811,7 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 			if (f->state == IAVF_VLAN_ADD) {
 				vvfl->vlan_id[i] = f->vlan.vid;
 				i++;
-				f->state = IAVF_VLAN_IS_NEW;
+				f->state = IAVF_VLAN_ADDING;
 				if (i == count)
 					break;
 			}
@@ -872,7 +872,7 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 				vlan->tpid = f->vlan.tpid;
 
 				i++;
-				f->state = IAVF_VLAN_IS_NEW;
+				f->state = IAVF_VLAN_ADDING;
 			}
 		}
 
@@ -2906,7 +2906,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 
 		spin_lock_bh(&adapter->mac_vlan_list_lock);
 		list_for_each_entry(f, &adapter->vlan_filter_list, list) {
-			if (f->state == IAVF_VLAN_IS_NEW)
+			if (f->state == IAVF_VLAN_ADDING)
 				f->state = IAVF_VLAN_ACTIVE;
 		}
 		spin_unlock_bh(&adapter->mac_vlan_list_lock);
-- 
2.53.0



