Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF59B2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B20C433EF;
	Wed, 12 Apr 2023 08:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288872;
	bh=us7ZqyftedUPyk3U5IsyXxtRTU4kkJDYkjIYGcsJeWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7SRz/3cBtJ3oCy/tTHFybacm9Eh94YzrEwd2QIgo/gf29xDt2aNdN/PrSlMR4FPy
	 HjT5fCW3xXl4meP5DL3QneZouc2RtOh71ipSYKXsmxGaghL6E4DwGUBDNqgfKqfSMo
	 PDCH+3kPzM6W9Yu2i0sA8lDg0TrPJ7aXiFcaHkX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/164] wifi: mac80211: fix the size calculation of ieee80211_ie_len_eht_cap()
Date: Wed, 12 Apr 2023 10:32:22 +0200
Message-Id: <20230412082837.752189234@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
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
index ed53c51bbc321..0785d9393e718 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -4785,7 +4785,7 @@ u8 ieee80211_ie_len_eht_cap(struct ieee80211_sub_if_data *sdata, u8 iftype)
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



