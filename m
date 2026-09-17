Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65172502D47;
	Thu, 17 Sep 2026 17:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665000; cv=none; b=jdmJuR4YGsYSrCrTr0vC9V1zN7YZTly2u12ZY+CaKH0Igokx/bsVsHqWB7UHRgXH/NgJOZxFqNzo5myO/SD90Q4a5QkT71Ng65/A9SYZZpeMepbloY1lJVNBO6O4TgnnKtuUZHURk531iffG9R0uRVLrXaWt/lNC2x/N1WGfTj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665000; c=relaxed/simple;
	bh=cO7aKby8ZF244jh1bT3oIokq5MdQ6vPe7ESPdJKa6WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqGG2CvJFdJkNVopvIzu7N9lw0NdHbTjCd8q8cMJDYUPdO2PbVmgadnUidGI7cKZFTpotMI7u4HiwbyqnWe23lf54TfruJx90dPgDItqgolNsMbAB8S7S+bHjDsVY+rSsEmHjD8blvwCXOJDO5HKD5KHkM7yXrpvn7y3ZCC6cCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gAMRhPl3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gAMRhPl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F3C1F000FF;
	Thu, 17 Sep 2026 17:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664999;
	bh=F5cTswkQkPFnHaoiYsdU3/kwauRXmr9ltMovAyDwfrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gAMRhPl3LMVe0DVSZe4sSmYe5K8WCAflM9lLf0Pt3LW8s/BAIcIDY28yWdTV22NxR
	 XAQAkOFlpYMAHsuoPFx8aGHlwRXU5p5r6kuHtAVhRMboSQPqoPC35aF3T6VNdeHYrj
	 8Phgs5zrTr2oKKrHIgLfJtTMFZTQYPv7Vpv+3pJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0519/1250] wifi: iwlwifi: mvm: fix an off-by-1 boundary check
Date: Thu, 17 Sep 2026 16:05:14 +0100
Message-ID: <20260917151606.017899235@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



