Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058980;
	b=H4LkUVorBZ18rOBGJml6LAL2rfr1SBndCpuhFmsn9Jzpx1aRrKIoAgqm9fqiKfsBb2QD
	 Vu1VtPrzs13jwHTSPtlFxb7fsDZ0uTk7rf+EhhvXUQjlT8/5i+xjbyXmV9ndo5XRVbZre
	 wsLVwOYRukrMy48WaJMp0QSxP0oW6h/5DRp4so6cm/J1yZd3ay878TLiR1lHlnnwlivNT
	 5CMUhhRxJG1MPAI7mIgmhGGdQAntSQyMKocJQbI/bToETWld2LGD1Bzrd3MWywqaJ4kcU
	 lFU7DARgymEpTDUxdk0PCZJ7wrKun72aXcJKSuDX7dFPJxl+G8D6x5r0UvB2YLNLHug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gfuOqpJMC2B8o92jzRUvWcd4LRz46e3qP1oHASVE0rM=;
	b=M2E2G3tic/PzF1HGNZ2Ek3j3V1DZ8M2nF/auIJEVk8S/yVUGgBscIAC6a0IT2xZv0ym1
	 WZS0VI5UfYjFSWEUloxG0KCbXhW59ToCi+3IS72ogr45edWMe2b+yToPudeKj0IQ+MmHI
	 y/05G90qIjvDeaf9+B7OsGML+V/VcGUIwqC1y56L6uUz2kTznY6sOzmo/8qkiWrWgHE6X
	 3IDThsM/2hCHm0AzbIsHYoM4KpWR1kK6oW+6n17Qm4UuW/7P6yj1PoWQrhBVvrhVhFzY4
	 eH6U/1p1R+T9aBAhpEwSjCMFpCiJto9X29jMSxx5HYCt95y013e7gDWRTEuY2wVlC/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pBuI/y+D";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50CA606A32F;
	Thu, 19 Nov 2026 03:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBuI/y+D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270821F000C4;
	Thu, 19 Nov 2026 03:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058980;
	bh=gfuOqpJMC2B8o92jzRUvWcd4LRz46e3qP1oHASVE0rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pBuI/y+D43om0Xswq0EA11eheq+k4k3pVU+DZAe9PjO59ApsYVHxAg5DUGv0OfyXq
	 L0NOTDtbo1RyKRFMC9L7LiIkA+y+9ogxqOeW40QQMuRLQBGpo6mq1hyShQDvFnchml
	 zfL7YL7UMQ8zyCjWokAQmvdq/coW3kvQpup1jIwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Kazinsky <a.kazinsky@ideco.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0680/1848] wifi: rsi: Skip TX aggregation setup for non-QoS frames
Date: Wed, 18 Nov 2026 15:45:18 +0100
Message-ID: <20261118145944.391625058@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Kazinsky <a.kazinsky@ideco.ru>

[ Upstream commit 71f756a4c064b0312f46617c20893ecc17c332e4 ]

When transmitting a non-QoS unicast frame to a station in AP mode,
rsi_core_xmit() assigns IEEE80211_NONQOS_TID (16) to tid. The station
lookup succeeds, allowing tid to index start_tx_aggr[], which has only
IEEE80211_NUM_TIDS (16) elements. This causes an out-of-bounds read and,
if the value read is zero, an out-of-bounds write.

Only access the aggregation state for tids below IEEE80211_NUM_TIDS,
excluding the non-QoS sentinel from TX aggregation setup.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 19844c0a9a19 ("rsi: data and managemet path changes for AP mode")
Cc: stable@vger.kernel.org
Signed-off-by: Alex Kazinsky <a.kazinsky@ideco.ru>
Link: https://patch.msgid.link/20261015072010.742369-1-a.kazinsky@ideco.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index b7fa03813da11..734e006caadb6 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -458,7 +458,7 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 			tx_params->sta_id = 0;
 		}
 
-		if (rsta) {
+		if (rsta && tid < IEEE80211_NUM_TIDS) {
 			/* Start aggregation if not done for this tid */
 			if (!rsta->start_tx_aggr[tid]) {
 				rsta->start_tx_aggr[tid] = true;
-- 
2.53.0



