Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056319;
	b=ljgUzuvVquP9CWDCTqWaW1Gx/GNHc/xBDG84rT9+sFyIcauDnnpXzLyy4denO4vtz3l5
	 FBvKXnS1Om5x6W/ovdmhQn5sm+B7DVl349xqsP/qVgvsG+PGOUQREfG3S5eqLjIK7mqN2
	 W3uGzf+eru69Y0SJ1h8jH59bQGf3lOU0WZwHSpAPcz3n3OjDywjM7/BkXJ6CrakqqjwsS
	 BAOhv9LTDp7VIPcSMGSMHson5OG0Ja+6J+f/FK98WC8yL6wX9fhrtlJEY6756kz03G29l
	 rjLH7gDrkSWEkFF4hUb1As5VBQH0OS2rmThH7wFXOMNZ/jkx0Vmzwy2RbLoNkYdlZfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eyYApIl49fYxfq/vTbR+GbsBCayyCs4E18VOK9DdEaM=;
	b=hsd8dKfPvck29w5D1V+dIucTOWz2JvwbqahBHvEdC4SvCDnBPsH1IsXZGAfnimu6fxxp
	 J5ij00EuceTYNh3jAGsuZu3f4p8v2thNUPn4VITlD/SIr0tAiegufEnW17ZDMVip72X2o
	 ngza+Cdy++68qHu7J75Ixe7d0iiRPFmrZ3drr01fFBPh18+MgjGaJ/H4MzX8tMmMrCL8s
	 Tywa9bsS7x6SO7kgxr9u9VO8aacAl7Z5HI6R/P5+QFxtp5yNrpz6BBNV+DugiTfLJCzG0
	 TuKTXp4VD4U/D0AqRwuMYpKIsXexJGAVo2EpJzocuLVvLFavOZGVftJUeEMdDojVaIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QaBVr1ax;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B25B606A320;
	Thu, 19 Nov 2026 02:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QaBVr1ax
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FAE1F000C4;
	Thu, 19 Nov 2026 02:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056319;
	bh=eyYApIl49fYxfq/vTbR+GbsBCayyCs4E18VOK9DdEaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QaBVr1axl1AuNKne1qGELmp9fvaGIHvw2nIKWG8UjgfjgQz68wGg8Kl5cT82i8iUu
	 gCI9H80xmdbvXahNnY3MF1njKerYYLdlFvb3VReH9wFkq2BvwIPGr/m9eSaYhPOC+T
	 x/g4z2ws1s4ym1dwEmceqLotzf0RywtuPjxeNYOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1943/2214] net: stmmac: selftests: use skb_share_check() in the loopback receive hook
Date: Wed, 18 Nov 2026 16:00:19 +0100
Message-ID: <20261118150128.740186982@linuxfoundation.org>
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

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit a7a89019bac0e8810bde7f1419f4adf9adc23d41 ]

The loopback hook gets a shared skb when another ETH_P_IP handler is
bound to the device. skb_unshare() does not unshare it, so
skb_linearize() on a non-linear frame hits BUG_ON(skb_shared()).

Use skb_share_check() instead.

Fixes: 091810dbded9 ("net: stmmac: Introduce selftests support")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261007-nb-net-selftest-shared-net-v1-2-458369bfa1ba@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 5b1610e427e02..62da3fab820bc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -262,7 +262,7 @@ static int stmmac_test_loopback_validate(struct sk_buff *skb,
 	struct tcphdr *thdr;
 	struct iphdr *ihdr;
 
-	skb = skb_unshare(skb, GFP_ATOMIC);
+	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (!skb)
 		goto out;
 
-- 
2.53.0



