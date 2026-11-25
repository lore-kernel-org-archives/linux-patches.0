Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619045;
	b=Jtpa5BkYI3377kDnzil7pKeamgUL40M9WiS/X5qxGQhP0K3UiWOlZzBcrjL5vMfxczNT
	 NVWIVcOxTQ6cOohBYueftKgumy3aohrLpHI/NLaI3Yx1gOELP4sq3CudzGIP1Q9XS2HJy
	 VZAcnmpiQxq0Qu+37Sf6Kgi4GgL19KpFBSWe7KY0uJle9eLt3Z/jErqzCEbHjsYt8v+B5
	 Q2mZdDiw3NQVfG6RMFercCs8fCnyWSBql3IQjRvJjm186foDMovFBPJkN7OQc5vcesA6N
	 M4FGiCKW3zbaFRDGR0h4TR4+p6SJ5/eR2Z0p+ybRI0PR65SaSolMQt3zPYEnw7ZpLcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=psO8cFdBmYwPTHLoXe6lA6LRLKwbCPWAshqMkt11AvE=;
	b=1VZAUeBvDOcJ9zCwtskmLwG0H9VFRVasdXd0D2sBOEZohzEObFY1zoSsYG23zfUOTcNc
	 1C0PFJwpr1AvtkdW9sMzLXsfRs+u0irmVHfkla/hv+u6pFLaKTkHNIQpYWXZ7Q+ZGI19f
	 uA71/gePtqj59qjsNkPC8HmFMmnWoo5Z7lTo7xJw/1jb0Rwux1twEeMcNoHlY0MZzwuv3
	 hX7PVeVkq/VZIGGJzBXweC0r3hEQE4Sj0MjBAK0WAefCTWkGqKmrq8NOx5umuwruXy/7e
	 /tZEjDUaA1gE6Km6hjQ+AjQucooVSCNahNEI0mOpF7HlKknUJp5VaPoQveY/wB5aczQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e7JvoU2H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A167E606A31E;
	Wed, 25 Nov 2026 15:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e7JvoU2H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11E31F000C0;
	Wed, 25 Nov 2026 15:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619045;
	bh=psO8cFdBmYwPTHLoXe6lA6LRLKwbCPWAshqMkt11AvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7JvoU2Hiq5jG4qhWQLOv4gG7CpaSewhVqUJ/FAHp3xLaTTIBxTICo5zj88GUCK9Q
	 QS7iE4TMQIBzE6PuGDWYyo6Dp50cl0e5yAky+jjoPFFfz6sHqGJytokWjJ9ejrzt9S
	 RysMR2hbiFMTpymuZsxf7YyeJO3oxUh4/on8w47g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0472/1005] cgroup/cpuset: Protect current->mems_allowed read in cpuset_fork()
Date: Wed, 25 Nov 2026 15:30:10 +0100
Message-ID: <20261125143832.802232904@linuxfoundation.org>
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

[ Upstream commit a25cc4c75fdd8921f160bc3950665889eba7374b ]

Reading mems_allowed of the current task outside of cpuset_mutex critical
section should be protected by using mems_allowed_seq seqlock as the
nodemask can be updated concurrently leading to a torn read. Such
protection is currently not implemented in cpuset_fork() for the
!CLONE_INTO_CGROUP case. As a result, the child task may inherit an empty
or corrupted mems_allowed nodemask. This violates NUMA memory policy
constraints and causes subsequent page allocations to unconditionally
fail, potentially leading to crashes or spurious OOM killer invocations
for the child task.

Fix that by using a read_mems_allowed_begin/read_mems_allowed_retry()
loop to protect the mems_allowed read.

Fixes: 06f4e9489891 ("cpuset: make sure new tasks conform to the current config of the cpuset")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/bug/linux-601100b4-fa77-45fd-99f9-bfbd4385201f
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 8f0979b73e20f..67d79749a1444 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3980,11 +3980,20 @@ static void cpuset_fork(struct task_struct *task)
 	rcu_read_unlock();
 
 	if (cs == oldcs) {
+		unsigned int seq;
+
 		if (cs == &top_cpuset)
 			return;
 
 		set_cpus_allowed_ptr(task, current->cpus_ptr);
-		task->mems_allowed = current->mems_allowed;
+		/*
+		 * A cpuset.mems update can update current->mems_allowed
+		 * concurrently, so retry it again if it really happens.
+		 */
+		do {
+			seq = read_mems_allowed_begin();
+			task->mems_allowed = current->mems_allowed;
+		} while (read_mems_allowed_retry(seq));
 		return;
 	}
 
-- 
2.53.0



