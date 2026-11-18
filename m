Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042118;
	b=MGRdImAT7/42CoUYsGp8f+F6hYDArNuHkJqRNiL0gjEHeapID3YcET9gfgYdZMrVMWCu
	 qWi3rjZtJlQ5XHAcNcOULEI17bGACA7HLEzmtvJpgRjG8n58CoOrIIVmQXASf11nq1cnw
	 Ifi4t4XtHXuNiHk896etkRpwyFNwbH1iEUmt7Am/8B+ktGAWF8WYemKDPyUCD0EcJfxQx
	 YOdVrxfZm0EUsxanfh/lxZCefK69Ne6Y8/XYGT8jOW16VyIXYJvvJkQjhyIOzdAsbt443
	 C2jm+x7rytNWga4ScMEMalHx+LbFiicpo+TZGDZAM+n0RSVQ0IKF+Vn6W7r8V74QU0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=52t8auPp0xaFVzQJh7aLvIDWUkgxUmfVzazsBENIVR4=;
	b=MXtoQWiWFVx1BNj7ieimU4RMgEKmR8opr65+/7Ug/YrLC7fSsLCXCzzZWMZEUWmDHfXQ
	 +WrCgP/OIYIJeMWNkxYVwafGcvPE8+tApUDWd6uib3r/8sEUooAfu/NK1OJOKZS6ij+pd
	 QuSzDyBXySANDDaLpczQkflkoAe3t2Z8Bw7zUsL7vbIm3jzMKKR8ztlK1yYHazLq9/0fr
	 1FkWWTwFHBFesxdhypfRwsMhVPO+mkT9iLsqCTDZBdHv527skvpixlxyJwE19gzKZ6TG3
	 MU3KWDj4mZqWeO2y0voGbPvP+lC4LmaVplcy9316Qek+cPaz3QhH7RMSHVA33MffvIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZC0ItGSK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF102606A31C;
	Wed, 18 Nov 2026 22:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZC0ItGSK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129E61F000C5;
	Wed, 18 Nov 2026 22:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042118;
	bh=52t8auPp0xaFVzQJh7aLvIDWUkgxUmfVzazsBENIVR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZC0ItGSKqYRF+jOoCF+ePOMMo+uupQ6yCz096wUMOImtz2hYT/dIlbyMUYdZUel/V
	 fDx5FnO0OxwFpZkBuKM8cXDmu+ldjGSFFrXWpVGjvM4ZikLWD5GvpiyRDQmnoDzei3
	 A5ExNyMIMaQyQpNUcHz9aWtjR2PgvTqwE5fSw3j4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Waiman Long <longman@redhat.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3055/3318] cgroup/cpuset: use mems_allowed_seq when checking a policy nodemask
Date: Wed, 18 Nov 2026 16:01:17 +0100
Message-ID: <20261118150451.794067713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f59c0922122dc..ed6b57e25b904 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3864,10 +3864,21 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
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



