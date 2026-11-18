Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043765;
	b=hS0VvcUNtE+af5VFbfzVQDCc12tovxU3LW5OveyE14JEK/6DNz3O9qtYC+fPg5XNCZNx
	 Pfjk0KxFOOSE5C6hJctRdtYYrNdZKxhFqoDhQ9N7k8vRqFCCgH91kux+iRw7BK6YIntTu
	 4/CmU6iU4wq182JOFZmtwwlvywDnhIH2dgo5wgmSLMpClOqPed/c7AxXY2TViayZauKDt
	 Jke/AvT6J1QD0bmxgeBaB4+/oqPAvFjo+WwXMily2G28WRHFbTlSMgKdDqqgEpculhaVq
	 TxecB8H/2yMkVQC90hD4H3gnE+DTYz1Xk4PCMv4PLhmGCyjOrw8SKm61IqQob7vT6jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pv8cw3sNf8L5PKdnS8qcPq2TAA1VobTStx9jdv0nIWg=;
	b=ZPzAon7TllyEoLGd32v601ST37s8cyCFS/JvAQp0htq5kSeTj/0FxI5giE7rbjhwDcB1
	 9Ymj8lOW305PEFPnI8+XTOt25RSSJYtqyIQff/4csJIWcCsF/C7Pk0nCV9DXHIeU+7GDp
	 g9zFEvQwqMWykhRONN8iEZneQcqZGnyfZ0f0na22P3sF8ePruLelGKwTbWiBI97M8RlUf
	 /B9X+Sj4tws65FYwmI907FfPIAgJwW9+TBT9PPVI2XPpwp6P2QeTYKnFVr9P2giyOF1I1
	 Z01kWjwIlPSIp+k8SpsueUuetwZykec6Sw+7ABMLh2SYnvS60gmZEPRxgbkJEWzhT/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cXfOPPFQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FF9606A332;
	Wed, 18 Nov 2026 23:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cXfOPPFQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D911F000C4;
	Wed, 18 Nov 2026 23:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043765;
	bh=Pv8cw3sNf8L5PKdnS8qcPq2TAA1VobTStx9jdv0nIWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cXfOPPFQvd92K+1CDDc3gskvmKaKXrrxnZy0dClwDedPXcXCZpxmP6Lrt0oajN/Nv
	 ar1p2lMvUsz2cXhnmFgpJUAbwk2oEknm9EzdLolU/P4wIKEdzGwvMVKipuB3u33tZM
	 y1FlAjzcBcRdGzUEd4XnyKBSTYIjOXvLRREiQt38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0320/2857] wifi: cfg80211: release locks on error in cfg80211_wext_siwgenie()
Date: Wed, 18 Nov 2026 15:22:34 +0100
Message-ID: <20261118150212.963512142@linuxfoundation.org>
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

From: Wentao Guan <guanwentao@uniontech.com>

This error path returns while wdev_lock() is still held, so one
malformed IE request can permanently block later operations on this
wiphy. Route the error through out to release the lock.

This bug is stable-specific: it was introduced by the stable backport
commit 8b921a899346 ("wifi: cfg80211: validate IEs in
cfg80211_wext_siwgenie()") of upstream
commit a2f5286ca4f3 ("wifi: cfg80211: validate IEs in
cfg80211_wext_siwgenie()").  Upstream is safe because that function
runs under guard(wiphy)(), added by
commit f42d22d3f7963 ("wifi: cfg80211: define and use wiphy guard"),
while this tree still uses explicit locking and the separate wdev
mutex that upstream removed in
commit 076fc8775dafe ("wifi: cfg80211: remove wdev mutex").  Backporting
those locking reworks is not appropriate as a minimal stable fix.

This is a fix for stable v6.1.189 backport commit, so no upstream commit.

Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Closes: https://lore.kernel.org/all/93db0eae-f479-4343-a126-59987ae0dc22@oracle.com/
Fixes: 8b921a899346 ("wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/wext-sme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index be121fa36c514..ba6d8827f64b3 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -352,8 +352,10 @@ int cfg80211_wext_siwgenie(struct net_device *dev,
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



