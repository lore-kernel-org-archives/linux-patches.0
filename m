Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D92522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:23:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F51BC433C7;
	Sun,  9 Jul 2023 11:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901816;
	bh=gPvR8WsfLC8bgVhmgdPD+sObLj676baT02srq73MJKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EbL2cxzDpWAO6a/h3xRZozfEBchQNbjHlvyyNA7pT0kZbL4QbiSW9+0xg7BYqAT2P
	 WtqxvYUTM2NIkUifORWzrsQQBTtzyx9VC5ICUKtoaj6JHjekkNXZ9zEQy3VhtXAdTz
	 JpKO6KLGtft3eNzWYWNuRSxQsCGcAn7TLwDJN4So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Simon Horman <simon.horman@corigine.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 127/431] wifi: mac80211: Remove "Missing iftype sband data/EHT cap" spam
Date: Sun,  9 Jul 2023 13:11:15 +0200
Message-ID: <20230709111454.133385321@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

[ Upstream commit 6e21e7b8cd897193cee3c2649640efceb3004ba5 ]

In mesh mode, ieee80211_chandef_he_6ghz_oper() is called by
mesh_matches_local() for every received mesh beacon.

On a 6 GHz mesh of a HE-only phy, this spams that the hardware does not
have EHT capabilities, even if the received mesh beacon does not have an
EHT element.

Unlike HE, not supporting EHT in the 6 GHz band is not an error so do
not print anything in this case.

Fixes: 5dca295dd767 ("mac80211: Add initial support for EHT and 320 MHz channels")

Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230614132648.28995-1-nicolas.cavallari@green-communications.fr
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 1a0d38cd46337..ce25d14db4d28 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3707,10 +3707,8 @@ bool ieee80211_chandef_he_6ghz_oper(struct ieee80211_sub_if_data *sdata,
 	}
 
 	eht_cap = ieee80211_get_eht_iftype_cap(sband, iftype);
-	if (!eht_cap) {
-		sdata_info(sdata, "Missing iftype sband data/EHT cap");
+	if (!eht_cap)
 		eht_oper = NULL;
-	}
 
 	he_6ghz_oper = ieee80211_he_6ghz_oper(he_oper);
 
-- 
2.39.2



