Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042363;
	b=GTm9oBmjlkoIcABcLfuzgn9id48rjFALrE//7GdEOwj7JuQv9hLpy6ZAhRLg/fKK4AV+
	 NSwFdlz5qtSvvIE2J+JveRXJ8G3AbcAuygha1YsTle3TJ79ZHvrzTrbksRxuXBEGXE6co
	 2EZLfmg3Y8rDkIH76iZvaW3aVoa+yu8EN3j7O9xCoqvwbmYyqAwcmTmHGQ8nZEJyenFMB
	 J3OntjxxJ+DIYrtquCpjx3ZeRd7sVbQXBS2gDG8tywLOLD32WYwv2/y0wj79kYmKpJ4OP
	 //sGQArqEeOOqoJ/3CNWwhulboTPbRbcQpRqyhl/4eoqq0G1hZPBM1FYsasv+w+1gqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ns6C0I0gQz8ZOvZbQeD3dPBofg5dv3eDT6rVDBInSCE=;
	b=5cRkBostNOGnM28wtq+D0HgRtWNa5aXJNkAp0S05MOmlG+LXR5PC4Dn6R1wgppY8wf2g
	 r9ZyMH1fjK8hqnEywXuQC0txhkuTR0F5MVsFAB0H4zILqZinXpLmXwTxBh0UwMiIos30d
	 mDbeJ1eOq2Gbof9Y+dvHOeTtffOrG9jriBNf6l7x+89N9KVV3ovV8vJsX70tbDC2i5Xjk
	 lzL0b6MRc1ZfLyEL+Jir6RnCaQYLjJtyKObedJTEy1FkvMixNl9t8vW7DNyEkYEzG9xD3
	 yWrVXzRG6JOdeoOS8ZAtOQucS4+JASca3hL6cVFy6l6IG9FaYE5+VGV4SnPJe+rbMXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g3ZEBhta;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF28606A31C;
	Wed, 18 Nov 2026 22:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g3ZEBhta
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B527F1F000C4;
	Wed, 18 Nov 2026 22:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042363;
	bh=Ns6C0I0gQz8ZOvZbQeD3dPBofg5dv3eDT6rVDBInSCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g3ZEBhtaOcHr8+QoaFY1MID1vDvNnnPQiFZHCuXoE9rk5y4tbwPhUhZ2eYGk4tZAU
	 hbl3GBe+TwnBGy5WmJKa3wgxAIr5LUgwFZZ+NKzhGcYPLMtxHCc/bwUr0GhqpVABYr
	 WXV9gYVp7OT/KrHkWMbsFJ74A1O9+Vx7rri9c3cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3143/3318] cgroup/cpuset: check effective mems for a movable-only configuration
Date: Wed, 18 Nov 2026 16:02:45 +0100
Message-ID: <20261118150454.163295954@linuxfoundation.org>
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
index ed6b57e25b904..7ccc0c3845ccf 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1967,6 +1967,8 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 			continue;
 		rcu_read_unlock();
 
+		check_insane_mems_config(new_mems);
+
 		spin_lock_irq(&callback_lock);
 		cp->effective_mems = *new_mems;
 		spin_unlock_irq(&callback_lock);
@@ -2037,8 +2039,6 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 	if (retval < 0)
 		goto done;
 
-	check_insane_mems_config(&trialcs->mems_allowed);
-
 	spin_lock_irq(&callback_lock);
 	cs->mems_allowed = trialcs->mems_allowed;
 	spin_unlock_irq(&callback_lock);
-- 
2.53.0



