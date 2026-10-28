Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216535;
	b=zHZbnMJSa7YJ+bfoQOMsWf9ODWidzIqlmb76cmt5PqSiwNKSpUHVGxIURFRdbUgPjW6W
	 YQ1ZlTykIxAOYMcv1dQkO3N+8wyegAD+uua5auaV7vSoxSBEBcw3v3iYO/dxZO7sOOFvK
	 lTZQKrZj49zbstFuyzCzyjB2U4UfcA6yQUh55bhb8x17oMDTeZUURy4lDvpoT3mQNWzUd
	 4K1TTQSJ3VwQgukmP4Bj/PQnWolCAL5KtTWf3nFyS0K9U86GQHGgoCjQXC1b/QdXUSgld
	 RxfQ9Hs0KdIgP5E5pJQ5KhCYggd6dN/82d/c7OXeMIBc6kGdKejhS7QpcKGEJcMQr9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jGdQ5tMlIdN5aS4Xwo7pB8dgSJT497prhGxo+qEJqGw=;
	b=Oj1f4ohDqHppUMzeqRnVz2t2Vf7R99sfGXtWgc4hwGBBqn3hhWJwzPBR5vy7Ti9qnOL1
	 vrqg6CV9TOkUcBNpO0Gr+CVaMv4SPBD+NEAEtyhd+p+f40y1EKrTC6TH8AhIZXp5XtteS
	 sZkxAjhzZRnYDrNvaI3xetAcyQ6W86mime0ExJc+NPp3DX632Qyal2B1r/4Y8nRpswYxw
	 jbNHkWNiPZ0wWyl8Y0NC0jl8cDfJqT+Jfty/SdMHZMxm/8CTR9ScfizsPOLVwAGIb1C9g
	 GpTXKu/Aid5CXYuNkONmXHR1Jm/KYwcUfnO+KRYkRBFyAbNV85/+avLXVsQLUIfXYjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ObSNU5Mv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E592E606A31A;
	Wed, 28 Oct 2026 19:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ObSNU5Mv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F379B1F01825;
	Wed, 28 Oct 2026 19:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216534;
	bh=jGdQ5tMlIdN5aS4Xwo7pB8dgSJT497prhGxo+qEJqGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ObSNU5MvtvWcKi51E9UR9f+MLDq53YYnXNDkHXYFpKIjzegrzFi5tc6OQuB7PgBub
	 FGz4Z/onSYRcL96ReshoAmNrumVOS6Nf8WcE2z5Jj+kV9uaKu8GEkYRBo1lJbEwbFV
	 YAfuCNp4eaSOGrNJNUXVGsYJHTaesGd9H6sYDDu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1589/1887] wifi: nl80211: clean up color-change beacon data on errors
Date: Wed, 28 Oct 2026 18:01:25 +0100
Message-ID: <20261028170535.630742066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 927ee844c47ac2aef22c8f7a35f098ff576b398b ]

nl80211_color_change() calls nl80211_parse_beacon() for the beacon_next
template, which can allocate params.beacon_next.mbssid_ies and .rnr_ies.
A parsing failure returned directly instead of using the out: cleanup,
leaking any allocations completed before the error.

Allocate the nested attribute table before parsing beacon_next. Its
allocation failure can then return before beacon data exists, while a
later parsing failure uses out: to release the parsed data.

Fixes: dc1e3cb8da8b ("nl80211: MBSSID and EMA support in AP mode")
Assisted-by: Codex:gpt-5
Assisted-by: Claude:opus-4.8
Assisted-by: Kimi:K3
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260731120244.82628-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dbd777ce43409..fab77741663ff 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -15968,15 +15968,15 @@ static int nl80211_color_change(struct sk_buff *skb, struct genl_info *info)
 	params.count = nla_get_u8(info->attrs[NL80211_ATTR_COLOR_CHANGE_COUNT]);
 	params.color = nla_get_u8(info->attrs[NL80211_ATTR_COLOR_CHANGE_COLOR]);
 
-	err = nl80211_parse_beacon(rdev, info->attrs, &params.beacon_next,
-				   info->extack);
-	if (err)
-		return err;
-
 	tb = kcalloc(NL80211_ATTR_MAX + 1, sizeof(*tb), GFP_KERNEL);
 	if (!tb)
 		return -ENOMEM;
 
+	err = nl80211_parse_beacon(rdev, info->attrs, &params.beacon_next,
+				   info->extack);
+	if (err)
+		goto out;
+
 	err = nla_parse_nested(tb, NL80211_ATTR_MAX,
 			       info->attrs[NL80211_ATTR_COLOR_CHANGE_ELEMS],
 			       nl80211_policy, info->extack);
-- 
2.53.0



