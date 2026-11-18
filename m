Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041211;
	b=AWpN3yWJBECpBdBRZIoObukrcwtUyGOvsPkg+8QIjK7FBmrU6dLgtA++lEyR0eGFrKz8
	 oMLcI911kZ8zPtxqvvOpVZJLNt5oFyGeBjlqt/VmxhxRCxoCoYgpO1SDOQqEoeVIc5dgA
	 BT/qKH+BjORimqWpzgfYXD4G9ipB9UORmpbYfXg8OM4s37eoTWqXoeu1ddRu2jMB99i9z
	 rLnyzCwGB3xDFckVKJxHh36BbzJ7a08NLz/+7XhVyyX0huT2UnW0cN+4hLFZ76B0Tncgl
	 WzR2f0LWOumozHT9Hc5qFV9nLk2aLQpJUx6hvL3tmpvpsD28aL4+qztjGSmYR6um+QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YawC8zCAYkb3ggUYGPUcf9ioQkqQZAVcUpxLOVI3g9Q=;
	b=f5ahHTJlk8KDKc9dQXvUUd84cgayXew5E8SMWqjK3yN8fNrHDZkulLo3FKVNE/yeSx9g
	 xIGuvbRZXoT+e2/43GQWugZkWMDA7zwalnuNlLSwrtKezbgIiskmaft9UxFJj82GdjwZa
	 /e84rI4VxcU6wtV4zgGmOejhmkMtvu3XUAITolDtnCUA4Ld+mfqQMKVgzmSiprFZz93MM
	 r9IFmVAepDJo0ZlDXkFh4mbUaI9lQtDwKzS8F01cHe1OJXwuojlSXmG2NW+q8URkwSw0/
	 2JAsLefNBN1ByscLLuJRx7/D+jeB2mH7wbRO3FIdrywirh1Ln1mo0az8LepKO23ptgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xNvu27oG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332BF606A320;
	Wed, 18 Nov 2026 22:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xNvu27oG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882DA1F000C4;
	Wed, 18 Nov 2026 22:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041211;
	bh=YawC8zCAYkb3ggUYGPUcf9ioQkqQZAVcUpxLOVI3g9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xNvu27oGr+m29444WVpPzjAwjM9qyBLXNrvyup2Ow4ZPynDwCLESKOfvFX5PKJQ/e
	 zJY75lCASDL/t4H4JlmJMiqBZvyNtDT+NcadG6+zg/hnAyJphE3zHZR4j5gpEdAQKH
	 uwaChU5p/Ri0m3csL5w5q1QCCsIUuR8DHL45+G2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aloka Dixit <aloka.dixit@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2715/3318] wifi: mac80211: remove redundant null check in ieee80211_assign_beacon()
Date: Wed, 18 Nov 2026 15:55:37 +0100
Message-ID: <20261118150442.317622839@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aloka Dixit <aloka.dixit@oss.qualcomm.com>

[ Upstream commit 229cf0621950919c38a271ab3c07dfd41dd301d0 ]

The else-if branch condition 'old && old->mbssid_ies' already
guarantees 'old' is non-NULL. The inner 'old &&' in
'if (old && old->rnr_ies)' is therefore redundant; remove it.

Signed-off-by: Aloka Dixit <aloka.dixit@oss.qualcomm.com>
Link: https://patch.msgid.link/20261002-csa_cca_fix-v1-2-b83a998aeb44@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: baf0d4feed2f ("wifi: mac80211: fix mbssid/rnr allocation in beacon data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c3a8f0faf0ee6..a6f53af5a8f09 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1164,7 +1164,7 @@ ieee80211_assign_beacon(struct ieee80211_sub_if_data *sdata,
 	} else if (old && old->mbssid_ies) {
 		mbssid = old->mbssid_ies;
 		size += struct_size(new->mbssid_ies, elem, mbssid->cnt);
-		if (old && old->rnr_ies) {
+		if (old->rnr_ies) {
 			rnr = old->rnr_ies;
 			size += struct_size(new->rnr_ies, elem, rnr->cnt);
 		}
-- 
2.53.0



