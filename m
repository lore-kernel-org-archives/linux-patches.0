Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCD53DFC9B;
	Mon,  4 May 2026 14:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903608; cv=none; b=pZ0gAbwHeH2MvurK+dQ3elzYUTFjt02WPc86szkizpVRmnuC6angBS7cGwADlQtfkhhFSV/1PPOOREuYIittAzxO9KFvBCVnwWa4aVc1E0+CVCVZIwciM9+Sdm0LjX3N8ifLHD5mV4NxuT4yDgrO0MRYZeVg3oybN8iZNVo/HLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903608; c=relaxed/simple;
	bh=9z0Q8mrNbcLQf3nWm26SeHAEutfw2z+02ozG2UaUeYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDSqgWDymIWFGvxg51MUzGyap779YLAZmmr63Fp79LPTYXyeh/dI+4KLHBd/ZVGRcZV7tBZxXBCh3PgFVHaOQllMEF0A+HYJzgS1GfrT5gAOYJd4ZaMcgqUJ843mE9q8Q8bbmaSFKgITmjCxZFB7UV8BaM7SaWGNl+6xv7PvUoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BkRcjqwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BkRcjqwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42722C2BCC4;
	Mon,  4 May 2026 14:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903608;
	bh=9z0Q8mrNbcLQf3nWm26SeHAEutfw2z+02ozG2UaUeYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BkRcjqwzktvmBKNEcUeTxbYEuIsY6FJaSpEqxo/A3nnCWxPo0ioyysqisqBiYxVMY
	 vNuQ98Qw2Lyt7uw//ipjAJ0cUHyayl2bEYXGETYqXRNBYaubEkhCt2G/oK8fFLuxa8
	 0ZO49GeE3WRZlqwVyuWP9Lj7/W9DR72oGxAi47hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brajesh Gupta <brajesh.gupta@imgtec.com>,
	Alessio Belle <alessio.belle@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>
Subject: [PATCH 7.0 300/307] drm/imagination: Fix segfault when updating ftrace mask
Date: Mon,  4 May 2026 15:53:05 +0200
Message-ID: <20260504135154.068761034@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brajesh Gupta <brajesh.gupta@imgtec.com>

commit 5dfd429591f8d7185bf63a08b5c30863fb605611 upstream.

Fix invalid data access by passing right data for debugfs entry.

[  171.549793] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
[  171.559248] Mem abort info:
[  171.562173]   ESR = 0x0000000096000044
[  171.566227]   EC = 0x25: DABT (current EL), IL = 32 bits
[  171.573108]   SET = 0, FnV = 0
[  171.576448]   EA = 0, S1PTW = 0
[  171.579745]   FSC = 0x04: level 0 translation fault
[  171.584760] Data abort info:
[  171.588012]   ISV = 0, ISS = 0x00000044, ISS2 = 0x00000000
[  171.593734]   CM = 0, WnR = 1, TnD = 0, TagAccess = 0
[  171.598962]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[  171.604471] user pgtable: 4k pages, 48-bit VAs, pgdp=0000000083837000
[  171.611358] [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
[  171.618500] Internal error: Oops: 0000000096000044 [#1]  SMP
[  171.624222] Modules linked in: powervr drm_shmem_helper drm_gpuvm...
[  171.656580] CPU: 0 UID: 0 PID: 549 Comm: bash Not tainted 7.0.0-rc2-g730b257ba723-dirty #13 PREEMPT
[  171.665773] Hardware name: BeagleBoard.org BeaglePlay (DT)
[  171.671296] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  171.678306] pc : pvr_fw_trace_mask_set+0x78/0x154 [powervr]
[  171.683959] lr : pvr_fw_trace_mask_set+0x4c/0x154 [powervr]
[  171.689593] sp : ffff8000835ebb90
[  171.692929] x29: ffff8000835ebc00 x28: ffff000005c60f80 x27: 0000000000000000
[  171.700130] x26: 0000000000000000 x25: ffff00000504af28 x24: 0000000000000000
[  171.707324] x23: ffff00000504af50 x22: 0000000000000203 x21: 0000000000000000
[  171.714518] x20: ffff000005c44a80 x19: ffff000005c457b8 x18: 0000000000000000
[  171.721715] x17: 0000000000000000 x16: 0000000000000000 x15: 0000aaaae8887580
[  171.728908] x14: 0000000000000000 x13: 0000000000000000 x12: ffff8000835ebc30
[  171.736095] x11: ffff00000504af2a x10: ffff00008504af29 x9 : 0fffffffffffffff
[  171.743286] x8 : ffff8000835ebbf8 x7 : 0000000000000000 x6 : 000000000000002a
[  171.750479] x5 : ffff00000504af2e x4 : 0000000000000000 x3 : 0000000000000010
[  171.757674] x2 : 0000000000000203 x1 : 0000000000000000 x0 : ffff8000835ebba0
[  171.764871] Call trace:
[  171.767342]  pvr_fw_trace_mask_set+0x78/0x154 [powervr] (P)
[  171.772984]  simple_attr_write_xsigned.isra.0+0xe0/0x19c
[  171.778341]  simple_attr_write+0x18/0x24
[  171.782296]  debugfs_attr_write+0x50/0x98
[  171.786341]  full_proxy_write+0x6c/0xa8
[  171.790208]  vfs_write+0xd4/0x350
[  171.793561]  ksys_write+0x70/0x108
[  171.796995]  __arm64_sys_write+0x1c/0x28
[  171.800952]  invoke_syscall+0x48/0x10c
[  171.804740]  el0_svc_common.constprop.0+0x40/0xe0
[  171.809487]  do_el0_svc+0x1c/0x28
[  171.812834]  el0_svc+0x34/0x108
[  171.816013]  el0t_64_sync_handler+0xa0/0xe4
[  171.820237]  el0t_64_sync+0x198/0x19c
[  171.823939] Code: 32000262 b90ac293 1a931056 9134e293 (b9000036)
[  171.830073] ---[ end trace 0000000000000000 ]---

Fixes: a331631496a0 ("drm/imagination: Simplify module parameters")
Signed-off-by: Brajesh Gupta <brajesh.gupta@imgtec.com>
Reviewed-by: Alessio Belle <alessio.belle@imgtec.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260427-ftrace_fix-v3-1-e081530759a8@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imagination/pvr_fw_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imagination/pvr_fw_trace.c b/drivers/gpu/drm/imagination/pvr_fw_trace.c
index e154cb35f604..6193811ef7be 100644
--- a/drivers/gpu/drm/imagination/pvr_fw_trace.c
+++ b/drivers/gpu/drm/imagination/pvr_fw_trace.c
@@ -558,6 +558,6 @@ pvr_fw_trace_debugfs_init(struct pvr_device *pvr_dev, struct dentry *dir)
 				    &pvr_fw_trace_fops);
 	}
 
-	debugfs_create_file("trace_mask", 0600, dir, fw_trace,
+	debugfs_create_file("trace_mask", 0600, dir, pvr_dev,
 			    &pvr_fw_trace_mask_fops);
 }
-- 
2.54.0



