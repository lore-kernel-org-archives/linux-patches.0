Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018023;
	b=Ii6d/B5kcVdPtCE2XJdPAqsPZ3a9k/LH7u9788DRsx3+ZpYBz5PXopasZoJOMH247uWO
	 PAjDG4t209jCqJS6hbA6SynRRVcu+eX8hMA+/GdxsgI6w3tFsBppY0DzE5I7nsdvVC89M
	 pOFGfdowF6papzbMYE9M/PIN9PNtlwN1+3bzXq8ZlVNVmjRZ/XWpB/HAU+r6mrOAA1i7i
	 9C25uBCUCQtCON4SdhSNdEmDZLPcfAo52mns6z+sJMKJXhXrcHEgnWxssGVaSjYysjetc
	 AiVF1tlvsK8DN5gNE7t/n+8EKMDkgR+t9qGCkQYNdcIKwiyian0yLd24xMt0CiROqdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+LNXSDULqjwwbAJT1A3xm3ff79d5FQxieqUvIRRwkEw=;
	b=RrDnoyBz9JgQ4iv3YUuABDOCNZMys9nUxbj3GaFCzsbSIdravUWZNacGxPhT4GuN5c2x
	 C6JiED3SetrWJ5Z0DEx1JWqo3BiW6/8JodfIBnyQ/8w7PHdw2p5Wcimj5eApd7B4EXMwO
	 FaJL7ObJVMQCk5Mr3JlDE2BjigMeEAd/nSyIlw9ey653Q7WgIg9W9fzQatHxh0YMLJM41
	 om6uRlGlhx30y1UJreaBOTW795amtshEB0X5J+WyAWVU3hypY85BxnN+1ShaxnwFN5usb
	 m+MJqbpnGFhtvlT5kaIz6f/uTumr9lppSr+na/t9S9Zw5c7TcdoAH0aySKDehdBH59g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvquDi1E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B3A606A320;
	Wed, 18 Nov 2026 16:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvquDi1E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA7A1F000C8;
	Wed, 18 Nov 2026 16:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018023;
	bh=+LNXSDULqjwwbAJT1A3xm3ff79d5FQxieqUvIRRwkEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DvquDi1E5n5WjCHDwKxYwiEnkMd3h/WJGZSXUzMYJze3tDdXMphKHObNoT43OBUv+
	 yvEMhBc1oUv/9njqrnW2/9JC9ADUMotN98ROUlkb+HfXy+JVllTtaLQhlpFzDtTNWE
	 l+H65XH8dG9/ugvJb/iWl40KasijGjCcMxCEs8mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1086/2651] ice: size ring stats arrays from the final queue count
Date: Wed, 18 Nov 2026 15:38:46 +0100
Message-ID: <20261118150327.091528613@linuxfoundation.org>
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

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

[ Upstream commit f1c3b87896e656c1940a1dc3e2f286e000c62da8 ]

The ring stats arrays were sized in one place and indexed in another,
with nothing reconciling the two. ice_vsi_alloc_stat_arrays() gave up as
soon as a container existed:

	if (pf->vsi_stats[vsi->idx])
	/* realloc will happen in rebuild path */
		return 0;

while ice_vsi_alloc_ring_stats() walks the arrays with
ice_for_each_alloc_txq() / ice_for_each_alloc_rxq(), that is, up to
vsi->alloc_txq / vsi->alloc_rxq. Whenever the arrays are shorter than
the count ice_vsi_set_num_qs() ends up computing, that loop reads and
stores past the end of the kmalloc'ed pointer arrays.

Deferring to "the rebuild path" does not hold. It cannot get the size
right, and some paths never call it at all.

ice_devlink_reinit_down() is one of the latter. It calls ice_vsi_decfg()
directly, which does not free pf->vsi_stats[], and nothing on the way
down releases the main VSI's entry either: ice_dealloc_vsis() runs only
from ice_init()/ice_deinit(), and the single entry that ice_unload()
does drop is the control VSI's, via ice_deinit_fdir(). The main VSI's
arrays therefore survive the reload, while ice_devlink_reinit_up() runs
ice_vsi_cfg() and recomputes the count from
netif_get_num_default_rss_queues(), which follows cpu_online_mask.
Sizing the arrays with most CPUs offline and then onlining them is
enough, no VF involved:

  for c in /sys/devices/system/cpu/cpu[0-9]*/online; do echo 0 > $c; done
  echo 0000:18:00.0 > /sys/bus/pci/drivers/ice/unbind
  echo 0000:18:00.0 > /sys/bus/pci/drivers/ice/bind
  for c in /sys/devices/system/cpu/cpu[0-9]*/online; do echo 1 > $c; done
  devlink dev reload pci/0000:18:00.0 action driver_reinit

The unbind/bind is what makes the arrays actually be allocated at the
small size; a reload alone only reuses them.

The read then runs off the end of tx_ring_stats[] and picks up whatever
follows it in kmalloc-32. Here that was a string, 0x74756f5f6c697475
spelling "util_out" in memory order. It is stored into ring->ring_stats
and faults on the first dereference, in ice_setup_tx_ring(), call trace:

 RIP: 0010:ice_setup_tx_ring+0x8d/0xe0 [ice]
  ice_vsi_setup_tx_rings+0x2a/0x80 [ice]
  ice_vsi_open+0x28/0x170 [ice]
  ice_open_internal+0xc9/0x160 [ice]
  __dev_open+0x138/0x2b0
  __dev_change_flags+0x1d5/0x250
  netif_change_flags+0x21/0x60
  do_setlink.constprop.0+0x336/0xcf0
  rtnl_newlink+0x4a4/0x9b0

Even where the rebuild path does run, it sizes the arrays before
ice_vsi_decfg() returns the queues to the PF pool, and for an
ICE_VSI_PF VSI with no explicit request it derives the count from that
shared pool. Nothing serializes it against the recount in
ice_vsi_set_num_qs(), so a concurrent release, say
"echo 0 > sriov_numvfs", leaves the final count larger than the arrays
that were already installed.

ice_vsi_alloc_stat_arrays() runs from ice_vsi_cfg_def(), right after
ice_vsi_alloc_def() called ice_vsi_set_num_qs(), so it is the first
place where the queue count is final. Make it the only authority: keep
the existing arrays when they are already long enough, and otherwise
grow them with ice_vsi_install_stat_arrays(), which carries the
surviving entries over. The check only forces a grow: while both arrays
are long enough they are kept, an oversized one being merely wasteful.
Once either is too short the whole container is replaced, and then the
other one follows the final count too, shrinking if that is what it
takes.

Michal Schmidt hit the same corruption through the VF path, where a
guest raises its queue count with VIRTCHNL_OP_REQUEST_QUEUES and the
following VF reset reconfigures the VSI with the larger count while the
old, shorter arrays are still installed:

 BUG: KASAN: slab-out-of-bounds in ice_vsi_alloc_ring_stats+0x385/0x4a0 [ice]
 Workqueue: ice ice_service_task [ice]
 Call Trace:
  kasan_report+0xd7/0x120
  ice_vsi_alloc_ring_stats+0x385/0x4a0 [ice]
  ice_vsi_cfg_def+0x12e2/0x2060 [ice]
  ice_vsi_cfg+0xb5/0x3c0 [ice]
  ice_reset_vf+0x858/0xf80 [ice]
  ice_vc_request_qs_msg+0x1da/0x290 [ice]
  ice_vc_process_vf_msg+0xb15/0x1430 [ice]
  __ice_clean_ctrlq+0x70d/0x9d0 [ice]
  ice_service_task+0x840/0xf20 [ice]
  process_one_work+0x690/0xff0
  worker_thread+0x4d9/0xd20
  kthread+0x322/0x410
  ret_from_fork+0x332/0x660
  ret_from_fork_asm+0x1a/0x30

 Allocated by task 2439:
  kasan_save_stack+0x1c/0x40
  kasan_save_track+0x10/0x30
  __kasan_kmalloc+0x96/0xb0
  __kmalloc_noprof+0x1d8/0x580
  ice_vsi_cfg_def+0x115c/0x2060 [ice]
  ice_vsi_cfg+0xb5/0x3c0 [ice]
  ice_vsi_setup+0x180/0x320 [ice]
  ice_start_vfs+0x1f3/0x590 [ice]
  ice_ena_vfs+0x66d/0x798 [ice]
  ice_sriov_configure.cold+0xe4/0x121 [ice]
  sriov_numvfs_store+0x279/0x480
  kernfs_fop_write_iter+0x331/0x4f0
  vfs_write+0x4c4/0xe40
  ksys_write+0x10c/0x240
  do_syscall_64+0xd9/0x650
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

 The buggy address belongs to the object at ffff88810affea40
                which belongs to the cache kmalloc-32 of size 32
 The buggy address is located 0 bytes to the right of
                allocated 32-byte region [ffff88810affea40, ffff88810affea60)

Fixes: 288ecf491b16 ("ice: Accumulate ring statistics over reset")
Reported-by: Michal Schmidt <mschmidt@redhat.com>
Closes: https://redhat.atlassian.net/browse/RHEL-164321
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Link: https://patch.msgid.link/20260925132636.123300-7-przemyslaw.kitszel@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 448d3c7780adf..c393d913d0379 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -634,10 +634,15 @@ static int ice_vsi_install_stat_arrays(struct ice_vsi *vsi, u16 txq, u16 rxq)
 /**
  * ice_vsi_alloc_stat_arrays - Allocate statistics arrays
  * @vsi: VSI pointer
+ *
+ * Runs after ice_vsi_set_num_qs(), so this is the first point where the queue
+ * count is final. Grow the arrays if an earlier sizing guessed too low.
+ *
+ * Return: 0 on success, negative error code otherwise.
  */
 static int ice_vsi_alloc_stat_arrays(struct ice_vsi *vsi)
 {
-	struct ice_vsi_stats *vsi_stat;
+	struct ice_vsi_stats *old_stat;
 	struct ice_pf *pf = vsi->back;
 
 	if (vsi->type == ICE_VSI_CHNL)
@@ -645,16 +650,13 @@ static int ice_vsi_alloc_stat_arrays(struct ice_vsi *vsi)
 	if (!pf->vsi_stats)
 		return -ENOENT;
 
-	if (pf->vsi_stats[vsi->idx])
-	/* realloc will happen in rebuild path */
+	old_stat = pf->vsi_stats[vsi->idx];
+	if (old_stat && old_stat->tx_ring_stats_len >= vsi->alloc_txq &&
+	    old_stat->rx_ring_stats_len >= vsi->alloc_rxq)
 		return 0;
 
-	vsi_stat = ice_vsi_new_stat_arrays(vsi->alloc_txq, vsi->alloc_rxq);
-	if (!vsi_stat)
-		return -ENOMEM;
-
-	pf->vsi_stats[vsi->idx] = vsi_stat;
-	return 0;
+	return ice_vsi_install_stat_arrays(vsi, vsi->alloc_txq,
+					   vsi->alloc_rxq);
 }
 
 /**
-- 
2.53.0



