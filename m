Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FE618C003;
	Fri, 27 Sep 2024 12:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440081; cv=none; b=acuTAfe4dXg9Dy0Bs5ijWZH4TY7LXecMB61vYR+ypM7lUVymXr3RpqVU0bbJ2vpdNCEkt6XM6Ko0GeevZCU7v2zK+NMQfxmSRvCQ8xAg6kWmNkY0iwtK3vZpqk/aY9KresrXADmH6fVyrI4pk3CwI5Hzyapwp2iu/7S6u28L5dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440081; c=relaxed/simple;
	bh=FdTYQHjmrDTg4EIou7bNN6P2T75/kFL7v+wmDyGpiic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODcIabUjpkDTuGzLXsxMuvd9LZe+xjPbIXzsM471Va3uAcZUJ/Cxk//G9cOm/SXml1+S030xFckWJjWkZSLCVvqltcGal+T0L/xRQtyWxvyDK/mg21F/uYNCosZC/eZjyL576ivUBhnDr8BRh2sAqPsk+OLKtW3RP08gJvQNfAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WwRu6ewI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WwRu6ewI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C180EC4CEC6;
	Fri, 27 Sep 2024 12:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440081;
	bh=FdTYQHjmrDTg4EIou7bNN6P2T75/kFL7v+wmDyGpiic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WwRu6ewIgB3+hUfSqgxla24mcjY6Yvc6L0gcwALmxdyql/hWIxSX4b1LPO9XJ0aqP
	 pCkeLtJ30bPoQBDvxX5ozU8L4Yr1mWjCx8pnNfbzO4Ft3Up+RatlFh/NXARl8cg3Lp
	 HNJcnZllcbc/9hYKs2LzFOcJXx7p2Tr2fTdikhmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gabay <daniel.gabay@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 18/58] wifi: iwlwifi: mvm: fix iwl_mvm_max_scan_ie_fw_cmd_room()
Date: Fri, 27 Sep 2024 14:23:20 +0200
Message-ID: <20240927121719.552535622@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
References: <20240927121718.789211866@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Gabay <daniel.gabay@intel.com>

[ Upstream commit 916a5d9c5354c426220a0a6533a5e8ea1287d6ea ]

Driver creates also the WFA TPC element, consider that in the
calculation.

Signed-off-by: Daniel Gabay <daniel.gabay@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20240825191257.e710ce446b7f.I2715c6742e9c3d160e2ba41bc4b35de370d2ce34@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 89adc6421eeee..d7c276237c74e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -48,6 +48,8 @@
 /* Number of iterations on the channel for mei filtered scan */
 #define IWL_MEI_SCAN_NUM_ITER	5U
 
+#define WFA_TPC_IE_LEN	9
+
 struct iwl_mvm_scan_timing_params {
 	u32 suspend_time;
 	u32 max_out_time;
@@ -303,8 +305,8 @@ static int iwl_mvm_max_scan_ie_fw_cmd_room(struct iwl_mvm *mvm)
 
 	max_probe_len = SCAN_OFFLOAD_PROBE_REQ_SIZE;
 
-	/* we create the 802.11 header and SSID element */
-	max_probe_len -= 24 + 2;
+	/* we create the 802.11 header SSID element and WFA TPC element */
+	max_probe_len -= 24 + 2 + WFA_TPC_IE_LEN;
 
 	/* DS parameter set element is added on 2.4GHZ band if required */
 	if (iwl_mvm_rrm_scan_needed(mvm))
@@ -731,8 +733,6 @@ static u8 *iwl_mvm_copy_and_insert_ds_elem(struct iwl_mvm *mvm, const u8 *ies,
 	return newpos;
 }
 
-#define WFA_TPC_IE_LEN	9
-
 static void iwl_mvm_add_tpc_report_ie(u8 *pos)
 {
 	pos[0] = WLAN_EID_VENDOR_SPECIFIC;
-- 
2.43.0



