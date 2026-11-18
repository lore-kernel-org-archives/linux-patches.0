Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062026;
	b=dOybZPmdUgYJi8q8cGoVJfGgzaYYf0RTyfMcd5SjUcFLIu8njp0A5pzRPAonzCh2PID9
	 Xu7QzSmkKmy+DZI97D9aP/4Xxvx/GENSXd0FuEUN05x3k8cWmrjkCvOuWpYKhIc5eWtVo
	 Znr14wmv+6/SCj3W1roeJcK1Gx+hJA7i+dK9OC1QcKqmbYetPZkzs4QWhgt9nOCtECl6B
	 Hbvx8217BcZHdF68RHtRyhz90j9iqiRsOjtxuc6f4sXX0XGtL8GSPfc1v8BjQ+sQ05Fb5
	 BP8U4ZXRHiAzzxvz1cDfqyDuC/95Kt8b9HfldSAGiRLdcb971bpfBDEsfFrgMmZgMgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aaYR9ybW1FiMczOIydyQaw7+OxQIz7cmWt8SmVYLP94=;
	b=0N7x/LsIyQD/J/b9mwHEzB2GR02K5fSky4v9zC0gS280hocGI7JiGB/hfEWtIFyjly9N
	 SYRaPtBjZCsQ3jF/fjKqgdlxJNqG6cPlVgYjFd+ThhBKar2kJgtG/PXUx59eJESyhQfpV
	 gisjrh6fTavN0V2dNsrss0bCONRcSy8h9D9brY1TvjnceQwWd495T7JRtgIlBY0FeRvI4
	 xs6OvCoCXaknfQAwmW2SliYUF8g7HL/vX+TxkSkGQJtTu9qPshbN4eW9GRiIADRJPf/ba
	 LXPGr32nNiOabzANwJoIWYlv3gcD4yklFJgGJzwvIz0cD/MBXJ5ZqCGJYp84fEBGq9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nvX4ETlf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A204E606A326;
	Thu, 19 Nov 2026 04:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nvX4ETlf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D781F000C4;
	Thu, 19 Nov 2026 04:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062026;
	bh=aaYR9ybW1FiMczOIydyQaw7+OxQIz7cmWt8SmVYLP94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nvX4ETlf9gmaZ0hYsAe81hEJlcVp1Y45LcuQNXql1z9YHWcuPX4ypLBFhdnexFd7z
	 7rSYS/2wn86WyfD7rDWS3ix4hEPtqUB4euMtE/zftgZLMnrrJ6MgU8ILrEfR5r7aNz
	 WXLtPpsRAXebJ3HBOQHDf5XTTas6HboVdesUHtd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1762/1848] cgroup/cpuset: check effective mems for a movable-only configuration
Date: Wed, 18 Nov 2026 16:03:20 +0100
Message-ID: <20261118150033.199433150@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 62b9ac240ec93..4c3bca699eedc 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1831,6 +1831,8 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 			continue;
 		rcu_read_unlock();
 
+		check_insane_mems_config(new_mems);
+
 		spin_lock_irq(&callback_lock);
 		cp->effective_mems = *new_mems;
 		spin_unlock_irq(&callback_lock);
@@ -1901,8 +1903,6 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 	if (retval < 0)
 		goto done;
 
-	check_insane_mems_config(&trialcs->mems_allowed);
-
 	spin_lock_irq(&callback_lock);
 	cs->mems_allowed = trialcs->mems_allowed;
 	spin_unlock_irq(&callback_lock);
-- 
2.53.0



