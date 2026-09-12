Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D326377EC5;
	Sat, 12 Sep 2026 13:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218357; cv=none; b=fz8DDu7T+pSE/pWfDv2J2UkWOAb7ADR+YosPOZ1/puATY0eDvqCvvdiqZZsnNzi9E0zXrKUKD0ooMrQnDgvAQXLmIHr70Ywl/ZYH8ecqf3Lo0kboZG5zSkhGSMf6oQru51SnU8kTzM/efxU1TNcQR6dsDIhYe9wuLTAzV/Zgfo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218357; c=relaxed/simple;
	bh=oKzXnfulxH56DhjXzUHi/E2fhwo3G1zJABrmNAjeQF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SV3KszSVGMSIP9aCulPBWINxbzvouot9e8eQNasWAQOFvGFKVlmZCC2OqjP2Rx4HaJM1HUxzwXDHbgQbvFGqOxmhpnufiSZV7MYFbTrplCAdWz68vrN2Rv8VqMaBjZAkjitLYWO1rtTJnD135wRmwKB3m9aHTChqCsKfQ9lQ8SI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xOSHEqr+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xOSHEqr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB761F000FF;
	Sat, 12 Sep 2026 13:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218356;
	bh=JLRuYI/26IF8XaV3teV7tjTZXh3Qh9pf7JRZvqeCmdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xOSHEqr+xANLI9n/PljaynyVFlMRqNOKVfe6en4rZDqQbwdRQpYfQuMLIk3wlYLDT
	 FF7F3Eqi0mRefxXqJGf71/P92lngkgrVhunKu+jqnEM6zPkJPu1cUjE5Ls+GvUnjyO
	 RrB+Q1wCVyIkQsPz5i6OY3vVjWn8fTrtOA9DU6DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Everest K.C." <everestkc@everestkc.com.np>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1111/1376] cgroup/cpuset: Fix spelling errors in file kernel/cgroup/cpuset.c
Date: Sat, 12 Sep 2026 08:58:57 +0200
Message-ID: <20260912065632.323195526@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: everestkc <everestkc@everestkc.com.np>

[ Upstream commit 95a616d89ccd2d2af0bd26c13c50143b301d82e8 ]

Corrected the spelling errors repoted by codespell as follows:
	temparary ==> temporary
        Proprogate ==> Propagate
        constrainted ==> constrained

Signed-off-by: Everest K.C. <everestkc@everestkc.com.np>
Acked-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: ddabc5dbd262 ("selftests/cgroup: Preserve CPU hotplug write errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 425d1cbe73793..a5909bba7542a 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1386,7 +1386,7 @@ static inline bool is_local_partition(struct cpuset *cs)
  * remote_partition_enable - Enable current cpuset as a remote partition root
  * @cs: the cpuset to update
  * @new_prs: new partition_root_state
- * @tmp: temparary masks
+ * @tmp: temporary masks
  * Return: 0 if successful, errcode if error
  *
  * Enable the current cpuset to become a remote partition root taking CPUs
@@ -1425,7 +1425,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 	cs->prs_err = 0;
 
 	/*
-	 * Proprogate changes in top_cpuset's effective_cpus down the hierarchy.
+	 * Propagate changes in top_cpuset's effective_cpus down the hierarchy.
 	 */
 	cpuset_update_tasks_cpumask(&top_cpuset, tmp->new_cpus);
 	update_sibling_cpumasks(&top_cpuset, NULL, tmp);
@@ -1435,7 +1435,7 @@ static int remote_partition_enable(struct cpuset *cs, int new_prs,
 /*
  * remote_partition_disable - Remove current cpuset from remote partition list
  * @cs: the cpuset to update
- * @tmp: temparary masks
+ * @tmp: temporary masks
  *
  * The effective_cpus is also updated.
  *
@@ -1463,7 +1463,7 @@ static void remote_partition_disable(struct cpuset *cs, struct tmpmasks *tmp)
 	update_unbound_workqueue_cpumask(isolcpus_updated);
 
 	/*
-	 * Proprogate changes in top_cpuset's effective_cpus down the hierarchy.
+	 * Propagate changes in top_cpuset's effective_cpus down the hierarchy.
 	 */
 	cpuset_update_tasks_cpumask(&top_cpuset, tmp->new_cpus);
 	update_sibling_cpumasks(&top_cpuset, NULL, tmp);
@@ -1473,7 +1473,7 @@ static void remote_partition_disable(struct cpuset *cs, struct tmpmasks *tmp)
  * remote_cpus_update - cpus_exclusive change of remote partition
  * @cs: the cpuset to be updated
  * @newmask: the new effective_xcpus mask
- * @tmp: temparary masks
+ * @tmp: temporary masks
  *
  * top_cpuset and subpartitions_cpus will be updated or partition can be
  * invalidated.
@@ -1522,7 +1522,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *newmask,
 	update_unbound_workqueue_cpumask(isolcpus_updated);
 
 	/*
-	 * Proprogate changes in top_cpuset's effective_cpus down the hierarchy.
+	 * Propagate changes in top_cpuset's effective_cpus down the hierarchy.
 	 */
 	cpuset_update_tasks_cpumask(&top_cpuset, tmp->new_cpus);
 	update_sibling_cpumasks(&top_cpuset, NULL, tmp);
@@ -1537,7 +1537,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *newmask,
  * @cs: the cpuset to be updated
  * @newmask: the new effective_xcpus mask
  * @delmask: temporary mask for deletion (not in tmp)
- * @tmp: temparary masks
+ * @tmp: temporary masks
  *
  * This should be called before the given cs has updated its cpus_allowed
  * and/or effective_xcpus.
@@ -2248,7 +2248,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 			return -EINVAL;
 
 		/*
-		 * When exclusive_cpus isn't explicitly set, it is constrainted
+		 * When exclusive_cpus isn't explicitly set, it is constrained
 		 * by cpus_allowed and parent's effective_xcpus. Otherwise,
 		 * trialcs->effective_xcpus is used as a temporary cpumask
 		 * for checking validity of the partition root.
-- 
2.53.0



