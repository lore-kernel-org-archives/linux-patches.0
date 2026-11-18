Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050221;
	b=XasRYFU/dxlG5La77bmYgX88mq8bLTlXrX3rbyL1Ze2oODh8nVSEhCubPCxefdkZTPA4
	 XXOzCnnU4Dmi4ebAG9/B9yZnbTSqYXilt8HuXfz8iQXD2NdkHqM9kVRPjvnIZROynKun4
	 2xhPLHp/tf0egTEZ3xMHjlBLRZxAJk+BZnDVI2WYsGxf65td8dtCuCuTCtCFN5QGFOKqL
	 MtCwRaqC7DJKEWPt6/pHNQFK/vJ88RERGnPVeZ+wFxJY/rp3FiDWprK91jLrTEIQNde7U
	 LerBYi8NmttIPJ/IghM8vXm+xVZUzP9yD7GMqulmQHTnchFV1rhOMdXamsKId7RGekA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hBEQ+p+RuccWAbXbQg9IEvph4Npw2z6lcD85iEKOzK4=;
	b=dylLQuInU2iennCWmUxbS5El4LVucLYr4XiKfk2FSoowSPFRvzyD86xeQH7wMtAEKGiH
	 UvXDyw4BGaw9Mc9LabZMfOTKJHMNZk/RqW/JGXa6bLKy4qeSbbs/CBctEy9ECJllJ8xK0
	 4b3kBACTaxVo4rmauEtOGLS26cJMIEXZKSzre3TBWVoRLdQbkO+3GpCHNZByCpWHdf0p0
	 +BOdaXSrnDg8RWVdrwu3UcmgLhZYqLrGlrtMA7pRwBg/x8QObKdsxWauX3KQJWWJogDhp
	 FTpVmvloyTez1G+dZR+Zt/B1wzG4uNapYDkFVM03fhP114tF4qBXWrFRIYvP9UElpIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQQRo6pQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDA4606A331;
	Thu, 19 Nov 2026 01:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CQQRo6pQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E201F000C4;
	Thu, 19 Nov 2026 01:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050221;
	bh=hBEQ+p+RuccWAbXbQg9IEvph4Npw2z6lcD85iEKOzK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CQQRo6pQHYsDcihcghn+nJGH8+uhwRD+Ewm8xOpDR6h9OCuI9DVAXI8u+eV9p0t7B
	 gnTzGzBG5ouJt94amFdXYvcBZga3T6adLVSoa3Lgyh5PCbSh9ATjGr/ZtVihK3ZWTr
	 8qSNdcbr3KvwHMk5O2aR+ckmld3ZXwP6V8ErjgFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Waiman Long <longman@redhat.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2632/2857] cgroup/cpuset: use mems_allowed_seq when checking a policy nodemask
Date: Wed, 18 Nov 2026 16:01:06 +0100
Message-ID: <20261118150336.361421131@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price (Meta) <gourry@gourry.net>

[ Upstream commit b0cec62d2867ab3ed27604d5c177b8960c43b17a ]

A cpuset update changes the task's mems_allowed and rebinds its
mempolicy in separate steps under mems_allowed_seq, but the check
reads both without it.  This can cause a spurious numa placement
miss under some cpuset/mempolicy combinations.

A reader that loads one mask before the update and the other after
it can see a spurious empty intersection and drop the nodemask.

For example, a task with cpuset.mems={0} and MPOL_BIND={0}.  If the
cpuset moves to mems={1,2}, the policy is rebound to {1}.

The allocator can race and compare the old mems_allowed {0} against
the new policy {1} - which will result in a dropped nodemask and a
misplaced allocation on node 2.

Simply retry the intersection until mems_allowed_seq is stable.

This covers the task policy, which is rebound under mems_allowed_seq.
VMA policies are rebound afterwards by mpol_rebind_mm(), outside
mems_allowed_seq, and are not covered by this change.

Fixes: cc9a6c877661 ("cpuset: mm: reduce large amounts of memory barrier related damage v3")
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 61736a4e105bf..3f78047c090a9 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3790,10 +3790,21 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
  * @nodemask: the nodemask to be checked
  *
  * Are any of the nodes in the nodemask allowed in current->mems_allowed?
+ *
+ * A cpuset update rebinds the task's mempolicy and changes mems_allowed in
+ * separate steps, so retry if an update raced with the check.
  */
 int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
 {
-	return nodes_intersects(*nodemask, current->mems_allowed);
+	unsigned int seq;
+	int ret;
+
+	do {
+		seq = read_mems_allowed_begin();
+		ret = nodes_intersects(*nodemask, current->mems_allowed);
+	} while (read_mems_allowed_retry(seq));
+
+	return ret;
 }
 
 /*
-- 
2.53.0



