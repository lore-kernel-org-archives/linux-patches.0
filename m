Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056628;
	b=QUba5v5sxzwKXDrVk/tb6SHeeSuOEV3ztom9UojQ3rMql3RuBhjlM+IM5rpX4vUQRdSk
	 fEoWoJFkD3kEt6kj5IAH2O/dygyoYQvDVC97sKU5i2V57+RP3Buea01QzRs1BhDF8Eclm
	 8uL+Iqd4rmRWBAlWbLUcOjczF7O+wPqe5yTPhB0Cl2myuaGhOHsI+/WJSfdQIkxKr7dRQ
	 kIc/cAPfbZk8ZSnNUzXfWHpuBxb41LntWtBsg2nkft4qw8bSbyNobWedjSEKaWxqTrRR3
	 MmkfOgDRIzV07ClEqDmBguHt5cJuPOR4SDuX/7SK1d9HCKWHYFasWmk4YtT9u1N8Yng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kic24/1shaB2pVLTEzJ7sZ6CYZ/dG00KQTN5Xs0/SjY=;
	b=USGtQ90cxeFpWt65xk1nUFFV94v8tqWmqWgeeo8D3YVsBW9e0JzhcGy0gCwq684+MLp3
	 EzaT5DAZWOPFeMZKnbX7ZLjGV4WSHxXLZIKlf7gLiNYQVwRQryKqHMw8TEAfvhmR438FG
	 LS6UYFLPc7RSPddz+TTX7Bv+YYyanzAiQUgA59XWyyTwxq2/Cm8R4PSa9MqGAfov/b9gJ
	 b1lgDIFQtpElzWw+Tfr1yKQpKQ+tu7Mazm2JtsoBCzV3aug3bmRmqr28lxIiVUuz4IzM+
	 QrQpvbVztBRFQFM/ci7XoXI2Dxh+otSyQD9MbosSBsn88Vc+Mya8WkOF8Zdp6MUTteg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M8oZJQW8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F413D606A325;
	Thu, 19 Nov 2026 02:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M8oZJQW8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F23C1F000C4;
	Thu, 19 Nov 2026 02:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056627;
	bh=kic24/1shaB2pVLTEzJ7sZ6CYZ/dG00KQTN5Xs0/SjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M8oZJQW8Hianj/f23ps7Q4+bKt5L96hnH5/lw/gO5ZehPSmIfAz2TYWbVzF68ovwk
	 PO5hf6RneaLOQsfj/7uoMe0cKL2a5Ay1i4Yy9dUZ8fUe3WI154hw3jDBtXLUdg+PaK
	 OImWnP7aaWrG6MHWCc8h75Fpruy9mhEnXH7LY/dA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Waiman Long <longman@redhat.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2055/2214] cgroup/cpuset: use mems_allowed_seq when checking a policy nodemask
Date: Wed, 18 Nov 2026 16:02:11 +0100
Message-ID: <20261118150132.899679861@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index dafa8933f3aeb..791d19f6b35c6 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3571,10 +3571,21 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
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



