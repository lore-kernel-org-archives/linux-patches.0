Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F24335BBD;
	Mon, 18 Aug 2025 13:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523649; cv=none; b=DVrE1UNLUt3iTENyhm1wvCLy0FcNusy4PQ2dhib9SZ1TQKhn/6cf9pifW+2SvkjseSyoOL1FGkQbcQnY64wiPXYwpQsJe+e5dbjCGJjMj8AVCnK/f8BshgkX6Vu1T5Ep2O3UuA+Van4gQhEv04vms8fFVPgeLx8LokyEEh0gVX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523649; c=relaxed/simple;
	bh=6N1nsFKGh74C4YXhLCu0VPWitU+SflUNRr9o6NI5RSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rPGk646EWQk9iuMqUyqn96OaGv82B1UItSi+cQ7qu0s8tWTsZ/1zgU/4FiOy8jE4bUZuSTlGqBfPBFAqFpDjpE8cw1WygmOLvQxi1vLTpBeE6Wls7KUM4UefkIW6tGSZ2a0w+q6/vBprx4cTx7GawX+HJeB4r3bcfVLfcXLqZjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ciVIQ6j1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ciVIQ6j1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DE3C4CEEB;
	Mon, 18 Aug 2025 13:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523649;
	bh=6N1nsFKGh74C4YXhLCu0VPWitU+SflUNRr9o6NI5RSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ciVIQ6j1hIduGbpmV/AVniMkPpfVLCZDAJGOARmvzgSlGBdnFXNBepD6IUuqrNQ3U
	 NfQtsmT4kLDeHVf/n9zDunzH3rxlc82+uCRoNfxkWP9s/ONizrMGSZiIiNKtuS4yeT
	 2hDGr/G+DMr4L5EtcfuDrXLLWpU7kOItRypf7+50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 237/515] wifi: iwlwifi: mvm: fix scan request validation
Date: Mon, 18 Aug 2025 14:43:43 +0200
Message-ID: <20250818124507.510847342@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 60bd9c7e5f03..3dbda1e4a522 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -835,7 +835,7 @@ static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
 				     int n_channels)
 {
 	return ((n_ssids <= PROBE_OPTION_MAX) &&
-		(n_channels <= mvm->fw->ucode_capa.n_scan_channels) &
+		(n_channels <= mvm->fw->ucode_capa.n_scan_channels) &&
 		(ies->common_ie_len +
 		 ies->len[NL80211_BAND_2GHZ] + ies->len[NL80211_BAND_5GHZ] +
 		 ies->len[NL80211_BAND_6GHZ] <=
-- 
2.39.5



