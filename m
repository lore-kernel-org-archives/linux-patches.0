Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FCB34573C;
	Tue, 16 Dec 2025 11:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885028; cv=none; b=YpX2HCe14Qo5lf3XDA5AdHfFXTLdjagQZ3nRRbv9JTTUZUZkb9NvbnWbS/fCrkjCprumtu/tMowQzAdSPYLnr6IaYLEHwvg/ZRXO0zi4tKY2DmUW0zzjBIukWVExlv5LtTjZRRMe58vu/1MsOku8FfVbnyjnba6eyE7L/B8w2PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885028; c=relaxed/simple;
	bh=MpkrbpOk8adbZYe9jng0EuBZ4BE3q4LlhHb11eZQUM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPANugWLRaVfOa8CbfKF/O2DxntdfQ+dKwoGRAEABX/MlNnxxbsSYGdHo2kwLVhTKy4cN/YQdQTgDA6wIWCbo126h0iPTm0NOW5ucHqpda65Fu3a/+mZCQaAiq9tzQV3GO7fhHqPUzS6jrqGvOln7qcIapKXVAGzNxsUIkZTK2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svQy4KYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svQy4KYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9378CC4CEF1;
	Tue, 16 Dec 2025 11:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885028;
	bh=MpkrbpOk8adbZYe9jng0EuBZ4BE3q4LlhHb11eZQUM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=svQy4KYMtbJRgjptgxEMDhAFB055V2C32xko2ghooIaIQ/ygyggGKEi1ZAfSur8TE
	 E54NAOkbKboH1TVEhpQv5RVJ9z3DUiv5LlIYGaVHmTp3/98Z7Kr37H+IQWXFYFTmyC
	 8IHc2U3bbrbzZmA5/zgAQy6Bs6Uh2DzVYLWYFQrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 017/507] bpf: Cleanup unused func args in rqspinlock implementation
Date: Tue, 16 Dec 2025 12:07:38 +0100
Message-ID: <20251216111346.161152162@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>

[ Upstream commit 56b4d162392dda2365fbc1f482184a24b489d07d ]

cleanup unused function args in check_deadlock* functions.

Fixes: 31158ad02ddb ("rqspinlock: Add deadlock detection and recovery")
Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Reviewed-by: Eduard Zingerman <eddyz87@gmail.com>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20251001172702.122838-1-sidchintamaneni@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/rqspinlock.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/rqspinlock.c b/kernel/bpf/rqspinlock.c
index a00561b1d3e51..21be48108e962 100644
--- a/kernel/bpf/rqspinlock.c
+++ b/kernel/bpf/rqspinlock.c
@@ -89,15 +89,14 @@ struct rqspinlock_timeout {
 DEFINE_PER_CPU_ALIGNED(struct rqspinlock_held, rqspinlock_held_locks);
 EXPORT_SYMBOL_GPL(rqspinlock_held_locks);
 
-static bool is_lock_released(rqspinlock_t *lock, u32 mask, struct rqspinlock_timeout *ts)
+static bool is_lock_released(rqspinlock_t *lock, u32 mask)
 {
 	if (!(atomic_read_acquire(&lock->val) & (mask)))
 		return true;
 	return false;
 }
 
-static noinline int check_deadlock_AA(rqspinlock_t *lock, u32 mask,
-				      struct rqspinlock_timeout *ts)
+static noinline int check_deadlock_AA(rqspinlock_t *lock)
 {
 	struct rqspinlock_held *rqh = this_cpu_ptr(&rqspinlock_held_locks);
 	int cnt = min(RES_NR_HELD, rqh->cnt);
@@ -118,8 +117,7 @@ static noinline int check_deadlock_AA(rqspinlock_t *lock, u32 mask,
  * more locks, which reduce to ABBA). This is not exhaustive, and we rely on
  * timeouts as the final line of defense.
  */
-static noinline int check_deadlock_ABBA(rqspinlock_t *lock, u32 mask,
-					struct rqspinlock_timeout *ts)
+static noinline int check_deadlock_ABBA(rqspinlock_t *lock, u32 mask)
 {
 	struct rqspinlock_held *rqh = this_cpu_ptr(&rqspinlock_held_locks);
 	int rqh_cnt = min(RES_NR_HELD, rqh->cnt);
@@ -142,7 +140,7 @@ static noinline int check_deadlock_ABBA(rqspinlock_t *lock, u32 mask,
 		 * Let's ensure to break out of this loop if the lock is available for
 		 * us to potentially acquire.
 		 */
-		if (is_lock_released(lock, mask, ts))
+		if (is_lock_released(lock, mask))
 			return 0;
 
 		/*
@@ -198,15 +196,14 @@ static noinline int check_deadlock_ABBA(rqspinlock_t *lock, u32 mask,
 	return 0;
 }
 
-static noinline int check_deadlock(rqspinlock_t *lock, u32 mask,
-				   struct rqspinlock_timeout *ts)
+static noinline int check_deadlock(rqspinlock_t *lock, u32 mask)
 {
 	int ret;
 
-	ret = check_deadlock_AA(lock, mask, ts);
+	ret = check_deadlock_AA(lock);
 	if (ret)
 		return ret;
-	ret = check_deadlock_ABBA(lock, mask, ts);
+	ret = check_deadlock_ABBA(lock, mask);
 	if (ret)
 		return ret;
 
@@ -234,7 +231,7 @@ static noinline int check_timeout(rqspinlock_t *lock, u32 mask,
 	 */
 	if (prev + NSEC_PER_MSEC < time) {
 		ts->cur = time;
-		return check_deadlock(lock, mask, ts);
+		return check_deadlock(lock, mask);
 	}
 
 	return 0;
-- 
2.51.0



