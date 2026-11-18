Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020656;
	b=dWhtRs09bKpFgKEELs5UcAyvt4PajdnoJyFEBVsXL1nxa55XvJjry2pxC3Z702uUArg4
	 ZwcZZhGKa5EC1lswtfDGpOENHg7jZq9rVxXwNJOHQRsjOu0ALZsLDRf2+yt/1AmhBRrvf
	 b61eLgDjQ90p66FqueMK6TcA5EtsvuFu0eX+YSTJE94FQSnlmopG+gLb34DJeJGb6gTFs
	 WTNZWLxntxm6g+IlEYDHc5UH/KIjaWep3EOKY6w7YT2rG9veGeCIP/cHHkRQUIC25xeDm
	 ad0XXFTK51kRGm9BPpu4fAOgC9I/AD+IuoiVxHvGLA8em3Wqpi614Diu4L5Z/of0NKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020656;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UsOo0MPaeTaKNS2iR7WQnz5ZLaopB4g5nCZVCxU77HE=;
	b=sIuQpQvgdK6eELLSZpRW8+g9oT0P/V7aykoPTrVMXVYLPAGGHWtWn0cNE6oZR7lhc3xP
	 iucqrzeXrCLG2iVpQUzY4vEFe5JdRHiz3DsM1ZwO5o80mNsdIP1zowJQeMvU/oN3BZCML
	 jAPpDNkxGPAXP7IGiXoHYgWUOIP0gR7ik8yE6EptKX+VNjg2foF3jIZCMfxazyiyW0Ink
	 eiSFRtvD9bZZSUbS2dFQVB75+cfNuqWEtyzyjQkneGNwReg9KBD2EnWLEBzVF6l64TMru
	 AnD3+z1K6AvVW8Eue79LE12+t3Hvml2nf/ghDJZHjks/eHt4ehroBgMl9nWrSJ0MI3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l50CegC5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1630360A2636;
	Wed, 18 Nov 2026 16:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l50CegC5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D56F1F000C7;
	Wed, 18 Nov 2026 16:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020655;
	bh=UsOo0MPaeTaKNS2iR7WQnz5ZLaopB4g5nCZVCxU77HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l50CegC5ek4U5M7BXJ8xKkuWyZmJNsetvijV/MAPeh0+brkHkRjRQyQprKV57M5bV
	 xnZO51eQW8XkWsGxsAGsFP+SuMl7Atp6LwAKTqCd0Uyb0U/IBh/vqYskdE40t1eS9o
	 cUDqlJOndHTvBNlQz73a5Vx0C5F5VfOU03DJO0iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Jemmy Wong <jemmywong512@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2029/2651] sched/cache: Avoid publishing partial LLC utilization
Date: Wed, 18 Nov 2026 15:54:29 +0100
Message-ID: <20261118150359.205532728@linuxfoundation.org>
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

From: Jemmy Wong <jemmywong512@gmail.com>

[ Upstream commit fcceb7da94659695d6cba97190e18e87d9cce82c ]

update_sg_lb_stats() sums utilization over the CPUs in both
sched_group_span(group) and env->cpus, but takes capacity from
group->sgc->capacity for the whole group. record_sg_llc_stats()
publishes both.

Rejecting an all-affinity-pinned source runqueue removes that CPU from
env->cpus and retries group selection. The retry can publish the
partial utilization with the full capacity.

can_migrate_llc() then treats a busy preferred LLC as having spare
capacity. More tasks can aggregate into it, migrations out can be
blocked, and two busy LLCs may not fall back to generic balancing.
This increases CPU contention and task latency. Found by inspection.

Skip publication on affinity retries using LBF_ALL_PINNED, retaining
the first-pass snapshots and avoiding repeated cpumask checks. On the
first pass, publish either shared LLC statistic only when env->cpus
covers the whole group. Load balancing still uses the affinity-filtered
statistics.

The same window exists during CPU hotplug. env->cpus drops a CPU at
set_cpu_active(false), but the group span and sgc->capacity still
include it until cpuset_cpu_inactive() rebuilds the domains. Keeping
the previous snapshot avoids the mismatched publish. After the rebuild,
the next periodic balance records both statistics again.

Fixes: f025ef275388 ("sched/cache: Record per LLC utilization to guide cache aware scheduling decisions")
Suggested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Suggested-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Jemmy Wong <jemmywong512@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20261013084338.55100-1-jemmywong512@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 913630c0b0590..548a28e37d0e7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -12128,6 +12128,14 @@ static void record_sg_llc_stats(struct lb_env *env,
 	if (env->sd->child != rcu_dereference_all(per_cpu(sd_llc, env->dst_cpu)))
 		return;
 
+	/*
+	 * A redo repeats stats published on the first pass. Hotplug can
+	 * still leave env->cpus partial, so util would not match capacity.
+	 */
+	if ((env->flags & LBF_ALL_PINNED) ||
+	    !cpumask_subset(sched_group_span(group), env->cpus))
+		return;
+
 	/*
 	 * At this point we know this group spans a LLC domain.
 	 * Record the statistic of this group in its corresponding
-- 
2.53.0



