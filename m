Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8863E340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301103; cv=none; b=Viik+0y9Rw4sf3xgMGiqdD8GAoa8ifF7rZoBmvhtIhteJQ3C3iFoITlYPyJ4ZM0jIqnv84wtKpa/+98oUo190aZHgCHZY/LkWvxbXTLetZVfscRARAtQqYuk+xXayh52aTq4gGWYBmHphVaMdPVpkJAkN+ba9kBmNo4Ynz8b1IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301103; c=relaxed/simple;
	bh=bJq2LZ/QHMgMd9+Pf3DGjsGyDKmiuUdJu/6wChtH6Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyiH3/xPXo+otnJWsl7RCATntZnvtxRS00UIaG8d6v39dujiZT6jR9erqmV/85ddtkigvcG9740BCw0dR5dcwaIEcmzjw7p+xMe3UZ6aJG5+rk/XrVsjlJs4+wk43gcirkeI3DAE9p87vdM52D5Ty0KYRCbjXrHCKGAp5tnNrKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q1ep2yzh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q1ep2yzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB271C116D0;
	Sat, 28 Feb 2026 17:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301103;
	bh=bJq2LZ/QHMgMd9+Pf3DGjsGyDKmiuUdJu/6wChtH6Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1ep2yzhoaTHBV5pvwcEVDfhKPSThBIe6/gJEUmFLLC1iuKcY/8/SoJQ4m+Wpz22N
	 Aj7OBXYVlexKdiwSYsHAKxKNUu6CT4ixD7ZvD+YrUJ37f9Wy9JBbyxcgRb/evfB7/K
	 /wB0kBR7TmWYrvFkJWTMAScc08yCJ+iT79PLPSN7JIp3BkFs5i7nDSobic3v2narA4
	 WbMLtPGuYqxjiiniK8zATzXTRtyW4hLaATfJqkPSXVH7RPGGZ2MB1EJNHshBBRLo3q
	 322MOtX4pyP9bA9iuwHV5sdZHHGJrdTqFeN+WgLuHuItYmGsqUMUINjGCC4d2pjBC5
	 sUG4cp8/sbodg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 256/752] wifi: iwlwifi: mld: Handle rate selection for NAN interface
Date: Sat, 28 Feb 2026 12:39:27 -0500
Message-ID: <20260228174750.1542406-256-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit dbbeebece03050cd510073ce89fee83844e06b00 ]

Frames transmitted over a NAN interface might not have channel
information assigned to them. In such cases assign the lowest
OFDM to the frame.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20251110180612.72046f98f878.Ib784931fffd0747acd9d7bb22eabbbec5282733e@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/tx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tx.c b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
index 3b4b575aadaa5..e3fb4fc4f452e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
@@ -345,6 +345,11 @@ u8 iwl_mld_get_lowest_rate(struct iwl_mld *mld,
 
 	iwl_mld_get_basic_rates_and_band(mld, vif, info, &basic_rates, &band);
 
+	if (band >= NUM_NL80211_BANDS) {
+		WARN_ON(vif->type != NL80211_IFTYPE_NAN);
+		return IWL_FIRST_OFDM_RATE;
+	}
+
 	sband = mld->hw->wiphy->bands[band];
 	for_each_set_bit(i, &basic_rates, BITS_PER_LONG) {
 		u16 hw = sband->bitrates[i].hw_value;
-- 
2.51.0

