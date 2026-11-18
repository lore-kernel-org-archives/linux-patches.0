Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032080;
	b=3NiYhJF3ynGhMd9gwRZqO1zUYqNUSHwMKoerUFrGjHlEqU3g7v9bKWTRp/2pBOzaV4ni
	 AMuM1k/sNKpZMxTuNk47oe829Tjq5orHydvAA9N03DMXyn7kNXkipkWedBMihLFsxU5bc
	 yBd+m8F4KSTZS3ko0svtHEiLM1mcapTO7w/gDK0Vw53mnK3PZ+UaOg2qmkE0dLYTMN6va
	 RfKhXwNIQOwRYNMjHxGNOhKkaaa2/Un06+7ygpS/3pfXz3j5OQhwSMgiWmcxTtGS5K6W6
	 bzoVUZ2ZjQ7wly4uhwrSCaMW5SKkkWQ/IiRdRwQ2VCknvNucbvOyFTVW3kgvOTl4j0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ui7MsKet0ngN5NwJL4hqBqD3WskbWiADtR1BzVnNtPE=;
	b=OG/loRaFnW9pEmdkj7VlSAajmJSvW1+hSy+O7cve11lwoONjxybA9Roj14xR3Yl41t+q
	 lpobIAOlL4bulUTEOk+aMtkCnXQwGU97BJCalKrHDP+xjlBwxEIOaQ5RQI2Kj9Ls/Wy8F
	 iNJqS0w7z1PStylzKPV8/7+PrsIaJ1Tdaldygrud4nFfEDWpEZXBN73uTNqQf64Cc7tJn
	 J6F7HrxWmAnRlFBN8J/dte4MhQk76J6d2uCmviYgGAOIdaX9mDmPzm+Or/X99it5hqU3I
	 hoz25NGYTpdUbQ50u0AsHG4aH75WqBKH/l8x5fqzU/PgMCO76SxHFP+GN5VYbDalHWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MAH//UZ7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A335606A31C;
	Wed, 18 Nov 2026 20:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MAH//UZ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599EE1F000C4;
	Wed, 18 Nov 2026 20:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032079;
	bh=Ui7MsKet0ngN5NwJL4hqBqD3WskbWiADtR1BzVnNtPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MAH//UZ73uFU886usMmfb6OjBRAYS1PHNPzOt7w4Lk4FnlfKL9IFv8l9tf7yx4vzs
	 rIe7hG/ffL/QkFpcdePE4l7DHbvOX6LK1/POF5gQnH1VZtFs5JjXcj4W+vfMPYBIWQ
	 77Wi7UxIbGvfRphXcms0UtmT9B86jbd7nnfmw4+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1243/1756] net: stmmac: selftests: use skb_share_check() in the loopback receive hook
Date: Wed, 18 Nov 2026 15:56:10 +0100
Message-ID: <20261118150059.231613557@linuxfoundation.org>
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
index e39ee3ea0efff..a9cb100cef1a1 100644
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



