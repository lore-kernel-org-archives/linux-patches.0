Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018734;
	b=rysbhkBiYUsjcHO7DdQYkBPQiDUR6vYvzwhdSYRdSYqlZl35Aeilt40GgKOxokz/OdOa
	 UdgPUIW70rs2ydUWBITUu14Q/4fyutWDxiNHzylhuWM83xhmr82frzRnRSjdWTY7U1/p+
	 1c75BtD+rPmxASKhVUvW/3EKAi25ymxWkYVP63YhB0UPEu6ioJBy+5GQ4/NFkUobhGJFC
	 YWVRUEB63b1zGad4e/7DCTJt8IY7antSJGbQSVSrmQwuBKlnQ7SSBZHd0LZ1kJR6gDgll
	 mh9NKadfY1p0O2vfk/n3Uj+7kmZUGcBHlRD6xdIpQ1dZzkSif8EOiOMd3LcAM6+knBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018734;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gKaiekWELwsBSpoirdYRlwNm6QWzJUr97dLMAjwofr4=;
	b=Y+LVLNLi5MHsjGh0jg+zXtbQ+8oQNQOadLGsh2F6N9kfw9zElHh2XI9WHij7ENXlNs6/
	 ZzwnpGRV31AesvkDxJYZzdFYQJDUzPQSo2zMJLVRn77X2HkrB24XgDeXz9SKAND0OAZrl
	 QfXtCE0YUd9nZhlvgAFLqCGNuH5fMiXppeHj43pi37+vFkCJE2Rgz5252L3ePQljklsy0
	 TG14rAUSUSyyervOQccyApRKfix1aDtPSBLDJjOv39lX2KNNAwtV9g71R9c4fcCZukwOg
	 eCWISv60cgNGeHgr9LoxkpvF26mQ25IanPrTcNQDS5U3W2t6cwhDn3QuuCKUJFNqPwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Blw0zdRo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D02606A32A;
	Wed, 18 Nov 2026 16:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Blw0zdRo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D1B1F000C4;
	Wed, 18 Nov 2026 16:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018734;
	bh=gKaiekWELwsBSpoirdYRlwNm6QWzJUr97dLMAjwofr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Blw0zdRoZOamRDp2JrvtXwMCdRMbJ9rwPJ1MxUFqRCabdw+xi7QiWbHcxeIlDbs3F
	 bwm8dMrofcZz2enH1L7rQklk4b5CIQbHg7bb1FU3YgASa5C8a2rLgrFpAD3shgwJL5
	 3BZ0Pc07agXyhtxzm0vE5LucPXLbugre9u0NPeHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominic White <github@singe.za.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1308/2651] wifi: cfg80211: allow zero HE OBSS PD offsets
Date: Wed, 18 Nov 2026 15:42:28 +0100
Message-ID: <20261118150335.066125559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 3f3c341967ee0..7acab4fd2860b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -529,11 +529,11 @@ nl80211_pmsr_attr_policy[NL80211_PMSR_ATTR_MAX + 1] = {
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



