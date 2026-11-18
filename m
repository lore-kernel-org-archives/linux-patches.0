Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030889;
	b=J+fTbl4ecvdSeVBm4RIrIClV6ClsbF/ayLNLbG/V8hSIYD0FWJ3FrKoL5lZLpcwRm1wx
	 3QSonjd4pLn2LVj1cBvgfllQLlgv+fiYSKeqZ5/Rd0w+2NPZXAJc75Q4/U7AyU9nvD0Sj
	 9g4tJnMsDmTjh/Efh1zO7Hk6H3Y8HX0VeD/oCW7PSMfJBzK65c/R+lnWnn07/nrSzlfM9
	 lLiW22Btbai5yR3OL34r3H/jCc3IWS1uN6SNQLQJ6GPJxiEMs4EbwiysRNGjk8LauFgh3
	 HzoPw1vVhOOuJxZps1507PsXgvkrqsso3AImxiOhY8WGN/UtKheaoG4Y93MvOMj/wTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g3qIUeFFVLW96UtR7tbLmwLXExLGGzA5XKT76K1VsO8=;
	b=nm+McQvSpZlcDt1lArvR7EAhb/4Qbrs3qE3AMfy5a7cLtQHnIz/x50onipudLwsN299n
	 Q63Rnu5Na9oZz0NZGsSnmfCkuj0It0O/sjTx9AZlKC5o3W9QZXEKxPgRr2CWtveLQUAJZ
	 ljb4YpAg2mITOn52/yTjSakHZVJLWu4gG9WrQNwdPh/aICTzuK6CU1cVIebHqIIR3SkUz
	 cBi0e+ZnfpQwAFP3YySR9DQuAHcplp2354SQKez3hpBBDmBtaKJmgyZtLMHGokyez6y/+
	 K9JjWBZEPRebsfMKdUILaUH0Oea2Yx8yPPy84dL/3lamPQUU8onr/t5reObV00fQWtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iXNL1xDT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A0E606DD0B;
	Wed, 18 Nov 2026 19:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iXNL1xDT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA84F1F000C4;
	Wed, 18 Nov 2026 19:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030889;
	bh=g3qIUeFFVLW96UtR7tbLmwLXExLGGzA5XKT76K1VsO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iXNL1xDTMceNRrQSRDlQuwWzMPLn5vEfrcLaYaMZffSey9e02CHjOpVZJd+icv07V
	 OxXtEdNEzDNAW3+ANvfHE5GkyfO68cADT/yNsuDw8EMJg9GNq+Bw4YDS7syy4XV/DO
	 g/aPwn5CURBz3f0+IqIu0T8/HvbqkLOs3mRPjIj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominic White <github@singe.za.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0863/1756] wifi: cfg80211: allow zero HE OBSS PD offsets
Date: Wed, 18 Nov 2026 15:49:50 +0100
Message-ID: <20261118150043.689287878@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 443ee72e58e0e..0062ce34d4efb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -365,11 +365,11 @@ nl80211_pmsr_attr_policy[NL80211_PMSR_ATTR_MAX + 1] = {
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



