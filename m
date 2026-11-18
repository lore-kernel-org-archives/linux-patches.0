Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019868;
	b=DLMR7kN6fUlP2bOXZBeowiDmPsQ5uWZv3egrJX94oI1fN+3pWb//0i+NcWdGo4jNc44T
	 Uq1100wW/8d6JJnZxa/66XEITwZIM3/VzpqAIf7cuPEaXA3jleQ6qJXDVF3aUk0IU/Vqe
	 5VFRtO5DTJrGZoFX5VBqJYFw+H3eA7jRtPJJR88gNhM2Pqa8dJ3pL/btt3zUkCV74iNL3
	 QO2jM3lwPneE0J2Pv0djwD0SQgEp5zUNhskwtmKDl/8jXaKDhT7Ne+VpEfnJ9ea+XQrpN
	 25L084r2Yphx6yE3ruKPdxhx0Ngwfr7GAV9LDtWuhKMhGAWYmQijXjBPex9wjGwjGVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H/1qZRNtpQVQfSPbtew2NFiFj7XvL/zBidleJx68GBM=;
	b=irvhbOx57mhlhS1XG7EuX8sBD1esZwh/X5RX5GVbd63aDkCsaPnTVgs/OoHDB6VWIdxi
	 yzp4JBJKUXygDMtTbvxGrDY7T3D+u/0VCaUKcquWdzh3EqDwx9zVUfLSHeell0emDzvPk
	 dduwqzDR9r+Zv5Cdn4NyYpQoPgCBickR0jG2PD4zm1BGx2yXU0XuHXWW/jpMNCZgoYuHY
	 Vp7miY66DVvDgzSMP1ytHyH2wB4rKJ+RFYC2vODBdMV3GRBN5QeN1O8ZJXFRP77y5rvYB
	 oJPdJC6dRDTx+GgrNxlwuRT8RfMAtCJiGWvZpkCRsXaA4QEP5tg9xDw7k0iHwKGs9Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pdA1fAf+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14969606A331;
	Wed, 18 Nov 2026 16:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pdA1fAf+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6368E1F000C4;
	Wed, 18 Nov 2026 16:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019867;
	bh=H/1qZRNtpQVQfSPbtew2NFiFj7XvL/zBidleJx68GBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pdA1fAf+bkfET8AeiJlO0llZ3SqRLVuFF/M7RvztppPPCg2RyNwhaZssZ/FpUSU6i
	 XJMWEpzrouHfpk/bUhe0SINBsojh1/aZF9V5FcEv520z3svIvi3SCKnTlkHI+oMmY4
	 AUaq88JFYpNXMKETDhbDSJYjG7r44CkVQ8o3TfnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chien Wong <m@xv97.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1708/2651] wifi: mac80211: fix encryption tailroom
Date: Wed, 18 Nov 2026 15:49:08 +0100
Message-ID: <20261118150349.126529035@linuxfoundation.org>
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

From: Chien Wong <m@xv97.com>

[ Upstream commit c49f54fd2abff08964677db8fdc1674c713ab42c ]

BIP-CMAC-256 and BIP-GMAC append a 26-byte MME but mac80211
currently reserves only 18 bytes of encryption tailroom.

Generating 26-byte MME may happen to work because the actual skb
tailroom can exceed the requested amount. For example, dev_alloc_skb()
rounds the allocation to kmalloc size buckets or alignment boundaries,
and the extra space may cover the 8-byte shortfall.

Reserve enough tailroom for the 26-byte MME.

Fixes: 56c52da2d554 ("mac80111: Add BIP-CMAC-256 cipher")
Signed-off-by: Chien Wong <m@xv97.com>
Link: https://patch.msgid.link/20261012140738.70178-2-m@xv97.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 43f7971e99abb..cdd2581d7f59d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -52,7 +52,7 @@ struct ieee80211_mesh_fast_tx;
 
 /* Required encryption head and tailroom */
 #define IEEE80211_ENCRYPT_HEADROOM 8
-#define IEEE80211_ENCRYPT_TAILROOM 18
+#define IEEE80211_ENCRYPT_TAILROOM 26 /* current max: GMAC/CMAC-256 MME */
 
 /* power level hasn't been configured (or set to automatic) */
 #define IEEE80211_UNSET_POWER_LEVEL	INT_MIN
-- 
2.53.0



