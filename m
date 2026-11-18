Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021777;
	b=ojcXbvzi/stcDYoHZM1hh3EwGfyb/JmFVXL4mwmVDS0NlF+CxTe10YJuz3UjFOrEw5jg
	 VPbZLEhPOptgP+abNcQQzJcZpUSE5uQRY4sIUUMLUSfZE/pvnqIvqVd9InovPvAKIP6bG
	 L+eG4ZyWRtjK+lC/0E9LcIzrbQk4Wt9zM47q0Amg+HtkfcABmjBXhoNKRWMy+J8+C+j9L
	 mV832AmAUQmSnzWGI0QEtCtIo1j+rqT+qAnwxtsma5Dpjd5LnixCbcqTUDNP78y+LLIYn
	 AX3sdRQ1Kgr16hWBw+M18GWv4EGcFp8UZS+kjz7JFdKDqV+YbgfmIRn+ygVy44iJUmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h0PP7jQSRW0+xgsMUa6pmchJhBXBDQGthzMC1pIGjwc=;
	b=LpMHf7MJjkaVGDvYT5hQakeSZ+1/L4nOQ0fVQLwdbz+5t3FNBlCFaxSNNviJ2QBHSpMM
	 OHfu+X7yaL7saxh6av6AMz1Dedxrt+cPbw5N90wPS9hWwHpDD1kn3KnEgMsrBAOMoywfp
	 bPbbTr5HroA6wmd9IZ1HmnGcDlm1sK6oUohLfQYaywi+EOQef0wEUbT3HlFLl/fOh2aJ6
	 IBnObWoOUVGFDKBX8ZEythXKbhG/Nb9xDt23XsKpMIbLA/DBkLIpxXohVRwy/mfm87I1V
	 PkVkrD2WxknpOU/9K6ShzQZ733kSHAmMiR7fEFST+fvPaW769/+rk1XUkP6b9QFOegA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rg1m/Vqp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED80606A320;
	Wed, 18 Nov 2026 17:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rg1m/Vqp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473C61F000C5;
	Wed, 18 Nov 2026 17:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021776;
	bh=h0PP7jQSRW0+xgsMUa6pmchJhBXBDQGthzMC1pIGjwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rg1m/VqpHTqpINnmV11JpvHmd2EHPjBOzzsJ+Y4hSTTnTtYsGanaQhmOL/2nZ+cL0
	 4fSQK9yljdTAbh1ITC/rKzpMjFXkELxhHkYmO2Q7xPzX2ROvDI+0ba8uvXzvJKBRcz
	 /I0aEkXbAvxNfZXmHRrVSN/+l55FRX+7tSot9cQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2427/2651] cgroup/cpuset: Prevent recursive call of remote_cpus_update() via update_cpumasks_hier()
Date: Wed, 18 Nov 2026 16:01:07 +0100
Message-ID: <20261118150412.600325427@linuxfoundation.org>
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

[ Upstream commit 10a6f00d82544a1baa901de8d28f41f28c364995 ]

Guopeng reports that changing the cpumask of a remote partition root
may set the effective_cpus of the top_cpuset incorrectly. It is
due to the following call sequence:

  update_cpumask()
   -> partition_cpus_change()
    -> remote_cpus_update()
     -> update_sibling_cpumasks()
      -> update_cpumasks_hier()
       -> remote_cpus_update()

The second remote_cpus_update() call passes in the cs->effective_xcpus
instead of the trialcs->effective_xcpus of the first remote_cpus_update()
call.  As a result, the second call can revert what has been done in
the first call leading to incorrect effective_cpus of the top_cpuset
as well as subpartitions_cpus.

Fix that by adding a new remote_partition_updating flag into the cpuset
structure to indicate that a remote partition is being updated and
update_cpumasks_hier() should skip the whole subtree as update_cpumask()
or update_exclusive_cpumask() which calls partition_cpus_change()
will eventually calls update_cpumasks_hier() for that subtree anyway.

This new flag is currently set only in remote_cpus_update() to prevent
recursive call of remote_cpus_update() on the same cpuset.

A test case is added to test_cpuset_prs.sh to verify this change.

Reported-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Link: https://lore.kernel.org/lkml/20261010075947.333549-2-guopeng.zhang@linux.dev
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Fixes: f62a5d39368e ("cgroup/cpuset: Remove remote_partition_check() & make update_cpumasks_hier() handle remote partition")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset-internal.h                   |  5 +++++
 kernel/cgroup/cpuset.c                            | 13 +++++++++----
 tools/testing/selftests/cgroup/test_cpuset_prs.sh |  1 +
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index 701c3854ec7ad..33990902cdc81 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -161,6 +161,11 @@ struct cpuset {
 	 */
 	bool remote_partition;
 
+	/*
+	 * Set to true when a remote partition is undergoing update.
+	 */
+	bool remote_partition_updating;
+
 	/*
 	 * number of SCHED_DEADLINE tasks attached to this cpuset, so that we
 	 * know when to rebuild associated root domain bandwidth information.
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7e0ca4fae49eb..3abfd6c2387d8 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1800,6 +1800,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 			goto invalidate;
 	}
 
+	cs->remote_partition_updating = true;
 	spin_lock_irq(&callback_lock);
 	if (adding)
 		partition_xcpus_add(prs, NULL, tmp->addmask);
@@ -1821,6 +1822,7 @@ static void remote_cpus_update(struct cpuset *cs, struct cpumask *xcpus,
 	 */
 	cpuset_update_tasks_cpumask(&top_cpuset, tmp->new_cpus);
 	update_sibling_cpumasks(&top_cpuset, NULL, tmp);
+	cs->remote_partition_updating = false;
 	return;
 
 invalidate:
@@ -2278,16 +2280,19 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		old_prs = new_prs = cp->partition_root_state;
 
 		/*
-		 * For child remote partition root (!= cs), we need to call
-		 * remote_cpus_update() if effective_xcpus will be changed.
-		 * Otherwise, we can skip the whole subtree.
+		 * For a child remote partition with remote_partition_updating
+		 * set, we can skip the whole subtree as the this function will
+		 * be called eventually. We can also skip the subtree if the
+		 * effective_xcpus isn't going to be changed. Otherwise, we
+		 * will have to call remote_cpus_update().
 		 *
 		 * remote_cpus_update() will reuse tmp->new_cpus only after
 		 * its value is being processed.
 		 */
 		if (remote && (cp != cs)) {
 			compute_excpus(cp, tmp->new_cpus);
-			if (cpumask_equal(cp->effective_xcpus, tmp->new_cpus)) {
+			if (cp->remote_partition_updating ||
+			    cpumask_equal(cp->effective_xcpus, tmp->new_cpus)) {
 				pos_css = css_rightmost_descendant(pos_css);
 				continue;
 			}
diff --git a/tools/testing/selftests/cgroup/test_cpuset_prs.sh b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
index 644cf0d2a7c48..b7ddebb6eebec 100755
--- a/tools/testing/selftests/cgroup/test_cpuset_prs.sh
+++ b/tools/testing/selftests/cgroup/test_cpuset_prs.sh
@@ -278,6 +278,7 @@ TEST_MATRIX=(
 	"   C0-3    C1-3  C2-3    C4    X2-3   X2-3  X2-3:P2 P2:C4-5 0 A3:2-3|B1:4-5 A3:P2|B1:P2 2-5"
 	"  C4:X0-3  X1-3  X2-3     .      .      P2     .      .     0 A1:4|A2:1-3|A3:1-3 A2:P2 1-3"
 	"  C4:X0-3  X1-3  X2-3     .      .      .      P2     .     0 A1:4|A2:4|A3:2-3 A3:P2 2-3"
+	"   CX1-6  C1-4:P1  .    C4-5     .    C1-3     .      .     0 A1:4-6|A2:1-3|B1:4-5 A2:P1"
 
 	# Nested remote/local partition tests
 	"   C0-3    C1-3  C2-3   C4-5   X2-3  X2-3:P1   P2     P1    0 A1:0-1|A2:|A3:2-3|B1:4-5 \
-- 
2.53.0



