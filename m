Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051575;
	b=kxOe1Z6vTJiUfRCnFtJJ/VtCwSXUGJ00boHCuuP6hE5u2Av0QK8Akz36ueFiLMuwYAQI
	 vgjlZ2bvowGAJ57JTflm9QC9A48w0ACs+m0kosPVbH2C482lG7ZVEizyjobfVk+eHMh+e
	 ZhQ+FanEiMGw4NLxXl+bYqIrUnn/0JA3gCsSczdyhnaBcqnG8udp2Zc9jHLaP3cfE9WrA
	 Wv59CmRt4DEq4bELgtFjgoslMpbIIecNqv2gFfIxWznI3xBeFw5EXgrTsj2Sb69IJyjSA
	 KPqZFmaUnGDh9FN24xEZ8gowx4Tb0bsaDksbcgUI7YDMks0Xv3r/zU6tTzehLBG3E4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sOuWTwJn04rOhYJf659cOQsWzpfvWJEolWHSYhgb0a0=;
	b=F9j3s8Iv1RdsufiuoaEqidC3d1EAjJnsJp2xlQt7IiWVidacsPqN3yXaKv10BiHllD3W
	 xvoFMqBKYn3lcbDnZW89BwErFUFNYUuSdmrdQUiYGCEOAnWcWMSW9m4/WpcxqSv6skghQ
	 PbvpEOH54hKxHESsFApGexJO3SiXR2K50UhNBMr4VsUXJUHY+SVGCWadEJsqX/s3Lqm58
	 TebivQ7Bi/ATMKecYKzPHWsB8hX22UoDEkR2Wq9z+1t8i1Mf98U1+F6HMTIvsG66Q4zku
	 2AyP+/P/skZCNMw7AEzUylUOyJlttoiaRM4YqWLXem9dJvNwlJnyan2PwjfTs4+pB9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2P36VyT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401DB606A31C;
	Thu, 19 Nov 2026 01:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2P36VyT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9570D1F000C4;
	Thu, 19 Nov 2026 01:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051575;
	bh=sOuWTwJn04rOhYJf659cOQsWzpfvWJEolWHSYhgb0a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2P36VyTaLq5l6zWFIrEB6ULYmizIBzDF6XXZlpmhVthT43jdCOPmVIYvFMNE+0VQ
	 Nc95SvGxAuHdOFK+aU/DyYVgDymm5db51v+gl2XOxTeEgy+QwkrAC5UEv4jkwsRUgm
	 Imayrrxa60hWEwqAxAX/RlK0X6Dzigm1YE1+WFoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0255/2214] wifi: cfg80211: release locks on error in cfg80211_wext_siwgenie()
Date: Wed, 18 Nov 2026 15:32:11 +0100
Message-ID: <20261118150020.336980658@linuxfoundation.org>
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

From: Wentao Guan <guanwentao@uniontech.com>

This error path returns while wdev_lock() is still held, so one
malformed IE request can permanently block later operations on this
wiphy. Route the error through out to release the lock.

This bug is stable-specific: it was introduced by the stable backport
commit 685082f4be77 ("wifi: cfg80211: validate IEs in
cfg80211_wext_siwgenie()") of upstream
commit a2f5286ca4f3 ("wifi: cfg80211: validate IEs in
cfg80211_wext_siwgenie()").  Upstream is safe because that function
runs under guard(wiphy)(), added by
commit f42d22d3f7963 ("wifi: cfg80211: define and use wiphy guard"),
while this tree still uses explicit locking and the separate wdev
mutex that upstream removed in
commit 076fc8775dafe ("wifi: cfg80211: remove wdev mutex").  Backporting
those locking reworks is not appropriate as a minimal stable fix.

This is a fix for stable v5.15.222 backport commit, so no upstream commit.

Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Closes: https://lore.kernel.org/all/93db0eae-f479-4343-a126-59987ae0dc22@oracle.com/
Fixes: 685082f4be77 ("wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/wext-sme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index 1919290d1208d..f0c9aab622385 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -339,8 +339,10 @@ int cfg80211_wext_siwgenie(struct net_device *dev,
 			/* nothing */
 		}
 
-		if (!for_each_element_completed(elem, extra, ie_len))
-			return -EINVAL;
+		if (!for_each_element_completed(elem, extra, ie_len)) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		ie = kmemdup(extra, ie_len, GFP_KERNEL);
 		if (!ie) {
-- 
2.53.0



