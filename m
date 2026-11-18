Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053290;
	b=GgkG8JHHqa/pkYesyXuIo5IJwHdKLYy7hP14hw+lBsPQwd/a4QgF/mxVxjFQO2gbkd6s
	 MtYBAt/gvzJTwtDRQI3mCcsv2/+A5nTyKJc4/gi7M49YmKiOY7/fE5c16k7oGNXnXvhEB
	 WYSD+jbSB/idNX+9maTIWywZYAlm5tkfXFfKX8SA7e9GvgBm/DJ/YYHh+oG0V9mj0Vt2B
	 OirAF86tl2SmIDQ5hKRFctKub7D6fDf185L57u2+fa8mpeNnkGp1whvD9SHuLH65DHFBZ
	 ByaIVB0EKPZDzMGfyW8Zp+RJ0nwF+bKzo57KM4J5/W0Ze9BRJMCKlpWC+LwkhJjqJVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053290;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x8E6UtsVN48yFqRHDfYViRI/l3u5arDSMPD6FKaho84=;
	b=aQsy7LwhLufE3l/x4jFLRW0ZBTt4j6ZXGFnNslOni8MLlO7Hw1Q/DMZcTCLpELu/5EWy
	 wYavd3PswIZiPAQvgSg+848TryFG5KDmNQywKTpW7XA1mhuQJpEWPECKk3V1bqPWpaTfq
	 PUE5lKKamIPzAoy9PUz2v4elJDSe3BT3a0tCfkMwiE1zE+QZr24nKKK0epLHxKVvuRoeR
	 Ey0jGi1ZvjxLbKf7At/BSngUKgdeHxH0rKNGThabnlgSp93t3KwvX2T6PQiV8al6i+gdo
	 taZeOUiWzBnSL/mkK7/AWYJcMjX36yyGgMtUz8aBN4RezIo9QlVixlevHLtPt+IIxTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YAa9Jmuo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62B0606A335;
	Thu, 19 Nov 2026 01:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YAa9Jmuo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A451F000C8;
	Thu, 19 Nov 2026 01:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053290;
	bh=x8E6UtsVN48yFqRHDfYViRI/l3u5arDSMPD6FKaho84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YAa9Jmuoo9+ZeSOGxw0IqTA/leDUkQasxgRQ6kumoSocGEDFhY8SDKDxcTLjjvOnJ
	 kwVziqEaPaaDiz7natl60XMBaGfJXuxXjZH5Mvz8dSr71TzFPSIldKQVqdHmSKxkt6
	 4po6dgAGTuOV++M5E8O3dFEMT9X+XQR6gRqkT700=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Kazinsky <a.kazinsky@ideco.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0840/2214] wifi: rsi: Skip TX aggregation setup for non-QoS frames
Date: Wed, 18 Nov 2026 15:41:56 +0100
Message-ID: <20261118150045.808774678@linuxfoundation.org>
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
index 6b64a103f39f0..1f5c8e7164307 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -457,7 +457,7 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 			tx_params->sta_id = 0;
 		}
 
-		if (rsta) {
+		if (rsta && tid < IEEE80211_NUM_TIDS) {
 			/* Start aggregation if not done for this tid */
 			if (!rsta->start_tx_aggr[tid]) {
 				rsta->start_tx_aggr[tid] = true;
-- 
2.53.0



