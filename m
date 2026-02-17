Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0C93542E2;
	Tue, 17 Feb 2026 12:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771331627; cv=none; b=DM/KBWUjKdvqvMlwhsw51BhEPtTbVTa6MsnEABn5HXD47mrS1gO//KfULPmFVVMIpfuA6fy8Bo2nSFH9fmQRB4THkNK7ZnqjuxJK2EDmPanksIo9g1DscwSuvRn1cv7qOd/1DXXRo+kt/1tS7Uyz939ruAPWVdn4CUrZO6TeE0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771331627; c=relaxed/simple;
	bh=g66xpWz4v322SSO+MMrZ4M3ZHcBS9XovXUcYiKTXiUM=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=gWoznqjEiOPF40sO0V3/r7sllW1/4gALjomVF0lec6o9HmXSN6Dayrxdy4auGwC1P21XOPeVjz+hiu8GV6pNuKbn4aIPZGdrHGLoJRtrHgRLrFqqS7qhOJFxRaGFdTSk1BjhYwY0CUFo4w1CBtkj4yDr3RaLsXUAAlyWT14nBE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0qBMgYvb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0qBMgYvb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48BDC2BC87;
	Tue, 17 Feb 2026 12:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771331627;
	bh=g66xpWz4v322SSO+MMrZ4M3ZHcBS9XovXUcYiKTXiUM=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=0qBMgYvbS8HKzwTpnxBrrODIjq8t7f1DdFhWjRvRLMNkZK4mxJgBh0FDg/DlsMFjs
	 WJDC4YZY79hSEx08h3oAGe53NllMT85VuWuBt0VS/PEdrVDa8WZbm/Up1lYIHcnxES
	 F/kVgagn0H64IAXJu/apeJX1Sucxt2GOb+0+IyIY=
Subject: Patch "devlink: rate: Unset parent pointer in devl_rate_nodes_destroy" has been added to the 6.1-stable tree
To: 1468888505@139.com,cjubran@nvidia.com,davem@davemloft.net,dlinkin@nvidia.com,edumazet@google.com,gregkh@linuxfoundation.org,jiri@nvidia.com,kuba@kernel.org,pabeni@redhat.com,patches@lists.linux.dev,shayd@nvidia.com,tariqt@nvidia.com,vladbu@nvidia.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 17 Feb 2026 13:33:38 +0100
In-Reply-To: <20260210030234.1532584-1-1468888505@139.com>
Message-ID: <2026021738-petticoat-pacifist-7af8@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    devlink: rate: Unset parent pointer in devl_rate_nodes_destroy

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     devlink-rate-unset-parent-pointer-in-devl_rate_nodes_destroy.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-215594-greg=kroah.com@vger.kernel.org Tue Feb 10 04:02:55 2026
From: Li hongliang <1468888505@139.com>
Date: Tue, 10 Feb 2026 11:02:34 +0800
Subject: devlink: rate: Unset parent pointer in devl_rate_nodes_destroy
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, shayd@nvidia.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, dlinkin@nvidia.com, vladbu@nvidia.com, netdev@vger.kernel.org, cjubran@nvidia.com, tariqt@nvidia.com
Message-ID: <20260210030234.1532584-1-1468888505@139.com>

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit f94c1a114ac209977bdf5ca841b98424295ab1f0 ]

The function devl_rate_nodes_destroy is documented to "Unset parent for
all rate objects". However, it was only calling the driver-specific
`rate_leaf_parent_set` or `rate_node_parent_set` ops and decrementing
the parent's refcount, without actually setting the
`devlink_rate->parent` pointer to NULL.

This leaves a dangling pointer in the `devlink_rate` struct, which cause
refcount error in netdevsim[1] and mlx5[2]. In addition, this is
inconsistent with the behavior of `devlink_nl_rate_parent_node_set`,
where the parent pointer is correctly cleared.

This patch fixes the issue by explicitly setting `devlink_rate->parent`
to NULL after notifying the driver, thus fulfilling the function's
documented behavior for all rate objects.

[1]
repro steps:
echo 1 > /sys/bus/netdevsim/new_device
devlink dev eswitch set netdevsim/netdevsim1 mode switchdev
echo 1 > /sys/bus/netdevsim/devices/netdevsim1/sriov_numvfs
devlink port function rate add netdevsim/netdevsim1/test_node
devlink port function rate set netdevsim/netdevsim1/128 parent test_node
echo 1 > /sys/bus/netdevsim/del_device

dmesg:
refcount_t: decrement hit 0; leaking memory.
WARNING: CPU: 8 PID: 1530 at lib/refcount.c:31 refcount_warn_saturate+0x42/0xe0
CPU: 8 UID: 0 PID: 1530 Comm: bash Not tainted 6.18.0-rc4+ #1 NONE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
RIP: 0010:refcount_warn_saturate+0x42/0xe0
Call Trace:
 <TASK>
 devl_rate_leaf_destroy+0x8d/0x90
 __nsim_dev_port_del+0x6c/0x70 [netdevsim]
 nsim_dev_reload_destroy+0x11c/0x140 [netdevsim]
 nsim_drv_remove+0x2b/0xb0 [netdevsim]
 device_release_driver_internal+0x194/0x1f0
 bus_remove_device+0xc6/0x130
 device_del+0x159/0x3c0
 device_unregister+0x1a/0x60
 del_device_store+0x111/0x170 [netdevsim]
 kernfs_fop_write_iter+0x12e/0x1e0
 vfs_write+0x215/0x3d0
 ksys_write+0x5f/0xd0
 do_syscall_64+0x55/0x10f0
 entry_SYSCALL_64_after_hwframe+0x4b/0x53

[2]
devlink dev eswitch set pci/0000:08:00.0 mode switchdev
devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 1000
devlink port function rate add pci/0000:08:00.0/group1
devlink port function rate set pci/0000:08:00.0/32768 parent group1
modprobe -r mlx5_ib mlx5_fwctl mlx5_core

dmesg:
refcount_t: decrement hit 0; leaking memory.
WARNING: CPU: 7 PID: 16151 at lib/refcount.c:31 refcount_warn_saturate+0x42/0xe0
CPU: 7 UID: 0 PID: 16151 Comm: bash Not tainted 6.17.0-rc7_for_upstream_min_debug_2025_10_02_12_44 #1 NONE
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
RIP: 0010:refcount_warn_saturate+0x42/0xe0
Call Trace:
 <TASK>
 devl_rate_leaf_destroy+0x8d/0x90
 mlx5_esw_offloads_devlink_port_unregister+0x33/0x60 [mlx5_core]
 mlx5_esw_offloads_unload_rep+0x3f/0x50 [mlx5_core]
 mlx5_eswitch_unload_sf_vport+0x40/0x90 [mlx5_core]
 mlx5_sf_esw_event+0xc4/0x120 [mlx5_core]
 notifier_call_chain+0x33/0xa0
 blocking_notifier_call_chain+0x3b/0x50
 mlx5_eswitch_disable_locked+0x50/0x110 [mlx5_core]
 mlx5_eswitch_disable+0x63/0x90 [mlx5_core]
 mlx5_unload+0x1d/0x170 [mlx5_core]
 mlx5_uninit_one+0xa2/0x130 [mlx5_core]
 remove_one+0x78/0xd0 [mlx5_core]
 pci_device_remove+0x39/0xa0
 device_release_driver_internal+0x194/0x1f0
 unbind_store+0x99/0xa0
 kernfs_fop_write_iter+0x12e/0x1e0
 vfs_write+0x215/0x3d0
 ksys_write+0x5f/0xd0
 do_syscall_64+0x53/0x1f0
 entry_SYSCALL_64_after_hwframe+0x4b/0x53

Fixes: d75559845078 ("devlink: Allow setting parent node of rate objects")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1763381149-1234377-1-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Routine devl_rate_nodes_destroy is moved to net/devlink/rate.c by commit
 7cc7194e85ca ("devlink: push rate related code into separate file") after linux-6.6.
 This fix applies the same update to its original location in net/devlink/leftover.c. ]
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/devlink/leftover.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -10274,13 +10274,15 @@ void devl_rate_nodes_destroy(struct devl
 		if (!devlink_rate->parent)
 			continue;
 
-		refcount_dec(&devlink_rate->parent->refcnt);
 		if (devlink_rate_is_leaf(devlink_rate))
 			ops->rate_leaf_parent_set(devlink_rate, NULL, devlink_rate->priv,
 						  NULL, NULL);
 		else if (devlink_rate_is_node(devlink_rate))
 			ops->rate_node_parent_set(devlink_rate, NULL, devlink_rate->priv,
 						  NULL, NULL);
+
+		refcount_dec(&devlink_rate->parent->refcnt);
+		devlink_rate->parent = NULL;
 	}
 	list_for_each_entry_safe(devlink_rate, tmp, &devlink->rate_list, list) {
 		if (devlink_rate_is_node(devlink_rate)) {


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.1/devlink-rate-unset-parent-pointer-in-devl_rate_nodes_destroy.patch
queue-6.1/ksmbd-set-attr_ctime-flags-when-setting-mtime.patch
queue-6.1/clk-mediatek-fix-of_iomap-memory-leak.patch
