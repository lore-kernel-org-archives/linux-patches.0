Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C24335BBF;
	Mon, 18 Aug 2025 13:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523643; cv=none; b=D5aBCOxANw9ez/cmDRO5rAYT8oH0tLN6mEhpQID5Aq0J2baQqnK077AR5DtTbOyow9wPNC3dfXl1/1xKxnLBTNizmBREUyRbPNriTWvTuY/zXbqe0MLnI+QJYJlYA59yJXTJYuzByqHsYPUmIEp4q0qRTk4wa9+LEv+n6SydJLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523643; c=relaxed/simple;
	bh=10aHbvIiPJaG+HaIhSZjc8m6sMmEiG1thAj2c27UtOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMLODFX0Sdp8Xu617NzS5SnyIGh9WR01Wj4tzF/93ljlyvYHMdQePFedAmEbjBdO/m+b/TZ0mZoZK7QwQWLkDqWwwM7ZhGWY7r+dvnanBUwc8VO9AiKzXEnhlobAwpmm1X5J9tmTwNO2LTISoeM2hpPKsKEbVD1oHxHQP6bk2ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NnaKJctc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NnaKJctc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3921C4CEEB;
	Mon, 18 Aug 2025 13:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523643;
	bh=10aHbvIiPJaG+HaIhSZjc8m6sMmEiG1thAj2c27UtOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NnaKJctcqMEXWPYSOn1oOk2EqIJgo15W1yC7WOcyWtJgVsacEnGMTnRgzxChxsBxS
	 X5g+ggjrrf7Pr5tSz/jlqDm/CA1brKG2J+hvzrz6eSCMeYOKueyON6w5BmI63rkZec
	 LaukwWuj2wLisUr0f6ey6l69YjauuF+3ZX3BulGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avraham Stern <avraham.stern@intel.com>,
	Daniel Gabay <daniel.gabay@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 235/515] wifi: iwlwifi: mld: fix scan request validation
Date: Mon, 18 Aug 2025 14:43:41 +0200
Message-ID: <20250818124507.428554968@linuxfoundation.org>
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
index 7ec04318ec2f..13b9ae18dd7c 100644
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



