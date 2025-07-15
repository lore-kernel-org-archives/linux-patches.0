Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA882E613D;
	Tue, 15 Jul 2025 13:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586526; cv=none; b=Xmqn6grwu5mahdETiNztaTbNTeUchrDZPMnKoEi7/Me/WMj+OnKMk1JoyirajbnOZ9VnlGnfSwZ9nSYzWGdGAvidCUvzibKERjx0gqI9MUOIP96J4YqogbGhxDKdn7nwggtkSdbMzc/YHB3Ge/pwwjVwIsoFSlC+Ttmm2yjCZ9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586526; c=relaxed/simple;
	bh=WnnIpN4xufKjVRrJF2IyCxQEScOCXvuK3m/TuIGiF64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=boByQKF1Cw3BmN1KWplqc8zob3IOKqdAhPVvkTn6kZZAaCcCSVt3u+hrF7cywTagoZacDJgqbNE6x/RBW5hNPswzfjNS3fD8V3kZiJyhcxBQWU9URTGW5gHVHELFxJyV57j/FMJps5kQnqCzuwJfx3T+6lD0jCsSIh8lVsqMKJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHDFpSeL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHDFpSeL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DC7C4CEE3;
	Tue, 15 Jul 2025 13:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586526;
	bh=WnnIpN4xufKjVRrJF2IyCxQEScOCXvuK3m/TuIGiF64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHDFpSeLHV9i2+uYE0KjS6A4cqQlbrdLCJfxNns0wSVimniB7NAK1MtG8ABnJrbyi
	 wt09y7nd10lMjIJjFOwOSpn3PYq8lQ4826RsOthjTe339vbzg6tpVhYYF2dez1r8zL
	 qmzwMMYEb+66D9VnYrWKxaWWTaM4d4rmVwve1mxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 097/148] net: rose: Fix fall-through warnings for Clang
Date: Tue, 15 Jul 2025 15:13:39 +0200
Message-ID: <20250715130804.201760896@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit 90d181ca488f466904ea59dd5c836f766b69c71b ]

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding multiple break statements instead of
letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 34a500caf48c ("rose: fix dangling neighbour pointers in rose_rt_device_down()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_route.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index 64d441d3b6533..49a0e7d5a7684 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -347,6 +347,7 @@ static int rose_del_node(struct rose_route_struct *rose_route,
 				case 1:
 					rose_node->neighbour[1] =
 						rose_node->neighbour[2];
+					break;
 				case 2:
 					break;
 				}
@@ -508,6 +509,7 @@ void rose_rt_device_down(struct net_device *dev)
 					/* fall through */
 				case 1:
 					t->neighbour[1] = t->neighbour[2];
+					break;
 				case 2:
 					break;
 				}
-- 
2.39.5



