Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4D418BB91;
	Fri, 27 Sep 2024 12:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727439900; cv=none; b=m0wXcSCsVPWcwzXxoCG47etHFTT5J8Us8UfPTozbrASuMWqLj2cE9ZOoPvX2deNaVCSLQAjnmojJ8dWZPEqymExXX4i/REMu50+sJecSUS3d26k0xLK9yov493URX/veKAW0mjkSbPEfLSz9otXUFQi40mKqps00wL4oIX7W5yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727439900; c=relaxed/simple;
	bh=dZM1GS68P6OA1r+Zh1YGS9nmgWxQnyG0txq2yE0PnSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BakqDI00y1otPRnQvSmXf4ey04iF7Pi2pXOK9ELHFRXxtvs9YtRvpkqLu0Oc2ttEr+ODWJcbcZGVx2rkDKqwzwbqBfK+SBO9m7CslNEet4nOw4rUIpv8sQLRyzOUGJuXwS0OrTC8jLw7+52HpU12bdTFRjfSN5Uu3sjOJ3x3UTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pdljaFRa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pdljaFRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B41C4CEC4;
	Fri, 27 Sep 2024 12:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727439899;
	bh=dZM1GS68P6OA1r+Zh1YGS9nmgWxQnyG0txq2yE0PnSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdljaFRaa3J90vrB9sxvsuHhaH+b85ru0kdH6Njx2LZjSflTMGy0qzkRypqrARz/T
	 TLXj9bHknS+l3lOiN2ygPF/b+2LKsq/ooMXqZLKFB0HaU020jv5oaAgQyDwG0KVYfK
	 nvaz2oW/p4jgWx4uIRsLEiD4y8b6D/q5/mZxwJDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Gabay <daniel.gabay@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 16/54] wifi: iwlwifi: mvm: fix iwl_mvm_max_scan_ie_fw_cmd_room()
Date: Fri, 27 Sep 2024 14:23:08 +0200
Message-ID: <20240927121720.350655007@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c61068144c638..626620cd892f0 100644
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
@@ -296,8 +298,8 @@ static int iwl_mvm_max_scan_ie_fw_cmd_room(struct iwl_mvm *mvm)
 
 	max_probe_len = SCAN_OFFLOAD_PROBE_REQ_SIZE;
 
-	/* we create the 802.11 header and SSID element */
-	max_probe_len -= 24 + 2;
+	/* we create the 802.11 header SSID element and WFA TPC element */
+	max_probe_len -= 24 + 2 + WFA_TPC_IE_LEN;
 
 	/* DS parameter set element is added on 2.4GHZ band if required */
 	if (iwl_mvm_rrm_scan_needed(mvm))
@@ -724,8 +726,6 @@ static u8 *iwl_mvm_copy_and_insert_ds_elem(struct iwl_mvm *mvm, const u8 *ies,
 	return newpos;
 }
 
-#define WFA_TPC_IE_LEN	9
-
 static void iwl_mvm_add_tpc_report_ie(u8 *pos)
 {
 	pos[0] = WLAN_EID_VENDOR_SPECIFIC;
-- 
2.43.0



