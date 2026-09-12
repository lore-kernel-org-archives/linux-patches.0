Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C7727FB37;
	Sat, 12 Sep 2026 16:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229615; cv=none; b=QT97o/lVxQLkkKdZop6nquCyi9VJ/QgtbokjRTYKwF7Nt9jRo9i24AELlI2qTxJGgzswhXaI9/U7d3QayEvLjYeOl1/5SLuiQvVqgNJpYiGl3tuF/cEnhzLE4Cnms+z7q9HRHMK8rRjbSnxFDi2of3EnV02FMM/eu6jFkWwF+64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229615; c=relaxed/simple;
	bh=xStsWvKlNTwUZSff1jEUTo7M8kQ9TkBOknlMxllB6Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYlM4RiNA2NzsN0ZemnXY+JIzfFaTocMp0cJgERY2aG8TadKLbM1nIpBuCM1HUoV6PIBvumsZZbKCSWpY4qShMkjLEVmp5Y61VeiPNnU+zq0mZw5K05VsEvvfK+GJIm0G6hjYuxNE1dB7zuH+NQogfKpnurbJl8kG2W5B6M1Qh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ph0LdsA2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ph0LdsA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC6B1F000FF;
	Sat, 12 Sep 2026 16:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229614;
	bh=QT/ySRrPPfcmPzNHHD6MuCZw0ddkd5zOqzbU1HejR/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ph0LdsA2lT2PoSz1PdpyqW3JZxOipjEpwPKp4Aphl4MgMI8E5l+Hqxp1C3uz8csNS
	 ci/W6Wzt1AtFMBywKMrX8r2it72I6fKR/rOXpcQ9aiSMSit2zmXBlSfGRiYgR2GWL1
	 PrJ7zcZ6bZMpLSMiwA+mO9shS9L65lkk6Rm0KMUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0626/1191] wifi: iwlmei: dont send SAP messages if AMT is disabled
Date: Sat, 12 Sep 2026 08:55:54 +0200
Message-ID: <20260912065602.313941361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit ef030ab17e060b0ef47028e86cf85b68988b56ae ]

SAP messages should not be sent when AMT is disabled.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230822103048.db16b55c27c1.I48834c14f5af8d31792f5048b3023509cba191dd@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 7d8cc301bcba ("wifi: iwlwifi: mei: check SAP message length before reading it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mei/main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mei/main.c b/drivers/net/wireless/intel/iwlwifi/mei/main.c
index 27eb28290e234..c2f84e1ce73fe 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/mei/main.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (C) 2021-2022 Intel Corporation
+ * Copyright (C) 2021-2023 Intel Corporation
  */
 
 #include <linux/etherdevice.h>
@@ -1437,7 +1437,7 @@ void iwl_mei_host_associated(const struct iwl_mei_conn_info *conn_info,
 
 	mei = mei_cldev_get_drvdata(iwl_mei_global_cldev);
 
-	if (!mei && !mei->amt_enabled)
+	if (!mei || !mei->amt_enabled)
 		goto out;
 
 	iwl_mei_send_sap_msg_payload(mei->cldev, &msg.hdr);
@@ -1466,7 +1466,7 @@ void iwl_mei_host_disassociated(void)
 
 	mei = mei_cldev_get_drvdata(iwl_mei_global_cldev);
 
-	if (!mei && !mei->amt_enabled)
+	if (!mei || !mei->amt_enabled)
 		goto out;
 
 	iwl_mei_send_sap_msg_payload(mei->cldev, &msg.hdr);
@@ -1502,7 +1502,7 @@ void iwl_mei_set_rfkill_state(bool hw_rfkill, bool sw_rfkill)
 
 	mei = mei_cldev_get_drvdata(iwl_mei_global_cldev);
 
-	if (!mei && !mei->amt_enabled)
+	if (!mei || !mei->amt_enabled)
 		goto out;
 
 	iwl_mei_send_sap_msg_payload(mei->cldev, &msg.hdr);
@@ -1531,7 +1531,7 @@ void iwl_mei_set_nic_info(const u8 *mac_address, const u8 *nvm_address)
 
 	mei = mei_cldev_get_drvdata(iwl_mei_global_cldev);
 
-	if (!mei && !mei->amt_enabled)
+	if (!mei || !mei->amt_enabled)
 		goto out;
 
 	iwl_mei_send_sap_msg_payload(mei->cldev, &msg.hdr);
@@ -1559,7 +1559,7 @@ void iwl_mei_set_country_code(u16 mcc)
 
 	mei = mei_cldev_get_drvdata(iwl_mei_global_cldev);
 
-	if (!mei && !mei->amt_enabled)
+	if (!mei || !mei->amt_enabled)
 		goto out;
 
 	iwl_mei_send_sap_msg_payload(mei->cldev, &msg.hdr);
@@ -1585,7 +1585,7 @@ void iwl_mei_set_power_limit(const __le16 *power_limit)
 
 	mei = mei_cldev_get_drvdata(iwl_mei_global_cldev);
 
-	if (!mei && !mei->amt_enabled)
+	if (!mei || !mei->amt_enabled)
 		goto out;
 
 	memcpy(msg.sar_chain_info_table, power_limit, sizeof(msg.sar_chain_info_table));
-- 
2.53.0



