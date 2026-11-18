Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017728;
	b=EhC6/GZJGU5UJzCs7Q6omu/LJpuRey9za94aYG/iVneJOrMiO4+N5RgjfnFhVTTQlca4
	 F3Hmm2Qv5KbLZ5bfnr3M/+eaBXFAbODANuY0+P0u8SkCF7jKs8O8tIa9RfZYZwG5cjrp4
	 XWaotJ8abqP+F5rnhkwi19J6WwbuTzayteb3HvXXyvoox/perTr0Iq3IY5apHOAFM2ifV
	 aMpYJMU2ejMDKspH29u5R0BheggBEGXWm8bilwK2O6hcjIesmx4baS4PfxlenuSu8wP5k
	 TQQcczXtnVHfqzIHlo7JmVDFStfG7wmXClbss/LQdgkAFULL+mtW3zMwZBVKvV+5Hmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gj4QWNm8meAhNOhOhfAE8R3q0G8NMpB2ExQdxyQxEys=;
	b=Lzrh6KcOkF42Rr6ZPcj0jEAgHddmtL1eF/xzottzD5SXZ5wFEp/CfXMdVTW8Ny1uU8t/
	 CwtTikodSiqYpNOkDtccuNso8rU1crSNngOB808ocfAAS7/J71PpljiIQj0AIIBj3qh8Z
	 UHao2SQ7uJJYFr5Myejk1Ku5daDsyU20QE3K1hgGy+MIJSZeT30Zez7OV7U0ydNoTe0ed
	 FB0Z+m1z8zLGCuAEEILDKUvrYyMxfGGgLALG68aItURz4EAlZjVclg+YCUaEpi73kANCY
	 ZZTiB/VyUt7OtI3v0QBFwwaLmiLtzNk3jganS3YWfH56NswDcl9UmEYLkzt+lwePjxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hM/CFTAR";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BB5606A320;
	Wed, 18 Nov 2026 16:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hM/CFTAR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1513A1F000C6;
	Wed, 18 Nov 2026 16:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017728;
	bh=gj4QWNm8meAhNOhOhfAE8R3q0G8NMpB2ExQdxyQxEys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hM/CFTARlfcYb/fZoSgoHhHTFIexLE/vA8ZPwll0YxBrNK3uNw5C1DKsSQHokB2UI
	 eoMYa5wMMKRlA6H9kTcHrffOoa1LkjOFaYaJ7BZu2Uh57+fTHWS3+iFQ+YiRqf8H3S
	 /2M2MV6gIfQYAp8UKg8/5QxVB3MRtWbH/+2I+hk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0987/2651] cgroup/cpuset: Run SCHED_DEADLINE shrink test on valid partition root only
Date: Wed, 18 Nov 2026 15:37:07 +0100
Message-ID: <20261118150323.435472167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

[ Upstream commit 8a1c0f5c82843104d9bef2bc3726c89da70a9b91 ]

Commit f82f80426f7a ("sched/deadline: Ensure that updates to exclusive
cpusets don't break AC") adds a check in validate_change() to make
sure that there is enough bandwidth for SCHED_DEADLINE tasks if we
shrink a v1 exclusive cpuset that has CS_CPU_EXCLUSIVE flag set.

With the introduction of cpuset partition in cgroup v2, we keep setting
the CS_CPU_EXCLUSIVE flag for a partition root so that the SCHED_DEADLINE
check will continue to work as intended. However it turns out that the
current code isn't perfect and there are cases where a cpuset isn't
a valid partition root, but the exclusive flag is still incorrectly
set. This can leads to SCHED_DEADLINE check being incorrectly triggered
when there are deadline tasks in the system. This can result in unexpected
-EBUSY failure when making changes to cpuset control files. Fix that
by checking for a valid partition root for v2 and is_cpu_exclusive()
for v1. It is far easier and less cumbersome than to make sure that
the exclusive flag is only set for valid partition roots.

Even though commit a86ce68078b2 ("cgroup/cpuset: Extract out
CS_CPU_EXCLUSIVE & CS_SCHED_LOAD_BALANCE handling") is marked as a
commit to be fixed, the problem may exist before that.

Fixes: a86ce68078b2 ("cgroup/cpuset: Extract out CS_CPU_EXCLUSIVE & CS_SCHED_LOAD_BALANCE handling")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 86b5921998afa..4a8166101a69a 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -792,8 +792,8 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 	 * For v1, effective_cpus == cpus_allowed & user_xcpus() returns
 	 * cpus_allowed.
 	 *
-	 * For v2, is_cpu_exclusive() & is_sched_load_balance() are true only
-	 * for non-isolated partition root. At this point, the target
+	 * For v2, is_partition_valid(cur) & is_sched_load_balance() are true
+	 * only for non-isolated partition root. At this point, the target
 	 * effective_cpus isn't computed yet. user_xcpus() is the best
 	 * approximation.
 	 *
@@ -802,7 +802,8 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 	 * becomes an issue.
 	 */
 	ret = -EBUSY;
-	if (is_cpu_exclusive(cur) && is_sched_load_balance(cur) &&
+	if ((is_partition_valid(cur) || (!cpuset_v2() && is_cpu_exclusive(cur))) &&
+	    is_sched_load_balance(cur) &&
 	    !cpuset_cpumask_can_shrink(cur->effective_cpus, user_xcpus(trial)))
 		goto out;
 
-- 
2.53.0



