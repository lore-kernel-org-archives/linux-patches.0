Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049879;
	b=grLCmhHtkHh8GhpIYvvuOc3VYS4mvODsQCQNZzovI496pt1TsXJ2ZLqRSaWBTFrjenq0
	 zXpwP7zwIkDi5DyD5A11tdn90nk9K6f3/prHKYqsIv7VA+aiDkEF2JtfWIVDSrMCof0kS
	 gqttuEQ2WIfi9O8QIfc4OeKLm5NEckq0Tg6khwjSGvLEyPdVXtXpP04FYq0UCIIhkTJIv
	 rik9iERu5YLYngTrPLe/e1i43oju0hkPMIfVgvMg00OjJcRgr5CWb6iZPhtg9p/lCTTIA
	 0YefUC3b5YaqVz4GEhkqdtj12MHKFCZQX1Am2JkpQZt61oIbQ60W+XX3D8vPQxCzZNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QtwqBXx2Q0TDia4zZoiPcxgAVNIt6o64rqjLitqUDQA=;
	b=3HDNYwcIBBj00YyGAAt+WOB1va6mxlIaQiu8kL3lrVbE3Ej203v01SomxImjU7rmhgpt
	 fKBOvWYpQS4HdyQJ6XiB+BUPFLYQwpN9hDzEb46Vd2hYamtQvC62UuOtwboI9Qi2yP5El
	 LvSh00TxLFP+UYMferYzoHkdBAJ9nwOiZw4pQ20sAPHNKaNZrr+WL1DYJMlP3TEUbTsi8
	 auex77XdQIG4guQrv8KvY5iSRWKO4kBk9YlyD3JRj3pct97k0lceQs5Mh246mqCGnjP8A
	 lJDlc5KB3E71+vfhBJx0QWLTpW5riNKOq9xyKBg3jfeRt55TOPSyOpj7ETltNqRMpLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RPpzx2lB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC16A606A32C;
	Thu, 19 Nov 2026 00:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RPpzx2lB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B5E1F000C4;
	Thu, 19 Nov 2026 00:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049879;
	bh=QtwqBXx2Q0TDia4zZoiPcxgAVNIt6o64rqjLitqUDQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RPpzx2lBU7/woUKtxs3J/O4diX1Pde8YAewriWqHTTRlPEr5W52fKumu85mcYF4OI
	 rveyLLYuYI6MRioqG7SK5Bgvs/csnpOkT/CuY+NIkOV3KLiMbqVZ4Pzqf+frIpaVKS
	 Vn8aKFKJT8i31G92knMs+zNLYSXQCUe8fjqZ/LVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2510/2857] net: stmmac: selftests: use skb_share_check() in the loopback receive hook
Date: Wed, 18 Nov 2026 15:59:04 +0100
Message-ID: <20261118150331.918772251@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fa338b083129c..11172f05ef6fb 100644
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



