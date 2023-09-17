Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279B96FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B60BC433C7;
	Sun, 17 Sep 2023 20:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981839;
	bh=rKMqKMYtPuHxuvWgsRpj7pbF/B5Vln81ztXoh/FcueA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBGZYIK2e5KbZNGgf9bNHv00YsRbFE82/oWnghl9Bh0KPEmjXMHgZz0Ho/TMKYYpH
	 TRj2J1k5W9YNiiu3B0r+Qrhfyf4NIX9g/KlKLarNheN6Gpi1XchNZmmndGMhin3AK6
	 Mn+PONdvtRpBcVs1+K81gNa/NdYGzC3fv6uOb9Do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Simon Horman <horms@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/511] wifi: nl80211/cfg80211: add forgotten nla_policy for BSS color attribute
Date: Sun, 17 Sep 2023 21:09:00 +0200
Message-ID: <20230917191116.585562351@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1b91a9c208969..ed3ec7e320ced 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -314,6 +314,7 @@ nl80211_pmsr_ftm_req_attr_policy[NL80211_PMSR_FTM_REQ_ATTR_MAX + 1] = {
 	[NL80211_PMSR_FTM_REQ_ATTR_TRIGGER_BASED] = { .type = NLA_FLAG },
 	[NL80211_PMSR_FTM_REQ_ATTR_NON_TRIGGER_BASED] = { .type = NLA_FLAG },
 	[NL80211_PMSR_FTM_REQ_ATTR_LMR_FEEDBACK] = { .type = NLA_FLAG },
+	[NL80211_PMSR_FTM_REQ_ATTR_BSS_COLOR] = { .type = NLA_U8 },
 };
 
 static const struct nla_policy
-- 
2.40.1



