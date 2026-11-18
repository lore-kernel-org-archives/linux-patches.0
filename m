Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051202;
	b=iSi05Hck37wXLKP2NyqAzgF4/Ko+UgmV56bgSdgwd1yBQtHJQ4CUlJ7R+0nzphZnQKMT
	 gMcDqGm/6UpWq5JjJX3uLIbhe38FNKkHmGh5LkM/+5pPPta0eLmA2+g4I1rjTRisH5Hc6
	 cY4Dhx1TA6OCVlyXsyWf8006YanngcBInVBH9Cu6PjEMxh+FjPHOqGGwc99MSvHXWBnnu
	 DmH7c5ukX2C6YeyfdDtM2KUWsnBUBRC/jnhNmoE3ahlG+mw+Rx3/a6Qyzoynm0t/oxPzm
	 f7eUuBwrWigog8Z1na+zt8uuFEqwAuYffNNfRFfB28Q3A8DI7JG9NlAGcq3YsIOjx9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0FzabjqZlQHnoPe19AhoRE/kXQBti5q58OG1RYOUzts=;
	b=R7uyr2mh5Q8iTeRmxhc6R0g3prphZebf61leBBPmcJKzNKey9DSFJ4B+NsTOUtYhaqup
	 b0YYu0jNgyLeCkKehXxsnkhiOL2is3aVcjinvsv4HjlQ1KZtsR+d1htUqtgvOu7SGIzV8
	 qpHKbjQZHKGyn1rS0AKUZHnA8t5fAStzYkLlxdcMd8KmAo+Y27e7n6PQVY28VijM3Y/0K
	 vU4U6G0CbaLCdxamWowAKp2IiJVGimTuHY7+tPkAboScYwozqHjEcLg4exKiWg//uD7h6
	 ALT7iPezcWe0nAM0TOFcG2k0kImnzMtFjmxXXKvFM0cO+kauwBstZyPCFLG0x5r/WAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D6UYh+WK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2020E606A320;
	Thu, 19 Nov 2026 01:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D6UYh+WK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D23B1F000C4;
	Thu, 19 Nov 2026 01:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051202;
	bh=0FzabjqZlQHnoPe19AhoRE/kXQBti5q58OG1RYOUzts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6UYh+WKZaAJJCCqYzWRmt977srdjWq5xBxVd5wqX2ecEH+6VSTSkuD/p6h675gZn
	 HquDbDOQc5uucHoPXX6nlbgH45i5ruHqWW3QhSUW7+0vZESHY/ajJsgzKtFFkePyVJ
	 FcIC9L2g0SeqLed8RfvLbisg5cnXDjgJyqegzajk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0123/2214] wifi: cfg80211: include cf1 offset when sending chandef
Date: Wed, 18 Nov 2026 15:29:59 +0100
Message-ID: <20261118150015.072650084@linuxfoundation.org>
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
index 312163181d6b6..0a68d4f838445 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3571,6 +3571,10 @@ static int nl80211_send_chandef(struct sk_buff *msg,
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



