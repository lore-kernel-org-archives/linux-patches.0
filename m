Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38902ECE80;
	Tue, 15 Jul 2025 13:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587738; cv=none; b=oVdZx14uiWJBtuTzmB1hyV/hYHydtxGMF/z25KH9SUjNwTp/dX1BBp2JUitqGMLno2IU1S5vaurY1d+Mff1ftrl5AY82kkfXHVhd+IZvhW1RErk6Opybql8eLpzy1DWdZUmeKah5pMbI1ufiVAOCSwvvi6n+gb88gf1KOzqcFDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587738; c=relaxed/simple;
	bh=3MRK57SFk7MCYWxY7TLCdZjxjCKc6ScW6xsHbvytGVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aODwtaCoVZn59Q29KydU3vPA4DldVAJCA196vTCoMxEjGME+ZUVD7OgxJ+eZrg3nt1N0oIPEbDT6a4DQsZvYUhgOJLWgXhK6s4cJ5oOxf9+pnWT2IQ7K+ER39ervXofs7f3x06V6xJ6UaG4W5EdMNIa/Ig7ho1H0v5jE28kbOQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2o5/9rQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2o5/9rQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E8BC4CEE3;
	Tue, 15 Jul 2025 13:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587737;
	bh=3MRK57SFk7MCYWxY7TLCdZjxjCKc6ScW6xsHbvytGVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2o5/9rQK/wdzNAvZaBbOkWv7UMY9EJ0KT4YUp3Ykl7hjHhBEriIhaATe4GTPFYPd
	 vgAkvVY1LbEluk2qqDPdh0hYFADOCDZtYjRcVrGhADNfK2jznIHQDeTbgGSv/xMkHt
	 BQ4cit/nX87UlRWziTPvYNeWgTamCKI6cs25pawk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/208] net: rose: Fix fall-through warnings for Clang
Date: Tue, 15 Jul 2025 15:13:26 +0200
Message-ID: <20250715130814.829683441@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 981bdefd478b0..66aa05db5390f 100644
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
 					fallthrough;
 				case 1:
 					t->neighbour[1] = t->neighbour[2];
+					break;
 				case 2:
 					break;
 				}
-- 
2.39.5



