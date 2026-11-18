Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029075;
	b=qrMwwOk+PKTWsLF9tBUajL5yJvu0nkI9IV6Mbz7ZO8mteM3Qo7t3Kjh6bD9maUU2k/+L
	 2gDyMFu5r2KLChvCvyrKw9Xe71mFmMFZURrI2P8W/Up1K5MaKBB+dYlJpSzwFg8vxiAD2
	 ZnUPK5qoNvJnxBYBnJlGsLnsO02epL4bK/1E4Vu4Ztj9Er+fp+QR2H2B0OXRbx1Dxs12Z
	 nSE/QJbrWOy+6/Rqw3XH8WLig9773cMeMHYTc9o7B176fBp7zXpfh6RIdcGHMGEhoq3nL
	 dbAzE5Z5EJWAnglNLiA7Yoj9QvTi36p9OxJBSGkauzNuKcs+vkcupV9e4b8tWMimXiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lpTcVrLs7ica3pR4g9j2Zb7lwMhYuStweUk9TjHHKb8=;
	b=YILoljRhr292GAOdxRMXGArq0VBPKdT4lF85G4tNSteRQQMzBt48MaImwLmJ0n4yiYbX
	 TtY5f4h0UzZfLSmzlcbw4exidd86fefNAtsD0h5AwXO+bZYYlDW+1P+xjOfHj9larub6Y
	 wHB11nmJKFXNTSiIdQmec8YsMZP0782i0UET9v/8ZoVMVQpAPkHv0FAVGnQhXFMjR627o
	 btZ5ptsP+l6+U2Oap6Mg686yvUnTwX4vD3VGVbiB4OxAJFjcYDj17KulTz/Z7diytbPuu
	 QzzNshPF0xiXIAxJnZfJlf1m6JhUscU2uhxuygWKyVHhU5OWv6KviAikTWzNCyKYHuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SYVhDE4Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E98606A320;
	Wed, 18 Nov 2026 19:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SYVhDE4Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94021F000C4;
	Wed, 18 Nov 2026 19:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029074;
	bh=lpTcVrLs7ica3pR4g9j2Zb7lwMhYuStweUk9TjHHKb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SYVhDE4QYBEFAiM85Ew6Fhf7aINkZAnmXFhY7Hy2Z57mzOJ+FJ5AInskv/YFt+dYz
	 p3lNgSvV/4LIUEweTMDboWLfQePd1tkkyUpqoNgtMH0AsJMUwAAgac8uqaM6DAYdkH
	 xmCtpZ42x1OYCYdJ2lUni+gi1ixUUCM1tmzyWtKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0222/1756] wifi: mac80211: drop encap offload frames with a tainted key
Date: Wed, 18 Nov 2026 15:39:09 +0100
Message-ID: <20261118150017.135204664@linuxfoundation.org>
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
index bcc3b16bc183e..b4ee237378612 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -606,7 +606,13 @@ ieee80211_select_key_8023(struct ieee80211_tx_data *tx)
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



