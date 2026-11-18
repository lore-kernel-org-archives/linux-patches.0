Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049885;
	b=zbGzbm8VZP6iitoKUpWHzQnpNMHaYyamiNPRbuJAJCo2K90E1BKk4wZyvdPve7QzSW5V
	 vjSzbeI9ontl0xiIjCcscnvhTlcNtIsGE1tn3lyqJFpDgOP1Tezk18GXHsZ95rXbWF8yl
	 HSMCgbQcvbR60nGIP9pDiYu7OxqB4fXC5tVAglJaxb5jQ6GkzoXCKvePgvxkA/q77IbKt
	 nyx9dYDqeZVH9NivqXMF8m03rRGj5P5Hr4gqJ+h1kGntLg2KGCQ2j2PkSJciaLqCUPTzs
	 arOhC1NoVawoaDO+dHrd1vS6TYtmWX1V1ZL8ezChjC7vbuGHnH/QEmdn4PKEaSrjMMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AkcodnpcnaWjSP+nZUeBGoMC9xm20Sfhx41aShqhQZk=;
	b=D00YidwfkGuxUx4gm3BMRzy5/+aUsGytOUylC5inQqLmUFx5gNNfllG7A78kuPb1YBdt
	 L8z1/2w4RDVODutaUaTUHtDbYvNYZcvDz82FWpXcO4LJF+O/2jcHvKADE1DFsso/R5+rN
	 y87QtVRvZtoc8aDGGgWuifJbjZ7lisY4YqTBSIyGVpgLefD/hoY78rY/IKhurM0Z6fuoK
	 uJDZVSM+MvKyEbShS38ke85e1KGZqCgvJakmDIBcaUlBtHdvBIF6LbjZmxLd5Uq03ge4j
	 uYKLGZvMkGKqQWo8kwXyXIKa87qrS0bOTPKTZP2IrpZ4ADfuxeoE5la3NxjBPe/dslA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oqZmrr7O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C53606A320;
	Thu, 19 Nov 2026 00:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oqZmrr7O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23AA1F000C4;
	Thu, 19 Nov 2026 00:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049885;
	bh=AkcodnpcnaWjSP+nZUeBGoMC9xm20Sfhx41aShqhQZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oqZmrr7OKYrpcz8rI/KEAcw6ibhf6BI+Ji2Z50UVsD5NxHL/YCQYYR0nOXVCwXPTk
	 i9PXA08hLqKmarX/ryftHhAzaPHnPUv8rNhK9MKkFmSv6L9x1L1EqWTMaq08v0XjwD
	 2MBTtbzBsuE8mQaPp9ETwrvtn1cmm+QvL47SAx4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2511/2857] net/mlx5e: use skb_share_check() in the loopback selftest hook
Date: Wed, 18 Nov 2026 15:59:05 +0100
Message-ID: <20261118150331.954821806@linuxfoundation.org>
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



