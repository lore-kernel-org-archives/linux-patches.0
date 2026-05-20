Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF0042EEB1;
	Wed, 20 May 2026 18:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302876; cv=none; b=NzGo5bbAy+G9dwCfq33YfsbHrOXwkvfl0cnEjYqa3e4PQ3LbrOjc5aJHRnobNNGDlG+N287R1a2+r4cWWd8zGDwvNcwzqy4g4M44xVU3weowBwl0758NlnmwtisplOPlTl2uesltxAnDge4yX0ERHAS3i5nxr7IdgHP/DiIwk9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302876; c=relaxed/simple;
	bh=NlK9FHA34MQG071iX/JSF4Z61kgHD6XFPaig2141iUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXJYyvU48V5G3kSg6jvCNyq7Dmpzh6GyGEGg95sTqYhWQeVYgnsxJv+epuuB40HrUmQcJ1NxKtGZfqQHXFruMbYFE/Ux8tdLJDk7fQUetk3qd6osW4Rhm9MHHhzQMNuSWj1Z1ZGLjKGcckzrkLmmik0LJEYn+gB6q2cXnfeDvGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFW/VK+L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFW/VK+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70471F000E9;
	Wed, 20 May 2026 18:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302872;
	bh=w456P9GOvQ1WXMzHPByHriHDBBd45LT6vxfFoytwHo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kFW/VK+LrsmsKDFstf7ij7vqlC5pS+1c5ZAX0Skfb797sTRJEzoPT7jUR+1Ge6Bbw
	 grEGHiTiPRxo9Co1GKauLPussalZsTYdbcatHZut2lFmjq8suiqXKgul5C+Dgdt5Yl
	 vO+JySaywjX1LvXsR+hcxUM5/LjytX+EJ7cf61TI=
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
Subject: [PATCH 6.6 430/508] iavf: rename IAVF_VLAN_IS_NEW to IAVF_VLAN_ADDING
Date: Wed, 20 May 2026 18:24:13 +0200
Message-ID: <20260520162107.918629559@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index 431d9d62c8c66..c09ec8cc1e9fb 100644
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
index b95a4f903204b..bc8285f77a7be 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -637,7 +637,7 @@ static void iavf_vlan_add_reject(struct iavf_adapter *adapter)
 
 	spin_lock_bh(&adapter->mac_vlan_list_lock);
 	list_for_each_entry_safe(f, ftmp, &adapter->vlan_filter_list, list) {
-		if (f->state == IAVF_VLAN_IS_NEW) {
+		if (f->state == IAVF_VLAN_ADDING) {
 			list_del(&f->list);
 			kfree(f);
 			adapter->num_vlan_filters--;
@@ -702,7 +702,7 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 			if (f->state == IAVF_VLAN_ADD) {
 				vvfl->vlan_id[i] = f->vlan.vid;
 				i++;
-				f->state = IAVF_VLAN_IS_NEW;
+				f->state = IAVF_VLAN_ADDING;
 				if (i == count)
 					break;
 			}
@@ -763,7 +763,7 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 				vlan->tpid = f->vlan.tpid;
 
 				i++;
-				f->state = IAVF_VLAN_IS_NEW;
+				f->state = IAVF_VLAN_ADDING;
 			}
 		}
 
@@ -2520,7 +2520,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 
 		spin_lock_bh(&adapter->mac_vlan_list_lock);
 		list_for_each_entry(f, &adapter->vlan_filter_list, list) {
-			if (f->state == IAVF_VLAN_IS_NEW)
+			if (f->state == IAVF_VLAN_ADDING)
 				f->state = IAVF_VLAN_ACTIVE;
 		}
 		spin_unlock_bh(&adapter->mac_vlan_list_lock);
-- 
2.53.0



