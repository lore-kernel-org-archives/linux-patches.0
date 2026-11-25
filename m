Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621713;
	b=XyI8GNCYzH8PMsQkOIPu7ZpZcbzhXens2HPJ3FaIBN6+mV9ZGaTr4b5dUiU4qs60Yw/O
	 jwRNIMf/M2+sLwOlw6+7bWb0qfnZ3MmulyJu7zH2BqrXghd3LDsou+xaEAv1PYGdhociV
	 bmPkChQyD1miwx3vTAZwYf8SXCcgxX+Zk9ecBf/DR0WgW3N0fCwQvIkHtC6IsVbIYElTU
	 vCT0KFVeyTI1Yx5+kw+Z1BZSobXI3FHfT4y5euDnLXM/lSR/cC8+8twGpU79VW2EdlZ+g
	 eXtoPOc217o0LyVqpGoWux3/5UIUKd7oKzWZQj5DSODUDMl/IUSdIJjrtBHNfpF3IEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SvFXQMfqZKQf5ZIJ7U7GvauEoK3Tr4JU6wr9uvyD9ac=;
	b=lVk0LMnNMFqvXJYWCKQW9kdfTRztbHNq5zEhrm5U76NFdbqBHFzGsc52sZrQ6eIIZK9n
	 MmZNYoU5vpNEF/uFXN1kRSJGOrP0bVN3SWyH6uMXkp7L07aAMPC60dLnoazVVlLWSBLA2
	 YkEvxf0XWHBxodCwK3Ase6AQbBrMhocwMSpDZFydYZMek+rY0DwpGFhnFpzn/Mto4JBLJ
	 90tEHwYAiKbUMRrJMcaPKEgGgebdZnjFSJvkjlhQcB0Zkb1wgkYkL9CVVKWAnPIbaiz4+
	 NWsPyiJFz8npzb0h25V2V0DKVE22FXUiwbD8IpZRzsKDF0GQhO7ZGVuft4U5gI0Rrlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y3pGhvYi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938A6606A337;
	Wed, 25 Nov 2026 15:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y3pGhvYi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E949D1F000C4;
	Wed, 25 Nov 2026 15:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621713;
	bh=SvFXQMfqZKQf5ZIJ7U7GvauEoK3Tr4JU6wr9uvyD9ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y3pGhvYiAVkjgdUjLzkLc3Y8gr9yp2qH60MI0ju674bc2k2EVR0WweRpRmoRTEWKs
	 btY+zb1d2yFOJWtPvajO+jvT9IAkbln87/8Mtj4/wo7Br+5xObpX7J9bcX2qgqOR+4
	 OwIjXQuIT1H7j+RkP9igXiOlKrrRr5BcRlpU9YGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kayra Cizmeci <kayracizmeci@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 314/990] sched/topology: Balance cluster static-key updates
Date: Wed, 25 Nov 2026 15:28:01 +0100
Message-ID: <20261125143829.447999089@linuxfoundation.org>
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

From: Hui Su <sh_def@163.com>

[ Upstream commit 5ebdfe12ab96368d0339593129d4ce0bc2bd06f5 ]

build_sched_domains() increments sched_cluster_active once per newly
built partition that contains an SD_CLUSTER domain.
detach_destroy_domains() instead tested the global static key before
decrementing it, so destroying a cluster-less partition could drop a
reference owned by another partition and disable cluster-aware
scheduling while SD_CLUSTER domains remained installed.

Check the installed domains before detaching them, only while the key is
enabled, and decrement only when the removed partition contains an
SD_CLUSTER domain.

With two cluster-bearing partitions installed, removing a singleton
partition left the baseline count at 1 where 2 partitions still
carried SD_CLUSTER; the fixed kernel correctly reports 2.  On an
asymmetric cluster topology where the parent partition gains no
cluster domain, the baseline count drops to 0 while a cluster
partition remains installed; the fixed kernel keeps it at 1.

Fixes: 8881e1639f1f ("sched/fair: Scan cluster before scanning LLC in wake-up path")
Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Reviewed-by: Kayra Cizmeci <kayracizmeci@gmail.com>
Link: https://patch.msgid.link/20261021043834.1140951-1-sh_def@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/topology.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 35478aa2536fc..e3bf754e081c5 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2714,13 +2714,25 @@ int __init sched_init_domains(const struct cpumask *cpu_map)
 static void detach_destroy_domains(const struct cpumask *cpu_map)
 {
 	unsigned int cpu = cpumask_any(cpu_map);
+	bool has_cluster = false;
 	int i;
 
 	if (rcu_access_pointer(per_cpu(sd_asym_cpucapacity, cpu)))
 		static_branch_dec_cpuslocked(&sched_asym_cpucapacity);
 
-	if (static_branch_unlikely(&sched_cluster_active))
-		static_branch_dec_cpuslocked(&sched_cluster_active);
+	if (static_branch_unlikely(&sched_cluster_active)) {
+		rcu_read_lock();
+		for_each_cpu(i, cpu_map) {
+			if (lowest_flag_domain(i, SD_CLUSTER)) {
+				has_cluster = true;
+				break;
+			}
+		}
+		rcu_read_unlock();
+
+		if (has_cluster)
+			static_branch_dec_cpuslocked(&sched_cluster_active);
+	}
 
 	rcu_read_lock();
 	for_each_cpu(i, cpu_map)
-- 
2.53.0



