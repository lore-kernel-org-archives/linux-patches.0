Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6177E2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB05FC433EF;
	Wed, 12 Apr 2023 08:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289221;
	bh=fJhOX7HsVwZfl2hJVIseoVHJlONXznKBlBElU9PKKcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhaEArCGGeH6Uh91BaYOdtVkv0Y+kPC0H7Ik9UuTwwr32GzgdE5EGT9Yevl+Bw21S
	 gnIhUtvfK3rNLgVoVd++V+ASfVkXTS0THuhBUX+eR7hmiEXXY16sfLROyMkwcDuf/+
	 gzunBgA/ZiSdsU4ow74X2OIDvFqVDG1j+/peTemw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 017/173] wifi: mac80211: fix the size calculation of ieee80211_ie_len_eht_cap()
Date: Wed, 12 Apr 2023 10:32:23 +0200
Message-Id: <20230412082838.792541987@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit dd01579e5ed922dcfcb8fec53fa03b81c7649a04 ]

Here should return the size of ieee80211_eht_cap_elem_fixed, so fix it.

Fixes: 820acc810fb6 ("mac80211: Add EHT capabilities to association/probe request")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Link: https://lore.kernel.org/r/06c13635fc03bcff58a647b8e03e9f01a74294bd.1679935259.git.ryder.lee@mediatek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9c219e525eded..ed9e659f49f63 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -4906,7 +4906,7 @@ u8 ieee80211_ie_len_eht_cap(struct ieee80211_sub_if_data *sdata, u8 iftype)
 				       &eht_cap->eht_cap_elem,
 				       is_ap);
 	return 2 + 1 +
-	       sizeof(he_cap->he_cap_elem) + n +
+	       sizeof(eht_cap->eht_cap_elem) + n +
 	       ieee80211_eht_ppe_size(eht_cap->eht_ppe_thres[0],
 				      eht_cap->eht_cap_elem.phy_cap_info);
 	return 0;
-- 
2.39.2



