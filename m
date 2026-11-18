Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032775;
	b=tX5E7zzh6MK+Vtgap5WEoBJZ7kVSG0y1Gu3Z5xkQ170Qdn5Gk930M8/FqzxnFhOkz4GI
	 Vau9p1LrlcQRkcO/ZZbWUDgyHpVFywwoA4ahfk360QZu1YCUpM3BC4aEyeUukGhZeA9Mz
	 yK0XLSkrudCAEQfEru3s83+OIcBdWhvTriCNQUk0MlUU7/0/uQjLjJSCFkQl7yAvQKft1
	 tO1O4/OczZBVlFOBjN2SPuSbJsB+/hDRPKyZh4sH2VcuSDdUL/jN9W49fYSLMwpXsrENC
	 bGc2ofGi52PnSTDmxTfyZlnQx9cyQ8FBANf+TXZFEPspI946muAZQgOWR0gfPP1pnxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=be+J8MSPc6deLdQYZ0Y776h9PipEyDPIFby8SleMEcE=;
	b=r1yd7EkhEOAD1OvnjGwHfNxS4bhDHzIR7aP7iF/gtE7lhrPGGxwPufR3oUV169OMLceI
	 0Fo72Kdk1favyUTv62J+0eKrhbF0X3eB0oTEiDeyMv2aLUfP3A3rnObBrbBhOXqlNXCiq
	 kEHxZV7eWuf6lq8w20UqFO8mPaY4yGsIXeMUWwjTABcbyvjngiWadzfDLPTc/kPeOA2sy
	 DHMTK7UChrg/HmBEBqYUJAog8g0LImIYf0lGZ8PfVewYFPSqiE727VOuxQ1gMbU+zrbhY
	 QcPcmDodN0JftuA1oBmvAWzvmk+cQUiu5zVPCOJFcPEkPRvsMz5BHRTnmN1gqerdGIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cSMFQZ7/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D296F606A31C;
	Wed, 18 Nov 2026 20:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cSMFQZ7/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7CB1F000C4;
	Wed, 18 Nov 2026 20:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032775;
	bh=be+J8MSPc6deLdQYZ0Y776h9PipEyDPIFby8SleMEcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cSMFQZ7/wiMNfd9k0CqQesPR/BsXkW5pA8JocIFEKhF+utdXzlp63rd6IbvxP7o/V
	 PzNEL0StmXhiwF1KmszsGAXGcnnp0Jni0Wakli6+s/46ozfkUusie5zBD8Z/8YHOpu
	 gQSVGKfvZZv1SHj2OFw/JNPmL9O9zfnw9jVN/5Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1531/1756] cgroup/cpuset: check effective mems for a movable-only configuration
Date: Wed, 18 Nov 2026 16:00:58 +0100
Message-ID: <20261118150109.930023672@linuxfoundation.org>
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
index 0f21e72703346..e11c70729e0a4 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2721,6 +2721,8 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 			continue;
 		rcu_read_unlock();
 
+		check_insane_mems_config(new_mems);
+
 		spin_lock_irq(&callback_lock);
 		cp->effective_mems = *new_mems;
 		spin_unlock_irq(&callback_lock);
@@ -2791,8 +2793,6 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 	if (retval < 0)
 		goto done;
 
-	check_insane_mems_config(&trialcs->mems_allowed);
-
 	spin_lock_irq(&callback_lock);
 	cs->mems_allowed = trialcs->mems_allowed;
 	spin_unlock_irq(&callback_lock);
-- 
2.53.0



