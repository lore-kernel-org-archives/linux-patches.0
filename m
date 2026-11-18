Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028034;
	b=O64uvGlZEFPI3/nr2e7DBnHdNyOnGSPieBAc2Et11/Ye8BDicWvUnQE6Nh8WPNEcHSeh
	 jiwVL1t2TIWflOJLi9jhsYQnhA56kNSqfQAP2lDNRNoKl/N4WgOlk3cQAILkHCwy2FkEc
	 0I8cNEb8lFYLVGNSX0tTFE3PIWYzK0ekkSvneuJ3Cdb+8KzfoHhB3SvwSnQUTX2xcn9NT
	 5uh+NynsfQqTN4mx0a/PlwN+RdgmBIEBF3K/9XBx6cNVEhJfnRk5QygGnnfKsjHq8VOQN
	 oPFTpRnvS96BlH5nia6DU4xghMuVJU728PPBYnMt2Of0K25aMX4ki5CPNtBaTtfpAXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kSQcdYSi8QfYsQU8j/lHj9q9KvBPtepUqIgFZxPfiFU=;
	b=Oaz2yOSD71rtHKOi+ALoGYYlDhhQ9qAMgBFNh2yMQNa46lv52mKqmB7OPN+pcv+qB/NC
	 wLCeHgXnN1E6Wi7gPyDJOEfzWIYu4SbBsVsMhDMfFjPcY3AwbtLq9JIVBSkkxVuPUyKBP
	 kp+XYZvAJfpkalaLgacddWWCfjPt9sT3oJvzTVgZxtTDHg4g+GHe/KRXzRyDO0zenk3oC
	 mRvQV1wAM91fXkhmXl7fV+JaQTvC0J2WKwF8ufdp2qqpyj5230eEJJJk/PQvGvgLQXcUz
	 zqtg+jp1j6Vhx1Iwy9l1rBgl5C+1jAtjVT9XALsQc8daZFaaRGmFGbGP75q5qSAvKvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eCXSkrj1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582CC606A31C;
	Wed, 18 Nov 2026 18:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eCXSkrj1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705A51F000C4;
	Wed, 18 Nov 2026 18:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028034;
	bh=kSQcdYSi8QfYsQU8j/lHj9q9KvBPtepUqIgFZxPfiFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eCXSkrj1z1jY0HpIPzHnbfbZVOOPHOr4tv/UiofEtFkAP+X7dX7MykjRrbd670LL2
	 ia3iLuz7Kj55HoJ25eJYNrtufXCXrGhwyldXwr+BqavIE01Z4ZhCTIt2+rX77Tv4Qg
	 UZrN/EQGCLkmfe3XRFQKOyhv/4De8ZsJVp0MXGe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1960/2151] cgroup/cpuset: Make sure compute_partition_effective_cpumask() is only called for valid partition
Date: Wed, 18 Nov 2026 16:01:35 +0100
Message-ID: <20261118150233.155258560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

[ Upstream commit 356a3aa7404e420e6f19c5ed42db7b8bd0c7ee9f ]

With visual inspection to make sure that
compute_partition_effective_cpumask() is only called for valid partition
root, it was found that the function can be called for an invalidated
partition near the end of cpuset_hotplug_update_tasks(). When partcmd is
set, update_parent_effective_cpumask() is called to either invalidate a
valid partition or with partcmd_update to check if an invalid partition
can be switched back to valid. In both cases, cpuset_force_rebuild()
should be invoked. However, compute_partition_effective_cpumask()
should only be called when an invalid partition is switched back to
valid. When a partition is invalidated, compute_effective_cpumask()
should be called instead.

Also add a WARN_ON_ONCE() in compute_partition_effective_cpumask() to
ensure that a valid partition root is passed in.

Fixes: 72c6303acfa1 ("cgroup/cpuset: Take isolated CPUs out of workqueue unbound cpumask")
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index df0d3bff50102..e90fb48cf0f9b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2181,6 +2181,8 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 	struct cpuset *child;
 	bool populated = partition_is_populated(cs, NULL);
 
+	WARN_ON_ONCE(!is_partition_valid(cs));
+
 	/*
 	 * Check child partition roots to see if they should be
 	 * invalidated when
@@ -4065,9 +4067,12 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 
 	if (partcmd >= 0) {
 		update_parent_effective_cpumask(cs, partcmd, NULL, tmp);
-		if ((partcmd == partcmd_invalidate) || is_partition_valid(cs)) {
+		if (is_partition_valid(cs)) {
 			compute_partition_effective_cpumask(cs, &new_cpus);
 			cpuset_force_rebuild();
+		} else if (partcmd == partcmd_invalidate) {
+			compute_effective_cpumask(&new_cpus, cs, parent);
+			cpuset_force_rebuild();
 		}
 	}
 
-- 
2.53.0



