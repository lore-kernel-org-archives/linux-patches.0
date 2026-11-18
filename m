Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061718;
	b=T5bsXpuAIn6kadgkEMaWgDCQ85+jFJqQRx5DFsgIb+QyZwj1K7xymLfGGDsy6aLtOBk6
	 zrJf11mUVl+3f2kVxNqFMVj75l2DIntGpzUkrFnQbbsmwYlOg0DQd0QXR+moXhw/RYEix
	 LlRJfvmbXQfDZISoj7NeV+v5mwSu2wWj3KMBRfz1dX7pSLqS2MeO9FC59StsGrA/+ShFu
	 VBbjA8fPHTYXlUqDyiPaNAFIvSXm+QymxCcXp6+fdQMrIM07AIUdjKKWBQY59nZql8+Nt
	 K0jegmpdnKnGjn+MVH6inA03UXlA0oW3zEwP2MdSuD3OJBt/jkF6VxVMYuC3Dsriypw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I0hpGLAz7fiFXtcA2t7RrcRNzwJ8nAyJDXnRurwwUDA=;
	b=r5LboeGwi0lFAFkFqy0ablmOgPXT8m9WiizopuSbPIavCc6qn2fbcW0CSYP5KQFuGF9f
	 Yh1Rcj37AlLUkNWzZMG3C5mxqW+R0l60YzGUWyKmaPUBBuDoJyVflLP/fkGRr+VrxjyBa
	 JsIc8ItmykkTUEufc+NxlCYI7+ItwHq/+O2TYq+XBsch2F2xhraQVrsCtYwSaDETjAPIW
	 uNA6Jz/nJm03VyFql2KNy/XFSE82OJI7AMd9O2h2GLUSFAZB6dn/nIMXfjPHlursfEnKy
	 aEnTtE/T0ZQlu0YsOhxGOQNTj+nsf7oH12m8/p6U9QNUb8XwZjlPhvsBc93O/XfFb0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QoC419E1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFF9606A326;
	Thu, 19 Nov 2026 04:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QoC419E1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE9F1F000C4;
	Thu, 19 Nov 2026 04:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061718;
	bh=I0hpGLAz7fiFXtcA2t7RrcRNzwJ8nAyJDXnRurwwUDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QoC419E1Gl2uv1XJdhcYc4WiC/gT2IInxRz7gilwngnKKHf070XyYpbyf4Ri9XS0q
	 9aXHYY6djTDkjjKPbkxsdslNwiC8Un6r8RoZUXdSRVd/1NS01bOtif+yKfaCg5JUd8
	 ZhIQv1NrLbFdjNxgdzaTZZHxFdhiJr3m2NUkcnnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1654/1848] net/mlx5e: use skb_share_check() in the loopback selftest hook
Date: Wed, 18 Nov 2026 16:01:32 +0100
Message-ID: <20261118150028.959676368@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c380340b81665..1d132614ae44b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -188,6 +188,10 @@ mlx5e_test_loopback_validate(struct sk_buff *skb,
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



