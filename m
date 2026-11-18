Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031332;
	b=LpF9z583KR2rkxkv3pBni4dJ5H1J2LlZ0Fa2mDRT8vQDxFiFE4dG4hYRqAd1WuUqiI1k
	 256bQ4VuHCUHwAGQxajtCVbWlUvrSlmSU9heRRpIVE0wLNgJwGGPsrR95YDGyaKzUENlR
	 k6mDPPNJCcT6jxBIvbteSil3Z8Xpv6+r/nnnMvDKFKnEdy+Yep3uOGHNK9QyG9oo/iCYY
	 sga+cBn0eDOqmyNxOwKr8y4TdEsRxYou2rneHd5tzC90qQM4/bXF3ZqbVkb4o2ZcssV/A
	 Do0+bb2mMTcY2bxvw7KSTot2zZjzfWmzrkSNqowe7Gm3m+PIXM6MKtgcFqT5HUpUj5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gcsILDVfgLXiAE+CuYvqrjEirMfZl3HKqRn1unOd75Y=;
	b=C0PC6iU2GCgQ0S20UNH+ggREmBdhMu4XoLHEJMZkZPeyMWm1TEfdnwgLPv4WP4MPDSc7
	 sA4a7kHKB6Bhkdhv0CzqNZIEmmyeI1jV8v+MFk9lgL9oy21JkiJ1YPeL3xRvUD9+GMh7K
	 iCSl/ujqT6RW8jePTvAPjqjSCnLf3C23JvW7xyRR4Fby949S3ys74RaLyf9mdEEz53GUl
	 UuY/mFHuEgBwlp65UG49f1FlV2GhZJY1iDXqgykEPtpFpRU8lscJk3w/VVvMTUmu6dS0V
	 CziwJ0LqFckjq9TYLa2rc+pFUckGct2AX3UsdVbJ/xdxM/V+2xHDmvXGqRs3U/08WiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oExmwl2j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30132606A31C;
	Wed, 18 Nov 2026 19:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oExmwl2j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D621F000C4;
	Wed, 18 Nov 2026 19:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031332;
	bh=gcsILDVfgLXiAE+CuYvqrjEirMfZl3HKqRn1unOd75Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oExmwl2jPdzpspkh6kzrKYuRhjAKPaOF8t6n7xPkE+CNs7M9aoxReToF5cncEaAgD
	 Fi2lR21I/o0YzmQU6T96UT0H/+NwtND5ZLF2MQiL3dybDl+kkv+h7MrFgN+YHhYfyw
	 sulZyvFB7jtz2W4tLDys0EufejqjqcOiEhC/0u1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1022/1756] wifi: ath6kl: dont take RTNL in del_virtual_intf
Date: Wed, 18 Nov 2026 15:52:29 +0100
Message-ID: <20261118150050.791869267@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 97aab70a03df478ffefcf890ed4be258c0240bcb ]

cfg80211 already holds the RTNL here, so this will
just deadlock. Remove the extra RTNL acquisition.

Oddly enough this was all true even back when the
locking here was added, so this is just a revert
of a broken ~13 year old commit.

Fixes: bc52aab380c7 ("ath6kl: Protect ath6kl_cfg80211_vif_cleanup using rtnl_locks")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20261008165646.48866f0521af.I1c166be830384473f67677eeb187afa7e54106ea@changeid
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 163351b169961..9b5e6207474d9 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1551,9 +1551,7 @@ static int ath6kl_cfg80211_del_iface(struct wiphy *wiphy,
 
 	ath6kl_cfg80211_vif_stop(vif, test_bit(WMI_READY, &ar->flag));
 
-	rtnl_lock();
 	ath6kl_cfg80211_vif_cleanup(vif);
-	rtnl_unlock();
 
 	return 0;
 }
-- 
2.53.0



