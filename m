Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0141A582
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BxnVpALY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3C0C433C7;
	Mon,  9 Oct 2023 13:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857140;
	bh=rX6i4tU+wOUHwQGHshYC+GKsORN5l+zLn8ZPIQjvDss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BxnVpALY+nZhbbDljhl2CSJi7IzkHe5YL0/JjKB037Y2TthBJazt3zcTjExmw1LS8
	 LzNsrOa8/wKIPdihGGosz5JyMXo5ntutWLNxMu9vdUCSp8pvHK6f0dmyjAqLNATHrh
	 GmaVzTEWi6KvOGg1+8lLxiUUkoDwRYtFTEwh954o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Antoine=20Beaupr=C3=A9?= <anarcat@debian.org>,
	Ilan Peer <ilan.peer@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 092/163] wifi: iwlwifi: mvm: Fix incorrect usage of scan API
Date: Mon,  9 Oct 2023 15:00:56 +0200
Message-ID: <20231009130126.574320604@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 22061bfc57fe08c77141dc876b4af75603c4d61d ]

The support for using link ID in the scan request API was only
added in version 16. However, the code wrongly enabled this
API usage also for older versions. Fix it.

Reported-by: Antoine Beaupré <anarcat@debian.org>
Fixes: e98b23d0d7b8 ("wifi: iwlwifi: mvm: Add support for SCAN API version 16")
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230926165546.086e635fbbe6.Ia660f35ca0b1079f2c2ea92fd8d14d8101a89d03@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index c1d9ce7534688..3cbe2c0b8d6bc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -2342,7 +2342,7 @@ iwl_mvm_scan_umac_fill_general_p_v12(struct iwl_mvm *mvm,
 	if (gen_flags & IWL_UMAC_SCAN_GEN_FLAGS_V2_FRAGMENTED_LMAC2)
 		gp->num_of_fragments[SCAN_HB_LMAC_IDX] = IWL_SCAN_NUM_OF_FRAGS;
 
-	if (version < 12) {
+	if (version < 16) {
 		gp->scan_start_mac_or_link_id = scan_vif->id;
 	} else {
 		struct iwl_mvm_vif_link_info *link_info;
-- 
2.40.1



