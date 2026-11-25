Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618871;
	b=W64FJrNObCX6HpViDotSGSg0OqnkIu6C4TSYMdHRMIYWQ0lq/AlmD0pLEp3CrCUoIPmi
	 GN32f+2DP34DeGkmrgY48cV/R2ahzqArugkWE5IW791IETPp5KJPYeJfj+4Sij+EHcIym
	 CKnAKaiI8cgJkq+tw9W64/8MBcMgYDytBnBwQ4cL/XRkC2pfmn7+9lqFX6GrQi0XZejoj
	 N9HHuprYWpG9Jq3D+aZGJR4CLvR5Druuv23MJipFXOSymE6dKdR5/UzWyLWpGa0JYv2UA
	 ysy5xMys1Rzm0BeEvpCwwF8Dp1R+d5feMYFvPSIAITEZLp4Ez/Ss3TFq3C1fkRf3TSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qOZV2QQ+htZyp/VY12UySDNen0PWT2Nc5BZfVtswGeA=;
	b=Ob78uU77EE2sSXSCDrU0bNVG5UgKNBtpbn9UahcmAGIyEUegaOYkCD1GtyUremtEBOzo
	 J/25XhwLOBic1Osl/yRfry+e2lgyr2n3UZhLj7bklxhvwnzLQfNa8NnnY7UOGRuVvtqxH
	 lN7FxSbvGUCrYGot5VGlXx8upjVEiooUd8LU8I8zT4jYD4NckJdZ/rhlD/PkQGF75Rqrv
	 +rVRhYBYmIFJRN402x4W9VycLjwQyjz4uIJXGK3yTfZwih1u4TPUNRp/Ccad1/HAqSUn/
	 GXmAFddxS5a+5hOEgadgC/0eAmL78I/W93Ymt3cL1IG6tCbPjG3yiDU1PSwY1rMdgqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BsiaqKPo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0E1606A321;
	Wed, 25 Nov 2026 15:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BsiaqKPo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8FE41F000C0;
	Wed, 25 Nov 2026 15:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618871;
	bh=qOZV2QQ+htZyp/VY12UySDNen0PWT2Nc5BZfVtswGeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BsiaqKPoOfgnYQlKXd1xeV9HULVJ1jxw4sJxRERE7t9Ft+Ybv+o8XeDxlEBT4m/5o
	 5UkXbm+cHEvPBZnS/e6OmGkNkVoY89TtnlOT8OB9sSzLkuJxObGslqUmL2E5tLYl1M
	 BAYMtI2bU0CrXibgVUsmOl47I6mOTzva73FTiaoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <chenridong@xiaomi.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0416/1005] cgroup/cpuset: Reset partition data when an invalid partition stays invalid
Date: Wed, 25 Nov 2026 15:29:14 +0100
Message-ID: <20261125143831.497770243@linuxfoundation.org>
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

[ Upstream commit ba4834fc81ddc0b500843c827c09d3ff95a317a9 ]

When cpuset.cpus or cpuset.cpus.exclusive of a partition root is
changed, update_cpumask() and update_exclusive_cpumask() copy the new
effective_xcpus computed for the trial cpuset into the cpuset, and call
reset_partition_data() only if the partition was valid before and is
invalid now:

	if ((old_prs > 0) && !is_partition_valid(cs))
		reset_partition_data(cs);

An invalid partition root (old_prs < 0) that stays invalid is not
covered. Its effective_xcpus is then left with the trial value, which
is computed from user_xcpus() and so falls back to cpuset.cpus when
cpuset.cpus.exclusive is cleared. As an invalid partition root does not
own any exclusive CPUs, and rm_siblings_excl_cpus() treats a non-empty
effective_xcpus of a sibling without cpuset.cpus.exclusive as owned,
those CPUs can then no longer be claimed by a sibling:

  # A1: cpuset.cpus=2-3, cpuset.cpus.exclusive=2-3, root, with tasks
  # offline CPUs 2-3 -> A1 becomes invalid
  echo > A1/cpuset.cpus.exclusive
  cat A1/cpuset.cpus.exclusive.effective    # 2-3, expected empty
  echo 3 > B1/cpuset.cpus.exclusive         # -EINVAL

Reset the partition data whenever the cpuset is a partition root, valid
or not, and ends up invalid. As effective_xcpus may be cleared by that,
also force update_cpumasks_hier() to update the subtree, so that the
effective_xcpus of the descendants doesn't keep the released CPUs. Add
test cases for it.

Fixes: de9f15e21c55 ("cpuset: use parse_cpulist for setting cpus.exclusive")
Fixes: c5866c9a007d ("cpuset: refactor CPU mask buffer parsing logic")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20261101114206.2434398-1-ridong.chen%40linux.dev?part=15
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c                            | 10 ++++++++--
 tools/testing/selftests/cgroup/test_cpuset_prs.sh |  6 ++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 6f336ace3033a..8f0979b73e20f 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2640,8 +2640,11 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	spin_lock_irq(&callback_lock);
 	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
 	cpumask_copy(cs->effective_xcpus, trialcs->effective_xcpus);
-	if ((old_prs > 0) && !is_partition_valid(cs))
+	if (old_prs && !is_partition_valid(cs)) {
 		reset_partition_data(cs);
+		/* effective_xcpus may be cleared, update the subtree too */
+		force = true;
+	}
 	spin_unlock_irq(&callback_lock);
 
 	/* effective_cpus/effective_xcpus will be updated here */
@@ -2705,8 +2708,11 @@ static int update_exclusive_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	spin_lock_irq(&callback_lock);
 	cpumask_copy(cs->exclusive_cpus, trialcs->exclusive_cpus);
 	cpumask_copy(cs->effective_xcpus, trialcs->effective_xcpus);
-	if ((old_prs > 0) && !is_partition_valid(cs))
+	if (old_prs && !is_partition_valid(cs)) {
 		reset_partition_data(cs);
+		/* effective_xcpus may be cleared, update the subtree too */
+		force = true;
+	}
 	spin_unlock_irq(&callback_lock);
 
 	/*
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 78ed0500e11db..7d5ca28e46c21 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -364,6 +364,12 @@ TEST_MATRIX=(
 	# cpuset.cpus is allowed, but those extra CPUs are ignored.
 	"  C2-3:P1   C3:P1  .      .      .     C2-4    .      .     0 A1:|A2:2-3 A1:P1|A2:P1"
 
+	# Clearing cpuset.cpus.exclusive of an invalid partition releases its
+	# exclusive CPUs, including those of its descendants, so a sibling
+	# can claim them.
+	" CX2-3:P1    .     .     C3  T:O2=0:O3=0:X  .     .      X3   0 XA1:|XB1:3 A1:P-1"
+	" CX2-3:P1   X3     .     C3  T:O2=0:O3=0:X  .     .      X3   0 XA1:|XA2:|XB1:3 A1:P-1"
+
 	# A child cannot recover until its exclusive CPUs are available again.
 	" CX1-4:P1 CX3-4:P1 .     .     X1-2     .      .      .     0 A1:1-2|A2:1-2|XA2: A1:P1|A2:P-1"
 	" CX1-4:P1 CX3-4:P1 .     .  X1-2:X1-4   .      .      .     0 A1:1-2|A2:3-4|XA2:3-4 A1:P1|A2:P1"
-- 
2.53.0



