Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410FD340298;
	Sat, 30 May 2026 17:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161976; cv=none; b=hv0VFnVg7GOwn4qHrEvozyBdirAJkjuL0BZiWpqk/vvV4zuJ8lsmHMTDKf6UKtcED0rFV/G8zJr6qVAgEW192h03byflcZ8rt3HP+g7Y7Mdna2139dIl4uuxaJjCAvwjCb67vPmW/nNZRieaMqXPfDTA6ltzKOXyRp8ssO2h4vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161976; c=relaxed/simple;
	bh=MOmqbrPqqUpX8Mii61zpTd1jliRkOt3aNBRi1kyyAtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y58G5ATknGWNRTWTYV2YSdhqum3KYmBXznaN9Ea5IRbfAF/PoU/xddHIuxG6zqlqYXQE7+KX/9CZRGx3mfuJw7N7CLuAbM4y/A3e1hQwr5BZ9sAvtm3Lg+04FZuU3qMmbesVO/uv7stEqX5dCYCIzMTNHDVr6KT9djbSOOmr4GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kaCNjtGi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kaCNjtGi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F3C1F00893;
	Sat, 30 May 2026 17:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161975;
	bh=FcO7MQMxa/pzm+U+7pUb+AvDhL7iw2zS/Iq5ZofrPa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kaCNjtGiWXiTg8jD9a3xVYjDfVU6yBXbquxBSLLQL0gYavOAarr3t+RZYkfExQgpy
	 POZZ9qL7ZtrGKZON9LvCenPA/wM5gEyF1GJpcvIHKiHbrRoEhSR+SEVoj2Bv/dHzyW
	 sJTuSmEPjBsAaM23w/pz6V8/AXQtBe7KoR1JYOBk=
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
Subject: [PATCH 6.1 783/969] iavf: rename IAVF_VLAN_IS_NEW to IAVF_VLAN_ADDING
Date: Sat, 30 May 2026 18:05:07 +0200
Message-ID: <20260530160322.221598392@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index ee0871d929302..64309bf18ef74 100644
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
index 951ef350323a2..de01edc5df79b 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -642,7 +642,7 @@ static void iavf_vlan_add_reject(struct iavf_adapter *adapter)
 
 	spin_lock_bh(&adapter->mac_vlan_list_lock);
 	list_for_each_entry_safe(f, ftmp, &adapter->vlan_filter_list, list) {
-		if (f->state == IAVF_VLAN_IS_NEW) {
+		if (f->state == IAVF_VLAN_ADDING) {
 			list_del(&f->list);
 			kfree(f);
 			adapter->num_vlan_filters--;
@@ -707,7 +707,7 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 			if (f->state == IAVF_VLAN_ADD) {
 				vvfl->vlan_id[i] = f->vlan.vid;
 				i++;
-				f->state = IAVF_VLAN_IS_NEW;
+				f->state = IAVF_VLAN_ADDING;
 				if (i == count)
 					break;
 			}
@@ -771,7 +771,7 @@ void iavf_add_vlans(struct iavf_adapter *adapter)
 				vlan->tpid = f->vlan.tpid;
 
 				i++;
-				f->state = IAVF_VLAN_IS_NEW;
+				f->state = IAVF_VLAN_ADDING;
 			}
 		}
 
@@ -2535,7 +2535,7 @@ void iavf_virtchnl_completion(struct iavf_adapter *adapter,
 
 		spin_lock_bh(&adapter->mac_vlan_list_lock);
 		list_for_each_entry(f, &adapter->vlan_filter_list, list) {
-			if (f->state == IAVF_VLAN_IS_NEW)
+			if (f->state == IAVF_VLAN_ADDING)
 				f->state = IAVF_VLAN_ACTIVE;
 		}
 		spin_unlock_bh(&adapter->mac_vlan_list_lock);
-- 
2.53.0



