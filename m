Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E244A3ECBC7;
	Mon, 20 Apr 2026 13:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691510; cv=none; b=NDHaqC0x3SrwjpVqDxzfqzg8fuCNxcgMr0ipS9ROSFDTnH3AuIs5Uk3S+D+lNQySL/0Jjt5eOte652eSa45g04KBmYzwGYPHfGdaddS9g2eYSUaf8msCeLF3OwyFZY+G+BqTeZN+TKWp0SahFo5wC/nq7DMtwNZNpNeRWIkM8w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691510; c=relaxed/simple;
	bh=TtjqapD4oLdZvZtt7JXD1IjiuGQVAMI3ln2GNqVTAu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fiyTZWhwfAj2QWLtuPIGKQY4WcR3iI6Yq3HoQOOSWz6bZu3JdxZe/rakEPK8kJzChNq0R3M6jFRiqV5F+aiNTjPR5h61bl9nhLxPohH3MnhOY3k67ktNCxx/bvtH6iuuOEVgLG2RLpsgRUImoKrZpJFZ99gB2d+HQlwPuL7YCzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vB45pR47; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vB45pR47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC89C2BCC4;
	Mon, 20 Apr 2026 13:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691509;
	bh=TtjqapD4oLdZvZtt7JXD1IjiuGQVAMI3ln2GNqVTAu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vB45pR47ah6OYi1s6GixYGJEWZqyTkmANBFu71lOLYwQQgB2s/BJVkX1mi+c93dfu
	 Sy9CxeM0dFAntvXQmTIE7CLuewrGdPsp5TST9gydfqfyU6O+h5oDUOxJDrz55+xZUJ
	 ylzv0X+zSsCOnkrDHywMkmiaE9WxhKBZ7sQb+B0A7Q9X8tzEwSB3XesqPcR73i9wWW
	 QT/m0Ch3TTR+kxWvfoRREsgManUBMWEGgHs2cUDkYCfpgWJPGRRNR/ctGcQty8g35c
	 bZ5TRrSqCX70D764pVlG6RKrBITPze9hmktKPjcb09eLDIPbJRERs3tTUMvVWrbwVt
	 1gkg9+RPjrbSA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chris J Arges <carges@cloudflare.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	bestswngs@gmail.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] net: increase IP_TUNNEL_RECURSION_LIMIT to 5
Date: Mon, 20 Apr 2026 09:17:46 -0400
Message-ID: <20260420132314.1023554-72-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Chris J Arges <carges@cloudflare.com>

[ Upstream commit 77facb35227c421467cdb49268de433168c2dcef ]

In configurations with multiple tunnel layers and MPLS lwtunnel routing, a
single tunnel hop can increment the counter beyond this limit. This causes
packets to be dropped with the "Dead loop on virtual device" message even
when a routing loop doesn't exist.

Increase IP_TUNNEL_RECURSION_LIMIT from 4 to 5 to handle this use-case.

Fixes: 6f1a9140ecda ("net: add xmit recursion limit to tunnel xmit functions")
Link: https://lore.kernel.org/netdev/88deb91b-ef1b-403c-8eeb-0f971f27e34f@redhat.com/
Signed-off-by: Chris J Arges <carges@cloudflare.com>
Link: https://patch.msgid.link/20260402222401.3408368-1-carges@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 include/net/ip_tunnels.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 80662f8120803..253ed3930f6ef 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -32,7 +32,7 @@
  * recursion involves route lookups and full IP output, consuming much
  * more stack per level, so a lower limit is needed.
  */
-#define IP_TUNNEL_RECURSION_LIMIT	4
+#define IP_TUNNEL_RECURSION_LIMIT	5
 
 /* Keep error state on tunnel for 30 sec */
 #define IPTUNNEL_ERR_TIMEO	(30*HZ)
-- 
2.53.0

