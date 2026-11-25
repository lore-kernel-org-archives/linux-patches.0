Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623211;
	b=Aq7Rk4iF7t6jx+luPGNP3tbsQo1BrTCU32zE9sIN0EKLd0c7UDOLpzGEx2XfvfjgzNXl
	 jbhh3ph7s3PXWCPzxLjYmaglHWtHaVkK1jxb2/7IIYAw2ez8KjhPrW35sqgmg0J1JBMZn
	 YvRV3U/uyhRZImb8b+1SpBF9V6Gam+Xc+TS8idmusnys5shGKAx38gT7kMYQ0/hvv93hU
	 P4ohQubzNylEd8fV6EpY249G0UlVX+dzDPqyUApNMT0s/iqgLnZ7hC26uYmu3D9/CD/rm
	 AEoxOWiCmy1JGPRMU6JzzzzYG2bzyjiaZfKnnAt9uXvJ8aHyMcwMd1dyN9R1le0UsKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uKWaBIwJM2WQtuMVIK5wAuH62X26NQhfa0CzFhL/ocg=;
	b=e+gP7dxOL65NTSSNmX8PXWGjYr71xIZyKoPjKKYU5kTGuCz0AgG5eqTqua8XfrwNkyPe
	 RVel/Cn2AZdLKt2CZuAcACvTTmKUiYv6lD2fBXfuGce+h+zNa8Rx6DTqUo7BpNs6oAYCb
	 fBWt/qU0WNuVBpkzFr0xvTSKPPbHsTPZEZt1in+5CQNXadgrOL9nADLXnyGDbiDsIr7CT
	 FfJSEHxyZX0U+lT9EqDMtC2WAMkqFmRSNkf9HIAawiivVOtM1Av3T1PPYdYc74FXMNu0k
	 YpPe6TG0w8IA7OdnWpP5bGML5hJtZegw0vVSy1hYCYlH/3XYFW3g89ryzkWPCv8413w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iY/S8Aa9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2CC606A323;
	Wed, 25 Nov 2026 16:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iY/S8Aa9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74DA1F000D1;
	Wed, 25 Nov 2026 16:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623211;
	bh=uKWaBIwJM2WQtuMVIK5wAuH62X26NQhfa0CzFhL/ocg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iY/S8Aa9x4ebdIiuH9lgPCpQ7N+TZF5jrqJL51H+aVeFXpkvpcVGclaXh5LrqyA3f
	 tpIdRyPhnv6OAoQrrA2XbXoBNYGvOP4SrhBBLtoNuNGhFsWDSIPdM1QXCdN9EOEMZ6
	 72+wLo5VUugC0szxc3dAmvBAvx6yTM8wnD2De7+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ridong Chen <chenridong@xiaomi.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.18 741/990] cgroup/cpuset: Dont revive invalid partition without active CPU on hotplug
Date: Wed, 25 Nov 2026 15:35:08 +0100
Message-ID: <20261125143839.421570662@linuxfoundation.org>
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
@@ -4164,10 +4164,10 @@ retry:
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


