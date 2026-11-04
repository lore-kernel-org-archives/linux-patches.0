Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829657;
	b=zkT7GBhp5c8rzQBNVCHph/V0iWSaGKJBazDMqRI+XRrNPpDS5wCb+CxNKVohttidCeA+
	 mad694VWADmh3ITkHawtbNZwbM5OqCUpm31j7XBbTQ5IctLZA0cizn/kbM2lBpF0gXpvB
	 ZSJRswVfKh8Dodooro1r5+D56M0d1CkuMFO7wSaMtwRk/nHO9CC+i7jIxcNvyx1OV9NB9
	 j2XGrnE80D5eYoNfg5Nc1T9e+nfDVV83jNpJaUnNLphreCHVQeQBjc0vkUJzqAi3+b4+h
	 5wHofFGeROKwpmuGwxHDngNWKfm2Fhz3RarREFHUIFENs5FgLl1aPdRUsCpPsW+6jtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AEwBkWCs5eTRSnBbqmtzS2L/7U6nJKwA1UuymOaOqK0=;
	b=cFodGx0VvdQSbLqTOk8/bZST74MBgZUv4SfovqQL77/e4prxSzoaE2Rr9R12z1ROxLlO
	 C/BmkURDeOFRKhVPe4IuSZmDuN/i6LOxYmJWdG3t+55vmFM6Zm20gJvUrgqmhbZi7mVon
	 +BRWVeJ/sJ4QfWBaysh2JdpyrHPCqJbFZMt48AFH8m8cYb+naOsgs8KH2y8MhLRFxa0CK
	 GajOMbNTbGcUF+DSKuMY1TDu5I4wqtG/Xe//XLBaxHuuDcP0nSOQ5Jw2BfnXW7sdkE9DQ
	 gZtAVwrMGballo+HK6438YptxHRSwpxAK+H8PMFFi/vJKUuc8wsX4RtJUeCvQ0sNLzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PcV7gnoy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA91606A87B;
	Wed,  4 Nov 2026 22:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PcV7gnoy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593D41F0093A;
	Wed,  4 Nov 2026 22:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829656;
	bh=AEwBkWCs5eTRSnBbqmtzS2L/7U6nJKwA1UuymOaOqK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PcV7gnoygiiigmkv1IHU0vtC2Ziyt8taIoJWGTCzYJfElr9tD4hZllRzwIxVGL5zF
	 uqSU3hey9TXL8t93/l0ghWzPMetglLR2gC+IzPk7lmttneJmCqG1WxvYYPQhUwYOPr
	 MNhqSAF0IMERssTCVH0CGn/el86DCo8/oKD4Oarw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0222/1005] wifi: cfg80211: include cf1 offset when sending chandef
Date: Wed,  4 Nov 2026 15:59:15 -0500
Message-ID: <20261104211050.038370223@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index b851e398b1b36..6ebbb16accfe8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4260,6 +4260,10 @@ int nl80211_send_chandef(struct sk_buff *msg, const struct cfg80211_chan_def *ch
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



