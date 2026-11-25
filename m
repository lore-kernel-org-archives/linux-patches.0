Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619317;
	b=lWLsJ6n4k2yrtKB7AHKxxs8N2r8hF/SAO+FertSUyxv8pxNuuPPfHjUCn7lwrtosJfxU
	 4qzsHeuHuyTSHqMmR0EN6tkivR82HEeQsK9TS3ybxFN8SWV4z3swrmoK40+ob/zoVQCzs
	 WLBBl9wf1ysSJEzKBrIZLf7WaUq+wxNy1ARI/6K/ShtYilWGKL1zSkOLPBonDOnwSbcg1
	 ijrjVLos6KC2tR+fMglEaG8YPiQd9niMDx9wg1ohMjkUTIKJom5MWlFmrRw+3psNVAI33
	 rzelCUVUsAvE7ATdI/DQtjrClqk0Bsbpq9o6EsEFwH6P5eT7s4VN3huxRrPNmQcDoEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LwML82/iQd5s2S511HiaH3AvN58XEbbJ1BEFI7tnpJ8=;
	b=z1klscenKKYgAlYkyhiUa2E3ikMoWNU2Wv40HBXBs36BOhN7TjpAuUyTW8hLYNtAL1iE
	 i0kYI+tTsGMO1/CzefAlIQBoW9gJZ77xOOway3AhDJIGypC7gCzRfIxpHPrR0VJKlpWro
	 2js7Cf+9HuTDDY63HmzZvnkIqqeGugOw2MV6KOkFl22S0NekzvbQhnJLqJbzWhrMv0zDx
	 PXkkUAymFCpmOEp8qOGYiSD6xMDBlaAhpnUIzYV3BFQufKwjmZSGsUMUGLLZ53x4P82Iz
	 SwC+Tjt70fBgr9ydNY1WObyzw+wTKenYXuu5qSEreLAgEGFEMeg5YKX8P7brlI+9+9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KRbdhVaY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93417606A329;
	Wed, 25 Nov 2026 15:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KRbdhVaY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B451F000C0;
	Wed, 25 Nov 2026 15:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619316;
	bh=LwML82/iQd5s2S511HiaH3AvN58XEbbJ1BEFI7tnpJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KRbdhVaYO89KeG8qo3XwSdqBK5tbjEk/lH5AAwCF/WX3RUFOiZDU1RusuILDQaiNl
	 UNgOFcFcfavrx8kq84so72roISHebQLXhYVE3CaQjIVBZqSM+PJ+KJ835jiK7g1a11
	 0lVCltAkRCL9Nr+rxbkrntsvh20JKZKagRRq+H40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ridong Chen <chenridong@xiaomi.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0559/1005] cpuset: generalize the validate_partition() interface
Date: Wed, 25 Nov 2026 15:31:37 +0100
Message-ID: <20261125143834.844593062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ridong Chen <chenridong@xiaomi.com>

[ Upstream commit e234ed1bb82c96a5643fd70784f16cf3d72eeed3 ]

Refactor validate_partition() to take the parent partition, the new
partition root state, the new effective exclusive CPUs and the CPUs to
be deleted, instead of a trial cpuset. A NULL parent stands for a
remote partition, whose CPUs come from top_cpuset. This makes the
interface flexible enough to handle both local and remote partition
validation.

This also fixes a false PERR_NOCPUS error when expanding a remote
partition. The no CPU left for tasks check in partition_cpus_change()
is done against the cgroup parent, but the CPUs of a remote partition
come from top_cpuset, not from its parent. For example, on a 4-CPU
system:

  echo 2-3 > P/cpuset.cpus
  echo 2-3 > P/cpuset.cpus.exclusive
  echo 2-3 > P/C/cpuset.cpus
  echo 2 > P/C/cpuset.cpus.exclusive
  echo root > P/C/cpuset.cpus.partition
  (a task in P)
  echo 2-3 > P/C/cpuset.cpus.exclusive
  cat P/C/cpuset.cpus.partition
  root invalid (Parent is not a partition root)

The effective_cpus of P is 3, a subset of the new exclusive CPUs 2-3 of
C, and P has a task, so the expansion is rejected. However, P is not a
partition root and does not give any CPU to C, and top_cpuset still has
CPUs 0-1 for the task. Enabling C directly with exclusive CPUs 2-3
succeeds, as remote_partition_enable() checks top_cpuset instead.

The no CPU left for tasks check now uses the given parent instead of
parent_cs(cs), and top_cpuset for a remote partition, as that is where
its CPUs are taken from.

The housekeeping conflict check is folded into validate_partition(). It
is skipped when the parent is not a valid partition root, as @cs can't
be a valid local partition in that case.

Use the new interface for local partition enablement in
update_parent_effective_cpumask() and in partition_cpus_change(),
replacing the open-coded checks there. The order of the checks is now
the same for both paths: empty CPUs, housekeeping conflict, then no CPU
left for tasks.

Add a test case to test_cpuset_prs.sh for the remote partition
expansion above.

Fixes: 181c8e091aae ("cgroup/cpuset: Introduce remote partition")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c                        | 119 +++++++++---------
 .../selftests/cgroup/test_cpuset_prs.sh       |   5 +
 2 files changed, 64 insertions(+), 60 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 67d79749a1444..2be2e39da7952 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1511,6 +1511,48 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 	return res;
 }
 
+/**
+ * validate_partition - Validate a cpuset partition configuration
+ * @cs: The cpuset to validate
+ * @parent: Parent partition of @cs, NULL for remote partition
+ * @new_prs: The proposed new partition root state
+ * @new_excpus: The new effective exclusive CPUs mask to validate
+ * @del: exclusive CPUs to be deleted from @cs, can be NULL
+ *
+ * A remote partition gets its CPUs from top_cpuset, so top_cpuset is used
+ * as the parent when @parent is NULL.
+ *
+ * The housekeeping check is skipped if @parent is not a valid partition
+ * root as @cs can't be a valid local partition in that case.
+ *
+ * Return: PRS error code (0 if valid, non-zero error code if invalid)
+ */
+static enum prs_errcode validate_partition(struct cpuset *cs,
+					   struct cpuset *parent, int new_prs,
+					   struct cpumask *new_excpus,
+					   struct cpumask *del)
+{
+	int parent_prs;
+
+	if (new_prs == PRS_MEMBER)
+		return PERR_NONE;
+
+	if (cpumask_empty(new_excpus))
+		return PERR_INVCPUS;
+
+	if (!parent)
+		parent = &top_cpuset;
+	parent_prs = parent->partition_root_state;
+	if (parent_prs > 0 &&
+	    prstate_housekeeping_conflict(new_prs, parent_prs, new_excpus, del))
+		return PERR_HKEEPING;
+
+	if (tasks_nocpu_error(parent, cs, new_excpus))
+		return PERR_NOCPUS;
+
+	return PERR_NONE;
+}
+
 /*
  * cpuset_update_sd_hk_unlock - Rebuild sched domains, update HK & unlock
  *
@@ -1921,18 +1963,10 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 	if ((cmd == partcmd_enable) || (cmd == partcmd_enablei)) {
 		new_prs = (cmd == partcmd_enable) ? PRS_ROOT : PRS_ISOLATED;
 
-		/*
-		 * Enabling partition root is not allowed if its
-		 * effective_xcpus is empty.
-		 */
-		if (cpumask_empty(tmp->delmask))
-			return PERR_INVCPUS;
-
-		if (prstate_housekeeping_conflict(new_prs, parent_prs, tmp->delmask, NULL))
-			return PERR_HKEEPING;
-
-		if (nocpu)
-			return PERR_NOCPUS;
+		part_error = validate_partition(cs, parent, new_prs,
+						tmp->delmask, NULL);
+		if (part_error)
+			return part_error;
 
 		/*
 		 * This function will only be called when all the preliminary
@@ -2510,32 +2544,6 @@ static int parse_cpuset_cpulist(const char *buf, struct cpumask *out_mask)
 	return 0;
 }
 
-/**
- * validate_partition - Validate a cpuset partition configuration
- * @cs: The cpuset to validate
- * @trialcs: The trial cpuset containing proposed configuration changes
- *
- * If any validation check fails, the appropriate error code is set in the
- * cpuset's prs_err field.
- *
- * Return: PRS error code (0 if valid, non-zero error code if invalid)
- */
-static enum prs_errcode validate_partition(struct cpuset *cs, struct cpuset *trialcs)
-{
-	struct cpuset *parent = parent_cs(cs);
-
-	if (cs_is_member(trialcs))
-		return PERR_NONE;
-
-	if (cpumask_empty(trialcs->effective_xcpus))
-		return PERR_INVCPUS;
-
-	if (tasks_nocpu_error(parent, cs, trialcs->effective_xcpus))
-		return PERR_NOCPUS;
-
-	return PERR_NONE;
-}
-
 /**
  * partition_cpus_change - Handle partition state changes due to CPU mask updates
  * @cs: The target cpuset being modified
@@ -2549,33 +2557,24 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 				  struct tmpmasks *tmp)
 {
 	enum prs_errcode prs_err;
-	int parent_prs = is_remote_partition(cs)
-		       ? PRS_ROOT : parent_cs(cs)->partition_root_state;
+	struct cpuset *parent = is_remote_partition(cs) ? NULL : parent_cs(cs);
 
 	if (cs_is_member(cs))
 		return;
 
-	prs_err = validate_partition(cs, trialcs);
-	if (!prs_err && (parent_prs > 0) &&
-	    !cpumask_empty(trialcs->effective_xcpus)) {
-		int prs = cs->partition_root_state;
-
-		/*
-		 * Check for housekeeping conflict by passing the whole
-		 * effective_xcpus as well as those CPUs that are to be
-		 * removed from cs as delmask.
-		 */
-		if (prs > 0)
-			cpumask_andnot(tmp->delmask, cs->effective_xcpus,
-				       trialcs->effective_xcpus);
-		else
-			cpumask_clear(tmp->delmask);
-
-		if (prstate_housekeeping_conflict(prs, parent_prs,
-						  trialcs->effective_xcpus, tmp->delmask))
-			prs_err = PERR_HKEEPING;
-	}
+	/*
+	 * Check for housekeeping conflict by passing the whole
+	 * effective_xcpus as well as those CPUs that are to be
+	 * removed from cs as delmask.
+	 */
+	if (is_partition_valid(cs))
+		cpumask_andnot(tmp->delmask, cs->effective_xcpus,
+			       trialcs->effective_xcpus);
+	else
+		cpumask_clear(tmp->delmask);
 
+	prs_err = validate_partition(cs, parent, trialcs->partition_root_state,
+				     trialcs->effective_xcpus, tmp->delmask);
 	if (prs_err) {
 		WRITE_ONCE(cs->prs_err, prs_err);
 		trialcs->prs_err = prs_err;
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 7d5ca28e46c21..d7260a4c6a610 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -556,6 +556,11 @@ REMOTE_TEST_MATRIX=(
 	"  C1-4:P1 C5-6   C1-2     .       C5      .  \
 	      .      P1    P1      .      O5=0     .     p1:3-4|p2:6|c11:1-2|c12:3-4|c21:6|c22:6 \
 							 p1:P1|p2:P1|c11:P1"
+	# Expanding a remote partition should check top cpuset, not its member
+	# parent, for the no CPU left for tasks error.
+	"  CX2-3:T  .   C2-3:X2:P1  .       .       .  \
+	      .      .     X2-3    .       .       .     p1:1,4-7|c11:2-3 \
+							 p1:P0|c11:P1"
 )
 
 #
-- 
2.53.0



