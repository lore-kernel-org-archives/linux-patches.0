Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023181;
	b=gHiTIVMdTGNbdOt6be6sFIX157y3rmGM5ppIWJNfA+Py14Xfd0E/ApBqYuJPI4eknvtl
	 dsCCCGTU538PqV4JwwFccNNvDjjPAbVaCKRvc0jU7u4dVv4M+m3g+E/zrYzg9X+fYZdrN
	 KsDzjhHPwEH9hb8jA3updWVf2ZSccEP9/4VDRO027zqC7xhwkRDAGYtVI9KPZ4028djx5
	 oA+l7tWCIiNnxPaTw2zWVCxDu2QaVHtVEWRmwtH5KPBU87+8VoQowYxjUY+7nVcvktF+2
	 ckhYVVpX15x30+E0rnTyg2gRsHJ9YX3rBo0jDUTuPbxIdYysrAdexHNYzuOsrpTxXsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rsW8a86Ywn+00i7FUcKnp6c4lN9yZBf/oWMwjt4OUhw=;
	b=FAciO2UiQnR7rxxU5Mg3hWFCcZtSJy9phhy0pWxbLRfUXCMyi+UHNNLYxdgkh4fKXkG7
	 77iLcsS9L5XGRfElDIRR3hCmsgscpr+cdKNTZVxME3GKP7NWglH6QrNJpAJN5Y4Lp+2o6
	 iYC4GPRTKQjUl91HNiShRwdwCerXcYfXrrl+ESXRCypV9m8a7bBF51zI6FHJCGhE4npN2
	 ftBNblhcq3A9yVg5qFdNhBF1u6UCN2d1UFj94A5MYAj9Q/vv2IOte/cq2qve6dlpJith5
	 /Ifn7DYF4CQeGY7KzQanywWC6q7yoo8/7sJZKLdg269tcI/dZLrYf/2Kkt+oMPE8tdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LiAkdK0H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C452E606A320;
	Wed, 18 Nov 2026 17:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LiAkdK0H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A0E1F000C4;
	Wed, 18 Nov 2026 17:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023181;
	bh=rsW8a86Ywn+00i7FUcKnp6c4lN9yZBf/oWMwjt4OUhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LiAkdK0Hz7BatgIzoObnjN4uKI1jBRdCALP8/hIaFk7oEa/fTX+RoCULvYAY2bx91
	 nreVTRNzDdd38IaHU8ASFYgy5H1TNd0v+KgSS5JIzUWbnvjozV/tYYLLpLHZ0dTCXs
	 AoK291QczU6akzKJ6IbgmuOAx4as5hpNmcvwRBI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bert Karwatzki <spasswolf@web.de>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0277/2151] mac80211: tx: Use info->flags in ieee80211_tx_h_select_key()
Date: Wed, 18 Nov 2026 15:33:32 +0100
Message-ID: <20261118150131.951710410@linuxfoundation.org>
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

From: Bert Karwatzki <spasswolf@web.de>

[ Upstream commit 5f2530a4df8e0573e54cc0f4175c06ecb810a4dd ]

Without this ieee80211_select_key_8023() is never called and wifi never
connects.

Fixes: 0e80db08668b ("wifi: mac80211: fix key selection for encap offload frames")
Signed-off-by: Bert Karwatzki <spasswolf@web.de>
Link: https://patch.msgid.link/20260908094341.12196-1-spasswolf@web.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 79d0f0141d4ce..3224288583e20 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -618,7 +618,7 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
 
-	if (info->control.flags & IEEE80211_TX_CTL_HW_80211_ENCAP)
+	if (info->flags & IEEE80211_TX_CTL_HW_80211_ENCAP)
 		return ieee80211_select_key_8023(tx);
 
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_DONT_ENCRYPT)) {
-- 
2.53.0



