Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030759;
	b=kf36UIVYGpD2P72SU2mEjwBw71I6BllmLm6kfEoNGlTXJgwtyK7l4ckyGjkcO1MbivSh
	 lIIBRyE3mPVVpOq140U5dQ21tEDoqFww7fzB3TDTO66eFBmGKIW25S4L7nAYC5njybPY1
	 Ce8BKSCIh9ChMOA6eZJq+4o/zz6lCbqxofHVwSL/A36lGH5Sqmv6hQG64wRIBHMzSSs9v
	 gvAlvFPe0RLLxIie7iIxYMUNcA0dU1S48LaAQExB0EM/FU4WwBR2Mq0OLSse+dOK+au4u
	 /V8Ev0sSy9+pV9ZT/qgCFf2emOLtAfvsMsj/eX2IRgiPk200rtBPkoGpU7A8VEY62LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030759;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jMRU7oPOxy4ivrGgli6y8LBXW/es5174137UFghcRhQ=;
	b=zDIZ1MgXPFnJ+9CNA0h/q938ByGrD88a1BhfIZTUZJBWf2+L+Gmnkvlz7uHVq3V9LeDI
	 BBKfpGZ2PN+rmjuuOrRDz7xJYc28NHQ8lgUx2hJ7yWWaG1Dy4v7cu7ieqEgnhFncKng4r
	 Qa7S9s8gtZKykPLoY4iMrkkU9XhC7bmZ8CsrcIgyVnjPQxyucY6iiREwx5WAZE/ZPOxvJ
	 VR06GE2SE4zZK4cwFOoRYCdOGKLqUQgEnvN9tUIO5LsVCRLwFtq4BwMdCWQTFcl2QsxYM
	 UXfTTCDldPmzkTC1VybW5PQMEhMF497XWTiSQLa56fU7osVBkBIk0UT+2txy6yFIwcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OdVCjvgR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085FA606A918;
	Wed, 18 Nov 2026 19:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OdVCjvgR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177EE1F000C4;
	Wed, 18 Nov 2026 19:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030758;
	bh=jMRU7oPOxy4ivrGgli6y8LBXW/es5174137UFghcRhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OdVCjvgRBK8zQCQX2iuJWVQdla8PJgZydSSQkmBRJIL9OYqaRO1MP1qywLEc7Xbag
	 8AbD2kUMdfxvHQLYKrXV39Yk2O2HQghEt+M58YGwREnjNEsZpZ1SjWSbW/9wzXNGwt
	 QO/f3Psx+FlXb7BoJdLK29NzP52EaQuz5cuoT4Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0817/1756] perf/cxl: Fix the counter overflow delta fixup
Date: Wed, 18 Nov 2026 15:49:04 +0100
Message-ID: <20261118150042.110596900@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 0326269ed73529cdf821664b6176814cde9ca374 ]

The counter is masked to counter_width, so the subtraction in
__cxl_pmu_read() throws away the bit that records the wrap. A delta of one
whole period reads back as 0, the same as no events at all, and only the
overflow status tells the two apart - which is why __cxl_pmu_read() takes
an overflow argument.

The fixup keys off the delta rather than the operands:

	delta = (new_cnt - prev_cnt) & GENMASK_ULL(counter_width - 1, 0);
	if (overflow && delta < GENMASK_ULL(counter_width - 1, 0))
		delta += (1UL << counter_width);

so it cannot tell which of these it is looking at:

  event_start         polled read          wrap
  ctr = 0 ..........  ctr = P/2 .........  mask -> 0 (+r)
  prev = 0            prev = P/2                 IRQ reads new = r

  prev = 0    (no read yet):  new >= prev, fell short -> add period
  prev = P/2  (polled):       new <  prev, spans wrap -> add nothing

Both rows are the same interrupt and the old guard adds a period in both,
so a mid-period read makes the event over-count. 'perf stat -I' hits that.

Condition the fixup on new_cnt >= prev_cnt, the one case the subtraction
cannot express. Dropping it outright would break the first row. It stays
exact whatever the residual r is, which matters because some events
increment by more than 1 per cycle (CXL r4.0 8.2.7.2.1, Threshold) and can
step past 0 as they wrap.

Use mask + 1 for the period rather than a shift. It is 0 for a 64-bit
counter, and avoids the old 1UL << counter_width - undefined for width 64,
and for >= 32 on 32-bit kernels.

Fixes: 5d7107c72796 ("perf: CXL Performance Monitoring Unit driver")
Reported-by: sashiko-bot@kernel.org
Closes: https://sashiko.dev/#/patchset/20260715191454.459673-1-dave@stgolabs.net?part=1
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/cxl_pmu.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/perf/cxl_pmu.c b/drivers/perf/cxl_pmu.c
index 401c7ba3efbd9..5fc4799d1ec14 100644
--- a/drivers/perf/cxl_pmu.c
+++ b/drivers/perf/cxl_pmu.c
@@ -686,7 +686,7 @@ static void __cxl_pmu_read(struct perf_event *event, bool overflow)
 {
 	struct cxl_pmu_info *info = pmu_to_cxl_pmu_info(event->pmu);
 	struct hw_perf_event *hwc = &event->hw;
-	u64 new_cnt, prev_cnt, delta;
+	u64 new_cnt, prev_cnt, delta, mask;
 
 	do {
 		prev_cnt = local64_read(&hwc->prev_count);
@@ -694,12 +694,16 @@ static void __cxl_pmu_read(struct perf_event *event, bool overflow)
 	} while (local64_cmpxchg(&hwc->prev_count, prev_cnt, new_cnt) != prev_cnt);
 
 	/*
-	 * If we know an overflow occur then take that into account.
-	 * Note counter is not reset as that would lose events
+	 * The mask discards the bit that says the counter wrapped, so a delta of
+	 * one whole period reads back as 0 - the same as no events at all. Only
+	 * the overflow status separates them, and new_cnt >= prev_cnt is that
+	 * case, so add the period back. mask + 1 is 2^counter_width, which comes
+	 * out as 0 for a 64-bit counter and avoids an undefined 1 << 64.
 	 */
-	delta = (new_cnt - prev_cnt) & GENMASK_ULL(info->counter_width - 1, 0);
-	if (overflow && delta < GENMASK_ULL(info->counter_width - 1, 0))
-		delta += (1UL << info->counter_width);
+	mask = GENMASK_ULL(info->counter_width - 1, 0);
+	delta = (new_cnt - prev_cnt) & mask;
+	if (overflow && new_cnt >= prev_cnt)
+		delta += mask + 1;
 
 	local64_add(delta, &event->count);
 }
-- 
2.53.0



