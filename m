Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025486;
	b=210K3bHhOwFXJ69ammi061UKJ6lmEh0LRsPh6XSeVJaXAOh2bqwaOPRVE5tGyfQg/f4y
	 jZADkfz/b2btTD1J5hdCyU1WTptX/8mZ7V7iRL6CzjeKWb31vTPdwGD0OADNq4MtroNG7
	 WUQ1vCtFDn/SzDn76o/2MmuUoJ87f7uNZD85A24eNLJ8MQJpSxeooCzwUwngPp5IiKZ99
	 PcPwdg3+qxqyS57mvB3Cx3HfSZzPf3hJWmBXR9A6mKVF2A2MSQ9OxosFTg99OTIbpdiwU
	 7PsNYJSUlK/cQ6nC2DZ2TNwyZmCouXKI3IPs+jLJM08scrDu3lthAuT9w3n0HGAu3Dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NYV+L9mUYPppHtrxVn2u7bTFofgnh2utkEECW6ivGNs=;
	b=G+70I1eDSBHoaHG5mpcGTPHvcvdSt45JWVuJR043n4e+KgKu9bWD06Qcs5fUIMlBcv7i
	 Wm6UZoetoE9HzO30Ya3rJGUNFNAr5DgC+TzdWAWOOSOrYofaA7CGfr2RIM0cdxqTDSViN
	 BDLaeCa8VvpmLmNGl0jtrvE5jwQ1hHdm6kH01gyJvwpcLxEgfeXxfmCqx8pDXBkE+qXMo
	 PjJPS23NhwLbyoCO9RblnRdr7jiZfvV/muTPlErPmhz0TLgQglIsU4TrdQ2fXaY3RBs32
	 olOTDoTmDpDcrOOtdqaEQOVgU9/vI50NIs2dSMNkU1CLswpIaLDy4tVYcJGiNwIDxUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hfZwdjYG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64505606A32C;
	Wed, 18 Nov 2026 18:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hfZwdjYG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 704681F000C4;
	Wed, 18 Nov 2026 18:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025486;
	bh=NYV+L9mUYPppHtrxVn2u7bTFofgnh2utkEECW6ivGNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hfZwdjYG1wg2R6dEC8XfqL9XG6JhxjhvJizFdxYn0q3iTkwKImkWbM8cSaRbW3kCe
	 cJjU09/kNo5MIx3K/lipnQ8pWhpodZxP02PnKqOHiza41DBWW4UEA3LLuFRkrcmqkV
	 qb9jCyruZ4I6xYMoe/B0LUr2CrVYecC8KvYxecYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominic White <github@singe.za.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1095/2151] wifi: cfg80211: allow zero HE OBSS PD offsets
Date: Wed, 18 Nov 2026 15:47:10 +0100
Message-ID: <20261118150202.161218762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6ebbb16accfe8..d4b1e5dc5eb4f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -456,11 +456,11 @@ nl80211_pmsr_attr_policy[NL80211_PMSR_ATTR_MAX + 1] = {
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



