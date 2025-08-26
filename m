Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC50D35CED2;
	Tue, 26 Aug 2025 14:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219113; cv=none; b=al8R9hBCaPXobqn0PZvQn/84lgg0ej9i+ciqrTZwId6W2Jh/KZ7YOiE+n7luN0O9YTI2XTDXf11uiKqD5Ah9Z1H4DixMQcym8aQIXL43ZTqLzxa6+5mWaSMUOf9HU7VyJYCMO+BAO+1XgK+Zvm2076kdP51EwmGMMpQKIKa6Sdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219113; c=relaxed/simple;
	bh=PyPGkXxU1NeG0ZHGCcU8hEXy2AVXWwgAacAPOhKitYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNmZE5MR39ZZRCO6C6hZHbKruDo4qC782QP+b8TQKGimOm4LNraGnXvGT97TUjkyFMerpxHn+Ac/Un6u6gcXHVEek+KmV5cRCNR1iewJsk4V/wGw7znb6dI2OHSCJdu6oPBL5HfmGJJh6C2X+kyQKnbwvcQv4gHjBVUNpIyQoy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YqtsA41T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YqtsA41T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E163C4CEF1;
	Tue, 26 Aug 2025 14:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219112;
	bh=PyPGkXxU1NeG0ZHGCcU8hEXy2AVXWwgAacAPOhKitYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqtsA41TjkELw+p8ss8MwhZJH5oM0jXcumstJd5q2Owt+2YVPt9aoqdg2iPqEWBIG
	 X4pFefiEZLSAef27dbvi+kNsUiRMkvA4jozLKBl+upSCSm872A4fXSWlxOctKn8Z0x
	 BrucsHDGD3D9kIMe2xUfMdmI8hJM+dxrCcUKzCfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 216/403] wifi: iwlwifi: mvm: fix scan request validation
Date: Tue, 26 Aug 2025 13:09:02 +0200
Message-ID: <20250826110912.806010496@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 7c2f3ec7707188d8d5269ae2dce97d7be3e9f261 ]

The scan request validation function uses bitwise and instead
of logical and. Fix it.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250709230308.3fbc1f27871b.I7a8ee91f463c1a2d9d8561c8232e196885d02c43@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 55292e9b15c1..b860aad4c155 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -874,7 +874,7 @@ static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
 				     int n_channels)
 {
 	return ((n_ssids <= PROBE_OPTION_MAX) &&
-		(n_channels <= mvm->fw->ucode_capa.n_scan_channels) &
+		(n_channels <= mvm->fw->ucode_capa.n_scan_channels) &&
 		(ies->common_ie_len +
 		 ies->len[NL80211_BAND_2GHZ] +
 		 ies->len[NL80211_BAND_5GHZ] <=
-- 
2.39.5



