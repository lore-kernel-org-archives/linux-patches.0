Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049225;
	b=yWOiAxFNbVetUHjwvBd+2IAihOe2HSCP5YMZgGE0mrLu21EpYWwD6/dNvrshIsRlu/ks
	 cVDFzhUn8Zfkk9h3ox5qCUJuXb+vTEHE/o/6kbFaaFtUbWmKTqdzTnBR+6jZeAZFgA8YZ
	 bwKnCVzax/dhmxkARueOgVcJdihejvy5+3gTOw0X5tAtXD+MAELBAEokgAyE+Eps8ksAq
	 UHGhp66KMisyvjXaWCLDOQQCJNc/MKOH/eCCfBKlYxXhO+IxJzQyWfHNuIMU0FAsfsYag
	 v9BBB/pJAH2rO/STx/XGO0Damn71Bm4p8ECFdPSfR6J0GqcIiAHXI/r7sj29hjdGS4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049225;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fD8KptXzgdVccsMwZ832pd69bRedt8Pu7Qe6RrIeWnU=;
	b=LYeH4ikEFCDS1PI1GBRPVXsg83Rss/Ikpim9M7WdvIwdF1D6DL9YRZ1u1Dk/sM4w6dhw
	 wF8Skicp/zKJ7fJV08mjeP/M2aKy3gW0/8bvbdRXT7OSzKODHy28fQZbKgyajpkt1Ardi
	 bI698lprOXd0isoQnLlJbNs/fqpMP87PPYXqPCRg/84/WEk4aYj26olppsKenPyk2CZe7
	 jVFLcLq9ERT/+W42rJSyXuQyLgjIU+PucpiOkwMhgItOGkpy2L3R4xvi+MOW9IUxGmKnZ
	 oRnvWdQNwBl8vvdd7RLMc9CW8IDBobswwcbO9ROAErXcbf1dMOjud+FLLBYrI1JmjOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hc8ATZi2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028AD606A31C;
	Thu, 19 Nov 2026 00:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hc8ATZi2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B941F000C4;
	Thu, 19 Nov 2026 00:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049224;
	bh=fD8KptXzgdVccsMwZ832pd69bRedt8Pu7Qe6RrIeWnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hc8ATZi2JCQZB+tXDptk1oShbg3r0aCtRaMqlaoW2JPkE7wZXP2jH267LObge/7zE
	 NlXzElA9wzV+vMxKYuKhLimD5lnY5AkWrE9UjENQ7IuQAHp/VDN/LM9uv+jeB42M86
	 cy7QOcbNU8qq8J90WehSyPeMp4wC3nzBxn3YODZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominic White <github@singe.za.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2235/2857] wifi: cfg80211: allow zero HE OBSS PD offsets
Date: Wed, 18 Nov 2026 15:54:29 +0100
Message-ID: <20261118150321.907413825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index f94ba29f2db1d..42eeb3782c1f9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -363,11 +363,11 @@ nl80211_pmsr_attr_policy[NL80211_PMSR_ATTR_MAX + 1] = {
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



