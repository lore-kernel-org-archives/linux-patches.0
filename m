Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619727;
	b=oVZ3OmKTOYcHsMy2FwIcac+D7Ri7tF2NJ28zS28o4DnPnfSBmhIJcw3TS0H/kjmv1dm9
	 le00I7QIuPatFsyvtjEFiSwxXWq7xDmAmifhHVyH3V1D9eMambBXfGmWaUbd9bLkpF2ZD
	 8+3pJB+G6Ms/IzHWom18a2idRtasInhTLl32XU69g7ECTLNRDlhzNSjvwtux80TzDcf3l
	 K9B1Eu9JDYYbvmgpeKUxnPBDPC1hUC2fbyjGyWP9b4j16lh116OBH21WQBAnpuQNSfQmL
	 JayaBfBxKyBeuEBX5Yxkq15lkr5hnPqb1nwKwaF4ouT/Voeim/zJf85pBXHxGyGwIFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qJuFyfVVQKU9/2VWeqEIujXJwJ23kD38KIlIgdMwMbs=;
	b=fqYV4F9wTKYg2TQTklHJXA/N5D4akqAQqX+LC3ndndDTpHlUZhl3WoUS7Wdu8iOb8RiP
	 9FWq/d0MBIPWU9bATGqKBiLERktBjSKd5utH97M+YTpivARBO3T1ZJhBbtnqZLk6uBiCi
	 6UyvGNfyL5fKbsI4QnwR921tu+u+W3KgsLDRdMwSq3Y5nTY1euudGzZiotQkmURa4szWO
	 f09mc5Sb2UGYS2n+DulFtLkWyYGmLgG/kFq4F9b3e+QBlREUnq1N9rea3IKP1N4W2ABFK
	 ZU4FYsZHOKOpQzvGeOAkEe+Y5ZDRy5atyjufsWJyJBoDTbKkd3X9jjfRZlVDl4ghZIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W1SVnKkq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAF9606A684;
	Wed, 25 Nov 2026 15:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W1SVnKkq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA631F00A3D;
	Wed, 25 Nov 2026 15:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619726;
	bh=qJuFyfVVQKU9/2VWeqEIujXJwJ23kD38KIlIgdMwMbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W1SVnKkqerBUxfY+5buc8JHna7zge1ixs0lJ3RbmlO7JGfxJW4I9E38dSMZMd5p8X
	 zLvgnTmsTsJ3wnYLb8moOYcwm8h/gj71xCFe3YJxO/o2th7gsoyNXLiO7Kfgft9zrI
	 cg3mdry48IFeKS2DgS1lneKbpsanubtBZ4ORSvTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.3 0687/1005] cgroup/cpuset: Correctly set isolated_cpus when switching partition state
Date: Wed, 25 Nov 2026 15:33:45 +0100
Message-ID: <20261125143837.845286926@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

commit 56681bc448a80bb2473026b41c44c133766bc38d upstream.

When update_prstate() is called to switch the partition state from
root to isolated or vice versa, the whole effective_xcpus is passed to
isolated_cpus_update(). However, if there are child partitions present,
some of the effective_xcpus are dedicated to those child partitions
and their partition states will remain the same or get invalidated in
the case of child root partition with isolated parent in the latter
update_cpumasks_hier() call. In the latter case, their exclusive CPUs
will be returned to their parent.

Therefore isolated_cpus may be set incorrectly with child partitions
underneath. Fix that by excluding their exclusive CPUs in computing
the correct cpumask of exclusive CPUs used by that partition alone.

Add new test cases into test_cpuset_prs.sh to test for such cases.

Fixes: 11e5f407b64a ("cgroup/cpuset: Keep track of CPUs in isolated partitions")
Cc: stable@vger.kernel.org # v6.8+
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Tested-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c                            |   30 ++++++++++++++++++----
 tools/testing/selftests/cgroup/test_cpuset_prs.sh |    7 +++++
 2 files changed, 32 insertions(+), 5 deletions(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3151,12 +3151,32 @@ static int update_prstate(struct cpuset
 						  cs->effective_xcpus, NULL))
 			err = PERR_HKEEPING;
 		else if (parent_prs == PRS_ISOLATED)
-			err = PERR_ISOPARENT;
+			err = PERR_ISOPARENT;	/* old_prs should be isolated */
 
-		if (!err)
-			isolcpus_updated = true;
-		else
+		if (err) {
 			disable_partition = true;
+		} else {
+			struct cgroup_subsys_state *css;
+			struct cpuset *child;
+
+			/*
+			 * Need to scan child partitions, if present, and
+			 * exclude their effective_xcpus from cs. In the case
+			 * of switching to isolated partition with child root
+			 * partitions, those child partitions will be
+			 * invalidated in update_cpumasks_hier().
+			 */
+			isolcpus_updated = true;
+			cpumask_copy(tmpmask.new_cpus, cs->effective_xcpus);
+			rcu_read_lock();
+			cpuset_for_each_child(child, css, cs) {
+				if (!is_partition_valid(child))
+					continue;
+				cpumask_andnot(tmpmask.new_cpus, tmpmask.new_cpus,
+					       child->effective_xcpus);
+			}
+			rcu_read_unlock();
+		}
 	} else {
 		/*
 		 * Switching back to member is always allowed even if it
@@ -3193,7 +3213,7 @@ out:
 	if (!is_partition_valid(cs))
 		reset_partition_data(cs);
 	else if (isolcpus_updated)
-		isolated_cpus_update(old_prs, new_prs, cs->effective_xcpus);
+		isolated_cpus_update(old_prs, new_prs, tmpmask.new_cpus);
 	spin_unlock_irq(&callback_lock);
 
 	/* Force update if partition is disabled & update effective_xcpus */
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -468,6 +468,13 @@ TEST_MATRIX=(
 	" C1-4:P1 C3-4:P2   .      .    T:C4-6   .      .      .     0 A1:5-6|A2:4 A1:P1|A2:P2 4"
 	" C1-4:P1 C1-2:P2   .      .    T:C4-6   .      .      .     0 A1:4-6|A2:4-6 A1:P1|A2:P-2 ."
 
+	# Switch PRS state (root <=> isolated) will properly update cpuset.cpus.isolated
+	# even if child partitions are present.
+	" C1-6:P1 C3-6:P1 C5-6:P2  .       .    P2      .      .     0 A1:1-2|A2:3-4|A3:5-6 \
+								       A1:P1|A2:P2|A3:P2 3-6"
+	" C1-6:P1 C3-6:P2 C5-6:P2  .       .    P1      .      .     0 A1:1-2|A2:3-4|A3:5-6 \
+								       A1:P1|A2:P1|A3:P2 5-6"
+
 	#
 	#  old-A1 old-A2 old-A3 old-B1 new-A1 new-A2 new-A3 new-B1 fail ECPUs Pstate ISOLCPUS
 	#  ------ ------ ------ ------ ------ ------ ------ ------ ---- ----- ------ --------


