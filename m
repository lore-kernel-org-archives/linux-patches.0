Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22E24A1E1B;
	Mon, 31 Aug 2026 13:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183711; cv=none; b=QmV28zs45n9Bmsjp5Uy+qe19rO4yvmJ9Tg7zhHfL94qhojWgxx/rB+V3MKMnJEpJSosekgy5/4UNPqHTqAvd+zle5C2MFf22JdbnjCTVnV3CwQpQ3LsfkFDQkybZla1i+RTYVaaHL/24uwqyiMWY2ly7x/P0Q2PAa+qQTckAHuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183711; c=relaxed/simple;
	bh=+nMALovB10NfONBUbJxks57h4L2oR8ruKLFxL4t6RDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N1Jv55ALDZNGORv4CHDff9Eeh4unMt2vXjVDMfFpUDWCMh8ohaRvOm2lVXM64gDf0OVbr8c8+PxBEHU+eCMw9krOn7/KIm3530ZDNWDhih5rRx4Mz1NYoB9hicA4txMzdqY96MoNWgfSuWs9eDXKryDqDFMlwWMIseuP+iohR3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FcbUka6W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FcbUka6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CA31F00ADE;
	Mon, 31 Aug 2026 13:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183709;
	bh=La1Xp1x5Nei/poEFeumFUOtK4pgaG2CWMMXIdscTe6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FcbUka6WHKzwDtz20SIEUzavBcez6fLIy6gSCZifgtxMOHx/wndExneZF3uIZwbV2
	 4rxSnMuP0vTlmchq9m1oK15QLLTmgby9jdyknxPTy50Q5Bkw3iNUFzlMQdgRygpUZ0
	 wUdiYEIcAdEG3+Zbidb2SbjwW0x0wo9u6OLwAHPGwWEai59bpTlOKnV8Jlqf1HL/O2
	 9hDm0IfesxbB98AOTKIBEQJM0OBURhzliVomeOZAPDFgftpYAE6z9Ruu1CGY15Yl2N
	 njwYu0Of8/CuE59Xh2niUtQGWvPjGJyZin7NP+dxeT7/LtQ5jESBapuyc+o3hOcGO/
	 Rux6I0GmNtQVA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: iwlwifi: mvm: fix an off-by-1 boundary check
Date: Mon, 31 Aug 2026 09:24:46 -0400
Message-ID: <20260831133314.4125787-258-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit d77aff138c9ec6c8562f4c2c9f262d3d9c4b4cb8 ]

Before looking at the 11th byte, check the length is big enough.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Link: https://patch.msgid.link/20260714141909.d22bf52a18d0.If0ef6612a67cca671428b06dbdeec68549e50ae6@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**Verdict: YES** — backport to this tree (Linux 6.18.44).

This is a one-line fix in `iwl_mvm_check_he_obss_narrow_bw_ru_iter()`:
the check used `elem->datalen < 10` but then read `elem->data[10]`, so
an Extended Capabilities element with exactly 10 data bytes caused an
out-of-bounds read. The bug has been present since 2019 (`4f58121dc40a`)
and still exists in 6.18.44; fix `d77aff138c9ec` applies cleanly and is
only on mainline so far, not in this stable tree.

Worth noting: the same off-by-one exists in `iwl_mld/mac80211.c`, but
this commit only fixes the mvm path.

 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 2d2587c6e9757..92471bc7b505b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3529,7 +3529,7 @@ static void iwl_mvm_check_he_obss_narrow_bw_ru_iter(struct wiphy *wiphy,
 	elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY, ies->data,
 				  ies->len);
 
-	if (!elem || elem->datalen < 10 ||
+	if (!elem || elem->datalen < 11 ||
 	    !(elem->data[10] &
 	      WLAN_EXT_CAPA10_OBSS_NARROW_BW_RU_TOLERANCE_SUPPORT)) {
 		data->tolerated = false;
-- 
2.53.0

