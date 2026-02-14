Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CDA30B538;
	Sat, 14 Feb 2026 21:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104353; cv=none; b=mC+YwnztZI5U6su0BFKxCN67U7MFbre76oKBBOydXBNgtSHS+hIVFB390KwAvPCVjanh71ReFJRdjbgbbjcOd78xEjLon9BAaOgXXMDqRoDExunBB99QFoPvCt46qzU/0u6FLg9R7sZmN2RtPV1gPmSEPMjhTHO9rHWrXt1LrjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104353; c=relaxed/simple;
	bh=a6AFDtak2ZeymRim/dSLlx+Pr0RgsP92jVYL9T3nWmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UTTmZSBf9Dz+74uD7nT3EYjftxoValLxhYlx8av79qHaTvJiqM2VCYHvGvY3KoJyCk5CKZDjirXE5H0QPu3HtCW3gBsLbtJewGWQdlDySjpAYAOfLwfcHu9YjUjaIQOLUuT6xvAR/2DDewmEvvJEQwlbI3JXwM2iOdTgPLqT5Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DLtCwVfS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DLtCwVfS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409F2C16AAE;
	Sat, 14 Feb 2026 21:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104353;
	bh=a6AFDtak2ZeymRim/dSLlx+Pr0RgsP92jVYL9T3nWmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLtCwVfSHG5bKyYvX8hsUlHsTmXFEyzIZ2TBY8YiJJQDpUFLklmgHZHJ+FIONJxQi
	 GESr4B4DIalRK3Bkiu+OKeG3Qb4zag7GiH83VqckX+kPmZkt2AFYVUGtixMhSY6FmF
	 aDNueaNqL+/tGXyI55b386GxlpmXfbi0IQjNZoLDNI8Q63zKMzb5noeP8dtVnzc9WD
	 EqL7E/6xGPXTFniyjErn9tp9PGu4YY/xoZXbWrmw84G6p3QHNsRcVpIybfRoaBzvnW
	 RpysaJycJ8qCtbok7b3myz0rjcLpjAUQnVhvMbipA7UeQRwRsqbyCpUc7fasVgqtbM
	 wD4xRv3WpB/Jw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	dsahern@kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] ipv6: exthdrs: annotate data-race over multiple sysctl
Date: Sat, 14 Feb 2026 16:22:59 -0500
Message-ID: <20260214212452.782265-34-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 978b67d28358b0b4eacfa94453d1ad4e09b123ad ]

Following four sysctls can change under us, add missing READ_ONCE().

- ipv6.sysctl.max_dst_opts_len
- ipv6.sysctl.max_dst_opts_cnt
- ipv6.sysctl.max_hbh_opts_len
- ipv6.sysctl.max_hbh_opts_cnt

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260115094141.3124990-8-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of commit: "ipv6: exthdrs: annotate data-race over multiple
sysctl"

### 1. COMMIT MESSAGE ANALYSIS

The commit message is straightforward: it adds `READ_ONCE()` annotations
to four sysctl variables that can be modified concurrently from
userspace while being read in the packet processing path. The author is
Eric Dumazet, a prolific and highly respected networking maintainer at
Google, who frequently contributes data-race annotations and fixes.
Reviewed by Simon Horman, another well-known networking reviewer.

The four sysctls affected:
- `ipv6.sysctl.max_dst_opts_len`
- `ipv6.sysctl.max_dst_opts_cnt`
- `ipv6.sysctl.max_hbh_opts_len`
- `ipv6.sysctl.max_hbh_opts_cnt`

### 2. CODE CHANGE ANALYSIS

The changes are minimal and mechanical - wrapping four sysctl reads with
`READ_ONCE()`:

1. **`ipv6_destopt_rcv()`** (line ~317):
   `net->ipv6.sysctl.max_dst_opts_len` →
   `READ_ONCE(net->ipv6.sysctl.max_dst_opts_len)`
2. **`ipv6_destopt_rcv()`** (line ~326):
   `net->ipv6.sysctl.max_dst_opts_cnt` →
   `READ_ONCE(net->ipv6.sysctl.max_dst_opts_cnt)`
3. **`ipv6_parse_hopopts()`** (line ~1053):
   `net->ipv6.sysctl.max_hbh_opts_len` →
   `READ_ONCE(net->ipv6.sysctl.max_hbh_opts_len)`
4. **`ipv6_parse_hopopts()`** (line ~1056):
   `net->ipv6.sysctl.max_hbh_opts_cnt` →
   `READ_ONCE(net->ipv6.sysctl.max_hbh_opts_cnt)`

These are in the IPv6 extension header packet receive path - hot path
code that processes every incoming IPv6 packet with destination options
or hop-by-hop options. The sysctl values can be changed from userspace
at any time via `/proc/sys/net/ipv6/`, creating a data race.

### 3. BUG MECHANISM

Without `READ_ONCE()`, the compiler is free to:
- Re-read the value multiple times (store tearing), potentially getting
  different values in the same function
- Optimize based on assumptions about the value not changing

This is a real data race detectable by KCSAN (Kernel Concurrency
Sanitizer). While the practical consequences of this particular race are
relatively mild (the comparison values might be slightly stale or torn),
the race is real and in a networking hot path.

### 4. CLASSIFICATION

This is a **data-race fix** — category 3 (Race Conditions) from the
analysis framework. `READ_ONCE()`/`WRITE_ONCE()` annotations are a
common pattern for KCSAN-detected data races and are regularly
backported to stable.

### 5. SCOPE AND RISK ASSESSMENT

- **Lines changed**: ~8 lines across one file
- **Files touched**: 1 (`net/ipv6/exthdrs.c`)
- **Risk**: Extremely low. `READ_ONCE()` is a pure compiler annotation
  that generates identical or near-identical machine code on most
  architectures. It cannot introduce regressions.
- **Subsystem**: IPv6 networking — core infrastructure used by virtually
  all systems

### 6. USER IMPACT

- **Who is affected**: Any system processing IPv6 packets with extension
  headers where sysctl values might be modified concurrently
- **Severity**: Low to medium — the race could theoretically cause
  inconsistent enforcement of the max length/count limits, but more
  importantly it silences KCSAN reports and ensures correct compiler
  behavior
- **In the networking hot path**: These functions process packets, so
  correctness matters

### 7. STABILITY INDICATORS

- **Author**: Eric Dumazet (Google, top networking contributor) — very
  high trust
- **Reviewer**: Simon Horman — respected networking reviewer
- **Pattern**: This is part of a series (patch 8 of a set) of data-race
  annotations, which is a well-established pattern in the networking
  subsystem

### 8. DEPENDENCY CHECK

This commit is self-contained. `READ_ONCE()` is a basic kernel primitive
available in all stable trees. The sysctl variables being annotated have
existed for a long time. No dependencies on other patches.

### 9. VERDICT

This is a small, surgical, zero-risk fix for a real data race in the
IPv6 networking path. It follows the well-established pattern of
`READ_ONCE()` annotations that Eric Dumazet has been systematically
adding across the networking stack. These annotations are routinely
backported to stable trees. The fix is obviously correct, has
essentially zero regression risk, and addresses a real concurrency issue
in core networking code.

**YES**

 net/ipv6/exthdrs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index a23eb8734e151..54088fa0c09d0 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -314,7 +314,7 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
 	}
 
 	extlen = (skb_transport_header(skb)[1] + 1) << 3;
-	if (extlen > net->ipv6.sysctl.max_dst_opts_len)
+	if (extlen > READ_ONCE(net->ipv6.sysctl.max_dst_opts_len))
 		goto fail_and_free;
 
 	opt->lastopt = opt->dst1 = skb_network_header_len(skb);
@@ -322,7 +322,8 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
 	dstbuf = opt->dst1;
 #endif
 
-	if (ip6_parse_tlv(false, skb, net->ipv6.sysctl.max_dst_opts_cnt)) {
+	if (ip6_parse_tlv(false, skb,
+			  READ_ONCE(net->ipv6.sysctl.max_dst_opts_cnt))) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
@@ -1049,11 +1050,12 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
 	}
 
 	extlen = (skb_transport_header(skb)[1] + 1) << 3;
-	if (extlen > net->ipv6.sysctl.max_hbh_opts_len)
+	if (extlen > READ_ONCE(net->ipv6.sysctl.max_hbh_opts_len))
 		goto fail_and_free;
 
 	opt->flags |= IP6SKB_HOPBYHOP;
-	if (ip6_parse_tlv(true, skb, net->ipv6.sysctl.max_hbh_opts_cnt)) {
+	if (ip6_parse_tlv(true, skb,
+			  READ_ONCE(net->ipv6.sysctl.max_hbh_opts_cnt))) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
 		opt->nhoff = sizeof(struct ipv6hdr);
-- 
2.51.0

