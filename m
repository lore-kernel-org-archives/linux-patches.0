Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622736;
	b=tuynqkJ/FjDDZYRqhpvnlZJp/2pAyTwIGtF7SZpRK5cUlipG3t9mez7T6AyWyezoWPrX
	 72ra9eFVShqCXJFadLZkDIUvLj9hYZUYBAEe4H6CsSZWRDwxIJDIOyzIoZvQuktyo7xmx
	 sLBI0/WPi9RZdECLrQ9KKZu8CxFVIQqR69n7m+S5hon7BhkfmWaGmgGIhC6sIcq4wnS3n
	 e0bMXhn0N+0dScQi5iOt0eGs6Fs8vw/HavBGDRpy1enmjSBAdYY+fiLOVqQif722kVqnU
	 81leN4CneAhZqQJek0VycVZ+Vt8XTXeIYa3Dx05DtWXDHBq+wwpKtw4IVQcOyLgY2QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4bMTr2tMSk+mj7qU6ANOPQkbee9q9Qaf2djaIB3yELM=;
	b=ZBFY4ov7CSV9FEHS/MCvKDMyqxfgO5NZkTqb7eviciY5ENI6cynZWc8p0fRbM0RJOBHc
	 BWPuQVcYwyoCJMw9i2bTUSjS5mG8v3WqLBrkGm/HdLeKP46Th9QM0DlDQ08UUGAo0+VCG
	 C1UaRwz0Uu69r6Lo4W5zuuTjPP6EJLVhaQafw/KVfSKl589ExDQx7C9q36jy5cQ+ChcGj
	 FKSKWo3WrMcfyj+lYNmHrKvxMTbByiqJ6JkD3GayS4z0zqSEm32K+6ZTws+UJi+czb9G4
	 z05KZf61Uga5xIqVV0Qcb9AGJezTuP6f0eDaT6BpfihV/0ec1HRSALrdQYTm8/5heXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nyQ9rOYf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6E9606A31E;
	Wed, 25 Nov 2026 16:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nyQ9rOYf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41091F000C4;
	Wed, 25 Nov 2026 16:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622735;
	bh=4bMTr2tMSk+mj7qU6ANOPQkbee9q9Qaf2djaIB3yELM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nyQ9rOYf0FrQp5ab90wf8NizEdzwy9nJHmk8ozJp4+NqSV2RGzve9ECSr3qRwoZKR
	 g8mgQFlwI9MRDVvFweXSFD9MmWir6ebXfz9M/5JXfSJWe5AejlruAVf0vXfUZcJ6Ob
	 pC9CbRjTfDrE8niFlKjxeG/B5kRsF71dhUCxX7pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 630/990] cgroup/cpuset: Minor fixes to prstate_housekeeping_conflict()
Date: Wed, 25 Nov 2026 15:33:17 +0100
Message-ID: <20261125143836.854680372@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 40702b2ca8fa08fb64b926d8c72a4909d0330580 ]

Commit 9527ff78a413 ("cgroup/cpuset: Consider all the exclusive CPUs when
doing housekeeping check") changes the way prstate_housekeeping_conflict()
is being used by considering all the exclusive xcpus to be owned by the
partition when doing housekeeping check. However there are two minor
issues reported by sashiko with that patch:

 1) In partition_cpus_change(), prstate_housekeeping_conflict() can
 be called with an invalid partition root. In that case, there are
 no isolated CPUs that are going to be returned back to the system to
 become housekeeping CPUs, so the calculation of the del_cpus cpumask
 is meaningless.

 2) The checking of del_cpus in prstate_housekeeping_conflict() to see
 if it can contain an active housekeeping CPU that can be returned to the
 system ignores the fact that an active CPU not in HK_TYPE_DOMAIN_BOOT HK
 cpumask will not become an active housekeeping CPU when it is released
 by an isolated partition.

Update the existing code to handle these two issues properly to make
prstate_housekeeping_conflict() produce more accurate result.

Fixes: 9527ff78a413 ("cgroup/cpuset: Consider all the exclusive CPUs when doing housekeeping check")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ sashal: Replaced upstream's housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT) with have_boot_isolcpus ? boot_hk_cpus : cpu_possible_mask, since that housekeeping type is missing here and boot_hk_cpus is only allocated with boot isolation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 45 +++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7b13381755d07..d2bedfbd533de 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1520,6 +1520,9 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 	    !cpumask_subset(new_cpus, boot_hk_cpus))
 		return true;
 
+	if (del_cpus && cpumask_empty(del_cpus))
+		del_cpus = NULL;
+
 	/*
 	 * Exit 2nd check early and return false if
 	 * 1) there is no boot time isolated nohz_full CPU
@@ -1528,8 +1531,7 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 	 *    be returned back to the parent.
 	 */
 	if (!housekeeping_enabled(HK_TYPE_KERNEL_NOISE) ||
-	    (new_prs == parent_prs) ||
-	    ((new_prs == PRS_ROOT) && (!del_cpus || cpumask_empty(del_cpus))))
+	    (new_prs == parent_prs) || (!del_cpus && (new_prs == PRS_ROOT)))
 		return false;
 
 	/*
@@ -1540,20 +1542,29 @@ static bool prstate_housekeeping_conflict(int new_prs, int parent_prs,
 	if (parent_prs == PRS_ISOLATED)
 		swap(new_cpus, del_cpus);
 
-	if (del_cpus &&
-	   (cpumask_first_and_and(del_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
-				   cpu_active_mask) < nr_cpu_ids))
-		return false;
-
 	if (!alloc_cpumask_var(&full_hk_cpus, GFP_KERNEL))
 		return true;
 
+	/*
+	 * Check if del_cpus may contain a CPU that can become an active
+	 * housekeeping CPU again.
+	 */
+	if (del_cpus) {
+		cpumask_and(full_hk_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
+			    have_boot_isolcpus ? boot_hk_cpus : cpu_possible_mask);
+		if (cpumask_first_and_and(del_cpus, full_hk_cpus,
+					  cpu_active_mask) < nr_cpu_ids) {
+			res = false;
+			goto out;
+		}
+	}
+
 	cpumask_and(full_hk_cpus, housekeeping_cpumask(HK_TYPE_KERNEL_NOISE),
 		    housekeeping_cpumask(HK_TYPE_DOMAIN));
 	cpumask_andnot(full_hk_cpus, full_hk_cpus, isolated_cpus);
 	cpumask_and(full_hk_cpus, full_hk_cpus, cpu_active_mask);
 	res = !cpumask_weight_andnot(full_hk_cpus, new_cpus);
-
+out:
 	free_cpumask_var(full_hk_cpus);
 	return res;
 }
@@ -2628,23 +2639,29 @@ static void partition_cpus_change(struct cpuset *cs, struct cpuset *trialcs,
 				  struct tmpmasks *tmp)
 {
 	enum prs_errcode prs_err;
+	int parent_prs = is_remote_partition(cs)
+		       ? PRS_ROOT : parent_cs(cs)->partition_root_state;
 
 	if (cs_is_member(cs))
 		return;
 
 	prs_err = validate_partition(cs, trialcs);
-	if (!prs_err && !cpumask_empty(trialcs->effective_xcpus)) {
+	if (!prs_err && (parent_prs > 0) &&
+	    !cpumask_empty(trialcs->effective_xcpus)) {
 		int prs = cs->partition_root_state;
-		int parent_prs = is_remote_partition(cs)
-			       ? PRS_ROOT : parent_cs(cs)->partition_root_state;
+
 		/*
 		 * Check for housekeeping conflict by passing the whole
 		 * effective_xcpus as well as those CPUs that are to be
 		 * removed from cs as delmask.
 		 */
-		cpumask_andnot(tmp->delmask, cs->effective_xcpus, trialcs->effective_xcpus);
-		if (parent_prs > 0 &&
-		    prstate_housekeeping_conflict(prs, parent_prs,
+		if (prs > 0)
+			cpumask_andnot(tmp->delmask, cs->effective_xcpus,
+				       trialcs->effective_xcpus);
+		else
+			cpumask_clear(tmp->delmask);
+
+		if (prstate_housekeeping_conflict(prs, parent_prs,
 						  trialcs->effective_xcpus, tmp->delmask))
 			prs_err = PERR_HKEEPING;
 	}
-- 
2.53.0



