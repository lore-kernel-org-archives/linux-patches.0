Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213957;
	b=c8SkJzBIyN3zbXzoTgcogjfPn4qB1L7ZQ3yf9AU+vtf7ILNMxVYHRjj6gLi2RYcQlC0J
	 4QxPgSzRJIpCJkcujxGEUTMQKHs9IpShpUnECMDVFQNgwhcd4A+FKLwBRZVFTl43DSWPo
	 fRvpXkfkvA5E0hjassg/6XcxFrTYWl3vBINkkt46F5EihWQLGMNpIDKgZ2FNQ9Ea/lO4U
	 xiUsZmJR8bqQuKg0Uo9j9lrWCYiJsIUAW2R2SkRUDArM6ROgyrYqTh68Qww04V3WaHL+p
	 +K1UDH2Gg87S/xHlR3IPrlnF9E+T9sofxrqwgLP27vur1sk7p1vjk0b2ZkWsnR6Sw3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sKizPVP3B0g0LgH1dWxTxq6WYwAKh8CbCWTp6OwoGDI=;
	b=RrymdNwYHbrrh+eT0gHXthiMhMoVjq0pvg4J0t2iW6vXR0csE4stebiT3o1lg2WSgPR6
	 1vm/oK4uvkVZOz305Vcm6gGscuwzSfD5eqze5GJVJAFriYR8t9JeX5i+UoIeQKKjAiyoo
	 PNRX5eHLPujNL6tl5ravP0SexRZMESaKnSj5+fkkZrzPbeaaGe9CctFyjSzqcxqdq+xla
	 9tbxqARbWhiK8Ai/FjbM2HXluTksVRvcWxmwEx3nFKS2bnhc9jigIPxZMht62lLwe3KWc
	 guKyJJ4LbH3BRJcDnNeNYNTqL4aC7a3Ge6mx8z9S3fIKIcExWSR2ozJFEjiK6BFxNBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=loYEERUV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3CC606A31C;
	Wed, 28 Oct 2026 18:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=loYEERUV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338C51F01825;
	Wed, 28 Oct 2026 18:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213956;
	bh=sKizPVP3B0g0LgH1dWxTxq6WYwAKh8CbCWTp6OwoGDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=loYEERUV2JwOlHC44wpd4VGhz3zeJgqo+kdEQpfZ40pW+D2tCNCoc2VIwuuxVfwcr
	 nW4FDOP+dv0r16jpNEi3Mv/igk4bPZn0CT/aGDuA+VgBe9n5wjrlE5N5BlQU7LLtEK
	 ZKZ1MHgZHr1QFlW8L+iMrAdw7OMo2wvYYzzpb8y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinqi Zhang <quic_xinqzhan@quicinc.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0689/1887] firmware: arm_scmi: Fix slab-use-after-free in scmi_bus_notifier()
Date: Wed, 28 Oct 2026 17:46:25 +0100
Message-ID: <20261028170515.092451105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xinqi Zhang <quic_xinqzhan@quicinc.com>

[ Upstream commit 295416091e44806760ccf753aeafdafc0ae268f3 ]

The scmi_dev->name is released prematurely in __scmi_device_destroy(),
which causes slab-use-after-free when accessing scmi_dev->name in
scmi_bus_notifier(). So move the release of scmi_dev->name to
scmi_device_release() to avoid slab-use-after-free.

  |  BUG: KASAN: slab-use-after-free in strncmp+0xe4/0xec
  |  Read of size 1 at addr ffffff80a482bcc0 by task swapper/0/1
  |
  |  CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.6.38-debug #1
  |  Hardware name: Qualcomm Technologies, Inc. SA8775P Ride (DT)
  |  Call trace:
  |   dump_backtrace+0x94/0x114
  |   show_stack+0x18/0x24
  |   dump_stack_lvl+0x48/0x60
  |   print_report+0xf4/0x5b0
  |   kasan_report+0xa4/0xec
  |   __asan_report_load1_noabort+0x20/0x2c
  |   strncmp+0xe4/0xec
  |   scmi_bus_notifier+0x5c/0x54c
  |   notifier_call_chain+0xb4/0x31c
  |   blocking_notifier_call_chain+0x68/0x9c
  |   bus_notify+0x54/0x78
  |   device_del+0x1bc/0x840
  |   device_unregister+0x20/0xb4
  |   __scmi_device_destroy+0xac/0x280
  |   scmi_device_destroy+0x94/0xd0
  |   scmi_chan_setup+0x524/0x750
  |   scmi_probe+0x7fc/0x1508
  |   platform_probe+0xc4/0x19c
  |   really_probe+0x32c/0x99c
  |   __driver_probe_device+0x15c/0x3c4
  |   driver_probe_device+0x5c/0x170
  |   __driver_attach+0x1c8/0x440
  |   bus_for_each_dev+0xf4/0x178
  |   driver_attach+0x3c/0x58
  |   bus_add_driver+0x234/0x4d4
  |   driver_register+0xf4/0x3c0
  |   __platform_driver_register+0x60/0x88
  |   scmi_driver_init+0xb0/0x104
  |   do_one_initcall+0xb4/0x664
  |   kernel_init_freeable+0x3c8/0x894
  |   kernel_init+0x24/0x1e8
  |   ret_from_fork+0x10/0x20
  |
  |  Allocated by task 1:
  |   kasan_save_stack+0x2c/0x54
  |   kasan_set_track+0x2c/0x40
  |   kasan_save_alloc_info+0x24/0x34
  |   __kasan_kmalloc+0xa0/0xb8
  |   __kmalloc_node_track_caller+0x6c/0x104
  |   kstrdup+0x48/0x84
  |   kstrdup_const+0x34/0x40
  |   __scmi_device_create.part.0+0x8c/0x408
  |   scmi_device_create+0x104/0x370
  |   scmi_chan_setup+0x2a0/0x750
  |   scmi_probe+0x7fc/0x1508
  |   platform_probe+0xc4/0x19c
  |   really_probe+0x32c/0x99c
  |   __driver_probe_device+0x15c/0x3c4
  |   driver_probe_device+0x5c/0x170
  |   __driver_attach+0x1c8/0x440
  |   bus_for_each_dev+0xf4/0x178
  |   driver_attach+0x3c/0x58
  |   bus_add_driver+0x234/0x4d4
  |   driver_register+0xf4/0x3c0
  |   __platform_driver_register+0x60/0x88
  |   scmi_driver_init+0xb0/0x104
  |   do_one_initcall+0xb4/0x664
  |   kernel_init_freeable+0x3c8/0x894
  |   kernel_init+0x24/0x1e8
  |   ret_from_fork+0x10/0x20
  |
  |  Freed by task 1:
  |   kasan_save_stack+0x2c/0x54
  |   kasan_set_track+0x2c/0x40
  |   kasan_save_free_info+0x38/0x5c
  |   __kasan_slab_free+0xe8/0x164
  |   __kmem_cache_free+0x11c/0x230
  |   kfree+0x70/0x130
  |   kfree_const+0x20/0x40
  |   __scmi_device_destroy+0x70/0x280
  |   scmi_device_destroy+0x94/0xd0
  |   scmi_chan_setup+0x524/0x750
  |   scmi_probe+0x7fc/0x1508
  |   platform_probe+0xc4/0x19c
  |   really_probe+0x32c/0x99c
  |   __driver_probe_device+0x15c/0x3c4
  |   driver_probe_device+0x5c/0x170
  |   __driver_attach+0x1c8/0x440
  |   bus_for_each_dev+0xf4/0x178
  |   driver_attach+0x3c/0x58
  |   bus_add_driver+0x234/0x4d4
  |   driver_register+0xf4/0x3c0
  |   __platform_driver_register+0x60/0x88
  |   scmi_driver_init+0xb0/0x104
  |   do_one_initcall+0xb4/0x664
  |   kernel_init_freeable+0x3c8/0x894
  |   kernel_init+0x24/0x1e8
  |   ret_from_fork+0x10/0x20

Fixes: ee7a9c9f67c5 ("firmware: arm_scmi: Add support for multiple device per protocol")
Signed-off-by: Xinqi Zhang <quic_xinqzhan@quicinc.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Message-Id: <20241016-fix-arm-scmi-slab-use-after-free-v2-1-1783685ef90d@quicinc.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index 36f75b6629db0..323e1e48cabde 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -301,7 +301,10 @@ EXPORT_SYMBOL_GPL(scmi_driver_unregister);
 
 static void scmi_device_release(struct device *dev)
 {
-	kfree(to_scmi_dev(dev));
+	struct scmi_device *scmi_dev = to_scmi_dev(dev);
+
+	kfree_const(scmi_dev->name);
+	kfree(scmi_dev);
 }
 
 static void __scmi_device_destroy(struct scmi_device *scmi_dev)
@@ -314,7 +317,6 @@ static void __scmi_device_destroy(struct scmi_device *scmi_dev)
 	if (scmi_dev->protocol_id == SCMI_PROTOCOL_SYSTEM)
 		atomic_set(&scmi_syspower_registered, 0);
 
-	kfree_const(scmi_dev->name);
 	ida_free(&scmi_bus_id, scmi_dev->id);
 	device_unregister(&scmi_dev->dev);
 }
@@ -386,7 +388,6 @@ __scmi_device_create(struct device_node *np, struct device *parent,
 
 	return scmi_dev;
 put_dev:
-	kfree_const(scmi_dev->name);
 	put_device(&scmi_dev->dev);
 	ida_free(&scmi_bus_id, id);
 	return NULL;
-- 
2.53.0



