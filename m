Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF451170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C6B6C433C8;
	Mon, 11 Sep 2023 14:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440814;
	bh=7r9kEcu1172ODM0aLL5PdjavzOeL/EHdyjlSSzQwMdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bA08cAMERFcTK/AntBinvlCEeFClu7kq8xmuL+RpqaItA3UtXDGMNJLzJoTsc4vHq
	 Y0fVQ6E+RVe11dfAUKf6pbKnyz7Uj+L9kuoQGRysbdvj67o50OH2nhpQRaVZCMA+4B
	 qCMfJAklDdv+k6GcRSM3oiiujyrMn05Ln66hcB2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 167/739] wifi: nl80211/cfg80211: add forgotten nla_policy for BSS color attribute
Date: Mon, 11 Sep 2023 15:39:26 +0200
Message-ID: <20230911134655.840480956@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 218d690c49b7e9c94ad0d317adbdd4af846ea0dc ]

The previous commit dd3e4fc75b4a ("nl80211/cfg80211: add BSS color to
NDP ranging parameters") adds a parameter for NDP ranging by introducing
a new attribute type named NL80211_PMSR_FTM_REQ_ATTR_BSS_COLOR.

However, the author forgot to also describe the nla_policy at
nl80211_pmsr_ftm_req_attr_policy (net/wireless/nl80211.c). Just
complement it to avoid malformed attribute that causes out-of-attribute
access.

Fixes: dd3e4fc75b4a ("nl80211/cfg80211: add BSS color to NDP ranging parameters")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230809033151.768910-1-linma@zju.edu.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8bcf8e293308e..4dcbc40d07c85 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -323,6 +323,7 @@ nl80211_pmsr_ftm_req_attr_policy[NL80211_PMSR_FTM_REQ_ATTR_MAX + 1] = {
 	[NL80211_PMSR_FTM_REQ_ATTR_TRIGGER_BASED] = { .type = NLA_FLAG },
 	[NL80211_PMSR_FTM_REQ_ATTR_NON_TRIGGER_BASED] = { .type = NLA_FLAG },
 	[NL80211_PMSR_FTM_REQ_ATTR_LMR_FEEDBACK] = { .type = NLA_FLAG },
+	[NL80211_PMSR_FTM_REQ_ATTR_BSS_COLOR] = { .type = NLA_U8 },
 };
 
 static const struct nla_policy
-- 
2.40.1



