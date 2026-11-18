Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056780;
	b=WNRbUFBq80JlQagRQus1aQjGv9m1KHt539l9h85fz0jIJQ0Va3QxIu3ghzCbkkG9pj0s
	 QnZsVXGCqIIVG3Vpqr/N0guZ69y/cGGyIkndXULZRtnR+Kyl1V5JcopSYSMr31KdZtfc3
	 JVkxo5sebhU26f+XdgqV8wCnHM/orUJAs0zYnxFTv7FQVHWkaRhHFY2c3UPAwduJEzoSG
	 OZyc67K3aS7/iCZl7yb0kv5QsKsL/L8+rkpWuXOIPjsCiJTOh+oSYqNNSXja8MIMwlRjH
	 inBbKCRAw2wkoXDn3yPJu+RSb3TawWRLAk/TEOgWvj3xb//QibJKV+u3UotaGluz9qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uRHeiL/A0fV/xUZC6nlLv1aO9sMJX+V8Bh2xOIQia0A=;
	b=UYDd0mWYpDdfMMIkurFZr9sT/5VrakUbuBpPXNzpDtin/E6q+baB2MbOjaT5vCK1qbpC
	 62tucBWhvqNWn1dXj3diMqMtjb8NyqdI5S8bC23SBIroujeriQX3XwzBTXxphQUaI6F16
	 KGcSHxsmwAp2cgIszh0X1AzpfL05zdgxgf4Wn2l3rwdSUbwwUVTonKnEmzowqR2P8i0TT
	 AwJkkz7BTRNdk8NnNRDBco5JkDaPozxjbdn5DB/9jo3oJy4Az2QgYmx6ZFpwd7iMqfWO8
	 Agw9WGhIi/+O3hvyqXY2rk32OfzO/d6J3QsxJyCa4SC//Tzsa7T7kOnxYYImP2Zo58A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KFsJDoMk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EEA606A325;
	Thu, 19 Nov 2026 02:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KFsJDoMk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98141F000C4;
	Thu, 19 Nov 2026 02:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056780;
	bh=uRHeiL/A0fV/xUZC6nlLv1aO9sMJX+V8Bh2xOIQia0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KFsJDoMkGjZeaMXcj2hkfjkQbl/fmrevIML9qeIYXGGh1CJF84ukKefYes/v1BoI8
	 0XHM3lcwiqei5oPRUAN+S8kfUrH+y8NaiPCcmIi7TrIpPpYy5sYFIXUStDcHmjD95A
	 t0YFMNrjE/FRB4gFe2RPObJU4mihwcpFCIuQOKDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2109/2214] cgroup/cpuset: check effective mems for a movable-only configuration
Date: Wed, 18 Nov 2026 16:03:05 +0100
Message-ID: <20261118150134.991195913@linuxfoundation.org>
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

[ Upstream commit 4c047bd0499602161959478b90e66f4c8e523c9b ]

check_insane_mems_config() warns and enables cpusets_insane_config_key
when a cpuset's tasks can allocate only from movable memory.

In cgroup v2 the request may name a memoryless node, which has no zones
and cpusets reports it as a movable-only nodemask.

For example, with node 2 a CPU-only node:

  # echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
  # mkdir /sys/fs/cgroup/test
  # echo 2 > /sys/fs/cgroup/test/cpuset.mems
  # cat /sys/fs/cgroup/test/cpuset.mems.effective
    0-1
  # dmesg
    Unsupported (movable nodes only) cpuset configuration detected (nmask=2)!

This is a bit confusing, especially consider mems.effective ends up with
a valid nodemask by-design (cpuset.mems is treated as-if it were empty).

Check each new effective mask in update_nodemasks_hier() instead, as the
hotplug path already does. The allocator's bail-out tests the task's
mems_allowed, which comes from the effective mask.

A request naming a movable-only not present in the parent's nodemask
no longer warns (since, again, the cpuset.mems gets overridden and
treated as empty). However, it will warn if the parent's mems include
the node later.

For Example, with node 3 a movable-only node:

  # echo 0 > /sys/fs/cgroup/test/cpuset.mems
  # echo 3 > /sys/fs/cgroup/test/child/cpuset.mems
  # cat /sys/fs/cgroup/test/child/cpuset.mems.effective
    0
  # dmesg
    { empty }
  # echo 0,3 > /sys/fs/cgroup/test/cpuset.mems
  # cat /sys/fs/cgroup/test/child/cpuset.mems.effective
    3
  # dmesg
    Unsupported (movable nodes only) cpuset configuration detected (nmask=3)!

Fixes: 8ca1b5a49885 ("mm/page_alloc: detect allocation forbidden by cpuset and bail out early")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Waiman Long <longman@redhat.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 791d19f6b35c6..eef17c5aee760 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1868,6 +1868,8 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 			continue;
 		rcu_read_unlock();
 
+		check_insane_mems_config(new_mems);
+
 		spin_lock_irq(&callback_lock);
 		cp->effective_mems = *new_mems;
 		spin_unlock_irq(&callback_lock);
@@ -1938,8 +1940,6 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 	if (retval < 0)
 		goto done;
 
-	check_insane_mems_config(&trialcs->mems_allowed);
-
 	spin_lock_irq(&callback_lock);
 	cs->mems_allowed = trialcs->mems_allowed;
 	spin_unlock_irq(&callback_lock);
-- 
2.53.0



