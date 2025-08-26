Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6022165F13;
	Tue, 26 Aug 2025 12:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213024; cv=none; b=M388XD/Dl13r/Sc8V3zDCvejAaeJSMcyojhyNWuUDqvydt4M25VeleAqQTwftpuCqj0l1gaDL6sAaYF3+cL9BShnsFqHTyk6TevBux4Klymc78uJqkUXsy5C4JZjSKcAENBbHtiOoVl7zmEzew+N6EatLKw2Jta0Npu/y/IqtdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213024; c=relaxed/simple;
	bh=Ri+xdoM7QXVBmQMHJfwdUgw5e+EEtokO1y2tL5WVpVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtQ4osuhVFAK7mweq54gc9b+6OpGmW4cPbDDEfOsuWYhB7CkF/Eg565eRfMFmESXtaVHOO7Cq4FAPKeOXLyjG1b2hPMwhzfF9pHnXshJLb6LEMa+En/7SiW5kzN0wmyhUcv6Ix9E1mzo+nIy1dzIPZmJhpZfLwYvmE3qv0GsB1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSuFe0It; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSuFe0It"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D0AC4CEF1;
	Tue, 26 Aug 2025 12:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213024;
	bh=Ri+xdoM7QXVBmQMHJfwdUgw5e+EEtokO1y2tL5WVpVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSuFe0ItYiKCvWh5xp2Z+FbbpMpx2GRU81TaH27GMIRi8W+HCt8hgOeHcw69whmnm
	 5b9wEiyL8+17/3M8rzSTvHiGofnXEdO3p/fYhHjvXk67JHqMvAeVYq8pzUrTB0PxBM
	 EBK3rtGn5ctHNsvViD3FXqyv3py7GdTXNJncdqX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 162/587] wifi: iwlwifi: mvm: fix scan request validation
Date: Tue, 26 Aug 2025 13:05:11 +0200
Message-ID: <20250826110957.068002537@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cc866401aad0..8b22779e5b3e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -828,7 +828,7 @@ static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
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



