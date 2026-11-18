Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041791;
	b=qE14AnWpi9YJKW++YXuW7rarR/1pi2V35tbnjUmdUigZBNGglDMT88amG1LVXpieUI8j
	 8/V6bqkJCqpo55kr3X5+bAoBWBMnSVpTa1O5H4JSY0Id36L17RMq8TJcJJiPiAj+QOS+b
	 5Pr8hd1DNHT/uLDWL0OweuHulBNVJKIcf1fIZTPHXERu1QacAkoWt+7AGnjWEeoJWt+6u
	 rR5h6RXxxVczFfEDTxb1JxRySzVao0jk8Gx7CrkPrt2hBJUAq8PBuLBU2DUZHWSgFlIpl
	 orlTrYZTv5lJCGoZ+vCcYWq6iCRQ6SUhxz85S2+xy2rh2MHDVoecd7soOMDWPm2ymkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7aCWrpi1Vl3LNmN+1bXkxtQNVIPUgE3aG7o0bhyDz3g=;
	b=Mk+y5sB/C737lxsb0kLQW4POrBUtPymF7rV91VtheTXvMHT4OlVjRYeMaP+u8l9qOwRj
	 hSydlrE5v7tpZizEFx0PaxTWe61uz60yDmLPb0DG9ww3P+3EYBBBUeBRHZQT9ymkU6yLH
	 amRm/YHtjSToIa2/UB7Jefid5CZw3SygoGTz925lOhZ3E32f8ZxJhF4Gw6EFGbRT4eeOR
	 /p1BknBX59FTwEz7FPZKv5jepQzClyLT8byzBoJ5kdR+UXNaa5u5Y8q6zqr7fJG3ul4kz
	 YVK2YSmCjqgO8eaCdyW3CvquMkoK+Exdv6qQAneaWiJmnpCWvhiRo/vxPzqOglF5SIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vEsIkohE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06218606A325;
	Wed, 18 Nov 2026 22:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vEsIkohE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157B41F000C6;
	Wed, 18 Nov 2026 22:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041790;
	bh=7aCWrpi1Vl3LNmN+1bXkxtQNVIPUgE3aG7o0bhyDz3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vEsIkohEa3E3VwaYsXICDFQ+sWTxEmiF9Nfi5vRnGThme6JjMwmNDhPpdy+8VGoFp
	 ejV1YxeNIbMd/MoQAz1FnRVeGJrKrfUG4Ttu5R0o5xe9AKEzvoSXcjsvCZZpg7/hjh
	 C50gnhkcEkPacveO3EoDDofPR/JcQXRUvMCxLeXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2897/3318] net/mlx5e: use skb_share_check() in the loopback selftest hook
Date: Wed, 18 Nov 2026 15:58:39 +0100
Message-ID: <20261118150447.402140518@linuxfoundation.org>
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

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 16fb7aa6955a0af9f67ca42a61d9be58dfc9382a ]

The loopback hook gets a shared skb when another ETH_P_IP handler is
bound to the device. skb_linearize() on a non-linear frame then hits
BUG_ON(skb_shared()).

Call skb_share_check() before linearizing the skb.

Fixes: 95b9606b15bb ("net/mlx5: Extend Ethtool loopback selftest to support non-linear SKB")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261007-nb-net-selftest-shared-net-v1-3-458369bfa1ba@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
index c170503b3aace..0c3b530f45e86 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -165,6 +165,10 @@ mlx5e_test_loopback_validate(struct sk_buff *skb,
 	struct udphdr *udph;
 	struct iphdr *iph;
 
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb)
+		goto out;
+
 	if (skb_linearize(skb))
 		goto out;
 
-- 
2.53.0



