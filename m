Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D843C2D;
	Sat, 14 Feb 2026 21:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104332; cv=none; b=IKwbTpUZHcBulu6tPvkxNfSwoQDE54aSlZXbLzuR0gfJZr2QKc1AePQor2R80j+yu06NLVnagZquLtLTUI71q3Bxj9AiSQGI3akL1dvgvPqwG3C/PvNC2kI4txfVlVcTt1lTvOnHDHJCPeuRb/WrH6KGfC/kLPc2fNLmhbwPODQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104332; c=relaxed/simple;
	bh=IEolZjLt9W5K7QPJw1wk3fFPTdzpWuj9VU77DHTEGR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NTgYBwybWY0SzwsHkZxYNKjUP7+LDauBWiKVvVVpqG+Ew1gBo/0QuI7VkZEYDOTYq5HHxm2F/On0rNSv77D0BWwKCH6SswNyj+d6r1XcjO8uFMuSbGT6rPWgcacdR0ZTFGj8+2yZ22PghRZEUNfx3zeGXjZkL4xU8MDj3Wo54Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LWyKkMlu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LWyKkMlu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A81C19423;
	Sat, 14 Feb 2026 21:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104332;
	bh=IEolZjLt9W5K7QPJw1wk3fFPTdzpWuj9VU77DHTEGR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWyKkMlus429KIrrUbgC1HbODZFcj36X+CD4nexWBsawkwDovnam5LsyjpPTwo0Zd
	 oPKDDDVc6RsLZVF34BamLva+J5UFJ4vOqRmJ7vhg/5qREG/njw7TrOTPNOFUJQvfsx
	 UEb+gXpkcPx0pw3KgMTvLL4Ad/6doVaFrIeXYYQ5asvT0/750v2KDTF8EYYw0SSRJy
	 NI5VhPOHye85GUupGWDZE4+Z3DCUFDdreIZV0Ot+e8riKzd5T7bko1+O/PM2J09Drl
	 6dr+sRne1mYPGhWL0abBvZCHutVG91JuIbxfJpEHlXWNl4oRJfYGMqsZb0eQn9CANX
	 MK8lhlFbyEzVw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	dsahern@kernel.org,
	ncardwell@google.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] ipv6: annotate data-races over sysctl.flowlabel_reflect
Date: Sat, 14 Feb 2026 16:22:48 -0500
Message-ID: <20260214212452.782265-23-sashal@kernel.org>
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

[ Upstream commit 5ade47c974b46eb2a1279185962a0ffa15dc5450 ]

Add missing READ_ONCE() when reading ipv6.sysctl.flowlabel_reflect,
as its value can be changed under us.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260115094141.3124990-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of Commit: "ipv6: annotate data-races over
sysctl.flowlabel_reflect"

### 1. COMMIT MESSAGE ANALYSIS

The commit message is clear and direct: it adds missing `READ_ONCE()`
annotations when reading `ipv6.sysctl.flowlabel_reflect` because this
sysctl value can be changed concurrently by another CPU (via the sysctl
write path). The author is Eric Dumazet, a top-tier networking
maintainer known for systematically fixing data races in the networking
stack. Reviewed by Simon Horman, another well-known networking reviewer.

### 2. CODE CHANGE ANALYSIS

The patch modifies exactly 3 locations across 3 files, adding
`READ_ONCE()` around reads of `net->ipv6.sysctl.flowlabel_reflect`:

1. **net/ipv6/af_inet6.c** (`inet6_create`): Socket creation path —
   reads the sysctl to set the `REPFLOW` bit on new IPv6 sockets.

2. **net/ipv6/icmp.c** (`icmpv6_echo_reply`): ICMPv6 echo reply path —
   reads the sysctl to decide whether to reflect the flowlabel in echo
   replies.

3. **net/ipv6/tcp_ipv6.c** (`tcp_v6_send_reset`): TCP reset sending path
   — reads the sysctl to decide whether to reflect the flowlabel in TCP
   resets.

In all three cases, the pattern is identical: a plain read of
`net->ipv6.sysctl.flowlabel_reflect` is wrapped with `READ_ONCE()`. This
is a textbook KCSAN data-race annotation fix.

### 3. BUG CLASSIFICATION

This is a **data race fix**. The sysctl `flowlabel_reflect` can be
modified at any time from another CPU via the sysctl interface. Without
`READ_ONCE()`, the compiler is free to:
- Load the value multiple times (potentially seeing different values
  within a single check)
- Optimize the read in ways that produce undefined behavior under the C
  memory model

This is the exact pattern of KCSAN-detected data races that Eric Dumazet
has been systematically fixing across the networking stack. These are
real data races even if the consequences in practice may be minor (store
tearing or inconsistent reads).

### 4. SCOPE AND RISK ASSESSMENT

- **Size**: Extremely small — 3 locations, each changing a single read
  to `READ_ONCE()`.
- **Risk**: Essentially zero. `READ_ONCE()` is a pure annotation that
  prevents compiler optimization issues. It cannot introduce new bugs.
- **Files touched**: 3 files in net/ipv6/, all well-established code
  paths.
- **Subsystem**: Core IPv6 networking — widely used.

### 5. STABLE KERNEL CRITERIA

- **Obviously correct**: Yes — adding `READ_ONCE()` for a concurrently-
  modified sysctl is a textbook fix.
- **Fixes a real bug**: Yes — data races are real bugs, detectable by
  KCSAN, and can cause undefined behavior.
- **Small and contained**: Yes — minimal change, 3 lines modified.
- **No new features**: Correct — pure bug fix annotation.
- **Tested**: Reviewed by Simon Horman, authored by Eric Dumazet
  (networking co-maintainer).

### 6. USER IMPACT

The `flowlabel_reflect` sysctl affects IPv6 flow label behavior for:
- New socket creation
- ICMPv6 echo replies
- TCP reset packets

While the practical impact of the data race is likely limited (a torn
read of an integer sysctl would just result in a brief wrong decision),
the fix is important for:
- KCSAN cleanliness (preventing false positives that mask real bugs)
- Correctness under the kernel memory model
- Preventing potential compiler-induced bugs on architectures with weak
  memory ordering

### 7. DEPENDENCY CHECK

This commit is self-contained. It only adds `READ_ONCE()` wrappers and
has no dependencies on other commits. The code being modified exists in
all recent stable trees.

### 8. RISK vs BENEFIT

- **Risk**: Near zero. `READ_ONCE()` is a safe, well-understood
  annotation.
- **Benefit**: Fixes real data races in the IPv6 networking path,
  prevents potential compiler-induced misbehavior, enables clean KCSAN
  runs.

This is the type of small, surgical, zero-risk fix that is ideal for
stable backporting. Eric Dumazet's data-race annotation series in
networking has been consistently backported to stable trees.

**YES**

 net/ipv6/af_inet6.c | 4 ++--
 net/ipv6/icmp.c     | 3 ++-
 net/ipv6/tcp_ipv6.c | 3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index b705751eb73c6..bd29840659f34 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -224,8 +224,8 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 	inet6_set_bit(MC6_LOOP, sk);
 	inet6_set_bit(MC6_ALL, sk);
 	np->pmtudisc	= IPV6_PMTUDISC_WANT;
-	inet6_assign_bit(REPFLOW, sk, net->ipv6.sysctl.flowlabel_reflect &
-				     FLOWLABEL_REFLECT_ESTABLISHED);
+	inet6_assign_bit(REPFLOW, sk, READ_ONCE(net->ipv6.sysctl.flowlabel_reflect) &
+				      FLOWLABEL_REFLECT_ESTABLISHED);
 	sk->sk_ipv6only	= net->ipv6.sysctl.bindv6only;
 	sk->sk_txrehash = READ_ONCE(net->core.sysctl_txrehash);
 
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 9d37e7711bc2b..1a25ecb926951 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -958,7 +958,8 @@ static enum skb_drop_reason icmpv6_echo_reply(struct sk_buff *skb)
 	tmp_hdr.icmp6_type = type;
 
 	memset(&fl6, 0, sizeof(fl6));
-	if (net->ipv6.sysctl.flowlabel_reflect & FLOWLABEL_REFLECT_ICMPV6_ECHO_REPLIES)
+	if (READ_ONCE(net->ipv6.sysctl.flowlabel_reflect) &
+	    FLOWLABEL_REFLECT_ICMPV6_ECHO_REPLIES)
 		fl6.flowlabel = ip6_flowlabel(ipv6_hdr(skb));
 
 	fl6.flowi6_proto = IPPROTO_ICMPV6;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 280fe59785598..4ae664b05fa91 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1085,7 +1085,8 @@ static void tcp_v6_send_reset(const struct sock *sk, struct sk_buff *skb,
 			txhash = inet_twsk(sk)->tw_txhash;
 		}
 	} else {
-		if (net->ipv6.sysctl.flowlabel_reflect & FLOWLABEL_REFLECT_TCP_RESET)
+		if (READ_ONCE(net->ipv6.sysctl.flowlabel_reflect) &
+		    FLOWLABEL_REFLECT_TCP_RESET)
 			label = ip6_flowlabel(ipv6h);
 	}
 
-- 
2.51.0

