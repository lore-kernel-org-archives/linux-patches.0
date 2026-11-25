Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618658;
	b=n+RRcknBKmRhvC5cXnRHA3/K2wgud0NhLx9OVhCUr/UELvp+TzH52Jahl55cnlU/JCVT
	 ke+rdvIX1ukM89yKWpYfvQHHS8teRaPpXsZIfr/v8TAGb+eCajbX0Bta1j5gjTw2EZiHB
	 dmu70ZvNqKcxzMPDDjzQCFt90nbwHQLQFvvUXtLvwDXf0mEQnooePqDSVeG7xRw5ZftcR
	 /+fLfIvAexAttMM2Js13wchqS7vgXfaNuY4YyC41xJlg2HguNkgoThyvOcVUmE8QBuSa2
	 NfABA0YAGF7gTyzFsVyExhd6jfAyiU8STyp49aofhj0rTBVE+KmCYn6qwnxXEjKt9gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h2MYjWYviZSAV9e4K2oRc7SlY3Ohtp/o4CpO6O6NyYc=;
	b=BqCcbmAlq5RuFZcpmH10zqfKPpyRP3eclm8kZAC6lw6mLlYPneQoDNY6rDbU1U93GuZW
	 K3t25omrXj3XVTu4oQCWi8dqPfiebEBcuHubNlzEJAI4f6vwgC9hUXXC24/XI2thIUNkG
	 TBKHszokL4HYgbf6F0m7e902JJ7aBlyiOzgc5KnZfHJX5B23rXSjjkTceAie6NBd1IY7H
	 ukAcMIrtdtLIx5KkT+SxzZUhWUoLyHlT3VmX3KpVT088ipyguuPQfjnm7o/XVd0WEh/iP
	 CAAw2vqLC+FKo/1nnyIE18I7Zu/olmBq4cV1eSsDR9YUfDkhCbKvKKks3777eVnKHfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kW9WD9qi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D938606A31E;
	Wed, 25 Nov 2026 14:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kW9WD9qi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B651F000D1;
	Wed, 25 Nov 2026 14:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618657;
	bh=h2MYjWYviZSAV9e4K2oRc7SlY3Ohtp/o4CpO6O6NyYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kW9WD9qilXVRW/FtwyjvtD8fkG3q6UIV8mOM6ysv3Xlzs9nz4M+vo7AT500gKLu82
	 WjWmsQG7uPxvz531JFGL2zsgW//Ywnuypfzba/7/UDB1pEVx4YOICGPc7JPMmt4KYL
	 F9qXLBC58IcJDVSM8cugXiRUrFhDbnCGNY1beed8=
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
Subject: [PATCH 7.3 0347/1005] sched/topology: Balance cluster static-key updates
Date: Wed, 25 Nov 2026 15:28:05 +0100
Message-ID: <20261125143829.864301522@linuxfoundation.org>
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
index 3dab0253976fb..21e3ab1af4c85 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -3314,13 +3314,25 @@ int __init sched_init_domains(const struct cpumask *cpu_map)
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



