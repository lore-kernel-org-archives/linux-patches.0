Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1563C2E88AC;
	Tue, 15 Jul 2025 13:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587509; cv=none; b=OT2yTi85wvlSPb1jBy63Vncyyftrk+yUI2Wsoj9dJ0jylsDy3aliXmn2bq76BbEbXPhhyFa/9kymCpGUSWESbcdptRExlKjEm2CuK2P38KhBg2n69IEvkA/6PUEumOHd038vf5xVbCW4CjE+vFN6GZONiXc2bSxr1oRi9m/DXWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587509; c=relaxed/simple;
	bh=hxA3H3ilztMtA7CwsnjZ7Xu+PIbkG4rmOpzGCNwn+Mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d30v0YuCAV4PEr4+2Br/45BDSEV7YiABaf+NWxuqt7WSECA8VsNjTNAnrA6Ikrm2NPCA6dvlugqHCQ5TCye8omUftVX6QOQlB10UA9gXgvaqbCvogUmKabYBdHAzi/kgWU89w/uwcrRwMd+5KQV7UOCAclzvYwMzy/bgvcqGkAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yEbBmQ4k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEbBmQ4k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A91C4CEE3;
	Tue, 15 Jul 2025 13:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587508;
	bh=hxA3H3ilztMtA7CwsnjZ7Xu+PIbkG4rmOpzGCNwn+Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yEbBmQ4kBXqzA0LEAqvYxncuPPNQauGGMhGJQ1svmcS6+83G90YmKWXp+Jp5E6+nw
	 XlN7LTYtHTnYz6ukDpKdRZOHeFNTTKZ4rV2sR+cPrj1qF1RMA6szg7VFyZkXn1VhNN
	 YRokf+VS/uuLRUC7qI8520lMig8+4cVuvpKE1lIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Michael Kelley <mikelley@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/208] Drivers: hv: Rename alloced to allocated
Date: Tue, 15 Jul 2025 15:12:28 +0200
Message-ID: <20250715130812.525837718@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9da36d87ee2c7..4ee8b9b22bb9d 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -429,7 +429,7 @@ void hv_process_channel_removal(struct vmbus_channel *channel)
 	 * init_vp_index() can (re-)use the CPU.
 	 */
 	if (hv_is_perf_channel(channel))
-		hv_clear_alloced_cpu(channel->target_cpu);
+		hv_clear_allocated_cpu(channel->target_cpu);
 
 	/*
 	 * Upon suspend, an in-use hv_sock channel is marked as "rescinded" and
@@ -703,7 +703,7 @@ static void init_vp_index(struct vmbus_channel *channel)
 	bool perf_chn = hv_is_perf_channel(channel);
 	u32 i, ncpu = num_online_cpus();
 	cpumask_var_t available_mask;
-	struct cpumask *alloced_mask;
+	struct cpumask *allocated_mask;
 	u32 target_cpu;
 	int numa_node;
 
@@ -720,7 +720,7 @@ static void init_vp_index(struct vmbus_channel *channel)
 		 */
 		channel->target_cpu = VMBUS_CONNECT_CPU;
 		if (perf_chn)
-			hv_set_alloced_cpu(VMBUS_CONNECT_CPU);
+			hv_set_allocated_cpu(VMBUS_CONNECT_CPU);
 		return;
 	}
 
@@ -735,22 +735,22 @@ static void init_vp_index(struct vmbus_channel *channel)
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
index a785d790e0aae..323c56152fa1b 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -406,7 +406,7 @@ static inline bool hv_is_perf_channel(struct vmbus_channel *channel)
 	return vmbus_devs[channel->device_id].perf_device;
 }
 
-static inline bool hv_is_alloced_cpu(unsigned int cpu)
+static inline bool hv_is_allocated_cpu(unsigned int cpu)
 {
 	struct vmbus_channel *channel, *sc;
 
@@ -428,23 +428,23 @@ static inline bool hv_is_alloced_cpu(unsigned int cpu)
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
index e8bea7c791691..2fed2b169a910 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1790,7 +1790,7 @@ static ssize_t target_cpu_store(struct vmbus_channel *channel,
 
 	/* See init_vp_index(). */
 	if (hv_is_perf_channel(channel))
-		hv_update_alloced_cpus(origin_cpu, target_cpu);
+		hv_update_allocated_cpus(origin_cpu, target_cpu);
 
 	/* Currently set only for storvsc channels. */
 	if (channel->change_target_cpu_callback) {
-- 
2.39.5



