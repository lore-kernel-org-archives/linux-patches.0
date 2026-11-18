Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026916;
	b=H4yDto+43oGHxLCZCaDvPROxMlUwn6pZoNcxPZtonJJb9dOMnvTB/LIfNc7IEOATFX9P
	 pb3gW0GnFzdhpVfDWIOdFCL34LGLjpI1/EybM8xz9cPucFHI063/5ZLcLsYwGL02pUJOk
	 mPc7MILLXIJm4j9ktmb+8Fx3QlHGWUq005VNCkjV513+wcUe89xll/m7LM4WlxonuJdoz
	 0FlVD+79WYRZTq35HlGrmo3ejtyvQP25V9DrhX7o0npjaG62IoH3fwZnwnAdgZF8qAXt1
	 bIMiFtsP4Kn5EHcpkijfPs0Ed4/luLFaT1+5fBAgSeNqVLeU1+DLxY9TROHZ9yzahzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vOw7ie8vwSfB4VqMreMwpZKm42xYNPsIYxUVP6RnrJA=;
	b=aQWEDBujqnNnNYSEkzzttQuJCXuVmX1RUSj/NsI+KLkdEw0ZKGpHUag/GC58uPDZWtQK
	 IsvEwLu5FdvkmmRttlCgioQQF43UrcrjcdYvxIgS0WtczhnLjj3+NLRROnRHP5n2tdxox
	 +erRAhQ0XE+IiEbSgb4nYNcqf6WPDlYlZBVE0lGFco1S035Xjbxwob3v7+FkCqt/0DJij
	 //wTHlYBMwsvsIQI4mH0fMKi3xXrLZ+1PqgkdO1SMOcS0eYib+6N2K3QO4rDxlEt57vDT
	 ktwpAmC5Mc/t1rD8Znm+yrayZfSPlrGPQ0mHa00tMcKsy1dWAtuc4w1z6HWdHtgT4ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YLHUOvDZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26D1606A31C;
	Wed, 18 Nov 2026 18:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YLHUOvDZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C571F000C8;
	Wed, 18 Nov 2026 18:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026916;
	bh=vOw7ie8vwSfB4VqMreMwpZKm42xYNPsIYxUVP6RnrJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YLHUOvDZvIELRD+W766jHamGHTZ9MStfV6e2sM4JXQ8M9iglhxZTi9s1SFVXEDo2W
	 48asLAfXNzQBCAmUqrDg9yvYxUjD7Shxogzn0ojfuFBANFP0QELGhUxpI1G6t3dCp0
	 empQrNFKivH+44oFkY6KLx6gLBnSyGm8R/CGDSSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1554/2151] net/mlx5e: use skb_share_check() in the loopback selftest hook
Date: Wed, 18 Nov 2026 15:54:49 +0100
Message-ID: <20261118150218.505986770@linuxfoundation.org>
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



