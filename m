Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023048;
	b=iJizCi1KGBGJy2Z7puD2NP0+st8ZyE6QgWu4EIAWLl9CDGSE/MP31NxmJkYFGD006fP/
	 13NfIvfjAizfcSPwbQ23Pn1Gt57YYqjgPhdFQewPSBWvwlqmcVOH401HS9hPIfI6dNFKE
	 /WxxBqVsfQtsEhiLwQK8oaryytv+DQw14Fv/t55KW3HZGE2JmzXU6nOwY98RvAY9lFw9A
	 3BHeataKfJFEIv4P1zU6tdAqGAOH6JAhO/1voVU/SfPhBYeXuR2lCxuB8Gi/DmHGBFjwb
	 I9WYnbX1hKPHU4AR1F73+nfVkVmQGCNCz2O7pNZ6P/Km0oWvl6wzfzn3xUoxHD45T4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uRELIXJK+vKLRJVlZEQQSQYMw0aLPEAQGN4gC+YjM3A=;
	b=RhtzRoV/+GXIRKkqSqR90R7HmtwSWhCaWtduZjTepkjiGcwFvwl35p1gjsN/6lUtFbXt
	 5MzWOyPHDdXS7qhuMfsOM8q36Tt5T9CblobuLXCA+PZUJf+c5aGJ6CkPe43LGeLTGVCS/
	 3dshz8QfiU3icTDNTQG+f+C5uFhXKZ67+luTcfADPizfbomLwBVXCgYDD1VGq6TEeOd/f
	 jXbGXkvoXVB0ZC4rebSPqxB8UKa3bt8LZwpvYrWXw508PfywRwPhxOw1GbCp6smQCg3lw
	 fZokhJA1NuC7lTCtwBMeaA4/01T8CA/NQqXqoVarbtI7c0H43tYGCOlfOWVO+88Wl4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ftakvZJH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F718606A320;
	Wed, 18 Nov 2026 17:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ftakvZJH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966F01F000C4;
	Wed, 18 Nov 2026 17:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023048;
	bh=uRELIXJK+vKLRJVlZEQQSQYMw0aLPEAQGN4gC+YjM3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ftakvZJHN23G6NUU4XUz4eH4McioGMHtUALMp0EnZCbuYYNJTOMv5W4l0GeeRhrj6
	 qxwXbnfLJk2R34UGohQFRYDBQ+xK+Y0zG5iW0pXRzWgg1zq2IEnZinYcOErquJUoAK
	 bc0XnMJRwVQLVEZuL/0UpaC0qfbnB4ywxNeJdoi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0228/2151] wifi: mac80211: drop encap offload frames with a tainted key
Date: Wed, 18 Nov 2026 15:32:43 +0100
Message-ID: <20261118150130.088322344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index aa96d575849b8..f7cf7dc46cbb5 100644
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



