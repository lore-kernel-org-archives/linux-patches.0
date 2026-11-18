Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021091;
	b=jerdTkCAAS7YH5y8WBhdg7Mz7daQDA2U1+LUKoGGDlBVMK+1uzTgu2UW3wDeMZ4swRti
	 AV3o6ce4xhSuP6+C5rPk0RpkAYHVVSBKntnxBeJRStmBeWfFBQFDqL1yTiCnoZ5jupcmT
	 6XNEqikJ86RErpO/2yd/gQSHW4iGwe+KvTym6qmmdPJt4UnpWEYs4ko5wlu1L4FOlQvFK
	 km86IiHPTxNs/47zVhW7BWtlcoBUk7Diwn7WAn45mY4gKCwiu+nn32Je8CL2PGGH1O7ay
	 pHi5TuAt5voFzo3CeZdgLSfkxXOtxJubfL2AB7dqN2NSdeI5SF7ksiidQkCOY+CEy1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cTSsbOKotDfpXiLF5RryrYdYfqbiusuCU3xRnkJxInY=;
	b=FqrATgR5rteR0WP28y4kk2ItQE7G7KFlnI4Tk9ZrPMuQd9QP2dUWIGvnD2PCYbTnRJNr
	 LCL8rV7YeGNsvI+FlsG/MtBV9RclSQUjdcTnV3I7AMvzGCHgaadZ2Pv9aYaPSbUENgb2Z
	 VMC1LkWsgSsC+DrwLHt8fqaoMXFIKAeVrarYliEeoCBp3veTERV94EAO5jKW3Lkz5u1V5
	 wFcfCpgHXSKkla0iVEkfpOw008V+5lNAQTMDFFGJ2Wa6c/+ZyaWSaF070kdcPj9OcH8wX
	 64C0vU6N0Jj0vgPoepeXj+gLohsfFSTSis1d5e9W6DY5hxoNI7XM1yR+P/nl82FEQdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SzCmlMfN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1D0606A320;
	Wed, 18 Nov 2026 16:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SzCmlMfN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E041D1F000C5;
	Wed, 18 Nov 2026 16:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021091;
	bh=cTSsbOKotDfpXiLF5RryrYdYfqbiusuCU3xRnkJxInY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SzCmlMfN7r3sNdk6OlLvxQ84fxkH1+/8ZLM6rzHyNdM0zl0VZZkMxzZifAG+S6kNk
	 iODcpZuQ9N4tsRm4jsSVkAbE22kRzW6p+R09EkidfKECSxlcP8MjFaz0dWpb1swnvg
	 MHSxc5mAU1OCS977wKy7DBgB1ur6H6r08BHxeeqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Waiman Long <longman@redhat.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2182/2651] cgroup/cpuset: use mems_allowed_seq when checking a policy nodemask
Date: Wed, 18 Nov 2026 15:57:02 +0100
Message-ID: <20261118150404.326587419@linuxfoundation.org>
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
index ab3b4ee27d3ef..4a3c8882dec88 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4379,10 +4379,21 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
  * @nodemask: the nodemask to be checked
  *
  * Are any of the nodes in the nodemask allowed in current->mems_allowed?
+ *
+ * A cpuset update rebinds the task's mempolicy and changes mems_allowed in
+ * separate steps, so retry if an update raced with the check.
  */
 int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask)
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



