Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033895;
	b=gqAWpXbFJoH+dZhY0mZeh8f2lW9fRQJuNjZ5DWRI5xl8I7oiDHg0qY5iqZRCtQOrHDgK
	 bq03jFkvbR1SXh1UB9L3tQTwYPCl8NLAXPzHm6t6XunB7vAUCTlokAVFZoHw4zVvnNNAz
	 Q4+EkVX745+e8x+JeFMGTtV+lm/YuxEsGfaVCsFCt8KF5HyR0B7Gvs4MSWLSEaV/jr4Re
	 aHp/zva0jcxdJi282GOt3WOp0tMcHwiYeFFB0DVnY5by9niHAaa5ithW7bWCppZgyKLWk
	 oonK54cqpc0d87U1rSDjCYd3aVJh0zEW6SVjZXO9N1jfAHX31IoQEPDffJSt5IPzkBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033895;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q4SLevB8NoZByXL4lz+0QkEFzAo1i3VpGPK0kHGaFmY=;
	b=eE0CDGQwS0h3AL8XkjdLjdOK5nj5UV/cyLTARSiFPJPVJ3wSXo+I1gs0qt4r4b0QZA2A
	 l2Uo2kv+hujYG9thQ0sBX8l0btqkSCGbWuXh+5lXN5LdP8caplp1pl9VP1QUVDSvKKOWP
	 o5kzCITwuo4iRzjKog5Ula0RWiVirwgZ+9c6eGFtMyFDSrOF8mNHZbyQscgZt7lYTokZz
	 kh4uMhQp6mcajOpswMC6FxAywRBmTdyMQooLM965zCFc7bPz4c8v3UiYtY8uUHb3vHAoh
	 vjYyL8dRsRioGith0xS1CBX++Vk2iuQid1jbEHEwrgK5bkienmT7m8qfG+XEqaeTxmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L3Lh7yu9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82499606A31C;
	Wed, 18 Nov 2026 20:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L3Lh7yu9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DADEE1F000C5;
	Wed, 18 Nov 2026 20:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033895;
	bh=Q4SLevB8NoZByXL4lz+0QkEFzAo1i3VpGPK0kHGaFmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L3Lh7yu9fKMUyGTX7afzH3oQHkyt7lVCau226QngjGopbxvbHsHwc86y6i1nj54JU
	 MCNkdeMiSvAdcvnAFgaByXItBIK8VRgNUAqRXigTiHHTryWBotvO6vXkTawr8F3yo0
	 cbKgLjZMANIuvCJ1pa8LS6URMQq2iLYQiTevDDmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0160/3318] wifi: cfg80211: include cf1 offset when sending chandef
Date: Wed, 18 Nov 2026 15:13:02 +0100
Message-ID: <20261118150319.374195566@linuxfoundation.org>
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

From: Lachlan Hodges <lachlan.hodges@morsemicro.com>

[ Upstream commit 5a69b8dffd2a1b06e4cc4c9003c639eb78bac4cd ]

The cf1 offset is not included when sending the chandef leading
to incorrect channel resolution in usermode. Include it.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Link: https://patch.msgid.link/20260721053958.227853-1-lachlan.hodges@morsemicro.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3eccc83fa79b7..2041d5a2186c1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3845,6 +3845,10 @@ int nl80211_send_chandef(struct sk_buff *msg, const struct cfg80211_chan_def *ch
 		return -ENOBUFS;
 	if (nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ1, chandef->center_freq1))
 		return -ENOBUFS;
+	if (chandef->freq1_offset &&
+	    nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ1_OFFSET,
+			chandef->freq1_offset))
+		return -ENOBUFS;
 	if (chandef->center_freq2 &&
 	    nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ2, chandef->center_freq2))
 		return -ENOBUFS;
-- 
2.53.0



