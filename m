Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035057;
	b=T0FmymkHH/BIEHJ0Ta8vZdRxBbNzDbbiQ1zHEh5uPb8dN/rG4+AHyWwet8fBzMiSLDzH
	 7Bx7yiOK1ACypB18i434dVZNTj3SvD5Bq7YfoRt7Cs5CH03maTmO7zzIJPvNu7UUQoib1
	 YpiyLA/c+ECmRPWXC+axpMelDv3P4dmIEJygKNC5tXqv+Az0G9WVgoeYHfS/Edy6sFk4G
	 a01U6DkzlolSOr+v15kWjN54H7dISz3hEs1LDMIfqMTvyRWLbbv1+OLWHirrU8v4nCwrc
	 J71oC8zQfxO8qLATxl369Q/MOs97RitAOlNxfykVAcuAYcAEZHB0F3WfJH+NnZbMR+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BUmLKOOow4Wpf8dCxEW15Xc2jnWBcfbgf5Dpqz2cSE4=;
	b=oKpmvKxIGW1P3mYhcBIn4ITO2eKUVUCQ1RM+XrpTKjE860QBXiogu1R0aTZ1R7Wk95qJ
	 uOJIwANNDjH5vhyERTROvgd6/Tri8mIB7eYzMDPrRvPU55jvLuHz3mEQJwLaA6c4nND0R
	 /yObGIg6DdIk2IpMGCMYSvQrcWLvkez68VoyyDWwYJr44PVoM1o3+3dYSzhepuV8TPjcw
	 hYpN21gTu/0ZikzIpX1s0+gcLotFSkvvR2/gM/YcJdp01LRxQ0woCnuHme0L6xzd+evOu
	 7MulDWAhTZ9RjU3FN6fInRHrapA5ubcH9QHKyEtvqh79aABEzMRmSAy7W0tEfm6PHsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m0Q83Kzl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9042F606A320;
	Wed, 18 Nov 2026 20:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m0Q83Kzl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF50C1F000C4;
	Wed, 18 Nov 2026 20:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035057;
	bh=BUmLKOOow4Wpf8dCxEW15Xc2jnWBcfbgf5Dpqz2cSE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m0Q83KzlQ8cCFiMUfSOpkoqN8rtVmBK2lTU+tYad6k8Wpq+B121bcxjYax6+4/6vX
	 S0hSJ4xQ/71fnIMtWceaZ2MKQ/vmyue2MrnQSFuO4Ia8Y98RxdPEXK0L3AolYjGe3P
	 GiFImM/WJUYeCK/eqgAQdKZmctcJytckGtwEf2tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 0587/3318] nvmet-fc: fix use-after-free in nvmet_fc_ls_create_connection()
Date: Wed, 18 Nov 2026 15:20:09 +0100
Message-ID: <20261118150335.171367848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

commit 2c29f8c9b9e598c09fa50aa02200136a107f6b3f upstream.

nvmet_fc_ls_create_connection() looks up the association with
nvmet_fc_find_target_assoc(), which returns it with a reference held,
and drops that reference as soon as the target queue has been allocated.
iod->assoc is then dereferenced again by nvmet_fc_makeconnid() while
building the connection id.

The queue only borrows the pointer and takes no reference of its own.
Once the lookup reference is dropped the association is kept alive
solely by the reference taken when it was created, so a disconnect LS or
a remote port unregister running concurrently can free it before
nvmet_fc_makeconnid() reads it:

BUG: KASAN: slab-use-after-free in nvmet_fc_handle_ls_rqst_work (drivers/nvme/target/fc.c:193 drivers/nvme/target/fc.c:1841 drivers/nvme/target/fc.c:1995 drivers/nvme/target/fc.c:2021)
Read of size 8 at addr ffff888179f1b000 by task kworker/u9:2/1167

Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: nvmet-wq nvmet_fc_handle_ls_rqst_work
Call Trace:
 <TASK>
 dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
 print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
 kasan_report (mm/kasan/report.c:595)
 nvmet_fc_handle_ls_rqst_work (drivers/nvme/target/fc.c:193 drivers/nvme/target/fc.c:1841 drivers/nvme/target/fc.c:1995 drivers/nvme/target/fc.c:2021)
 process_scheduled_works (kernel/workqueue.c:3322 kernel/workqueue.c:3405)
 worker_thread (kernel/workqueue.c:3486)
 kthread (kernel/kthread.c:436)
 ret_from_fork (archkernel/process.c:158)
 ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
 </TASK>

Freed by task 1167 on cpu 0 at 405.998150s:
 kasan_save_track (mm/kasan/common.c:57 mm/kasan/common.c:78)
 kasan_save_free_info (mm/kasan/generic.c:584)
 __kasan_slab_free (mm/kasan/common.c:253 mm/kasan/common.c:285)
 kfree (include/linux/kasan.h:235 mm/slub.c:2705 mm/slub.c:6405 mm/slub.c:6720)
 nvmet_fc_handle_ls_rqst_work (drivers/nvme/target/fc.c:1808 drivers/nvme/target/fc.c:1995 drivers/nvme/target/fc.c:2021)
 process_scheduled_works (kernel/workqueue.c:3322 kernel/workqueue.c:3405)
 worker_thread (kernel/workqueue.c:3486)
 kthread (kernel/kthread.c:436)
 ret_from_fork (archkernel/process.c:158)
 ret_from_fork_asm (arch/x86/entry/entry_64.S:245)

The buggy address belongs to the object at ffff888179f1b000
 which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 0 bytes inside of
 freed 2048-byte region [ffff888179f1b000, ffff888179f1b800)

Hold the lookup reference until the response has been built, and drop it
on the error path as well.

Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Closes: https://lore.kernel.org/linux-nvme/20260731204504.2396434-1-shuangpeng.kernel@gmail.com
Fixes: c53432030d86 ("nvme-fabrics: Add target support for FC transport")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/fc.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1773,9 +1773,6 @@ nvmet_fc_ls_create_connection(struct nvm
 					be16_to_cpu(rqst->connect_cmd.sqsize));
 			if (!queue)
 				ret = VERR_QUEUE_ALLOC_FAIL;
-
-			/* release get taken in nvmet_fc_find_target_assoc */
-			nvmet_fc_tgt_a_put(iod->assoc);
 		}
 	}
 
@@ -1789,6 +1786,8 @@ nvmet_fc_ls_create_connection(struct nvm
 					FCNVME_RJT_RC_INV_ASSOC :
 					FCNVME_RJT_RC_LOGIC,
 				FCNVME_RJT_EXP_NONE, 0);
+		if (iod->assoc)
+			nvmet_fc_tgt_a_put(iod->assoc);
 		return;
 	}
 
@@ -1810,6 +1809,9 @@ nvmet_fc_ls_create_connection(struct nvm
 	acc->connectid.connection_id =
 			cpu_to_be64(nvmet_fc_makeconnid(iod->assoc,
 				be16_to_cpu(rqst->connect_cmd.qid)));
+
+	/* release get taken in nvmet_fc_find_target_assoc */
+	nvmet_fc_tgt_a_put(iod->assoc);
 }
 
 /*


