Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63167303A02;
	Sat, 14 Feb 2026 21:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104396; cv=none; b=JqRmZ04SCurLaA3N+EF4Ekx9pZ2QwtBqs/H7pM2V+0VrA4VqIN/Vd/SREeRyGt+YIWT3CYtZ+rX0OTfpO+n3ctYfrDmGusomHaXxymn3/XzMuqqZwtjxxURQ93rYGfa4mbjtoJOxcCsDqGWW8LCPa75S8GdWOLqzP6lAAWqHc7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104396; c=relaxed/simple;
	bh=I27tBtEkaPD93DNtj/GNfKg8FNNMdligpTzQU8cwlMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxfcKdB6WY60Iu5xa4foxVLuVZGtMlX+fYGMpa3ZxuJ3LvbZynQ57rmz5NNIhhskc07O1R6n+SXY4qRPjMuhDxQMHMju6LnRlgtiuR1B7E6EUAfBe/j/tdiEKIF7s5fUZ7qh+b9+vQnMABpN63iVtVs0fcjnDso/H15qgCm2K+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GBZtZrBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GBZtZrBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB2DC16AAE;
	Sat, 14 Feb 2026 21:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104396;
	bh=I27tBtEkaPD93DNtj/GNfKg8FNNMdligpTzQU8cwlMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBZtZrBvRGmakA5yBHVLXn4Rz6Osc41+qPSm/C6skI/yjHjYXO6Fhq/yDqTPf64NL
	 519zsR9agnTM5Dpms+W8+F/op6kb4N9mQApCC24FmsvfIHKJbKfxDUbTBWXkShU7U+
	 CDcYj3uv64Puau+nFvvZH4qDSIFsdFuK6ouLG7DXcegHAPoWUA6VfNMo3k4k1rX3m3
	 YRj2vKJ3GgbCcNfbqp+WMC0DDAXPRw5xWOwpNLKjeuc2EoSu+mRLP0Me8jTAveFY8k
	 PlRmTsQpphoAKTMkhjyxhA+KbvZTL2ivuN1yW8fk+SpF0NuZxZ/XwrEAisM4Y3mdud
	 h/+JjWQuzbZCw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	dsahern@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] ipv6: annotate data-races in ip6_multipath_hash_{policy,fields}()
Date: Sat, 14 Feb 2026 16:23:25 -0500
Message-ID: <20260214212452.782265-60-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 03e9d91dd64e2f5ea632df5d59568d91757efc4d ]

Add missing READ_ONCE() when reading sysctl values.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260115094141.3124990-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of ipv6: annotate data-races in
ip6_multipath_hash_{policy,fields}()

### 1. COMMIT MESSAGE ANALYSIS

The commit is authored by Eric Dumazet, a well-known and prolific
networking subsystem maintainer at Google. The subject explicitly says
"annotate data-races," which is a common pattern for KCSAN (Kernel
Concurrency Sanitizer) data race fixes. The commit adds `READ_ONCE()`
annotations when reading sysctl values that can be concurrently modified
by userspace.

Reviewed by Simon Horman (another senior networking maintainer) and
committed by Jakub Kicinski (networking subsystem maintainer). This is a
high-trust chain.

### 2. CODE CHANGE ANALYSIS

The change is extremely minimal - exactly 2 lines changed in a single
header file:

```c
// Before:
return net->ipv6.sysctl.multipath_hash_policy;
return net->ipv6.sysctl.multipath_hash_fields;

// After:
return READ_ONCE(net->ipv6.sysctl.multipath_hash_policy);
return READ_ONCE(net->ipv6.sysctl.multipath_hash_fields);
```

**What's happening:** These two inline functions read sysctl values
(`multipath_hash_policy` and `multipath_hash_fields`) from the network
namespace's sysctl structure. These values can be modified at any time
by userspace through `/proc/sys/net/ipv6/...`. Without `READ_ONCE()`,
the compiler is free to:
- Load the value multiple times (store-tearing)
- Optimize/reorder the read in unexpected ways
- Cause inconsistent behavior if the value changes mid-function

This is a classic data race: a sysctl writer (from userspace) and a
packet processing reader (in softirq/RCU context) access the same memory
without synchronization. `READ_ONCE()` prevents compiler-induced issues
and documents the intentional lock-free access pattern.

### 3. CLASSIFICATION

This is a **data race fix**, falling under category #3 (RACE CONDITIONS)
from the bug patterns. While the practical consequences of this
particular race may be minor (the worst case is likely reading a
partially-updated or stale value for hash policy/fields), the fix is:

- Standard practice in the networking stack (Eric Dumazet has done
  hundreds of these)
- Prevents KCSAN warnings that indicate real concurrent access
- Prevents potential compiler optimizations that could cause subtle bugs
- Part of the kernel's correctness guarantees

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** 2 (extremely minimal)
- **Files touched:** 1 header file
- **Complexity:** Trivial - `READ_ONCE()` is a well-understood macro
- **Risk of regression:** Essentially zero. `READ_ONCE()` is a volatile
  read barrier that cannot change functional behavior. It only
  constrains the compiler.
- **Subsystem:** IPv6 networking (core, affects everyone using IPv6
  multipath routing)

### 5. USER IMPACT

- Affects anyone using IPv6 multipath routing with hash policy or hash
  fields sysctls
- The data race could theoretically cause incorrect hash computation
  leading to suboptimal load balancing, though the practical impact is
  low
- KCSAN reports these as warnings, which clutters logs and may mask
  other real issues

### 6. STABILITY INDICATORS

- Reviewed by Simon Horman
- Author is Eric Dumazet (top networking contributor)
- Committed by Jakub Kicinski (networking maintainer)
- This is a well-established pattern - dozens of identical `READ_ONCE()`
  annotation patches have been backported to stable

### 7. DEPENDENCY CHECK

No dependencies. `READ_ONCE()` has existed in the kernel for many years.
The functions `ip6_multipath_hash_policy()` and
`ip6_multipath_hash_fields()` exist in all recent stable trees. This
patch applies trivially.

### Decision

This is a textbook data race annotation fix: 2-line change, zero
regression risk, fixes a real (if minor) concurrency bug, authored and
reviewed by top networking maintainers. These
`READ_ONCE()`/`WRITE_ONCE()` annotations for sysctl values are routinely
backported to stable trees. The fix is small, surgical, and meets all
stable kernel criteria.

**YES**

 include/net/ipv6.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 74fbf1ad8065a..a0407b9f510ad 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1010,11 +1010,11 @@ static inline int ip6_default_np_autolabel(struct net *net)
 #if IS_ENABLED(CONFIG_IPV6)
 static inline int ip6_multipath_hash_policy(const struct net *net)
 {
-	return net->ipv6.sysctl.multipath_hash_policy;
+	return READ_ONCE(net->ipv6.sysctl.multipath_hash_policy);
 }
 static inline u32 ip6_multipath_hash_fields(const struct net *net)
 {
-	return net->ipv6.sysctl.multipath_hash_fields;
+	return READ_ONCE(net->ipv6.sysctl.multipath_hash_fields);
 }
 #else
 static inline int ip6_multipath_hash_policy(const struct net *net)
-- 
2.51.0

