Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0173AD5A;
	Tue, 11 Mar 2025 00:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.166.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741653608; cv=none; b=ibsuaaPSlwHSOYRlIhSrA/UBq04dDlkKmZH+TfYDy0Yqg2FcAq6PMuPERXoY+TW5N6AYBkXH94rl8WJgybosvPX0PRGm/GdABAy4TtAf+bviVXppstAx+TMwIc4kfYeWrVNB7j4k0lYwRbvs7yXmX/R0pB+36voSxzOha8eXNWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741653608; c=relaxed/simple;
	bh=IFxIDLySzcDt2s61LMkBUfkmcFfpQk5sYPpSp6OaGBA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CHBxKodzPZLyNQ1KVAzFUKDJ98O0VcfX/fXgFGSpSLRMJQ4/PWT1Fr3uZ0qbDc+i7dFPSm35nT1ZqneaIi3iNtYOE/8pVWxRGCyxId8OLDLmISqp8FoR8YqJixZqtfW0CVjzp8+RGTWBqJ3r3rTL3UzlYHbCq5P9l4mqHYq654I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; arc=none smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52B0Wilb020395;
	Mon, 10 Mar 2025 17:39:53 -0700
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [147.11.82.254])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 458p9qjda1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 10 Mar 2025 17:39:53 -0700 (PDT)
Received: from ala-exchng01.corp.ad.wrs.com (147.11.82.252) by
 ALA-EXCHNG02.corp.ad.wrs.com (147.11.82.254) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.43; Mon, 10 Mar 2025 17:39:52 -0700
Received: from pek-lpg-core1.wrs.com (147.11.136.210) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server id
 15.1.2507.43 via Frontend Transport; Mon, 10 Mar 2025 17:39:50 -0700
From: <jianqi.ren.cn@windriver.com>
To: <stable@vger.kernel.org>, <liushixin2@huawei.com>
CC: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <patches@lists.linux.dev>, <minchan@kernel.org>,
        <senozhatsky@chromium.org>, <axboe@kernel.dk>,
        <akpm@linux-foundation.org>, <linux-block@vger.kernel.org>
Subject: [PATCH 6.6.y] zram: fix NULL pointer in comp_algorithm_show()
Date: Tue, 11 Mar 2025 08:39:49 +0800
Message-ID: <20250311003949.3927527-1-jianqi.ren.cn@windriver.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=QNySRhLL c=1 sm=1 tr=0 ts=67cf8659 cx=c_pps a=K4BcnWQioVPsTJd46EJO2w==:117 a=K4BcnWQioVPsTJd46EJO2w==:17 a=Vs1iUdzkB0EA:10 a=VwQbUJbxAAAA:8 a=i0EeH86SAAAA:8 a=cm27Pg_UAAAA:8 a=Z4Rwk6OoAAAA:8 a=t7CeM3EgAAAA:8
 a=m3UGnVx-GgMgIQ9NKaQA:9 a=HkZW87K1Qel5hWWM3VKY:22 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: noMcFJsJb6vVsnykpK8onSoqLxEPRDmG
X-Proofpoint-ORIG-GUID: noMcFJsJb6vVsnykpK8onSoqLxEPRDmG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-10_08,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 spamscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 clxscore=1011 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.21.0-2502100000
 definitions=main-2503110002

From: Liu Shixin <liushixin2@huawei.com>

[ Upstream commit f364cdeb38938f9d03061682b8ff3779dd1730e5 ]

LTP reported a NULL pointer dereference as followed:

 CPU: 7 UID: 0 PID: 5995 Comm: cat Kdump: loaded Not tainted 6.12.0-rc6+ #3
 Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
 pstate: 40400005 (nZcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : __pi_strcmp+0x24/0x140
 lr : zcomp_available_show+0x60/0x100 [zram]
 sp : ffff800088b93b90
 x29: ffff800088b93b90 x28: 0000000000000001 x27: 0000000000400cc0
 x26: 0000000000000ffe x25: ffff80007b3e2388 x24: 0000000000000000
 x23: ffff80007b3e2390 x22: ffff0004041a9000 x21: ffff80007b3e2900
 x20: 0000000000000000 x19: 0000000000000000 x18: 0000000000000000
 x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
 x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
 x11: 0000000000000000 x10: ffff80007b3e2900 x9 : ffff80007b3cb280
 x8 : 0101010101010101 x7 : 0000000000000000 x6 : 0000000000000000
 x5 : 0000000000000040 x4 : 0000000000000000 x3 : 00656c722d6f7a6c
 x2 : 0000000000000000 x1 : ffff80007b3e2900 x0 : 0000000000000000
 Call trace:
  __pi_strcmp+0x24/0x140
  comp_algorithm_show+0x40/0x70 [zram]
  dev_attr_show+0x28/0x80
  sysfs_kf_seq_show+0x90/0x140
  kernfs_seq_show+0x34/0x48
  seq_read_iter+0x1d4/0x4e8
  kernfs_fop_read_iter+0x40/0x58
  new_sync_read+0x9c/0x168
  vfs_read+0x1a8/0x1f8
  ksys_read+0x74/0x108
  __arm64_sys_read+0x24/0x38
  invoke_syscall+0x50/0x120
  el0_svc_common.constprop.0+0xc8/0xf0
  do_el0_svc+0x24/0x38
  el0_svc+0x38/0x138
  el0t_64_sync_handler+0xc0/0xc8
  el0t_64_sync+0x188/0x190

The zram->comp_algs[ZRAM_PRIMARY_COMP] can be NULL in zram_add() if
comp_algorithm_set() has not been called.  User can access the zram device
by sysfs after device_add_disk(), so there is a time window to trigger the
NULL pointer dereference.  Move it ahead device_add_disk() to make sure
when user can access the zram device, it is ready.  comp_algorithm_set()
is protected by zram->init_lock in other places and no such problem.

Link: https://lkml.kernel.org/r/20241108100147.3776123-1-liushixin2@huawei.com
Fixes: 7ac07a26dea7 ("zram: preparation for multi-zcomp support")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[This fix does not backport zram_comp_params_reset which was introduced after
 v6.6, in commit f2bac7ad187d ("zram: introduce zcomp_params structure")]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
---
Verified the build test
---
 drivers/block/zram/zram_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index b73038ad86f7..44cf0e51d7db 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2247,6 +2247,8 @@ static int zram_add(void)
 	zram->disk->private_data = zram;
 	snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
 
+	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
+
 	/* Actual capacity set using sysfs (/sys/block/zram<id>/disksize */
 	set_capacity(zram->disk, 0);
 	/* zram devices sort of resembles non-rotational disks */
@@ -2281,8 +2283,6 @@ static int zram_add(void)
 	if (ret)
 		goto out_cleanup_disk;
 
-	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
-
 	zram_debugfs_register(zram);
 	pr_info("Added device: %s\n", zram->disk->disk_name);
 	return device_id;
-- 
2.25.1

