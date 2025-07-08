Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8C22E49AF;
	Tue,  8 Jul 2025 16:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993952; cv=none; b=FOeHdmV02E3Vrgh4vtYqCtMTnWZ+2ojjhxhQKl68hxf794xjMXIUSqnNthEz9OTclS3CtNQSUamFqpnUvHXTohsLxYFLwyS4s8ry/80X/Ura9CPZ7VE+FeHNdPbB3e4bHg5mO4H33pFvxUlKPME3TTHx8k/v/ZsG+Qnw/7J9qlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993952; c=relaxed/simple;
	bh=j9qk0kAN8cMApbJrN7Qt9c1WUgBrhgLbp7Ujz3U3JR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYeqabtldrFz2yOyPLlQsK1yfHyW8kFkUMEmdirO8cW9aJGsXOnicrPNsOgRQwEqry+uxO/3VyBdaLBLqNYk02q2bmaRgMDyykmpYZAlhY0Lsdnow5nhqZnFbFZwqJgOVK+gP+ZcC7zYCMP/+pNp2zf0/yrAuFRySf7eU0dDX54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=umCP/InD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="umCP/InD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D19C4CEED;
	Tue,  8 Jul 2025 16:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993952;
	bh=j9qk0kAN8cMApbJrN7Qt9c1WUgBrhgLbp7Ujz3U3JR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umCP/InDQIEH2p5A8tB4mLCkOgXkhNZ5B/OdcTEpHADmOGccNTpJzLCJ7Smuhn5L/
	 JwHYPPoNzu5KIvd8200SwR5AS6cJSeMYEzm8Q6GdqcbZ6gNfSFZoirfVeFqEEvDc6g
	 Foe80x66zMkav2ZTX6exVosehNPjo5tf4oxTFKlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Michael Kelley <mikelley@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/160] Drivers: hv: Rename alloced to allocated
Date: Tue,  8 Jul 2025 18:21:22 +0200
Message-ID: <20250708162232.788600818@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit de96e8a09889b35dd8d1cb6d19ef2bb123b05be1 ]

'Alloced' is not a real word and only saves us two letters, let's
use 'allocated' instead.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20220128103412.3033736-2-vkuznets@redhat.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Stable-dep-of: 0315fef2aff9 ("uio_hv_generic: Align ring size to system page")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel_mgmt.c | 18 +++++++++---------
 drivers/hv/hyperv_vmbus.h | 14 +++++++-------
 drivers/hv/vmbus_drv.c    |  2 +-
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 62c864f8d991b..029f8269ad15d 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -459,7 +459,7 @@ void hv_process_channel_removal(struct vmbus_channel *channel)
 	 * init_vp_index() can (re-)use the CPU.
 	 */
 	if (hv_is_perf_channel(channel))
-		hv_clear_alloced_cpu(channel->target_cpu);
+		hv_clear_allocated_cpu(channel->target_cpu);
 
 	/*
 	 * Upon suspend, an in-use hv_sock channel is marked as "rescinded" and
@@ -733,7 +733,7 @@ static void init_vp_index(struct vmbus_channel *channel)
 	bool perf_chn = hv_is_perf_channel(channel);
 	u32 i, ncpu = num_online_cpus();
 	cpumask_var_t available_mask;
-	struct cpumask *alloced_mask;
+	struct cpumask *allocated_mask;
 	u32 target_cpu;
 	int numa_node;
 
@@ -750,7 +750,7 @@ static void init_vp_index(struct vmbus_channel *channel)
 		 */
 		channel->target_cpu = VMBUS_CONNECT_CPU;
 		if (perf_chn)
-			hv_set_alloced_cpu(VMBUS_CONNECT_CPU);
+			hv_set_allocated_cpu(VMBUS_CONNECT_CPU);
 		return;
 	}
 
@@ -765,22 +765,22 @@ static void init_vp_index(struct vmbus_channel *channel)
 				continue;
 			break;
 		}
-		alloced_mask = &hv_context.hv_numa_map[numa_node];
+		allocated_mask = &hv_context.hv_numa_map[numa_node];
 
-		if (cpumask_weight(alloced_mask) ==
+		if (cpumask_weight(allocated_mask) ==
 		    cpumask_weight(cpumask_of_node(numa_node))) {
 			/*
 			 * We have cycled through all the CPUs in the node;
-			 * reset the alloced map.
+			 * reset the allocated map.
 			 */
-			cpumask_clear(alloced_mask);
+			cpumask_clear(allocated_mask);
 		}
 
-		cpumask_xor(available_mask, alloced_mask,
+		cpumask_xor(available_mask, allocated_mask,
 			    cpumask_of_node(numa_node));
 
 		target_cpu = cpumask_first(available_mask);
-		cpumask_set_cpu(target_cpu, alloced_mask);
+		cpumask_set_cpu(target_cpu, allocated_mask);
 
 		if (channel->offermsg.offer.sub_channel_index >= ncpu ||
 		    i > ncpu || !hv_cpuself_used(target_cpu, channel))
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 631f0a138c2b9..6a0ae815a198e 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -405,7 +405,7 @@ static inline bool hv_is_perf_channel(struct vmbus_channel *channel)
 	return vmbus_devs[channel->device_id].perf_device;
 }
 
-static inline bool hv_is_alloced_cpu(unsigned int cpu)
+static inline bool hv_is_allocated_cpu(unsigned int cpu)
 {
 	struct vmbus_channel *channel, *sc;
 
@@ -427,23 +427,23 @@ static inline bool hv_is_alloced_cpu(unsigned int cpu)
 	return false;
 }
 
-static inline void hv_set_alloced_cpu(unsigned int cpu)
+static inline void hv_set_allocated_cpu(unsigned int cpu)
 {
 	cpumask_set_cpu(cpu, &hv_context.hv_numa_map[cpu_to_node(cpu)]);
 }
 
-static inline void hv_clear_alloced_cpu(unsigned int cpu)
+static inline void hv_clear_allocated_cpu(unsigned int cpu)
 {
-	if (hv_is_alloced_cpu(cpu))
+	if (hv_is_allocated_cpu(cpu))
 		return;
 	cpumask_clear_cpu(cpu, &hv_context.hv_numa_map[cpu_to_node(cpu)]);
 }
 
-static inline void hv_update_alloced_cpus(unsigned int old_cpu,
+static inline void hv_update_allocated_cpus(unsigned int old_cpu,
 					  unsigned int new_cpu)
 {
-	hv_set_alloced_cpu(new_cpu);
-	hv_clear_alloced_cpu(old_cpu);
+	hv_set_allocated_cpu(new_cpu);
+	hv_clear_allocated_cpu(old_cpu);
 }
 
 #ifdef CONFIG_HYPERV_TESTING
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index cb3a5b13c3ec2..f42c3cb3cc0aa 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1878,7 +1878,7 @@ static ssize_t target_cpu_store(struct vmbus_channel *channel,
 
 	/* See init_vp_index(). */
 	if (hv_is_perf_channel(channel))
-		hv_update_alloced_cpus(origin_cpu, target_cpu);
+		hv_update_allocated_cpus(origin_cpu, target_cpu);
 
 	/* Currently set only for storvsc channels. */
 	if (channel->change_target_cpu_callback) {
-- 
2.39.5



