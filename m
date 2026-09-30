Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDC351DDEE;
	Wed, 30 Sep 2026 16:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784752; cv=none; b=qEz2qoqNFzLtwZozBpTax7xJmrt+2uX7XStv94Q/39g++iRQh9ZOSBxwZqKXMBMN3x+xizHu6WOPnE1i8A5+FKGaoL8bOZK0tqKmg/Y4SxNRHSQccjwM/Lxqi4oNCC909PkCbtKw4fUnUgT/yC2bYknxhkTcsWakXRPqTOPuMa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784752; c=relaxed/simple;
	bh=JU6Wxg9cuKtDyZZfn5ltvJcRZk1tqVl7IwKKwW1Bt3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BT4p0M5XmWlr7tgE7GzA1apgq48lfk3OXE4tqglzekbMeT0AYINE3GsfW/j1Rf7HRw1+e1YdlDw3aXuotCIeZYAVH4GWWZ+PC1St/boDGJP+MuSQ9Whf4EsxgQUGNM997GVOCDmvPBtd9dnBpkaoMe9z9wmQedqtejqHN0iOOyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIlKsq43; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIlKsq43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C411F000FF;
	Wed, 30 Sep 2026 16:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784745;
	bh=UGv/9si6/W2tApPBFXRMRfZW2gL0HvlZS7ZBSof3nMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NIlKsq430pX3xEgBieSTqbQPIZAv88BfMC8qZ3FmyGVI46CN1zsphGAWvOSyAR8j0
	 KOubr5IIpct9VehSPKo7nIYZJXuGTX84rwkfc13P4evuvFAFufsGeldZAHG32DXCeS
	 NxjsyEUEYNumrCxTYbxqs2UhfTCyjsfSFrPgRtT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 265/982] wifi: iwlwifi: mvm: fix an off-by-1 boundary check
Date: Wed, 30 Sep 2026 17:16:41 +0200
Message-ID: <20260930152422.493412617@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit d77aff138c9ec6c8562f4c2c9f262d3d9c4b4cb8 ]

Before looking at the 11th byte, check the length is big enough.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Link: https://patch.msgid.link/20260714141909.d22bf52a18d0.If0ef6612a67cca671428b06dbdeec68549e50ae6@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index bd4301857ba87..184de7b3ebbec 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2962,7 +2962,7 @@ static void iwl_mvm_check_he_obss_narrow_bw_ru_iter(struct wiphy *wiphy,
 	elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY, ies->data,
 				  ies->len);
 
-	if (!elem || elem->datalen < 10 ||
+	if (!elem || elem->datalen < 11 ||
 	    !(elem->data[10] &
 	      WLAN_EXT_CAPA10_OBSS_NARROW_BW_RU_TOLERANCE_SUPPORT)) {
 		data->tolerated = false;
-- 
2.53.0



