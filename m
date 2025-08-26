Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DBB29D28A;
	Tue, 26 Aug 2025 13:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216397; cv=none; b=niwa0AUT8Ei30tkzG7MMXKQKkAEtAtasleUBRdl38MW/GdINfIJNDkXlkGImMhkehNJqjX0aPiDJxg3lqh2LZ5rfwWVx2FcMoU9UD1atetJy24y4P0hGN/D2QB4xcGRsYTN4GmdX5Ouq6xrQdQT7jGo90ytkk30N0t2rN6fjZTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216397; c=relaxed/simple;
	bh=RRlgXmb3sZuVmNHJAlHhUaZy2avo6ercDmaVVHogegs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLYIvOhMuhhHtl+Ak9AXvmAdnBqm0PC7sFQ5ON327H+So+wQVNLnKQJAM1y78mxI3MxyRLHB6gWYfP4rDlD43V7gW1ABJgUTXxc6JTcdFMI4D46tk3l/yxg2IOPOneTsEAJAUS5HUkiT+0NyZN1A4rYlmlwMQTrrgoI/3xK7dN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fyxDaluV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fyxDaluV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9777EC4CEF1;
	Tue, 26 Aug 2025 13:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216397;
	bh=RRlgXmb3sZuVmNHJAlHhUaZy2avo6ercDmaVVHogegs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyxDaluVx8DesnXddCn9yxuZfbv9t1US5APprO3fj8OSPO/bJqWjJ+h9hPET91uSu
	 X4M7QMOD8PfQiMI89JwSX4z12k33KkyHvJTjEqy4a/YVmnuaTwRXx0+mjrm5echSwZ
	 ZWhfF2pj0mcF/0q2y1VoPabZn2UcP41JvHSGr61A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 352/644] wifi: iwlwifi: mvm: fix scan request validation
Date: Tue, 26 Aug 2025 13:07:23 +0200
Message-ID: <20250826110955.120907166@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 16818dcdae22..3d0396b8afaa 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -832,7 +832,7 @@ static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
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



