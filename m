Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061207;
	b=LpZxs3sBviVXEW7iQkS9WGUqWdhvNVdIbAfaDmOf7pVytKk8HHau2lloCY32oHs7z9gY
	 m+HkXwuMCCKwvB91INgsTT20AiEeRKhFz4yNIZfrb9AQRYT2ygMmbc2xq5XzHlykL/HFw
	 4qworS7STrJ4HcdhB5tGC304lTcDEqu8KoxoV3rIG7V4luAoabUBfzIct0yQu3UXqOPGg
	 ht//pNKlRIlZJQ3s8dZ6gCSGDraEkkIzshjkOws1ESRDeEg9v1yMA2mpk8JWRi/UkOoaY
	 vkzyYOOMtPY2HT9Monr42MkuPPIc2Y6ErnvS9zT4eMwpeWboRkAqvaI4obS2s6h0Zjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F+3uLSN8PAlIXIoNoJdP2D92KL+JGCPLx9jen8uFtyc=;
	b=fhXG568bg08AFA+JXZoYnXLO0KDRX2dQpn/ivsyQ/37cwZebvc19YQJhEACrG8IuC89O
	 cSwg84IZIebap83DvrhHss9UCa3QB1wiZHCVl1x24D85SjMFw87akMAxmlVKLPg82PZC8
	 k198NtAvBRK52pMPTS2HhjfO5HnbcH2JA2SJNXYaenVyfTVUkvT6r9n/IbCGBL00u6HiR
	 wpAKHxJj3OUmUaarHw8j2kUQpdkK3xMo+0hICWfI3KN/HSaEbUONO5nv2tKSdBiq1ubqv
	 WPl5XdI94/uUcI60DooEy/lq/0VB/1sxPMYF/ZefSN/3JYJMrrfvzOHn5iyynTcL84Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XFzWXjMm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C55E606A320;
	Thu, 19 Nov 2026 04:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XFzWXjMm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8BD1F000C4;
	Thu, 19 Nov 2026 04:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061207;
	bh=F+3uLSN8PAlIXIoNoJdP2D92KL+JGCPLx9jen8uFtyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XFzWXjMmod0dpjFl9Pbma2KrVql1QOxuiQ6nnJknWe5OzMb1DbwV+yOSj/w4Sfdv7
	 5bUeScL8KoEqW4wd1onX/BdE33QiGUpzcwaOjaiewqqfTAQRJxvTg0exAbyOnJvegi
	 WjxwaT/j3agok+9rIEAnjDXK/Oy6R5gF6Ge1WGH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominic White <github@singe.za.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1471/1848] wifi: cfg80211: allow zero HE OBSS PD offsets
Date: Wed, 18 Nov 2026 15:58:29 +0100
Message-ID: <20261118150020.888693426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominic White <github@singe.za.net>

[ Upstream commit d9ecaa0a31732014a128e3b03243de54bbbd8394 ]

IEEE Std 802.11 permits the OBSS PD offset fields in the Spatial Reuse
Parameter Set element to have a value of zero. (IEEE Std 802.11-2024,
26.10.2.4)

The standard specifies the offsets as unsigned values added to -82 dBm,
with field presence signalled independently. The valid offset range is
therefore 0..20.

nl80211 currently rejects zero for all three HE OBSS PD offset
attributes during nested netlink policy validation, before the values
reach cfg80211 or the driver. Allow zero while retaining the upper bound
and the existing minimum/maximum relationship validation.

Fixes: 796e90f42b7e ("cfg80211: add support for parsing OBBS_PD attributes")
Signed-off-by: Dominic White <github@singe.za.net>
Link: https://patch.msgid.link/20260903081804.96532-1-github@singe.za.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e175593d8cedd..ccab4d673b2df 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -332,11 +332,11 @@ nl80211_pmsr_attr_policy[NL80211_PMSR_ATTR_MAX + 1] = {
 static const struct nla_policy
 he_obss_pd_policy[NL80211_HE_OBSS_PD_ATTR_MAX + 1] = {
 	[NL80211_HE_OBSS_PD_ATTR_MIN_OFFSET] =
-		NLA_POLICY_RANGE(NLA_U8, 1, 20),
+		NLA_POLICY_RANGE(NLA_U8, 0, 20),
 	[NL80211_HE_OBSS_PD_ATTR_MAX_OFFSET] =
-		NLA_POLICY_RANGE(NLA_U8, 1, 20),
+		NLA_POLICY_RANGE(NLA_U8, 0, 20),
 	[NL80211_HE_OBSS_PD_ATTR_NON_SRG_MAX_OFFSET] =
-		NLA_POLICY_RANGE(NLA_U8, 1, 20),
+		NLA_POLICY_RANGE(NLA_U8, 0, 20),
 	[NL80211_HE_OBSS_PD_ATTR_BSS_COLOR_BITMAP] =
 		NLA_POLICY_EXACT_LEN(8),
 	[NL80211_HE_OBSS_PD_ATTR_PARTIAL_BSSID_BITMAP] =
-- 
2.53.0



