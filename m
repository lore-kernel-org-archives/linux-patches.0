Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040919;
	b=o4fHOeK8DB7kdQecW7NGOy9th9Ch1LngcstOkcFJcLe0lZ7Iluq1yp2tbY3ygDa2gxrS
	 pWHFiJzmMK7+ZGR5fsHTJyK5LkiKzD1kkUWO38g4LyBppZRtHXaM5yChG5STc+wp5SJIf
	 yZXiO6f1lHUfQ1DpGi6q/O2vVihBfwBNApCTv3OcCEysF4KjKmtMboVKA8eCNFsqJxy8x
	 43+4akv08zMKTcgkesc7VleuLzgDSWBjtZboqwl/DKoAJe9W6eAPnoGPPlQvCdowSm/o4
	 YjlUdhpAgIGBRO4Hw1bOKYWnG+XUPtXBN+ioDJv6szUNGVHPAJtqifW3Awirkr2JUrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FV9bG0ubd+XUg9mgArdix0rEridNEkA+l188hb5+bFA=;
	b=RKlyflAk2Fy5dug4+v7WtkEg6yBcpvnoPrctwxAeZ0dkeNm5QKjOcsmbsEX5V8TCeWRy
	 E80mtAYs729kbMMTF44FC/Hpzg2rsF1issvQ/Jn6yq0552eLxaasrnqrrl6hpEplatgwl
	 PHvnWhe3Pd6lnO3FYEo8nVvgZ50NLVx5J9PKHWEr097+QARUdQKybqfAIALr0MUNryDnW
	 iGaOBtXkNlV+jtd6CYCtDU3SJgY/Su4CoQioNn9rMGij5vBl4DRiOCQnQowBTDdfAO5co
	 76omC+JgAdbmRFLoiFMKj7y0eoRl7Gyvko8JxXR9Qna5zlcVf6yVEC1eZ4penoapxAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a9O2BiwL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CE2606A31C;
	Wed, 18 Nov 2026 22:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a9O2BiwL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA8A1F000C4;
	Wed, 18 Nov 2026 22:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040919;
	bh=FV9bG0ubd+XUg9mgArdix0rEridNEkA+l188hb5+bFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a9O2BiwLg2NOBKPJKD/JgZ8n+82UwVG3Z/NS4AmCXQ4Xpt178wWxMz4qE2zWER3kS
	 iwChYyIdT+TnkQJkuQlqVKHWaFk6GSI96vB58G11GN6ApeSVM5A925qNfhd9SAjS4/
	 KKu7vuTXANVfSOzs10mpc3qFi9fIw/Km2jzWqYNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominic White <github@singe.za.net>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2586/3318] wifi: cfg80211: allow zero HE OBSS PD offsets
Date: Wed, 18 Nov 2026 15:53:28 +0100
Message-ID: <20261118150438.766732507@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2041d5a2186c1..08d321ce1a64a 100644
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



