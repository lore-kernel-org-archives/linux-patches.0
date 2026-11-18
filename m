Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015659;
	b=jV/xl/3gMf12JIezKerMV63mMlXVFmEyUYLcdeBRaveBZqE3eDRYWy4+hRUcVeW/3a7F
	 0bidzmeqd5fVNKIwRWYcqqsHsArr2WEym4dqrfK+7HP8I4zTxvS7CKTZfOMDtgYESPP43
	 bwpaZ4dojgNqoatad4SXUnVXCEd+voXuEY8dpBPd9amT19oNhvnbUB/mDQiKw5KgrPnD3
	 lQ7GN3A2SIi5TzPxmwtNwfPZeT0xQF1vOS3J/g1yBXxtIjQmY0Mjpp2SAac/giytd3h2t
	 yOTJs9UCrrXmEvvBHBcpXqJ4ZW1J8taT2MDCk7TicF2w0jt/6VlldBre8L9gDjdIqew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sQHPxJ0uzhHtdX8+Z4yB8QJDYV7c3gcUV7/mdFZC+GU=;
	b=1jdVDKmBY9zqnTuJTEfaodBOeF3E3P9uicNwJQvD8h4JLWjVYqEJlCryE1jI+pIdQDzq
	 MirVRf6oURCs1tDCYO9THdWYZOV+cJqIsZtnGOTvMHk1UnhFS+LJuPt3JdVrgd6m37nuv
	 SicM0KkjIRm88lB9pq2Ql4bUdWsYzkX1dZykOJm2tCSMibVCR0olmmCgiCUW52Op8SLYt
	 xSPA3KKGjXHTkVbWTel4MjCxHYK1nRxq4yZMBpRRuclsoe2KmcVq+Q2bkxmqVdRjhmLUZ
	 KpvLDjPtkeusgo+dEIqCWpdSwrRXzJQFeRcGQ/RptUHgpCkJWFGwXJC3wysiNftkjbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W5JY3ifJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535DB606A335;
	Wed, 18 Nov 2026 15:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W5JY3ifJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2E31F000C4;
	Wed, 18 Nov 2026 15:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015659;
	bh=sQHPxJ0uzhHtdX8+Z4yB8QJDYV7c3gcUV7/mdFZC+GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W5JY3ifJ41xdDizOu8b+3HqdVsrECYuNRDTeBx1u166zVQ5c8G5WDajWSvltyoXCh
	 BZ16jaTJ8R3p9q8eb0eY06VFiBMzWCcz3qhst264wlsdmw+JOVqct/N5B00w0XjVJs
	 yaIC6O1+uZzpPfp9vjJ8oMhDwcBvrIvciCsYOeyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0211/2651] wifi: mac80211: drop encap offload frames with a tainted key
Date: Wed, 18 Nov 2026 15:24:11 +0100
Message-ID: <20261118150255.473526859@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit c8ddbe1e8c43f6d008591c50f8be8de39cdce267 ]

When a key is tainted, which happens in some WoWLAN and extended
key ID scenarios, frames that would use it should be dropped.
Fix that for encapsulation offload frames.

Fixes: 50ff477a8639 ("mac80211: add 802.11 encapsulation offloading support")
Link: https://patch.msgid.link/20260802105818.870b6ef31374.Ib87175b55b9fd94c16ba6d9cd816b7a09248df87@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 884bf96547113..45167a2592615 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -599,7 +599,13 @@ ieee80211_select_key_8023(struct ieee80211_tx_data *tx)
 		tx->key = rcu_dereference(tx->sdata->deflink.default_multicast_key);
 	}
 
-	if (tx->key && tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
+	if (!tx->key)
+		return TX_CONTINUE;
+
+	if (unlikely(tx->key->flags & KEY_FLAG_TAINTED))
+		return TX_DROP;
+
+	if (tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)
 		info->control.hw_key = &tx->key->conf;
 
 	return TX_CONTINUE;
-- 
2.53.0



