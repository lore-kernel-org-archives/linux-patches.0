Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5290F481CD;
	Tue, 26 Aug 2025 14:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217845; cv=none; b=F9e+8MvDKT1/iFNJOEEI92ZBPUa8Nq0vNovAKG6IhP5H1SNLBkHPJTmBytGZ2eAJaWktLL1HLWAAnU4a+jPv8kQI3KYDlBgqTWglaHtn/SkoRFZa9WN5GmTSyueyOT+6KmDu75TUAxU20n4enki+qjbBvlVdprgIdegkanxhjOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217845; c=relaxed/simple;
	bh=d6D6x9sfdviyqteBD/ZvdLt59dSq6TgMR87g8O5AsrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpLZbfAxnypBiDs4dVD6VrDJNYhDcYQfs8C+jKAW2F/FOL8D+wtEf2R+NTgsZGWBqISK4iyOovNN8YBsKSHAXOXA6pQGMMkUmbWUo4BmfdxURPzMa1pU5f79RWO9CCf2X1QHAAStInwq9WOWrajJRz2nGSJ5OQROdfLVpR8zxA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NrMPBGBw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NrMPBGBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83AFCC4CEF1;
	Tue, 26 Aug 2025 14:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217844;
	bh=d6D6x9sfdviyqteBD/ZvdLt59dSq6TgMR87g8O5AsrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NrMPBGBwEUrFGSg7UQzHXpGvEfsUpnZDPCjH7fsMdviciXtidlA12ykoOL3Tjl0pM
	 6NMqQuYoFAMV8wiaZyaE4gjIHJobyC8W7ErjJA5GQ0qvFcYljhQMxePoS7R/uMip1U
	 btxUA5C4IxwXgqqRxqpLkkCzxDyBCIOQ83FquPng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 269/523] wifi: iwlwifi: mvm: fix scan request validation
Date: Tue, 26 Aug 2025 13:07:59 +0200
Message-ID: <20250826110931.064204792@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a52af491eed5..6e6325717c0a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -876,7 +876,7 @@ static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
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



