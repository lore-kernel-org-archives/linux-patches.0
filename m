Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69B933993
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754542691; cv=none; b=IhgRy8CHxF8tUSCK4XGBAakwb671c5mJEM46lTnh6rvU6QOY3fZyOWIB4+RECQ3X76qk6jktPj5i0dCeHJE5ywycT2YmSs6LD2dGQnP3yvC9duwqBrHeI6lLmpy7H8c6EW9AlsnItdWFDfX6xa3Q8x0Zkw40a6uRAhr2GfXFYc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754542691; c=relaxed/simple;
	bh=r1e0AQy+sit6owrwTi5PY/XGnzYaf8FR1YK7fLwLllA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=AN8HN8mG9mzgdS+GGl5t1jlifBSs9bRva3Z9F965XEAVEX7uyLuW01AIfJ4jMIRtwj9UXABr/aagF0xuLS9UYrz5m2ZvZ+9lFK2hj9zdjQbArj1AyPbpznCu63LfyKTXTwJXkCxAKOvtZM3Jwdj+EC8GNQXrewBrZ30uiZK5fOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=HM9C/RZ7; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="HM9C/RZ7"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250807045800epoutp012626bc5fbaee898632d7bcccbfad2b36~ZY0WfW5BA1937019370epoutp01K
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:58:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250807045800epoutp012626bc5fbaee898632d7bcccbfad2b36~ZY0WfW5BA1937019370epoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1754542680;
	bh=TC2X9up+BbeYi7E39j8KbJ1NkMc3ShamjPrzoIvspko=;
	h=From:To:Cc:Subject:Date:References:From;
	b=HM9C/RZ7oL8fa1C4YIZ/9yzJpV71Km1VRGRR2i4cMNQkRghIvsiHEIe3Tem1gIObB
	 NjP+LaHHv+wB8eavALWjkeFw/L4VOT+kRpPGHkggom1V1tfE6Zy9j+0Q4c/54pQk8+
	 f+s7jK4YtRJ1gSgq6PRR6e2opp6uOhH2TZb6zoW0=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250807045800epcas5p24b599575b3e68e80f485c93dcfad1bbe~ZY0WOvDTw3181431814epcas5p2T;
	Thu,  7 Aug 2025 04:58:00 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.94]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4byFKM1bCVz3hhT8; Thu,  7 Aug
	2025 04:57:59 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250807045740epcas5p4cdec49f07b86acf2eea832890393d256~ZY0EGj8dm1537115371epcas5p4x;
	Thu,  7 Aug 2025 04:57:40 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250807045740epsmtip112e9a706072727b3c0416e14b6925fd1~ZY0DmtXp-1637916379epsmtip1q;
	Thu,  7 Aug 2025 04:57:40 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>
Subject: [PATCH v2 00/15] Test patch Parallelizing filesystem writeback
Date: Thu,  7 Aug 2025 10:26:51 +0530
Message-Id: <20250807045706.2848-1-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250807045740epcas5p4cdec49f07b86acf2eea832890393d256
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250807045740epcas5p4cdec49f07b86acf2eea832890393d256
References: <CGME20250807045740epcas5p4cdec49f07b86acf2eea832890393d256@epcas5p4.samsung.com>

** Test patch do not review **

Currently, pagecache writeback is performed by a single thread. Inodes
are added to a dirty list, and delayed writeback is triggered. The single
writeback thread then iterates through the dirty inode list, and executes
the writeback.

This series parallelizes the writeback by allowing multiple writeback
contexts per backing device (bdi). These writebacks contexts are executed
as separate, independent threads, improving overall parallelism.

Design Overview
================
Following Jan Kara's suggestion [1], we have introduced a new bdi
writeback context within the backing_dev_info structure. Specifically,
we have created a new structure, bdi_writeback_context, which contains
its own set of members for each writeback context.

struct bdi_writeback_ctx {
        struct bdi_writeback wb;
        struct list_head wb_list; /* list of all wbs */
        struct radix_tree_root cgwb_tree;
        struct rw_semaphore wb_switch_rwsem;
        wait_queue_head_t wb_waitq;
};

There can be multiple writeback contexts in a bdi, which helps in
achieving writeback parallelism.

struct backing_dev_info {
...
        int nr_wb_ctx;
        struct bdi_writeback_ctx **wb_ctx;
...
};

FS geometry and filesystem fragmentation
========================================
The community was concerned that parallelizing writeback would impact
delayed allocation and increase filesystem fragmentation.
Our analysis of XFS delayed allocation behavior showed that merging of
extents occurs within a specific inode. Earlier experiments with multiple
writeback contexts [2] resulted in increased fragmentation due to the
same inode being processed by different threads.

To address this, we now affine an inode to a specific writeback context
ensuring that delayed allocation works effectively.

Number of writeback contexts
============================
As suggested by Christoph we have provided a sysfs interface to change
the number of writebacks. Also we plan to keep the number as 1 for
spinning disk.

IOPS and throughput
===================
We see significant improvement in IOPS across several filesystem on both
PMEM and NVMe devices.

Performance gains:
  - On PMEM:
        Base XFS                : 544 MiB/s
        Parallel Writeback XFS  : 1015 MiB/s  (+86%)
        Base EXT4               : 536 MiB/s
        Parallel Writeback EXT4 : 1047 MiB/s  (+95%)

  - On NVMe:
        Base XFS                : 651 MiB/s
        Parallel Writeback XFS  : 808 MiB/s  (+24%)
        Base EXT4               : 494 MiB/s
        Parallel Writeback EXT4 : 797 MiB/s  (+61%)

We also see that there is no increase in filesystem fragmentation
# of extents:
  - On XFS (on PMEM):
        Base XFS                : 1964
        Parallel Writeback XFS  : 1384

  - On EXT4 (on PMEM):
        Base EXT4               : 21
        Parallel Writeback EXT4 : 11

We also plan to see the impact on other filesystems.

[1] Jan Kara suggestion :
https://lore.kernel.org/all/gamxtewl5yzg4xwu7lpp7obhp44xh344swvvf7tmbiknvbd3ww@jowphz4h4zmb/
[2] Writeback using unaffined N (# of CPUs) threads :
https://lore.kernel.org/all/20250414102824.9901-1-kundan.kumar@samsung.com/

Changes since v1:
 - Added sysfs entry to change the number of writebacks for a bdi
 - Added a filesystem interface to fetch 64 bit inode numbers
 - Made common helpers to contain writeback specific changes, which were
   affecting f2fs, fuse, gfs2 and nfs
 - Changed name from wb_ctx_arr to wb_ctx

Kundan Kumar (15):
  writeback: add infra for parallel writeback
  writeback: add support to initialize and free multiple writeback ctxs
  writeback: link bdi_writeback to its corresponding bdi_writeback_ctx
  writeback: affine inode to a writeback ctx within a bdi
  writeback: modify bdi_writeback search logic to search across all wb
    ctxs
  writeback: invoke all writeback contexts for flusher and dirtytime
    writeback
  writeback: modify sync related functions to iterate over all writeback
    contexts
  writeback: add support to collect stats for all writeback ctxs
  f2fs: add support in f2fs to handle multiple writeback contexts
  fuse: add support for multiple writeback contexts in fuse
  gfs2: add support in gfs2 to handle multiple writeback contexts
  nfs: add support in nfs to handle multiple writeback contexts
  writeback: set the num of writeback contexts to number of online cpus
  writeback: segregated allocation and free of writeback contexts
  writeback: added support to change the number of writebacks using a
    sysfs attribute

 fs/f2fs/node.c                   |   4 +-
 fs/f2fs/segment.h                |   2 +-
 fs/fs-writeback.c                | 148 ++++++++-----
 fs/fuse/file.c                   |   8 +-
 fs/gfs2/super.c                  |   2 +-
 fs/nfs/internal.h                |   2 +-
 fs/nfs/write.c                   |   4 +-
 fs/super.c                       |  23 ++
 fs/xfs/xfs_super.c               |  12 ++
 include/linux/backing-dev-defs.h |  32 +--
 include/linux/backing-dev.h      |  77 +++++--
 include/linux/fs.h               |   3 +-
 mm/backing-dev.c                 | 349 ++++++++++++++++++++++++-------
 mm/page-writeback.c              |  13 +-
 14 files changed, 513 insertions(+), 166 deletions(-)

-- 
2.25.1

