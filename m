Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94648F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01586C433C9;
	Sun, 16 Jul 2023 20:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539742;
	bh=I0q1caJ9m4TgO21CiTVX92WdRIG0lfQwUG453VF1oFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uNMOmykDEd4bTBhP6Nftb55HVSMKHiaSJJLRK0eqF1wZBbLMTEBRuZ/M1UH+uYL73
	 dOBYqWFsZNr1JdaqImQQhuQB2OgQbkJvpol2xTXOftRR6uCT4Vm2rLvOL2OxWZpxkK
	 IY4XWoIO8RSDyWMptqV6A/9BB95tCoSkceAAXXmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/591] wifi: ieee80211: Fix the common size calculation for reconfiguration ML
Date: Sun, 16 Jul 2023 21:44:15 +0200
Message-ID: <20230716194926.878596564@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit ce6e1f600b0cfc563a7d607de702262a58cd835d ]

The common information length is found in the first octet of the common
information.

Fixes: 0f48b8b88aa9 ("wifi: ieee80211: add definitions for multi-link element")
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230618214435.3c7ed4817338.I42ef706cb827b4dade6e4ffbb6e7f341eaccd398@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ieee80211.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 470fafce2e707..870ae4cd82029 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -4575,15 +4575,12 @@ static inline u8 ieee80211_mle_common_size(const u8 *data)
 	case IEEE80211_ML_CONTROL_TYPE_BASIC:
 	case IEEE80211_ML_CONTROL_TYPE_PREQ:
 	case IEEE80211_ML_CONTROL_TYPE_TDLS:
+	case IEEE80211_ML_CONTROL_TYPE_RECONF:
 		/*
 		 * The length is the first octet pointed by mle->variable so no
 		 * need to add anything
 		 */
 		break;
-	case IEEE80211_ML_CONTROL_TYPE_RECONF:
-		if (control & IEEE80211_MLC_RECONF_PRES_MLD_MAC_ADDR)
-			common += ETH_ALEN;
-		return common;
 	case IEEE80211_ML_CONTROL_TYPE_PRIO_ACCESS:
 		if (control & IEEE80211_MLC_PRIO_ACCESS_PRES_AP_MLD_MAC_ADDR)
 			common += ETH_ALEN;
-- 
2.39.2



