Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5496371CEA;
	Wed, 20 May 2026 18:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300276; cv=none; b=T5NMT4y17Z9qFOj90yu6B/ciARVL6wIzGjoZcb53BflKRjHg2YZwxUKA1s+GJjxwx1lsnyy4S5WDcVxYNYzFqYPIDV1Qt/6gw2WmG5xTem0C2ruAsOnqJ+2mKqJqccbS5/q9OSfadkX32nZuM9gUCvFImYDthviV7KUloiVjQAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300276; c=relaxed/simple;
	bh=QE83UQF0o/Zv7MpkTdVDGoQZ7xCve17nYyHg1MyffCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZH9thTqcrEOwN5HcL+yvcrsbKvjxFtVcLWMpz8vzw5v04Ua7OpqFN08wzUVyk5CM/eXKWYMq3uDY1ZN0LSgXhVgzrBfmBPayH70UsLIpWHaqRegLMYx1aRS1npk8kSrJ/fLsjKt+ArBBSZgOy0lFFhlIgHlTMAFU8ALwX1lN3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SoCg3pJS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SoCg3pJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268311F000E9;
	Wed, 20 May 2026 18:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300274;
	bh=l3sJaFqbbR+006KMG8jSgutYsaRJ0y53U54PqrJTYnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SoCg3pJSxKSbSejpzLi35ABmRL2zJh+Us8B7cJYDv6/GTc9aY9tGFJ/D269QVkKxR
	 gXVqDIJgXUw6v7ZLMMMzCKeEJu9fblwikVnrSpkl5R70mXuSALkok8AHDVkKd4OKq9
	 TBnKtLQy12W7Sp7tuBiGT0kuzfEpns+9dh322KnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/666] ipv4: udp: fix typos in comments
Date: Wed, 20 May 2026 18:15:23 +0200
Message-ID: <20260520162113.647777854@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit d436b5abba4f80e968b3ff83be4363c7aedcc799 ]

Correct typos in ipv4/udp.c comments for clarity:
"Encapulation" -> "Encapsulation"
"measureable" -> "measurable"
"tacking care" -> "taking care"

No functional changes.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250907192535.3610686-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b80a95ccf160 ("udp: Force compute_score to always inline")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 27694334e410e..0d4a6abdfb963 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -68,7 +68,7 @@
  *	YOSHIFUJI Hideaki @USAGI and:	Support IPV6_V6ONLY socket option, which
  *	Alexey Kuznetsov:		allow both IPv4 and IPv6 sockets to bind
  *					a single port at the same time.
- *	Derek Atkins <derek@ihtfp.com>: Add Encapulation Support
+ *	Derek Atkins <derek@ihtfp.com>: Add Encapsulation Support
  *	James Chapman		:	Add L2TP encapsulation type.
  */
 
@@ -510,7 +510,7 @@ static struct sock *udp4_lib_lookup2(const struct net *net,
 
 			/* compute_score is too long of a function to be
 			 * inlined, and calling it again here yields
-			 * measureable overhead for some
+			 * measurable overhead for some
 			 * workloads. Work around it by jumping
 			 * backwards to rescore 'result'.
 			 */
@@ -2414,7 +2414,7 @@ static inline int udp4_csum_init(struct sk_buff *skb, struct udphdr *uh,
 	return 0;
 }
 
-/* wrapper for udp_queue_rcv_skb tacking care of csum conversion and
+/* wrapper for udp_queue_rcv_skb taking care of csum conversion and
  * return code conversion for ip layer consumption
  */
 static int udp_unicast_rcv_skb(struct sock *sk, struct sk_buff *skb,
-- 
2.53.0



