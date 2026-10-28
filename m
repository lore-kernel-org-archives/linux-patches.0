Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214238;
	b=veyB+WSNeYMywmZp9ybuAqpxfX6w8dushrGh+ynmITHM4OkMal4DWtJJg1Aa/yNZVrS3
	 GGI7uuTNypRXXfH4+TTZMPsn1Vjg8+e2vb76YMQayGJqSWz041VF7HYrdVxRRQW9y7/aZ
	 eZcQ19AzH9IWVXuMbdQUaKevBXZavPo7M5WRH5JsD1bn5wjimkobune4xjjpdG/XyEc8u
	 0EPHa0ARwWj4jbzKScL4FvSonkfnTyohi5QAFoYTAB3pGZQJkZV0rkuGPzI58+zoxoKUo
	 nmB93zNH4Z5C2bjO2/GuxE0viKL4k7hA4kwJnWnSSz4Nth2p87cdWg7+l8ncFg+4rDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wo1qKQId9T19hDYZxDusSRTV5bLB1QYJwrEjefzrdOU=;
	b=OP9Ao3t6nTUokIhznNm5XjVwn2whnTYihmvug93Sb8BBU9HghyVJ7SJaLscF3iI1iXvL
	 ikW6RufD2wLfznAAyYTwoDn2eRkADi++zGnGstyaFdQKdqM0Xbz5Ph+32qu5q0oxAcf+U
	 czoMlaY+AGNFOO3pKwYJuf6sOOCqc1om9HaAQHbcV2/v8ZGKO7T6JAr1xfiVJlZznm6BX
	 vkz5NN0XPFy2E48GY1NF20Hc/aFsTqS1d0su7XIt+xtKt/w00E2as/gQ77Xhz7w8xDt7J
	 1CUNsV9QRH1JU3GGI/jSG2tzMCAhAEmfjjxqKhE1q/2dj8GC5g1K7FH2t3JRi//X2tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ydS+gYIh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3334E606A31D;
	Wed, 28 Oct 2026 19:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ydS+gYIh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F631F01825;
	Wed, 28 Oct 2026 19:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214238;
	bh=Wo1qKQId9T19hDYZxDusSRTV5bLB1QYJwrEjefzrdOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ydS+gYIhaIe1npL32sTtOV1H92iEDTrpLArtpCeqJ0ILJZ7nymGKBnF2vAuSS6ROe
	 BZ5WvOFmKWXOo/UCGhUTpizslim2KmoMwTWgFZgA6lxgzlETPCNtD8gAOXOqQJw8sS
	 xaTbSe7yfK0SVuT5bxhB244JeHYjITNqUN5qTD+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0788/1887] wifi: iwlwifi: dbg-tlv: fix DRAM data init
Date: Wed, 28 Oct 2026 17:48:04 +0100
Message-ID: <20261028170517.368755297@linuxfoundation.org>
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

[ Upstream commit c2a2f505e0bcb45052131d173504887041e1faae ]

Given the existing code in iwl_dbg_tlv_update_drams(), the
following can happen and cause firmware asserts, and even
the device to become unusable:

 * We set the magic so the firmware will use the data;
 * we try to fill multiple allocation IDs, with at least
   one successful, but - crucially - one failing and thus
   not touching the data;
 * we don't clear the data since there was one success.

This doesn't seem like much of a problem just yet, however,
what happens now is that the allocation ID(s) that failed
are not initialized.

There are two additional things to know:
 * we never free these allocations across FW restart or
   interface down/up etc., in fact we never free them until
   the driver is unbound from the device (e.g. unloaded)
 * the firmware uses the DRAM info structure for real debug
   data when it has used it completely

Given that, and the fact that we never initialize the data
on restart, we can be unlucky and end up with an allocation
that looks for the most part valid (valid ID, valid number
of buffers, etc.) but has bad sizes - causing the firmware
to throw an assert we can never recover from.

Fixing the code to have the entire buffers cleared (which
we should do so old debug data isn't sticking around) is a
bit more complex, so as a first step make the actual code
that fills the information more robust by clearing the
structure first, and filling the magic values only if it
actually succeeded for one, rather than doing it the other
way around.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230613155501.87cf5528f4bc.I26ac907a4162297808b33467fc7f5d8177474a34@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: eb29b4ffafb2 ("wifi: iwlwifi: fix debug actions order")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 677c9e0b46f10..b7165082bdd80 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2018-2022 Intel Corporation
+ * Copyright (C) 2018-2023 Intel Corporation
  */
 #include <linux/firmware.h>
 #include "iwl-drv.h"
@@ -797,8 +797,7 @@ static void iwl_dbg_tlv_update_drams(struct iwl_fw_runtime *fwrt)
 			 IWL_UCODE_TLV_CAPA_DRAM_FRAG_SUPPORT))
 		return;
 
-	dram_info->first_word = cpu_to_le32(DRAM_INFO_FIRST_MAGIC_WORD);
-	dram_info->second_word = cpu_to_le32(DRAM_INFO_SECOND_MAGIC_WORD);
+	memset(dram_info, 0, sizeof(*dram_info));
 
 	for (i = IWL_FW_INI_ALLOCATION_ID_DBGC1;
 	     i <= IWL_FW_INI_ALLOCATION_ID_DBGC3; i++) {
@@ -811,11 +810,10 @@ static void iwl_dbg_tlv_update_drams(struct iwl_fw_runtime *fwrt)
 				 i, ret);
 	}
 
-	if (dram_alloc)
-		IWL_DEBUG_FW(fwrt, "block data after  %08x\n",
-			     dram_info->first_word);
-	else
-		memset(frags->block, 0, sizeof(*dram_info));
+	if (dram_alloc) {
+		dram_info->first_word = cpu_to_le32(DRAM_INFO_FIRST_MAGIC_WORD);
+		dram_info->second_word = cpu_to_le32(DRAM_INFO_SECOND_MAGIC_WORD);
+	}
 }
 
 static void iwl_dbg_tlv_send_hcmds(struct iwl_fw_runtime *fwrt,
-- 
2.53.0



