Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030342;
	b=f5peyds3IktrJwJvDMq0XxI/qjvqP+jcU+mBrExeKP+fc9z5q6JozgPidqco0zQOAQYC
	 fOtaFJbTnqWwH4R40SAzMC9VBgV0BfVpLIjgMTZsKgaKB55WAB9fJ/DFVC2xzzAmR8sKa
	 uNauPuLqtWfTct3G8vPcqLM+lmOoXU8cBHzFeYi49aVf8RYv+AzaLvIdgngc60C3/tbeZ
	 DwXmhN0RX/AnriOFiozBnglbgP66NCRYNIqBrLVUU9GPlgvxr5/dytHQAkMgvbgHZHkxu
	 7nZlb1mX5B3CDjVM+jf4/HR+5ZKEH8WTzL/Meih0q6qE44cIWoZZN7EGQrPSjOTK1kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dhUOpv+QZWvrZtlPsbLFJDYA1R58v/pXR59B4NfmsBk=;
	b=sXJDDJXSZylGbM8fX3Y/bk8TGIBWisEcmO5KS9JyLclY+CR6neCv64mL4lFrKFESKiB9
	 vpCM3n7coh0s7dtSVkFefYW3updvDRh0G8IWzQCvrjNPBts/+jwze13iPAFeJBPLKn4EF
	 RhgWsYi2ybB+zkXxftum+Ik6bWp2ms7MriFPPqxbzwbF13OYXHkl2FJdlATYFuOer6G+G
	 1ubWOlSTnRAuOtuj1vFXNp8lpoE7GgEve8Q3Wlc6GVPAYcUhbIgKpeX6W5oGYOYJ1GfkT
	 LW+zEwdFsfmGt0/lyeskr7ugD4Xwa2D6jzKuSdWXgyrD5Zi8DtXLhE3o2ZjgQDOsRuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQIpoQi9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374F0606A33A;
	Wed, 18 Nov 2026 19:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rQIpoQi9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5761F000C5;
	Wed, 18 Nov 2026 19:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030342;
	bh=dhUOpv+QZWvrZtlPsbLFJDYA1R58v/pXR59B4NfmsBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rQIpoQi9C7X19RAWXMv4aZEYyabtgGcDTlRyOdsKd+9hGZGwmHPEfwH+d09JRYcyd
	 bg48yuek5TdqA0WU6DxY9yxTh4YFI9m8yl2/j1iofCOxjbapQiNRBZKBX2uxh/IkvC
	 5BHov4HZCDeczqy2DDW7JXbQteNnxey2htj8kvd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0670/1756] cgroup/cpuset: Disable cpuset_cpumask_can_shrink() test if not load balancing
Date: Wed, 18 Nov 2026 15:46:37 +0100
Message-ID: <20261118150035.958410652@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

[ Upstream commit fbfbf86685b3270dc27d1c5d6108532334aaf329 ]

With some recent proposed changes [1] in the deadline server code,
it has caused a test failure in test_cpuset_prs.sh when a change
is being made to an isolated partition. This is due to failing
the cpuset_cpumask_can_shrink() check for SCHED_DEADLINE tasks at
validate_change().

This is actually a false positive as the failed test case involves an
isolated partition with load balancing disabled. The deadline check
is not meaningful in this case and the users should know what they
are doing.

Fix this by doing the cpuset_cpumask_can_shrink() check only when loading
balanced is enabled. Also change its arguments to use effective_cpus
for the current cpuset and user_xcpus() as an approiximation for the
target effective_cpus as the real effective_cpus hasn't been fully
computed yet as this early stage.

As the check isn't comprehensive, there may be false positives or
negatives. We may have to revise the code to do a more thorough check
in the future if this becomes a concern.

[1] https://lore.kernel.org/lkml/82be06c1-6d6d-4651-86c9-bcc828cbcb80@redhat.com/T/#t

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 8a1c0f5c8284 ("cgroup/cpuset: Run SCHED_DEADLINE shrink test on valid partition root only")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 5991a9a354aad..02f02ab517fdb 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -616,12 +616,24 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 
 	/*
 	 * We can't shrink if we won't have enough room for SCHED_DEADLINE
-	 * tasks.
+	 * tasks. This check is not done when scheduling is disabled as the
+	 * users should know what they are doing.
+	 *
+	 * For v1, effective_cpus == cpus_allowed & user_xcpus() returns
+	 * cpus_allowed.
+	 *
+	 * For v2, is_cpu_exclusive() & is_sched_load_balance() are true only
+	 * for non-isolated partition root. At this point, the target
+	 * effective_cpus isn't computed yet. user_xcpus() is the best
+	 * approximation.
+	 *
+	 * TBD: May need to precompute the real effective_cpus here in case
+	 * incorrect scheduling of SCHED_DEADLINE tasks in a partition
+	 * becomes an issue.
 	 */
 	ret = -EBUSY;
-	if (is_cpu_exclusive(cur) &&
-	    !cpuset_cpumask_can_shrink(cur->cpus_allowed,
-				       trial->cpus_allowed))
+	if (is_cpu_exclusive(cur) && is_sched_load_balance(cur) &&
+	    !cpuset_cpumask_can_shrink(cur->effective_cpus, user_xcpus(trial)))
 		goto out;
 
 	/*
-- 
2.53.0



