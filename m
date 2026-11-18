Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020330;
	b=n5APNXkQ4AM4vIOCLBjtEHd2QNM4jnkLzDaiEn+ZVB4RYr71lSNbNLKBEHFzbtU2J18s
	 F2PXyVqgEE92RjngC0uOO4KfRkyBlN2TlWg8jPuqU05rsLnExclRvA7f4zyPaKvij+xb8
	 W27HBt2JNvcWXfy1IByNiDP8P4OibeBuOswsN/0suJYWO2Ak6Io6WwzcgNNG5NiFGfzA0
	 6IW9+zk278g4td+gkjVmwanSOtXIkJfklogsls3Jh1k0KZ3cdknLhSCg/6XNAcfJLq5bu
	 4GIywnUShGkta77DfhkTgkeCGLficFn7GG2rKxGZrMo56ASpsfFhdiCsvFEOB94FQLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J6ysTUFVYK88dT9ilTHsBfFsM908qB76MhE9SPiANok=;
	b=wBVohorIKABAJDCcMeO9YdMw3N8EGVV2MO9HN7vzYO8PYZrdGc0yYp8eMfnsnCZ3UrRe
	 FjP/crjflcQizsbZOkzOOetf5PFglD4JQZN49qg6xY+U0BP/ujhsrciKyCX/1sO6RkE6K
	 J39Em+TJgopmePtDH5lmiLjfNF8/CKDhb4uugzI9pbhYtxFd5oZPkuPhEhRMVXLcPbifo
	 1THrgxXDp6LatiFFOSpdsisLNMqk2wRM4+S3frKUloG5bybRMwJPbc1qUwv5REeSnJw5t
	 Q9Lp8O00j4AtzO/a5xkIhRCCip+O6mDm9V7e3pWeb6LPTyYCcmDLSxcaFkIBDfO4b8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QLHSIVud;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF02B606A320;
	Wed, 18 Nov 2026 16:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QLHSIVud
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D14B1F000C4;
	Wed, 18 Nov 2026 16:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020330;
	bh=J6ysTUFVYK88dT9ilTHsBfFsM908qB76MhE9SPiANok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QLHSIVudPzOISeKqgpyySPUAIwZKTVD+R3y1YBMzdgpRpWB/eaXjY71OXkAxg6Ftz
	 YlRwAErUOw2LUHHYHf93vPcg1qb70OSASrA+c05J+0p8WB8Q6wbf35Bcy5FwKds8fd
	 jaOULMwsMK+glO8mMelk1PKagheY51fbUcSGArQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1912/2651] net/mlx5e: use skb_share_check() in the loopback selftest hook
Date: Wed, 18 Nov 2026 15:52:32 +0100
Message-ID: <20261118150355.613845344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 1dcdb86690bb7..8eb9a9469549d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -166,6 +166,10 @@ mlx5e_test_loopback_validate(struct sk_buff *skb,
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



