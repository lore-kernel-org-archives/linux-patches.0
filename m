Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021786;
	b=vrbCjGqk2qfg3x9mj+nD/VjtFWi0R/u6X5EyVh0SdCk2YDZ6pg4rkVGv6JU9NTheUOHH
	 02/XvlLpqCsk40zNkFwrIaGfq8cuECwTcdLyV7fvG4W1EFJdgJ46VO7r++7M6WPmja3Kk
	 lT5b6rjoDElqz0SfQxfL8tDRa274FCS5tEztYVyYJDGXS6kr1jH6u5QwHlsud2KgxshLp
	 eVEt9CnvOUXK12ilicwW13zgkUibQK5PWN85zsUZCtV73AQEPh7VClb4lui2jEFjxQ60L
	 wzVVLQHGZFUGS0bXGACB5Q2wWKX+mFj2nj3WlUQXCIR1ElW6QZiNvfa7EscJQfd/xkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021786;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4qAmZ+JCckNjCJijQFjg8JEXXFesVvnNM3b9rBqm81M=;
	b=4o3YCwQPz7QNhih4295vAWgOAvET3FUmxMIhel95ePCVIhJhZtWFFOSi4r/ONRj0UYp6
	 iDkKWLbY8QJD0efGp+v16WkUJqW61jjWMVw11u+GX7P6gyMERWosV+VJ3TYcwg4f/lEho
	 NSWLVVZuHFX4WRdcBmO8t8gNCw75hyh6vMH4q8tND4j/kvpnTE/apBpesD0oiClm280v1
	 +eXKE4LsKZtSv9GVZwFlgj9heaWJg0Pnoic6lgqZnWi9YRS52+afJWOG86bnxws8PcYnZ
	 3QDDewyZr833h+VIUjkJu+JThOtD1zp+Gb3GxgK2JYlXFby71aycKQH09A1nXmRc4Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0cmUrSoM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D52606A320;
	Wed, 18 Nov 2026 17:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0cmUrSoM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089D61F000C4;
	Wed, 18 Nov 2026 17:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021785;
	bh=4qAmZ+JCckNjCJijQFjg8JEXXFesVvnNM3b9rBqm81M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0cmUrSoMZoLvSigtyykq1FbOUWfHJq+dIOMqnCffvRm9RMuSDuzT9BuOH3+XkacAr
	 Rq9JlOU1RZ0dvZHpVRDTf7bL9dDfkS0DWBkz24Q0A2BiL1wvQxUTKpoYfpAugym6lZ
	 cmPlcNV4aShVxtUXx6sENRVQy78YRmShCJ0cZbjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2430/2651] cgroup/cpuset: Release invalid isolated CPUs with a shrunk root partition parent
Date: Wed, 18 Nov 2026 16:01:10 +0100
Message-ID: <20261118150412.693187914@linuxfoundation.org>
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

[ Upstream commit ec0254b9eb49ebc9383dc3ae5cb69c8606f88499 ]

It is also reported by sashiko that there may be leakages of isolated
CPUs when a root partition parent shrinks its effective_xcpus with
isolated partition children. Leakage here means that isolated_cpus may
contain extra CPUs that are not in any isolated partitions and not boot
time isolated. Those CPUs cannot be used in any isolated partitions
anymore.

There are 2 different cases here. The effective_xcpus becomes empty and
the isolated partition should be invalidated in this case. Alternatively
some of its effective_xcpus are not in parent's effective xcpus but
still have some valid effective_xcpus left. The isolated partition can
remain valid. In both cases, the invalid isolated CPUs will have to be
released from isolated_cpus if appropriate.

Fix that by calling isolated_cpus_release() to release those isolated
CPUs from isolated_cpus.

New test cases are added to test_cpuset_prs.sh to test this.

Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c                           | 16 +++++++++++++++-
 .../testing/selftests/cgroup/test_cpuset_prs.sh  |  6 ++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index e7a2f812db9ed..6f336ace3033a 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2037,8 +2037,22 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		 *
 		 * A partition error happens when parent has tasks and all
 		 * its effective CPUs will have to be distributed out.
+		 *
+		 * For an isolated partition with a shrunk root partition parent
+		 * we may need to return some or all of its isolated CPUs.
 		 */
-		if (nocpu || cpumask_empty(tmp->delmask)) {
+		nocpu |= cpumask_empty(tmp->delmask);
+		if ((parent_prs == PRS_ROOT) && (old_prs == PRS_ISOLATED)) {
+			cpumask_clear(tmp->addmask);
+			if (nocpu)
+				cpumask_copy(tmp->addmask, cs->effective_xcpus);
+			else if (!cpumask_subset(cs->effective_xcpus, parent->effective_xcpus))
+				cpumask_andnot(tmp->addmask, cs->effective_xcpus,
+							     parent->effective_xcpus);
+			if (!cpumask_empty(tmp->addmask))
+				isolated_cpus_release(cs, tmp->addmask);
+		}
+		if (nocpu) {
 			part_error = PERR_NOCPUS;
 			if (is_partition_valid(cs))
 				adding = cpumask_and(tmp->addmask,
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 5f1229c06645e..78ed0500e11db 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -456,6 +456,12 @@ TEST_MATRIX=(
 	# its effective xcpus will be removed from isolated_cpus.
 	" C1-4:P1 C3-4:P2   .      .    T:C3-4   .      .      .     0 A1:3-4|A2:3-4 A1:P1|A2:P-2 ."
 
+	# When a root partition parent with an isolated partition child is shrunk
+	# so that its effective xcpus is no longer a superset of its child effective
+	# xcpus, the invalid isolated CPUs should be removed from cpuset.cpus.isolated.
+	" C1-4:P1 C3-4:P2   .      .    T:C4-6   .      .      .     0 A1:5-6|A2:4 A1:P1|A2:P2 4"
+	" C1-4:P1 C1-2:P2   .      .    T:C4-6   .      .      .     0 A1:4-6|A2:4-6 A1:P1|A2:P-2 ."
+
 	#
 	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
 	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------
-- 
2.53.0



