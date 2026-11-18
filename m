Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050155;
	b=YTmfZYW5elyAigE/Wm73PrqILLjrRaS4Xt9hhMEO1L4zddj6nDzsvfDy+QP2S7tot5+j
	 Tzo7e5n5hQ0xp2iecHz4ky1Ox8Dy6hIQ3sb+arVxN35iFM5cnD/a0/9yDvHJ5UgNaffhd
	 y2krY72Lg7mbtVA0Xxpg/AaVB4YX/ZvIYyI1vXJ4KCDwyaKE6UmhhBqf1/h0Tyd+h0r1H
	 iv6pMEQcvznJGsP5REud9fzcFh1vwnT0qe/8GGMW8YLfmfMj5fqvnIFt67EQuW4sVI7XB
	 Qessy2dW1vFmYWeowVv4pFt0hxNw5Zf6+4N9RSxp6ZAuJk5N/DcDBIIH1OwKllLrFuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AlcW17k5U7CICiQZE7oV1DDtMWmrsxMLGhwF+KLZZO4=;
	b=UiLnkzAC8Q1Rwr80PKjn17SS6WQZ5LQmmEMd+GodfMVqzZh8ydhIWI+SNQWDsXWP++Ut
	 mc8xZqZjUIkpqV2MiSe+ORwsKcrRaebo0CZoNIXkajnL5EmTNJzzWAH4ZYfF2XY1S2uk8
	 HDGXiXSjXTlL2Qcd0Klg0S6VL/YciL9sVmpbzHjMab6snmz7IxyL/vpY6MLRikgffmqfl
	 qNeZOnx0nPiqq1zY3i9vK4+z37SP4vU2yMfFocFRLiicLvT8XGORQdzgsxEiUkM6oX9av
	 m/z9YjQZQf2yrh8mXVpJtvPldUDDW2BvBFNjMfTr2wukj3OGPpuyypNM0xRFqSNLwFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iwdNHQCH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2503F606A31C;
	Thu, 19 Nov 2026 01:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iwdNHQCH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B21E1F000C4;
	Thu, 19 Nov 2026 01:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050155;
	bh=AlcW17k5U7CICiQZE7oV1DDtMWmrsxMLGhwF+KLZZO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iwdNHQCH5031OOKeOs6HC4Kt6iRCEInweKym2a8GJWRa+b4dKVPM3ZZu4ChiT7kz3
	 O4jiL/B7WuQgPil4mJ4JCl74vY0/GXf+he8SsHCd6bn5tHgj6hfDp5iQYj+gm+/6gc
	 NnBq/orWvvvfYl2E7wvHn20c5gNN/NQgeX5NYQ0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serhat Kumral <serhatkumral1@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2607/2857] RDMA/srp: Avoid reading uninitialized has_port on srp_parse_in() failure
Date: Wed, 18 Nov 2026 16:00:41 +0100
Message-ID: <20261118150335.435008563@linuxfoundation.org>
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

From: Serhat Kumral <serhatkumral1@gmail.com>

[ Upstream commit 4b8f20dc8d25f575e8b8bb5abb09ab803a7e1a3f ]

srp_parse_in() returns -ENOMEM without initializing *has_port if
kstrdup() fails. Only check has_port when srp_parse_in() succeeds.

Fixes: bcef5b721568 ("RDMA/srp: Accept again source addresses that do not have a port number")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
Link: https://patch.msgid.link/20261016211509.12973-1-serhatkumral1@gmail.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index d9acbfe24f1ec..cfd3d15dba3de 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3482,7 +3482,7 @@ static int srp_parse_options(struct net *net, const char *buf,
 			}
 			ret = srp_parse_in(net, &target->rdma_cm.dst.ss, p,
 					   &has_port);
-			if (!has_port)
+			if (ret == 0 && !has_port)
 				ret = -EINVAL;
 			if (ret < 0) {
 				pr_warn("bad dest parameter '%s'\n", p);
-- 
2.53.0



