Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214241;
	b=iWGgKEMjDBjC740tQJ6BP+VZTJatmKpNorwhkCLshFZmHl+06k3dXHVLcffdM9qTuAq/
	 6/KDEE6QPR8dmnEmMwpY/wy2BLczKi+pB+qx8J9Bidc2MY59xiDD2y5AY1oUAdm+/LQpD
	 eMjTywaYNPDKh28IhUjAS/Arx9LdvU4jT2X+Xm8ooPMSWOS89SOZgFk9kD6Go6sSGdxsH
	 0N4vIYnr5JjCZKQM0t1pzVGQmseeY8AzkBqtEdEsEU0oNlptUWA+orFdNoqT3hcBj8nig
	 mkUKs/8nTrizWQVH00Y3aBDdNsAPT3ynrC0r/n5F8spRkB95qdJYLeuqlMcokba0caA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J4N8/FTWEPY56em3nN7OUFKNrDVt1Rd+olO70cEr82E=;
	b=u3oKALbrITamO0sU6mSeRPgy37NC7jS2znOA6eIwxWs96l4+A4KFkf3Ibv8Z0+O7wSqC
	 LrA3Rl8iimbbALt8IO6TuExuDjlC8MOsRlk+ZB3ZoTC0moOEVgYm5En8JqM5MjoTNmtwd
	 Ok8rvXUduQgSjx1Q21mJLsMxnKHqGi8YaZts/rwC9C+GNZl+zaMFArFCz2O+qdlr7MW11
	 GWF0GSfsGkKZ3++hPhTc4/H1MxqsVRGWjW/vOcclYtVM1dYjhmj0oUr08HkqBVkK6q7QJ
	 O6czPv8lxwSNwe824pYQZz2K16AnDuqn4GMqRiqAXLiC29LKsl/ugw7CpF330dMe9OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bA4+hM1S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2692D60A262C;
	Wed, 28 Oct 2026 19:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bA4+hM1S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03791F031E1;
	Wed, 28 Oct 2026 19:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214241;
	bh=J4N8/FTWEPY56em3nN7OUFKNrDVt1Rd+olO70cEr82E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bA4+hM1SIIT03DiIec3IQmWy9fvcxryD2eHCmIyDmNrCrmdCfkIhuWvzcy8mAH4oY
	 ijifjkX+G+SUsyxixutf9wQZ8Lz4gCjDPeMOYtSzBGSjYUeGhCr5HwTxf1mu570nSp
	 EY3FBs0fnDCZCAaSFpLltkxfKxVb+SQ2e1eeqGpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0789/1887] wifi: iwlwifi: fix debug actions order
Date: Wed, 28 Oct 2026 17:48:05 +0100
Message-ID: <20261028170517.389510932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit eb29b4ffafb20281624dcd2cbb768d6f30edf600 ]

The order of actions taken for debug was implemented incorrectly.
Now we implemented the dump split and do the FW reset only in the
middle of the dump (rather than the FW killing itself on error.)
As a result, some of the actions taken when applying the config
will now crash the device, so we need to fix the order.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250308231427.6de7fa8e63ed.I40632c48e2a67a8aca05def572a934b88ce7934b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index b7165082bdd80..a14a4437a0940 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2018-2023 Intel Corporation
+ * Copyright (C) 2018-2025 Intel Corporation
  */
 #include <linux/firmware.h>
 #include "iwl-drv.h"
@@ -1361,15 +1361,15 @@ void _iwl_dbg_tlv_time_point(struct iwl_fw_runtime *fwrt,
 	switch (tp_id) {
 	case IWL_FW_INI_TIME_POINT_EARLY:
 		iwl_dbg_tlv_init_cfg(fwrt);
-		iwl_dbg_tlv_apply_config(fwrt, conf_list);
 		iwl_dbg_tlv_update_drams(fwrt);
 		iwl_dbg_tlv_tp_trigger(fwrt, sync, trig_list, tp_data, NULL);
+		iwl_dbg_tlv_apply_config(fwrt, conf_list);
 		break;
 	case IWL_FW_INI_TIME_POINT_AFTER_ALIVE:
 		iwl_dbg_tlv_apply_buffers(fwrt);
 		iwl_dbg_tlv_send_hcmds(fwrt, hcmd_list);
-		iwl_dbg_tlv_apply_config(fwrt, conf_list);
 		iwl_dbg_tlv_tp_trigger(fwrt, sync, trig_list, tp_data, NULL);
+		iwl_dbg_tlv_apply_config(fwrt, conf_list);
 		break;
 	case IWL_FW_INI_TIME_POINT_PERIODIC:
 		iwl_dbg_tlv_set_periodic_trigs(fwrt);
@@ -1379,14 +1379,14 @@ void _iwl_dbg_tlv_time_point(struct iwl_fw_runtime *fwrt,
 	case IWL_FW_INI_TIME_POINT_MISSED_BEACONS:
 	case IWL_FW_INI_TIME_POINT_FW_DHC_NOTIFICATION:
 		iwl_dbg_tlv_send_hcmds(fwrt, hcmd_list);
-		iwl_dbg_tlv_apply_config(fwrt, conf_list);
 		iwl_dbg_tlv_tp_trigger(fwrt, sync, trig_list, tp_data,
 				       iwl_dbg_tlv_check_fw_pkt);
+		iwl_dbg_tlv_apply_config(fwrt, conf_list);
 		break;
 	default:
 		iwl_dbg_tlv_send_hcmds(fwrt, hcmd_list);
-		iwl_dbg_tlv_apply_config(fwrt, conf_list);
 		iwl_dbg_tlv_tp_trigger(fwrt, sync, trig_list, tp_data, NULL);
+		iwl_dbg_tlv_apply_config(fwrt, conf_list);
 		break;
 	}
 }
-- 
2.53.0



