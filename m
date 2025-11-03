Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F49231D758;
	Mon,  3 Nov 2025 18:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762192976; cv=none; b=SmIwfciGh5gXE7804CaRz9hOyQkAMlLs5jJd+yBvHPxriBvGyPoIoNbKFrouItdmMNktjg/uvAsrJk89D0DMnvVhI22zf3ATBzgxGLQ7wQZarevtFjF/eKIwL+KfsgYO55m6GYQThG6Y5wUXdIIBIZgG8w8Y/I2HjnZC8iejve4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762192976; c=relaxed/simple;
	bh=1ACGgZFpWtwXge4QClLOxJUBjQtEGHahQBEj+n93TOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=snpGIE9ILN+H+xsWohY0heFj3e1uWkM/hqmDaMj5tuLIF6lQgGviZNs8kuTgmKFaw4ggqJyTnYVLdVq8KS4WY+vovYOBPvUSznSpMYk3Wb8N8GkHSxf2J2/ixkJlCtc09lGMz0kE5Vzlz2pIn9l4qYm70kotd2MoqrcVufZH3lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n+BFTnIn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n+BFTnIn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEF7C4CEE7;
	Mon,  3 Nov 2025 18:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762192976;
	bh=1ACGgZFpWtwXge4QClLOxJUBjQtEGHahQBEj+n93TOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+BFTnInuetONOQPbI3A0Kns7/YQosgD/AY/aY9g747U0t+O/pd5fvL9oOWeRMRn/
	 qcMNlEMESl0MfCTts3fRD70hioGC1wbBUjLQiaB02PhCQxftzYWJduXJ0GGdUlfVoz
	 OEKKxUFi4+PylNZD0oqdHPLhGFM5HA5QQFop2DkhVTgjZrSvjw6t6ncmuCvTJmG1RS
	 zP0ife6NUyxE5uw5W20uAlHVD1/4SqYryg95Ns6cTu0pC9rpi6CicFr5dqQyQ56E/h
	 v6XH8hTYC1oeKnnOlBWqNRz624hRaLSuUWKXdHz3UABxE7WSRxJCpjsTh1pRrlBGdH
	 QGOOC1Wy+9bnA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shahar Shitrit <shshitrit@nvidia.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	john.fastabend@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	alexandre.f.demers@gmail.com,
	kuniyu@google.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] net: tls: Change async resync helpers argument
Date: Mon,  3 Nov 2025 13:02:17 -0500
Message-ID: <20251103180246.4097432-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251103180246.4097432-1-sashal@kernel.org>
References: <20251103180246.4097432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shahar Shitrit <shshitrit@nvidia.com>

[ Upstream commit 34892cfec0c2d96787c4be7bda0d5f18d7dacf85 ]

Update tls_offload_rx_resync_async_request_start() and
tls_offload_rx_resync_async_request_end() to get a struct
tls_offload_resync_async parameter directly, rather than
extracting it from struct sock.

This change aligns the function signatures with the upcoming
tls_offload_rx_resync_async_request_cancel() helper, which
will be introduced in a subsequent patch.

Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1761508983-937977-2-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis Result: YES (as part of series)

**Backport Status: YES** - But only as a dependency for the complete bug
fix series.

### Comprehensive Analysis

#### 1. Semantic Code Analysis Performed

**Tools Used:**
- `mcp__semcode__find_function`: Located both modified functions in
  include/net/tls.h:454-463
- `mcp__semcode__find_callers`: Identified impact scope - only 2 call
  sites total
- `mcp__semcode__find_type`: Examined struct tls_offload_resync_async
  structure
- `git log` and `git show`: Traced patch series context and dependencies

**Key Findings:**

1. **Function Signatures Changed:**
   - `tls_offload_rx_resync_async_request_start()` -
     include/net/tls.h:454
   - `tls_offload_rx_resync_async_request_end()` - include/net/tls.h:466
   - Both are static inline helpers with very limited scope

2. **Impact Scope (via mcp__semcode__find_callers):**
   - `tls_offload_rx_resync_async_request_start()` → 1 caller:
     `resync_update_sn()` in
     drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c:482
   - `tls_offload_rx_resync_async_request_end()` → 1 caller:
     `mlx5e_ktls_handle_get_psv_completion()` in
     drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c:423
   - **Total impact: 2 call sites, both in mlx5 kTLS driver**

3. **Structural Analysis:**
   - struct tls_offload_resync_async: Simple structure with atomic64_t
     and counters
   - No complex dependencies or architectural changes

#### 2. Code Change Analysis

**What Changed:**
```c
// OLD API:
tls_offload_rx_resync_async_request_start(struct sock *sk, __be32 seq,
u16 len)
{
    struct tls_context *tls_ctx = tls_get_ctx(sk);
    struct tls_offload_context_rx *rx_ctx = tls_offload_ctx_rx(tls_ctx);
    // Use rx_ctx->resync_async
}

// NEW API:
tls_offload_rx_resync_async_request_start(struct
tls_offload_resync_async *resync_async,
                                          __be32 seq, u16 len)
{
    // Use resync_async directly
}
```

**Behavioral Impact:** NONE - This is pure refactoring. The same
`resync_async` pointer is now passed directly instead of being extracted
from `sk`. The actual operations performed are identical.

#### 3. Patch Series Context Discovery

This commit is **part 1 of a 3-commit series**:

**Commit 1 (34892cfec0c2d - THIS COMMIT):** "net: tls: Change async
resync helpers argument"
- Preparatory refactoring
- Changes function signatures to accept `resync_async` directly
- Link: https://patch.msgid.link/1761508983-937977-**2**-git-send-email-
  tariqt@nvidia.com
- **No functional changes**

**Commit 2 (c15d5c62ab313):** "net: tls: Cancel RX async resync request
on rcd_delta overflow"
- Introduces `tls_offload_rx_resync_async_request_cancel()` helper
- This is the function mentioned in commit 1's message as "upcoming"
- Addresses WARN() triggered when rcd_delta exceeds threshold
- Link: https://patch.msgid.link/1761508983-937977-**3**-git-send-email-
  tariqt@nvidia.com

**Commit 3 (426e9da3b2840):** "net/mlx5e: kTLS, Cancel RX async resync
request in error flows"
- **Contains "Fixes: 0419d8c9d8f8" tag** - indicates this fixes a real
  bug
- Uses the new cancel function to fix error handling
- Prevents WARN() when device fails to respond or delays response
- Link: https://patch.msgid.link/1761508983-937977-**4**-git-send-email-
  tariqt@nvidia.com

#### 4. Bug Description from Series

**The Bug Being Fixed:**
When a TLS device loses track of records and requests async resync, but
then fails to respond (due to packet drops, hardware errors, resource
exhaustion, etc.), the software keeps incrementing `rcd_delta` without
bounds, eventually triggering a WARN().

**Impact:** Affects mlx5 hardware TLS offload users who experience
network issues or hardware problems.

#### 5. Evidence of Existing Backport

Found commit `1a0dc2d7707a1` which shows:
```
[ Upstream commit 34892cfec0c2d96787c4be7bda0d5f18d7dacf85 ]
...
Signed-off-by: Sasha Levin <sashal@kernel.org>
```

This proves the stable tree maintainers have **already decided to
backport this commit**.

#### 6. Stable Tree Compliance Assessment

**Against stable rules (if standalone):**
- ❌ Not a bug fix itself
- ❌ No "Cc: stable@vger.kernel.org" tag
- ❌ No "Fixes:" tag
- ❌ Preparatory refactoring for future work
- ❌ Changes API signatures

**For stable rules (as part of series):**
- ✅ Required dependency for bug fix (commit 3)
- ✅ Small, contained change (2 call sites)
- ✅ No behavioral changes (pure refactoring)
- ✅ Enables proper fix for WARN() trigger
- ✅ The bug affects real users with mlx5 hardware

#### 7. Recommendation Rationale

**YES - This commit should be backported, BUT:**

1. **Only as part of the complete 3-commit series** - Backporting this
   alone is pointless since it's purely preparatory.

2. **The actual bug fix (commit 3) justifies the series** - It has a
   Fixes: tag and addresses a real issue where hardware TLS offload can
   trigger kernel WARN()s.

3. **Low risk profile:**
   - Very limited scope (2 call sites in one driver)
   - No behavioral changes
   - Required for the bug fix to apply cleanly

4. **Already accepted by stable maintainers** - The presence of the
   backported version signed by Sasha Levin confirms this is appropriate
   for stable trees.

**Conclusion:** This commit meets the criteria for backporting **as a
dependency** for a legitimate bug fix, not as a standalone change. The
stable kernel rules allow preparatory commits when they're necessary for
applying important bug fixes, which is exactly this case.

 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |  9 ++++++--
 include/net/tls.h                             | 21 +++++++------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 65ccb33edafb7..c0089c704c0cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -425,12 +425,14 @@ void mlx5e_ktls_handle_get_psv_completion(struct mlx5e_icosq_wqe_info *wi,
 {
 	struct mlx5e_ktls_rx_resync_buf *buf = wi->tls_get_params.buf;
 	struct mlx5e_ktls_offload_context_rx *priv_rx;
+	struct tls_offload_context_rx *rx_ctx;
 	u8 tracker_state, auth_state, *ctx;
 	struct device *dev;
 	u32 hw_seq;
 
 	priv_rx = buf->priv_rx;
 	dev = mlx5_core_dma_dev(sq->channel->mdev);
+	rx_ctx = tls_offload_ctx_rx(tls_get_ctx(priv_rx->sk));
 	if (unlikely(test_bit(MLX5E_PRIV_RX_FLAG_DELETING, priv_rx->flags)))
 		goto out;
 
@@ -447,7 +449,8 @@ void mlx5e_ktls_handle_get_psv_completion(struct mlx5e_icosq_wqe_info *wi,
 	}
 
 	hw_seq = MLX5_GET(tls_progress_params, ctx, hw_resync_tcp_sn);
-	tls_offload_rx_resync_async_request_end(priv_rx->sk, cpu_to_be32(hw_seq));
+	tls_offload_rx_resync_async_request_end(rx_ctx->resync_async,
+						cpu_to_be32(hw_seq));
 	priv_rx->rq_stats->tls_resync_req_end++;
 out:
 	mlx5e_ktls_priv_rx_put(priv_rx);
@@ -482,6 +485,7 @@ static bool resync_queue_get_psv(struct sock *sk)
 static void resync_update_sn(struct mlx5e_rq *rq, struct sk_buff *skb)
 {
 	struct ethhdr *eth = (struct ethhdr *)(skb->data);
+	struct tls_offload_resync_async *resync_async;
 	struct net_device *netdev = rq->netdev;
 	struct net *net = dev_net(netdev);
 	struct sock *sk = NULL;
@@ -528,7 +532,8 @@ static void resync_update_sn(struct mlx5e_rq *rq, struct sk_buff *skb)
 
 	seq = th->seq;
 	datalen = skb->len - depth;
-	tls_offload_rx_resync_async_request_start(sk, seq, datalen);
+	resync_async = tls_offload_ctx_rx(tls_get_ctx(sk))->resync_async;
+	tls_offload_rx_resync_async_request_start(resync_async, seq, datalen);
 	rq->stats->tls_resync_req_start++;
 
 unref:
diff --git a/include/net/tls.h b/include/net/tls.h
index 857340338b694..b90f3b675c3c4 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -451,25 +451,20 @@ static inline void tls_offload_rx_resync_request(struct sock *sk, __be32 seq)
 
 /* Log all TLS record header TCP sequences in [seq, seq+len] */
 static inline void
-tls_offload_rx_resync_async_request_start(struct sock *sk, __be32 seq, u16 len)
+tls_offload_rx_resync_async_request_start(struct tls_offload_resync_async *resync_async,
+					  __be32 seq, u16 len)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct tls_offload_context_rx *rx_ctx = tls_offload_ctx_rx(tls_ctx);
-
-	atomic64_set(&rx_ctx->resync_async->req, ((u64)ntohl(seq) << 32) |
+	atomic64_set(&resync_async->req, ((u64)ntohl(seq) << 32) |
 		     ((u64)len << 16) | RESYNC_REQ | RESYNC_REQ_ASYNC);
-	rx_ctx->resync_async->loglen = 0;
-	rx_ctx->resync_async->rcd_delta = 0;
+	resync_async->loglen = 0;
+	resync_async->rcd_delta = 0;
 }
 
 static inline void
-tls_offload_rx_resync_async_request_end(struct sock *sk, __be32 seq)
+tls_offload_rx_resync_async_request_end(struct tls_offload_resync_async *resync_async,
+					__be32 seq)
 {
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct tls_offload_context_rx *rx_ctx = tls_offload_ctx_rx(tls_ctx);
-
-	atomic64_set(&rx_ctx->resync_async->req,
-		     ((u64)ntohl(seq) << 32) | RESYNC_REQ);
+	atomic64_set(&resync_async->req, ((u64)ntohl(seq) << 32) | RESYNC_REQ);
 }
 
 static inline void
-- 
2.51.0

