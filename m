Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032590;
	b=i9XsAYwzCV35BSWBdgxQ27bflobeWH2mFSwHHdkRYkE9O4i5M13wIlId6T4lTyRDi5l7
	 W7yrOd+gbfJhEP6jj1LEkvA0Fq/y7v6wtOHIN91PHpQ5O4HblnpyZgO6Ckqi0TJaWd/+n
	 TMuHIiT8iY1GXwVxfX7soaGVY1TA4mjGPOZ1pcbegyXjViIyUaGKykQIf9YPdPrikPBCk
	 bC0FR5cVH7mdMg747NhMmZREux3aDmlsEOh2IWRfbebtt/6lFe0pf/u6BShIFjOMkqZUd
	 yVvo97/DDKyAwJctpAlN5bTCImUOgutZdieDZNGps6QziFn3Js34B8xX8JxbcOx1XRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oXyclQJ5FTeR/C2qXpPc2GXmRTJjnUBaDbJs54oEMgM=;
	b=JKybmnvMghucKBk2tfjEP0Krxb0OuyzPEcSRlVL8wDepaeq6y7R66MtnyixLOxNDroaU
	 imZa0F138qsjZTiKmKLp54AjUdZQ8Mbb9h46Inxa+tq/ORY+B0Pljbq6TPZSROdOIk/Gz
	 snhbhCQr3dmhoG+l8l8raESYqYNxklKaZ8dT3rmxbBzPCasG7Q8FeRAY4gsKuAn4a6IKF
	 hTmVLlL/FSzNzLLAsotnAvX3D0pEV9pseGXXRtCPFGtcibrd+PXwN6WZiaB48vc2jpigB
	 juSncDPPOOa5su4KVVzIk5p8Wm9ktcZFXG3QviyFpC3uQ5qeZ/4Zo9kLgu0sVdgstXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tbshuBp/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547C5606A325;
	Wed, 18 Nov 2026 20:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tbshuBp/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FB81F000C5;
	Wed, 18 Nov 2026 20:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032590;
	bh=oXyclQJ5FTeR/C2qXpPc2GXmRTJjnUBaDbJs54oEMgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tbshuBp/pqqoMp4LcSxL5uCGRfsHnbg+sVyPf3YtgqilFd8rvopk2zXQ4FVIiZfwQ
	 jF1ZNhTph0ul2yxfpvjX/cCNd0q99/VFWmXX0kYhTDJ8wrekH+AO5t0uu1oW4THgl0
	 ArOPXxOIJRS1Mgm6M/dajybzu+ri9lp/c9AVSwPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Waiman Long <longman@redhat.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1420/1756] cgroup/cpuset: use mems_allowed_seq when checking a policy nodemask
Date: Wed, 18 Nov 2026 15:59:07 +0100
Message-ID: <20261118150105.705566878@linuxfoundation.org>
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
index 24ec9fa748998..0f21e72703346 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4185,10 +4185,21 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
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



