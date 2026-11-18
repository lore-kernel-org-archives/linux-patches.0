Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055748;
	b=vOybnu18QoOnpsmdos9LfDhFpFWGE5EpwqvRyg3dia1yk+q9+R6RKikWPKl1aSFFTCVJ
	 Hk3M7RWIFipcJFX6mVws8wu6d+OVmi6ZuAesmsCV+4VmZPHG3pYMltTLICRW1wlw0Fimt
	 kpqxjWQQvrdNdbWv+kiSAQLjMYcgFohuwloIMBFHmTLr5G8ppQl5uM0IFYSC/O7R39TH7
	 PrZs7DO4RY4zG+FnU8XWvVQKBGnLbNTU/fsKB7JSpyizk8Q7RuevZJ1xglW3b4HWuGxM3
	 w0t/XKL07pBJLgabw9pwyMFDGr3VFppkTr3zx7vQ284Fitpaes7lbt9UQQbk9C4W37A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pdL6WZ4i1iaPbQ0M0og6kSujBtG56kXgtEVGi8b99uU=;
	b=xsiWOKuTbZp2sK6z0nXrSR2F9NiuwNBPEPvYPOD46ZYJcjKJk1BZ6e/Twj3awPW+RmUK
	 CwbsF4P24XtaYn0JL4czUEuu0/f2TtA570iH+SAqe2fyRmUh3tIik1bCa08R1Y48bqCXz
	 PyEnwDp19yYaozuIGysNeuRrw5IX3gUmG0Y/fWI9EuSV8x8e27PxVz7vI+5eFGsHqJU6d
	 XG7wW2NPDBCOCj04a4h2sOZ/8I4MMdTkjnI4npTRmu0qJkQdeNvbGyVNjXUUS1EvtQaQm
	 Ui/F+V6koJhITTuqgNzgwMbrq6aqn2ZUYQO9o0kNKnMRMcTXxcUQ4N8sh+y9Hqu2lcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ND32VQN+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70425606A32A;
	Thu, 19 Nov 2026 02:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ND32VQN+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19901F000C4;
	Thu, 19 Nov 2026 02:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055748;
	bh=pdL6WZ4i1iaPbQ0M0og6kSujBtG56kXgtEVGi8b99uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ND32VQN+T7t7o8COx9zeENnxs1TD9igDSKbP2zETwWT7O/bnrJ1lO1mfqNRsC8Uat
	 LmUSb/jpoZ9lLoka5CP3IhW7HpQSQLg8MSViTZ143WbhTyi2fH+RLCr1U/7bfhCPSC
	 3k/LubECX9HZHzV0Qkvt9AE8/HFcjOFbKKpVV9yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominic White <github@singe.za.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1743/2214] wifi: cfg80211: allow zero HE OBSS PD offsets
Date: Wed, 18 Nov 2026 15:56:59 +0100
Message-ID: <20261118150121.356943588@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0a68d4f838445..db2484fb68c62 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -354,11 +354,11 @@ nl80211_pmsr_attr_policy[NL80211_PMSR_ATTR_MAX + 1] = {
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



