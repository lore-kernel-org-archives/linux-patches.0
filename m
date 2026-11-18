Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017967;
	b=0/qFVz80lJML8CkRVb8QI7ILM6Pbz9UM3CNhGBi1SrkinMK4s3/ZZUTfMrqMrTGsQ4Vw
	 +pEEGB3QtdVfekfJaG3YEgnX5l1oZIW2KmbajNFWF+E158xeqd5g1P75KjNB0AgwbXqMg
	 b9MwCx5vJI+K1PCHHfm+JPXZVLpHXytWpfl8lS0lUvRvLa4M2gq4vvbkburrklHzksxOp
	 Z3Btr6K1qsjHppZ9IGbsq6+PT3zZIw/gjuuNiYysVlNHJ+S3vppX2pbntMMwvDItnGcv9
	 z9QiJFWikssbvalROE8K3oHhIIWymQW8eI3rRmMu2nvbOh9wRSstwH6p4u/pXg6aNjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=GehZG+DPjpxivVCuSaEHqYWYD2IeoUXmcs2LyOT/+ls=;
	b=wjO7wyaJUBMBWnib593B5f1Rr21F+PKiNx37YEhHWh+gmW7hfzeOkALe9vzn2wL8XNAB
	 rmC1Clftt7JZ5/PeSvWHAmbEV5POZWv6WBCQDvU7DXfh15fsCqukEZ/DAXMwwNyZ+ualI
	 kh7jAYkcO/I4knJijzYsRGXyoQyh8johtILc0klUKFCbEOB5drm7hBnkWra6XdOBLUdQ0
	 RCqs6DlLLN0TA+z9Y9XpmAp4RCkb2QSW/Q/RWrqbePkGhMGsVlF7h/B0/XK8xSyCeggyB
	 TYtVqz/teasnDJ8pukMO0DK6hdxfG1pSK4ruxRTuzQJkDeC7yk7ZnG42ir59MvzAh3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UxvStrpI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7BC606A31C;
	Wed, 18 Nov 2026 16:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UxvStrpI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356A51F000C7;
	Wed, 18 Nov 2026 16:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017967;
	bh=GehZG+DPjpxivVCuSaEHqYWYD2IeoUXmcs2LyOT/+ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UxvStrpIIF7CbeNnNODPDncO1llm8kkSlh8MR1NH73pe9kyKjVscJcNbnmDqkDYxD
	 Cti23iCF0Q9YqgQu444UdIdHF37kTGVBqkDzgeuPud9qOotftuGn6+Jnqaew7lOyfb
	 6Ur8er6Y91ke3V7+CHjVJSq1qGLvZtkaM/hLDuUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Andrea Righi <arighi@nvidia.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1072/2651] cgroup/cpuset: Use cpuset_v2() in cpuset_num_cpus()
Date: Wed, 18 Nov 2026 15:38:32 +0100
Message-ID: <20261118150326.577052946@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 5ffe20411787dd9947a35669ef8cb9484053efcf ]

The cpuset code has 2 different helpers for determining if it is in a
v1 or v2 working environment - cpuset_v2() and is_in_v2_mode().

cpuset_v2() checks the binding of the cpuset subsystem is on a v1
or v2 hierarchy. It can also help to optimize out v1 specific code
if CONFIG_CPUSETS_V1 isn't defined.

is_in_v2_mode() layers on top of cpuset_v2() and returns true if it is in
a v2 hierarchy or in a v1 hierarchy with "cpuset_v2_mode" mount option
enabled to make "cpuset.cpus" and "cpuset.mems" behave in a way similar
to their v2 counterparts. However the cpuset hierarchy may still be a
standalone one separated from the other cgroup hierarchies.

Commit 90ac22ffef48 ("sched/fair: Add cgroup_mode: max") adds a new
cpuset_num_cpus() helper to return the number of effective CPUs in a given
cgroup. It is part of the "sched: Flatten the pick" patch series to help
flatten the cpu cgroup runqueue hierarchies. cpuset_num_cpus() currently
uses is_in_v2_mode() to determine if it is in a v2 environment. However
is_in_v2_mode() can be true in a v1 environment where the cpuset and cpu
cgroup subsystems can be in two separate hierarchies. The current use
case [1] for cpuset_num_cpus() assumes that it can return the number
of effective CPUs present in the current cpu cgroup which may not be
the case.

Fix that by switching to use cpuset_v2() which signifies that it is in
a unified hierarchy where both cpuset and cpu cgroup subsystems share
the same cgroup hierarchy if it returns true.

[1] https://lore.kernel.org/lkml/20260930081125.GF88198@noisy.programming.kicks-ass.net

Fixes: 90ac22ffef48 ("sched/fair: Add cgroup_mode: max")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 4a8166101a69a..ab3b4ee27d3ef 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4337,7 +4337,7 @@ int cpuset_num_cpus(struct cgroup *cgrp)
 	int nr = num_online_cpus();
 	struct cpuset *cs;
 
-	if (is_in_v2_mode()) {
+	if (cpuset_v2()) {
 		guard(rcu)();
 		cs = css_cs(cgroup_e_css(cgrp, &cpuset_cgrp_subsys));
 		if (cs)
-- 
2.53.0



