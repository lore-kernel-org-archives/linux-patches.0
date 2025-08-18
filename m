Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1B3321430;
	Mon, 18 Aug 2025 13:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525397; cv=none; b=UaLUVGIhpFbSJ5iQBtpfFHGNG/LVAucu7vkewT9a5Gg+22K9Rvb2k3vGdzHnTUUfm8+ZxJm/zV2V0cOW8v0KCly59Zd40yPTMHvV/hkw2W0MHIINlMY6mKUCpITgBW+2t8NICtUYzXtPtLZ4gGPIBZ4mcB5FwqLw4AdvCpsS0iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525397; c=relaxed/simple;
	bh=JGQVTEuUq4eTq69OKA86Q/3afcWXcguLBCEyeH6LkxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ks7NlM2H+TCtiKnJg1fTum7GwToqKmpI1rRYZcZky57FZGnh665FA2NbjqECPbIdVI7dd397Vs0mSkvyjcmZoEOk1fm4KrD6wfFvCu85O3PkABHwFqLc5cF1Mh1bl7Ex/++sU3uyShSZstsZzGJOPXwaGo5smZrq2Y49avQvWeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PgIh6qyQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PgIh6qyQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA80C4CEEB;
	Mon, 18 Aug 2025 13:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525397;
	bh=JGQVTEuUq4eTq69OKA86Q/3afcWXcguLBCEyeH6LkxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PgIh6qyQDp/xtE1UaRvDYfPnDwJu4DdKHrT+gC9xQSiVKpUYqgupOAk1YVrusZr7o
	 7h2YC1akhvS6hhgQK40e/NGFwtDIJxVOAcGp7wMvBozRtZCwHwNeTI60SmR+eKvMo2
	 UiQZc8GpJj0VbTu67jfuq3j87XRsIsZ0tONVBHSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Daniel Gabay <daniel.gabay@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 251/570] wifi: iwlwifi: mld: fix scan request validation
Date: Mon, 18 Aug 2025 14:43:58 +0200
Message-ID: <20250818124515.492245134@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit d1f5f881ac2c5dc185a88c7bfe47d2b3ecbbc501 ]

The scan request validation function uses bitwise and instead
of logical and. Fix it.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Reviewed-by: Daniel Gabay <daniel.gabay@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20250710212632.ec7d665f56a4.I416816b491fafa5d3efdf0a4be78356eedf2bd95@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/scan.c b/drivers/net/wireless/intel/iwlwifi/mld/scan.c
index 3fce7cd2d512..33e7e4d1ab90 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/scan.c
@@ -359,7 +359,7 @@ iwl_mld_scan_fits(struct iwl_mld *mld, int n_ssids,
 		  struct ieee80211_scan_ies *ies, int n_channels)
 {
 	return ((n_ssids <= PROBE_OPTION_MAX) &&
-		(n_channels <= mld->fw->ucode_capa.n_scan_channels) &
+		(n_channels <= mld->fw->ucode_capa.n_scan_channels) &&
 		(ies->common_ie_len + ies->len[NL80211_BAND_2GHZ] +
 		 ies->len[NL80211_BAND_5GHZ] + ies->len[NL80211_BAND_6GHZ] <=
 		 iwl_mld_scan_max_template_size()));
-- 
2.39.5



