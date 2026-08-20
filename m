Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CDD46D2C9;
	Thu, 20 Aug 2026 17:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247599; cv=none; b=qEY/USMYe/KIakHmMSvoengCDCNzho4jTByWR9QCw3JNTLPsxg8UcQCLXqsbhqBmHrw+e8b/QMOMWztwqjmHsx2TGKEn92N/tPI7RN4/3bbrjalQqcY9UfCazvvmG/PJXLWJZfQofBZp6v7NjWyZJAcR32TwGqKIFsDovwpvkMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247599; c=relaxed/simple;
	bh=1UPxVZ+mONgD0jeZt/bFgQCg6W7evs3qWSpwFObEiJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igTA4KwhZVFu5tRq5KpTEtpemOYYpoxI8uLmaHUKS8ZFHcmIwP3sDgGbgk9UXBgwDmLJ/N/fF5SKQgClcWUgqEYozpZhGbU1ksNcGyOn8voTmKtA5pEO+bHMF+r1oQfV52f03qf+m3HzVNGbiyFKYxOwkVbiBG/r4aINDimvTVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=icuiL/JT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="icuiL/JT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F181F000E9;
	Thu, 20 Aug 2026 17:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247598;
	bh=4muUKYmQD2/IQv1VBs2AyKuwOGka+hl8lVlEUzDrojw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=icuiL/JTPyn6P2kYsHO4eqBaznxbwDtoD4xas1+oaJ8p+OQCz1uM3cZ54Se67J71z
	 /s5wMKccUmubLVvP9DTNcbbcjDdfXJZijmjORo8HHlylJ8oY8IdWv7OMDt974y7XMQ
	 To/GJxQroonqbhgk8ZLR4hadXmMZOE/O6m5Ii7YE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 102/166] ice: make use of DEFINE_FLEX() in ice_switch.c
Date: Thu, 20 Aug 2026 16:56:01 +0200
Message-ID: <20260820145214.229710469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

[ Upstream commit e268b972270567e0414836919c5b9f8bc01651a4 ]

Use DEFINE_FLEX() macro for 1-elem flex array members of ice_switch.c

Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Link: https://lore.kernel.org/r/20230912115937.1645707-8-przemyslaw.kitszel@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: cdc36db204ff ("Bluetooth: hci_sync: Fix advertising data UAFs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_switch.c |   63 ++++++----------------------
 1 file changed, 14 insertions(+), 49 deletions(-)

--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -1812,15 +1812,11 @@ ice_aq_alloc_free_vsi_list(struct ice_hw
 			   enum ice_sw_lkup_type lkup_type,
 			   enum ice_adminq_opc opc)
 {
-	struct ice_aqc_alloc_free_res_elem *sw_buf;
+	DEFINE_FLEX(struct ice_aqc_alloc_free_res_elem, sw_buf, elem, 1);
+	u16 buf_len = __struct_size(sw_buf);
 	struct ice_aqc_res_elem *vsi_ele;
-	u16 buf_len;
 	int status;
 
-	buf_len = struct_size(sw_buf, elem, 1);
-	sw_buf = devm_kzalloc(ice_hw_to_dev(hw), buf_len, GFP_KERNEL);
-	if (!sw_buf)
-		return -ENOMEM;
 	sw_buf->num_elems = cpu_to_le16(1);
 
 	if (lkup_type == ICE_SW_LKUP_MAC ||
@@ -1841,8 +1837,7 @@ ice_aq_alloc_free_vsi_list(struct ice_hw
 			sw_buf->res_type =
 				cpu_to_le16(ICE_AQC_RES_TYPE_VSI_LIST_PRUNE);
 	} else {
-		status = -EINVAL;
-		goto ice_aq_alloc_free_vsi_list_exit;
+		return -EINVAL;
 	}
 
 	if (opc == ice_aqc_opc_free_res)
@@ -1850,16 +1845,14 @@ ice_aq_alloc_free_vsi_list(struct ice_hw
 
 	status = ice_aq_alloc_free_res(hw, sw_buf, buf_len, opc);
 	if (status)
-		goto ice_aq_alloc_free_vsi_list_exit;
+		return status;
 
 	if (opc == ice_aqc_opc_alloc_res) {
 		vsi_ele = &sw_buf->elem[0];
 		*vsi_list_id = le16_to_cpu(vsi_ele->e.sw_resp);
 	}
 
-ice_aq_alloc_free_vsi_list_exit:
-	devm_kfree(ice_hw_to_dev(hw), sw_buf);
-	return status;
+	return 0;
 }
 
 /**
@@ -2089,15 +2082,10 @@ ice_aq_get_recipe_to_profile(struct ice_
  */
 int ice_alloc_recipe(struct ice_hw *hw, u16 *rid)
 {
-	struct ice_aqc_alloc_free_res_elem *sw_buf;
-	u16 buf_len;
+	DEFINE_FLEX(struct ice_aqc_alloc_free_res_elem, sw_buf, elem, 1);
+	u16 buf_len = __struct_size(sw_buf);
 	int status;
 
-	buf_len = struct_size(sw_buf, elem, 1);
-	sw_buf = kzalloc(buf_len, GFP_KERNEL);
-	if (!sw_buf)
-		return -ENOMEM;
-
 	sw_buf->num_elems = cpu_to_le16(1);
 	sw_buf->res_type = cpu_to_le16((ICE_AQC_RES_TYPE_RECIPE <<
 					ICE_AQC_RES_TYPE_S) |
@@ -2106,7 +2094,6 @@ int ice_alloc_recipe(struct ice_hw *hw,
 				       ice_aqc_opc_alloc_res);
 	if (!status)
 		*rid = le16_to_cpu(sw_buf->elem[0].e.sw_resp);
-	kfree(sw_buf);
 
 	return status;
 }
@@ -4438,28 +4425,19 @@ int
 ice_alloc_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
 		   u16 *counter_id)
 {
-	struct ice_aqc_alloc_free_res_elem *buf;
-	u16 buf_len;
+	DEFINE_FLEX(struct ice_aqc_alloc_free_res_elem, buf, elem, 1);
+	u16 buf_len = __struct_size(buf);
 	int status;
 
-	/* Allocate resource */
-	buf_len = struct_size(buf, elem, 1);
-	buf = kzalloc(buf_len, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
 	buf->num_elems = cpu_to_le16(num_items);
 	buf->res_type = cpu_to_le16(((type << ICE_AQC_RES_TYPE_S) &
 				      ICE_AQC_RES_TYPE_M) | alloc_shared);
 
 	status = ice_aq_alloc_free_res(hw, buf, buf_len, ice_aqc_opc_alloc_res);
 	if (status)
-		goto exit;
+		return status;
 
 	*counter_id = le16_to_cpu(buf->elem[0].e.sw_resp);
-
-exit:
-	kfree(buf);
 	return status;
 }
 
@@ -4475,16 +4453,10 @@ int
 ice_free_res_cntr(struct ice_hw *hw, u8 type, u8 alloc_shared, u16 num_items,
 		  u16 counter_id)
 {
-	struct ice_aqc_alloc_free_res_elem *buf;
-	u16 buf_len;
+	DEFINE_FLEX(struct ice_aqc_alloc_free_res_elem, buf, elem, 1);
+	u16 buf_len = __struct_size(buf);
 	int status;
 
-	/* Free resource */
-	buf_len = struct_size(buf, elem, 1);
-	buf = kzalloc(buf_len, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
 	buf->num_elems = cpu_to_le16(num_items);
 	buf->res_type = cpu_to_le16(((type << ICE_AQC_RES_TYPE_S) &
 				      ICE_AQC_RES_TYPE_M) | alloc_shared);
@@ -4494,7 +4466,6 @@ ice_free_res_cntr(struct ice_hw *hw, u8
 	if (status)
 		ice_debug(hw, ICE_DBG_SW, "counter resource could not be freed\n");
 
-	kfree(buf);
 	return status;
 }
 
@@ -4512,15 +4483,10 @@ ice_free_res_cntr(struct ice_hw *hw, u8
  */
 int ice_share_res(struct ice_hw *hw, u16 type, u8 shared, u16 res_id)
 {
-	struct ice_aqc_alloc_free_res_elem *buf;
-	u16 buf_len;
+	DEFINE_FLEX(struct ice_aqc_alloc_free_res_elem, buf, elem, 1);
+	u16 buf_len = __struct_size(buf);
 	int status;
 
-	buf_len = struct_size(buf, elem, 1);
-	buf = kzalloc(buf_len, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
 	buf->num_elems = cpu_to_le16(1);
 	if (shared)
 		buf->res_type = cpu_to_le16(((type << ICE_AQC_RES_TYPE_S) &
@@ -4538,7 +4504,6 @@ int ice_share_res(struct ice_hw *hw, u16
 		ice_debug(hw, ICE_DBG_SW, "Could not set resource type %u id %u to %s\n",
 			  type, res_id, shared ? "SHARED" : "DEDICATED");
 
-	kfree(buf);
 	return status;
 }
 


