Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162A9303A02;
	Sat, 14 Feb 2026 21:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104398; cv=none; b=YSQ9nNrRwPtgnZh/snhbkoGr+4Q27bBHkGhuVvC+P4vyrGNHMJr3vxSwSHR7vx0eik258XK83dmQdhLx8WgspuiO2e8hoNSy589NDDr1X/cSws650ArH+uBS8gUWLc6HIYXun9gZusMU2uURY58Fgdo/NWHpj524q/HuEnWlhuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104398; c=relaxed/simple;
	bh=E+bPpLh4jKGwkCz53n37PdOSYohgNwZqFsf9WCgqRh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B/m3JIHffykLrQ8OjyDULmbKJ6eTB875um70g1sgCdsuW3MDZMN5Pwwsu0b6y90O0h6mdaCb5b1O5gv6Y0PD7Y1kFkE0m1hbUYX2XoJs1X1sRlSPGG3tyZA0M8KgEmswEKXXYz8MBx8MHfYPBFQ7OpuWh4gT+6ileK+6uMc8j3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FVWdtAl4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FVWdtAl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E94C16AAE;
	Sat, 14 Feb 2026 21:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104397;
	bh=E+bPpLh4jKGwkCz53n37PdOSYohgNwZqFsf9WCgqRh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FVWdtAl4Wgp2gnlRSgxyMOztltOuEPUG7wk/zG9jxwHjTmz8A4ENGOnloUbGKtpkG
	 vX8kp/sOx2L1N0KZRtnFzq2Jy3IZ/h870Su6mMpfuF8i3dCvjMIl2cK3U/0Fv8WXyp
	 3zqUnJRRYwipGJDLgJRYkRHi7XGdw/SS9pGNywcMabHamRF5il2A3w/e4sAv8vcYvr
	 JK/bCBE3rfgnLtDSb3Cuz0GcJp7+/QH6pGV3zlZtdDi13Q7JlU6S1T//d6vrgpzrf+
	 br/chhFCLVE7p9nnhaTVWS/FY7/aVMUkjCzfXIgNQY0PuVmrD3M9m8Pckopki+onBZ
	 vtadnnmwmhZRw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.6] ipv4: igmp: annotate data-races around idev->mr_maxdelay
Date: Sat, 14 Feb 2026 16:23:26 -0500
Message-ID: <20260214212452.782265-61-sashal@kernel.org>
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

[ Upstream commit e4faaf65a75f650ac4366ddff5dabb826029ca5a ]

idev->mr_maxdelay is read and written locklessly,
add READ_ONCE()/WRITE_ONCE() annotations.

While we are at it, make this field an u32.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20260122172247.2429403-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of commit: "ipv4: igmp: annotate data-races around
idev->mr_maxdelay"

### 1. COMMIT MESSAGE ANALYSIS

The commit message is straightforward: it adds READ_ONCE()/WRITE_ONCE()
annotations to `idev->mr_maxdelay` because the field is read and written
locklessly (i.e., without holding a lock that protects both the reader
and writer). Additionally, the field type is changed from `unsigned
long` to `u32`.

**Author**: Eric Dumazet — a highly prolific and respected networking
developer at Google, known for data-race annotation work across the
networking stack.

**Reviewed-by**: David Ahern — another senior networking developer.

### 2. CODE CHANGE ANALYSIS

The changes are minimal and contained:

**In `include/linux/inetdevice.h`:**
- `mr_maxdelay` field type changed from `unsigned long` to `u32`
- Field repositioned in the struct (moved after `mr_gq_running` which is
  `unsigned char`, before `mr_ifc_count` which is `u32`) — this is
  likely for better packing/alignment

**In `net/ipv4/igmp.c`:**
- **Line ~230 (igmp_gq_start_timer)**: `in_dev->mr_maxdelay` →
  `READ_ONCE(in_dev->mr_maxdelay)` — the reader side
- **Line ~1012 (igmp_heard_query)**: `in_dev->mr_maxdelay = max_delay` →
  `WRITE_ONCE(in_dev->mr_maxdelay, max_delay)` — the writer side

### 3. DATA RACE ANALYSIS

Let me examine the concurrency situation:

- **Writer**: `igmp_heard_query()` writes `mr_maxdelay` when processing
  an incoming IGMPv3 query. This runs in softirq/BH context when
  receiving network packets.
- **Reader**: `igmp_gq_start_timer()` reads `mr_maxdelay` to calculate a
  random timer delay. This is called from `igmp_heard_query()` itself,
  but also potentially from other contexts.

The key question: can the read and write happen concurrently? Looking at
the code, `igmp_heard_query()` writes `mr_maxdelay` and then calls
`igmp_gq_start_timer()` which reads it. However, on different CPUs
processing different network packets, one CPU could be writing while
another reads. Without proper annotations, the compiler could optimize
these accesses in ways that cause tearing or stale reads.

This is a real KCSAN-detectable data race. While the consequences may
not be catastrophic (the value is used for a random timer delay), it is
technically undefined behavior in the C memory model, and on
architectures where `unsigned long` is 64-bit but atomicity is only
guaranteed for 32-bit, there could be torn reads producing garbage
values that get passed to `get_random_u32_below()`.

### 4. TYPE CHANGE: unsigned long → u32

The change from `unsigned long` to `u32` is notable:
- `max_delay` in `igmp_heard_query()` is computed as
  `IGMPV3_MRC(ih3->code)*(HZ/IGMP_TIMER_SCALE)` — the MRC field is from
  a network packet and is bounded, so the value fits in u32.
- `get_random_u32_below()` takes a `u32` argument, so this makes the
  types consistent.
- On 64-bit systems, this also ensures atomic read/write since u32
  accesses are atomic on all Linux-supported architectures, which
  complements the READ_ONCE/WRITE_ONCE annotations.

### 5. RISK ASSESSMENT

**Risk**: Very low.
- The READ_ONCE/WRITE_ONCE annotations are purely compiler directives
  that don't change runtime behavior on most architectures
- The type change from `unsigned long` to `u32` is safe because the
  values stored are always small (timer delays in jiffies, derived from
  IGMP protocol fields)
- The struct field reordering doesn't affect functionality
- Only 2 files changed, only 3 lines of actual code logic changed

**Benefit**: Fixes a data race that could theoretically cause:
- Torn reads on 32-bit architectures (if `unsigned long` were involved
  in non-atomic access — though on 32-bit it's 32-bit anyway)
- Compiler-induced issues where the compiler might reload or optimize
  the value in unexpected ways
- Silences KCSAN warnings, which is important for finding real races

### 6. STABLE SUITABILITY

**Meets stable criteria?**
- **Obviously correct**: Yes — this is a textbook data-race annotation
  pattern from a top networking developer, reviewed by another expert
- **Fixes a real bug**: Yes — data races are real bugs (KCSAN reports
  them), even if the consequences are subtle
- **Small and contained**: Yes — minimal changes across 2 files
- **No new features**: Correct — purely a bug fix
- **No new APIs**: Correct

**Concerns:**
- The type change (`unsigned long` → `u32`) and struct field reordering
  are slightly beyond "pure annotation" and could theoretically conflict
  with other patches. However, the type change is necessary for
  correctness (ensuring atomicity on all architectures).
- The struct layout change might cause minor backport conflicts if other
  fields were added/modified in stable trees.

### 7. PRECEDENT

Eric Dumazet has authored hundreds of similar READ_ONCE/WRITE_ONCE
annotation patches in the networking stack, and many of them have been
backported to stable. These are considered important for correctness and
for enabling KCSAN to find real bugs by eliminating false positives.

### 8. CONCLUSION

This is a small, well-reviewed fix for a real data race in the IPv4 IGMP
code path. The IGMP code handles multicast group membership and is used
on any system with multicast networking. The fix is from a trusted
author, reviewed by a trusted reviewer, and follows established
patterns. The type change is safe and actually improves correctness. The
risk of regression is negligible.

**YES**

 include/linux/inetdevice.h | 2 +-
 net/ipv4/igmp.c            | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index 5730ba6b1cfaf..dccbeb25f7014 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -38,11 +38,11 @@ struct in_device {
 	struct ip_mc_list	*mc_tomb;
 	unsigned long		mr_v1_seen;
 	unsigned long		mr_v2_seen;
-	unsigned long		mr_maxdelay;
 	unsigned long		mr_qi;		/* Query Interval */
 	unsigned long		mr_qri;		/* Query Response Interval */
 	unsigned char		mr_qrv;		/* Query Robustness Variable */
 	unsigned char		mr_gq_running;
+	u32			mr_maxdelay;
 	u32			mr_ifc_count;
 	struct timer_list	mr_gq_timer;	/* general query timer */
 	struct timer_list	mr_ifc_timer;	/* interface change timer */
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 7182f1419c2a4..0adc993c211d7 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -227,7 +227,7 @@ static void igmp_start_timer(struct ip_mc_list *im, int max_delay)
 
 static void igmp_gq_start_timer(struct in_device *in_dev)
 {
-	int tv = get_random_u32_below(in_dev->mr_maxdelay);
+	int tv = get_random_u32_below(READ_ONCE(in_dev->mr_maxdelay));
 	unsigned long exp = jiffies + tv + 2;
 
 	if (in_dev->mr_gq_running &&
@@ -1009,7 +1009,7 @@ static bool igmp_heard_query(struct in_device *in_dev, struct sk_buff *skb,
 		max_delay = IGMPV3_MRC(ih3->code)*(HZ/IGMP_TIMER_SCALE);
 		if (!max_delay)
 			max_delay = 1;	/* can't mod w/ 0 */
-		in_dev->mr_maxdelay = max_delay;
+		WRITE_ONCE(in_dev->mr_maxdelay, max_delay);
 
 		/* RFC3376, 4.1.6. QRV and 4.1.7. QQIC, when the most recently
 		 * received value was zero, use the default or statically
-- 
2.51.0

