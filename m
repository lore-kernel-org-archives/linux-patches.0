Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3E5341674
	for <patches@lists.linux.dev>; Tue, 13 Jan 2026 09:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768296938; cv=none; b=GQybe2J6kvdmLBxVle55ZiZVf5mF7kaeMMPbnqsuIaVTCI/La6PQ8PACO7VXmJvzBhIoI9zKKEJGa8Mz9xOcejdeCQG4dIb6I1yaTr3GL8+mJZKpo3ftV/l89EoG1l5LSDcdm9OhRrMAb/muDEHGADEzFFQYf82TBQEKKq5vvqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768296938; c=relaxed/simple;
	bh=pMjvgNPLM7mMfHhYJaLseUgsQakwkO3YTs6fbL6VgEs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=hzb8jnt3AVn+tR9dqhsSQr0QF5MUlsuIhWriBxVQxLIF0IJx+bQJA4z0hvNX1bsgJHyvrpRkVhAodzV2zNsua+jAcljnl2luf8oQQG8oJA9g8T6o8yf8zKz0eguveB2QlxZ/NLSX/cRzOT1kOmNvxwxaSGwGfzjBXy5B98nKgRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=eJai0Sdj; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="eJai0Sdj"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260113093533epoutp02ca8a94dd81cd652786413487e7e96235~KQLE02VuC1742317423epoutp02N
	for <patches@lists.linux.dev>; Tue, 13 Jan 2026 09:35:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260113093533epoutp02ca8a94dd81cd652786413487e7e96235~KQLE02VuC1742317423epoutp02N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768296933;
	bh=eU3FGuQ3psPsVrKMGtnCEPXZ2vNAYVytaHGvtuaeumM=;
	h=From:To:Cc:Subject:Date:References:From;
	b=eJai0Sdj7NgM5lhh3wVhZXx1ZNgyaHeYejRsSywdKHur94J/Bof9w6qjm2V6VxSfu
	 yX6SwVbsCyDogmd77RIW09QNWRYuJE+jaczIBBHTfCYlpy8Ghcp50n5kVtIoS6np0j
	 NN3SQgJWlqR3ArUeK0uUvzIVvaOCRCfl2hWgrv5I=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260113093533epcas5p2ae24367b56d045f341de6a9e622631ed~KQLEkz6GJ1108811088epcas5p2r;
	Tue, 13 Jan 2026 09:35:33 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.90]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dr3yD3cpKz6B9m9; Tue, 13 Jan
	2026 09:35:32 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260113093532epcas5p402fd768992a67f4e58da2112a6adca2e~KQLDcjzJk2181921819epcas5p4z;
	Tue, 13 Jan 2026 09:35:32 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260113093530epsmtip2b6e020e514800055e93c683d97615ab8~KQLCN5YIh2795327953epsmtip2j;
	Tue, 13 Jan 2026 09:35:30 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: anuj20.g@samsung.com
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>
Subject: [PATCH 0/6] Test AG-aware parallel writeback for XFS
Date: Tue, 13 Jan 2026 15:00:44 +0530
Message-Id: <20260113093050.31705-1-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260113093532epcas5p402fd768992a67f4e58da2112a6adca2e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260113093532epcas5p402fd768992a67f4e58da2112a6adca2e
References: <CGME20260113093532epcas5p402fd768992a67f4e58da2112a6adca2e@epcas5p4.samsung.com>

Testing the format of patches

This series is a proof-of-concept exploring AG-aware parallel writeback for
XFS. The goal is to reduce writeback contention and improve scalability on
large filesystems by allowing writeback to be distributed across allocation
groups (AGs), while preserving existing iomap/writeback semantics.

Problem statement
=================
Today, XFS writeback walks the page cache serially per inode and funnels
all writeback through a single writeback context. On large, fragmented,
or aging filesystems, especially with high parallel buffered IO this leads
to :
 - lock contention on inode and mapping state
 - poor CPU scaling during background writeback
 - limited concurrency across independent AGs

The filesystem already has strong AG-level parallelism for allocation and
metadata operations, but writeback remains largely AG-agnostic.

High-level approach
===================

This series introduces an AG-aware writeback model with the these ideas:
1) Predict the target AG for buffered writes (mapped or delalloc) at write
   time.
2) Record AG hints per folio (via lightweight metadata / xarray).
3) Track dirty AGs per inode using bitmaps (hint-only).
4) Offload writeback to per-AG worker threads, each performing a one-pass
   scan for its AG only.
5) Reuse existing iomap writeback machinery (iomap_writeback_folio(),
   writeback_submit()) without changing IO submission semantics.

Importantly
===========
This is not a scan-until-clean model. Each worker performs a single pass and
exits.

Memory pressure safety:
Task objects are allocated from a slab-backed mempool.

No changes to global writeback behavior:
WB_SYNC_ALL continues to run synchronously.

Hint-only metadata:
AG prediction and dirty bitmaps are advisory; correctness does not depend
on perfect prediction.

Cleanup on consumption:
AG prediction entries are erased once a folio is processed to avoid
unbounded growth.

Patch overview
==============
Patch 1: Introduce ioamp write ops hook to attach metadata to folios.
Patch 2: Add helpers to pack AG info and iomap type.
Patch 3: Add per inode xarray to store the AG info also a dirty bitmap.
Patch 4: Tag folios with the AG number via iomap attach hook.
Patch 5: Introduce per-AG writeback worker infrastructure at mount time.
Patch 6: Offload XFS writeback to per-AG workers based on the inode dirty-AG
         bitmap.

Status
======
This is an early POC intended to gather feedback on:
- overall architecture
- correctness of the writeback integration
- interactions with iomap and VM writeback
- feasibility of AG-level writeback parallelism in XFS
- Performance numbers and tuning are out of scope for this series and will be
shared separately once the design stabilizes.

Any feedback—positive or negative—is very welcome.

Kundan Kumar (6):
  iomap: add write ops hook to attach metadata to folios
  xfs: add helpers to pack AG prediction info for per-folio tracking
  xfs: add per-inode AG prediction map and dirty-AG bitmap
  xfs: tag folios with AG number during buffered write via iomap attach
    hook
  xfs: add per-AG writeback workqueue infrastructure
  xfs: offload writeback by AG using per-inode dirty bitmap and per-AG
    workers

 fs/iomap/buffered-io.c |   3 +
 fs/xfs/xfs_aops.c      | 275 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_aops.h      |   3 +
 fs/xfs/xfs_icache.c    |  26 ++++
 fs/xfs/xfs_inode.h     |   6 +
 fs/xfs/xfs_iomap.c     | 120 ++++++++++++++++++
 fs/xfs/xfs_iomap.h     |  30 +++++
 fs/xfs/xfs_mount.c     |   2 +
 fs/xfs/xfs_mount.h     |   6 +
 fs/xfs/xfs_super.c     |   2 +
 include/linux/iomap.h  |   3 +
 11 files changed, 476 insertions(+)

-- 
2.25.1

