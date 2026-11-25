Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619730;
	b=iGWsjyBGNwbPs6SMcL90bskq3/onhy041QwHDL92905ZLGvlw9w8hd0lbflkE/LhZuYt
	 LdSfZguQNIDsCg8V6qCgx4DXqQYTZnbnGR2MEq3vvgezhtCHTthxbyXeQahqDgCmZqnwj
	 9nKCe3X+DGuEIlg4kicYLeEm0yXmCwyirg59nuLaVCMFhFe5PQDrIMOueDm3KNHwJZGfg
	 CLvd85sA51krF+KZm55keJYpvR5SQyi6P/z12yLgUEY/MaNUXNzxzs1/KIyIEJTTl9Itk
	 lZQ/98s+TSqqJmyG/vU4HOnfb9guNEEeS8mU8KvDVMiiFQ0dS975oFLt3/G88osN8rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BVsj+2XAEqNRnq449Yx7/0XAYcXZGz5B/yxecCXFeBY=;
	b=eeADYQP7B5ZbCMdpFFEexme0wGxmGPeR2vZRV6CCAFRhGpkQwyhEUMZHAYknmxEL4ur8
	 KUFDdEvhw1H4NnESSOm1MhAvubMUz1WY/b7m3TI8vGTN7ZbOjxWGlFVreHmbrxEAsMV34
	 PNGce10uW/X96TFwA86eqlDkmgcCtPNzyBgDRZxkihK5pVF1h9HLRj3bVfyjwQK8FvDDk
	 nShewji7rcfGrBCVpuACQj9Lwb08fx6mKzMxI8hBAkeT0rZrelBFCJH0ZsfR0WUvUDzQs
	 HCRNs/SETbEtm5n7tfwvJgwHMaU4AmctMxz4lztEYVgXCQ3ayNZQQIMUmrXmRu++4YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zw8I4+Lf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C21A606A32A;
	Wed, 25 Nov 2026 15:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zw8I4+Lf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6AA41F000C4;
	Wed, 25 Nov 2026 15:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619730;
	bh=BVsj+2XAEqNRnq449Yx7/0XAYcXZGz5B/yxecCXFeBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zw8I4+LfdLrNju3vMSrXLEPE3pSm9Zo2tQTpTaaqYWi9yu0hF1niHAW5RkL4PNt5D
	 RpN7tCrdGQHbVx/rwdTpzXlQ7Q1RL5qqETkOXtD4gsnH5OUuFDsUbNb6/fO7PrrIWm
	 uW5Ggoj1+fpBsyiXxTUbkf9vl+3AnE5jHcTcTpAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ridong Chen <chenridong@xiaomi.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 7.3 0688/1005] cgroup/cpuset: Dont revive invalid partition without active CPU on hotplug
Date: Wed, 25 Nov 2026 15:33:46 +0100
Message-ID: <20261125143837.868697722@linuxfoundation.org>
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

From: Ridong Chen <chenridong@xiaomi.com>

commit acec9637e03ca54bd3c3a0c1a6ad5c6dfa07c0df upstream.

When a CPU hotplug leaves no CPU outside of the partitions for the top
cpuset, cpuset_handle_hotplug() clears subpartitions_cpus and gives all
the active CPUs back to the top cpuset. cpuset_hotplug_update_tasks()
then walks the hierarchy and invalidates the partitions, as
subpartitions_cpus is empty.

However, an invalid partition visited in the same walk may be revived
if its effective_xcpus is not empty. tasks_nocpu_error() doesn't catch
it when its CPUs are all offline but it has no task. Its CPUs are put
back into subpartitions_cpus, and the valid partitions visited after it
are no longer invalidated, as subpartitions_cpus is not empty any more.
The top cpuset is left with CPUs overlapping with these partitions.

It can be reproduced on a system with 8 CPUs:

  # cd /sys/fs/cgroup
  # echo +cpuset > cgroup.subtree_control
  # mkdir A1 B1
  # echo 1 > A1/cpuset.cpus
  # echo 1 > A1/cpuset.cpus.exclusive
  # echo 0,2-7 > B1/cpuset.cpus
  # echo root > B1/cpuset.cpus.partition
  # echo root > A1/cpuset.cpus.partition
  # cat A1/cpuset.cpus.partition
  root invalid (Parent unable to distribute cpu downstream)
  # echo 0 > /sys/devices/system/cpu/cpu1/online
  # cat A1/cpuset.cpus.partition B1/cpuset.cpus.partition
  root
  root
  # cat cpuset.cpus.effective
  0,2-7

A1 can't take CPU 1, the last CPU of the root cgroup which has tasks.
When CPU 1 is offlined, A1 is revived without any active CPU, and B1
stays valid while its CPUs are also in the effective CPUs of the root
cgroup, which triggers

  WARNING: kernel/cgroup/cpuset.c:919 at rebuild_sched_domains_locked

Only revive an invalid partition in hotplug if its effective_xcpus has
an active CPU, the same as what is required to create a partition with
tasks. With that, A1 and B1 are both invalidated in the above case.

Fixes: 0c7f293efc87 ("cgroup/cpuset: Add cpuset.cpus.exclusive.effective for v2")
Cc: stable@vger.kernel.org # v6.7+
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20261114083124.1340140-1-ridong.chen%40linux.dev?part=11
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4179,10 +4179,10 @@ static void cpuset_hotplug_update_tasks(
 		partcmd = partcmd_invalidate;
 	/*
 	 * On the other hand, an invalid partition root may be transitioned
-	 * back to a regular one with a non-empty effective xcpus.
+	 * back to a regular one if its effective xcpus has an active CPU.
 	 */
 	else if (is_partition_valid(parent) && is_partition_invalid(cs) &&
-		 !cpumask_empty(cs->effective_xcpus))
+		 cpumask_intersects(cs->effective_xcpus, cpu_active_mask))
 		partcmd = partcmd_update;
 
 	if (partcmd >= 0) {


