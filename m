Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029A31875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B470C433EF;
	Wed, 28 Dec 2022 15:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243089;
	bh=/z/2bEyjvG3X5raRl8j6f1VOqfijVpW40Fqf4ISUH3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLMnfkJm3kwgq5yd15l9Y/+kyq51u9y8Zb4zMW+n6NUYXSic/CfMLiJH6R4IrmC6I
	 pt8a0Fwwhkwvhqo7GlZiK1qxp4vIdbV5C+qyz4TzjIL/9ouEBx+jEsGjA4YvoYX6hm
	 nzb07LKjs8m0lrzx3QLnG2XV0Zhbe37UD53mi9FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0450/1146] wifi: nl80211: Add checks for nla_nest_start() in nl80211_send_iface()
Date: Wed, 28 Dec 2022 15:33:09 +0100
Message-Id: <20221228144342.404678880@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 5cc58b376675981386c6192405fe887cd29c527a ]

As the nla_nest_start() may fail with NULL returned, the return value needs
to be checked.

Fixes: ce08cd344a00 ("wifi: nl80211: expose link information for interfaces")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221129014211.56558-1-yuancan@huawei.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 597c52236514..d2321c683398 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3868,6 +3868,9 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 			struct cfg80211_chan_def chandef = {};
 			int ret;
 
+			if (!link)
+				goto nla_put_failure;
+
 			if (nla_put_u8(msg, NL80211_ATTR_MLO_LINK_ID, link_id))
 				goto nla_put_failure;
 			if (nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN,
-- 
2.35.1



