Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624616;
	b=Sb8UhyyzltInJq5cfxrwayjrW+rLAihil0eGn+XwdarugmftYDjDvLBCb9Ad+l03W5QC
	 yzCCqzaeMHrBn4kkTdUVXi16ZHGT8bn5GhZjgOFtkFXeoWwXpBwsuV9J+XXU1aImMb4v2
	 lzEWTXU6qgV5gCPlHpzcNNA4BZRvWez0TT3GDKKVRbERmoZHCLXME1t1NCmttX18HnUzY
	 yLJxyL0ljdif9tOwBucYUw9P9Z+7kwld9mnvp0bE1XPmN8+VVJfcXPEUwFnx/fXwbK64Y
	 1VH4MJOePZZ1lsuWJkzK6brbMjIL9U03IeWp1S28dz2Y3z7b+ik3x+jaAE1M2uM2hiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FQMzPEzZoDoNXHZAPt4V82UkXFQJadKbbwRNuFgix1k=;
	b=1bu9j4DzxcoE/RAxov3Kvivp83tci0HozjO24GJ7J4NhxCCCQi6qzNgEgUpb115M8Eij
	 +px6feqmPgKiUYbyiUB/cVEx12tb0GhIS0ySEz1xO9YqcHkOKdMh2e7AMBNiHoU2sm8sb
	 6PyRxHLcZcjZ6ENIaRFyBZSyO/yUBj8Y+YNSpS7yCX+otfKjD6PlGzW2WA7s5xD55LHHM
	 StSsCfd3FMozKVB5PvUAzTpE+F7NSiuSVY0zgnAsvOzvZmF2n+BFcV5cstnuMGMJ7y2/Y
	 Drzjn87lu/NxRiq9aNteCLXmgwV5ZRpYAZ9p3RC8hJPrhGaV3vVxrdmDPDmQlKn3osw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2uq0ht/M";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8413E606A33C;
	Wed, 25 Nov 2026 16:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2uq0ht/M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E891F000C0;
	Wed, 25 Nov 2026 16:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624616;
	bh=FQMzPEzZoDoNXHZAPt4V82UkXFQJadKbbwRNuFgix1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2uq0ht/MGruTwT9ZVJ1nYeCf8kKYvv2XMOFXpsJnrljrrPl3ZS2mR2Bm6RiqxGUPD
	 8i7wihDB2iPt6n1aaQktr3OgmiBT4WIrohwiQitib6KRFAMjscXI04o1imGHy/hjq7
	 WvOId/np59GliRLUDrOj2HiPz1HRaaeXzX9Ruynk=
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
Subject: [PATCH 6.12 251/816] sched/topology: Balance cluster static-key updates
Date: Wed, 25 Nov 2026 15:29:59 +0100
Message-ID: <20261125143855.019662111@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index bd8b2b3015709..b909f56dcaecf 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -2635,13 +2635,25 @@ int __init sched_init_domains(const struct cpumask *cpu_map)
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



