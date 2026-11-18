Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032082;
	b=k57BR9UB4O6sbQvubd6NJsovuKZb0B5q8poDBcAqh0EDM5s4C0m84J2NbdnLek9siSKI
	 2kwNqemMAkESx3992jGsD0Z1BrKBLIbNXRxXi/IEte6dtD9Hv9SghIwuhb7q/1z1SpCyO
	 R6Jhw32c2CC28q/+WuHyy5xGJ+7O1X2exdrY3Od6gxhJqwkk/9yLkHkRQ6fFYmj89n1N4
	 UPY/LAe2nlCYjcO5upv+t5CedvLzszUktUGcP5WnlAhwSJdbiFgGr6cKpHE5AHNKxniNG
	 YPGS4+tHnF/WhhG/oa8w8VFaEpEWaOjmrB67Kr3vsR65rBqB5LWnWsAv4qjPHpneCIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032082;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nTj4b8c364zUxxm7e6fRZiY/M7BQYvulgUM+FfARCw4=;
	b=enxyaSIwaFdK257nLqNzYOvWMsGEKcoyVZnJQRvu42i1Y0AJ5d3EEucXmnhjzYh0Tfz9
	 9UYgNiUt2gkVdD5hx1OufN0+w9N6Z6UcuovD7wYVHMaUmmYqKo3V5wOCiLFQQvEN6aG4d
	 dj0UZO7JINH0Ng6EZfuUGMEWbLUMcEEHLktU39f5WK+wpLDB+zaFKBrhEDXjqURfZLVd8
	 19/oz+cLHfs4sBjep9W9Q7ZM/S+DzTLh8KGhJgRBppe/+jTst207e8vnFWwVvfOz+9D53
	 zPKLY6fsRVNwbcSmMMmhkU6SmhnkENKXlclTgLzkwhFkI3tzNCEdxPxasoKyz0Cv9ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iMpuHgHA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B60606A31C;
	Wed, 18 Nov 2026 20:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iMpuHgHA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A801F000C4;
	Wed, 18 Nov 2026 20:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032082;
	bh=nTj4b8c364zUxxm7e6fRZiY/M7BQYvulgUM+FfARCw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iMpuHgHALd1iDbebeqqPolkMPnZT/3HGxeJro89fMbFS3YiyUHxrQzKC2tYwdHMEv
	 q0UYxxGYhi8u4EvlDGYEb657smtllKOpAo1WJl21IrafyGwW1SgPeCcrXNFMhmfuPc
	 ye0lw12QubIayLbsW9+QTk9v8fSDB7W8sGwXYa0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1244/1756] net/mlx5e: use skb_share_check() in the loopback selftest hook
Date: Wed, 18 Nov 2026 15:56:11 +0100
Message-ID: <20261118150059.266709630@linuxfoundation.org>
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
index 2f7a543feca62..9e0a677ea9db6 100644
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



