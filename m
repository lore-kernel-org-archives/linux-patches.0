Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622687;
	b=r3UqIs2bvLvpP8FaiHqH1qeaft6v7oFEUitOc8Hwij1gCR0Qr3i2+MlwoCGDpNJ4rmrC
	 ForOUXpnOmtpcK+sf9pnCjcdEQcjlObebTrCvVdC2SQviTne2NEOB70ebnaUKSQZo2Px+
	 wCpM9kHxb8BglCPU7COKE/ijGtL91mj7jK/dk2ClqoMphl8OZ35PeDnYdOswCGlisIjZU
	 X/HiscC5lgc5PPEJ6gi+QccQOrtigB8Srs+GIWroo7GTD2lp8cP4rLKoMUoxjiYPWE44+
	 Nz1N5QGbTBgAYLKxLphrmlTRPUiZKwVTFl0UYSrSfrbJwlPr5YbMEI7+/qp3V5yY5SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622687;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vYt0raEB/vxBoehh7iLl2GBH+a2aH88/3Np5ceEzHxM=;
	b=gVHZpdzo3jqN1+ZsgA2GLhCQArtAcwHVuo3UkWS4qKDNsGRR33MV6TYzHvZTCUJjB0V4
	 vF5xAbt0Guzoy8YXFnQYw8hwbWprk73/CAia01RCkHEoKddA/IsE503LWwsVqmIY5+19P
	 +kVvmf8w4PrjGgkZLaPWRtReg8gW7WLuPzMPH1bY0Wexy5ffRRwepx4mRo0SbETzAatZK
	 WDs+Syo3PS+/ZGvDR0My1FvNnC7NfWZIOYldVWVu9AC0BDukToyWxB3RD2NGQkLQGBHj7
	 dUEdD6I4yhdRNawjEoj6KZ0mv4rXGgkFS1mwFpqgBmAgtrQ4D24ozj79+hnhk8h9x+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xJWbEX/W";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DB3606A31E;
	Wed, 25 Nov 2026 16:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xJWbEX/W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E4D1F000C4;
	Wed, 25 Nov 2026 16:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622686;
	bh=vYt0raEB/vxBoehh7iLl2GBH+a2aH88/3Np5ceEzHxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xJWbEX/Wr35o5rvPw8FOKj9D0RcCIPl7hWpbD0FFVqD4eujT57eUmz7/kYeNg7YdC
	 WsAJ2JhDdw/whNPv8PhD5nmBlN9N2TosU23ITBRlLy8Obh+Zb+NnrFkVjWZ3qRnwiT
	 i3vaAO2p5bFQXUrS6YT1/RtZ8fIJ3pce2dMzrVLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Waiman Long <longman@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 616/990] cgroup/cpuset: Properly disabling partition when partition state switching fails
Date: Wed, 25 Nov 2026 15:33:03 +0100
Message-ID: <20261125143836.524276745@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

[ Upstream commit db27a748a399e24af715c54c12a7e928e32d15b0 ]

Before commit 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full
don't leave any housekeeping"), the partition state can be freely switched
from "root" to "isolated" and vice versa. After that commit, the switch
from "root" to "isolated" can fail if it exhausts all the housekeeping
CPUs. Later on, the switch from "isolated" to "root" can also fail if
some of the partition CPUs are boot-time isolated by "isolcpus".

A local or remote partition is made invalid when the switch fails.
However there are 2 problems with the existing invalidation code.

 1) Both the subpartitions_cpus and isolated_cpus are not properly
    updated.
 2) In the case of remote partition with remote_partition flag set, it
    is not cleared.

Fix this by calling the proper partition disabling function in this case.

On an x86 test system with boot option "isolcpus=10 cgroup_debug" set
and more than 16 cores, the following commands were executed after boot.

  # cd /sys/fs/cgroup
  # echo +cpuset > cgroup.subtree_control
  # cat cpuset.cpus.isolated
  10
  # mkdir A
  # echo 10-12 > A/cpuset.cpus
  # echo isolated > A/cpuset.cpus.partition
  # cat A/cpuset.cpus.partition
  isolated

Before the patch:

  # echo root > A/cpuset.cpus.partition
  # cat A/cpuset.cpus.partition
  root invalid (partition config conflicts with housekeeping setup)
  # cat cpuset.cpus.isolated .__DEBUG__.cpuset.cpus.subpartitions
  10-12
  10-12

After the patch:

  # echo root > A/cpuset.cpus.partition
  # cat A/cpuset.cpus.partition
  root invalid (partition config conflicts with housekeeping setup)
  # cat cpuset.cpus.isolated .__DEBUG__.cpuset.cpus.subpartitions
  10

Reported-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/lkml/7f4c57b26ad120ab30adf35653f1dd94@kernel.org/
Fixes: 4a74e418881f ("cgroup/cpuset: Check partition conflict with housekeeping setup")
Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 4a38da24c3612..751ea3d6dcc0a 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3140,6 +3140,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	struct cpuset *parent = parent_cs(cs);
 	struct tmpmasks tmpmask;
 	bool isolcpus_updated = false;
+	bool disable_partition = false;
 
 	if (old_prs == new_prs)
 		return 0;
@@ -3200,15 +3201,21 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		 * Need to update isolated_cpus.
 		 */
 		if (prstate_housekeeping_conflict(new_prs, parent_prs,
-						  cs->effective_xcpus, NULL))
+						  cs->effective_xcpus, NULL)) {
+			disable_partition = true;
 			err = PERR_HKEEPING;
-		else
+		} else {
 			isolcpus_updated = true;
+		}
 	} else {
 		/*
 		 * Switching back to member is always allowed even if it
 		 * disables child partitions.
 		 */
+		disable_partition = true;
+	}
+
+	if (disable_partition) {
 		if (is_remote_partition(cs))
 			remote_partition_disable(cs, &tmpmask);
 		else
@@ -3217,7 +3224,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 
 		/*
 		 * Invalidation of child partitions will be done in
-		 * update_cpumasks_hier().
+		 * update_cpumasks_hier() below.
 		 */
 	}
 out:
@@ -3240,8 +3247,8 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	spin_unlock_irq(&callback_lock);
 	update_isolation_cpumasks(isolcpus_updated);
 
-	/* Force update if switching back to member & update effective_xcpus */
-	update_cpumasks_hier(cs, &tmpmask, !new_prs);
+	/* Force update if partition is disabled & update effective_xcpus */
+	update_cpumasks_hier(cs, &tmpmask, disable_partition);
 
 	/* A newly created partition must have effective_xcpus set */
 	WARN_ON_ONCE(!old_prs && (new_prs > 0)
-- 
2.53.0



