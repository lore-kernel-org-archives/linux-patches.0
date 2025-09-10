Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29C7219A7D
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757499262; cv=none; b=Kr2I7LmK/UzMvu6+VKlr0d7IYokRV8+iMXJ/81praNbvb6kRL09N1i3B5SQ0jZUDCIW3mfos/0oy2BpfsRJBYBTezxIBoqi+hufAnqSRh8uclK67d29i8BU1gMggMOan5SzyMMM3ukJ8hxotpJkwQOvh0CPod75o/mwDI/IK3hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757499262; c=relaxed/simple;
	bh=vvRpfp15fdsBDDV5Wbx9GMG1Qa+OwPZ6jYvrmaoR2cI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=KsSHBzRY4bxQu6Txj2ny/6zLQe0/WmGLuztWiQQOxpWVXludTLYIaW++4AZhz0OGxqM9i3l//VyG3/DRgfZk9I/0wO/gRDKPFJ/Qe/sgxzy9TY+Shd2LUz8BM8BuJ3M7Fm/Wd8GrAHU/I2y2321x+s9wQx7NJysK1BQBDVPPif4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FIvcH7CE; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FIvcH7CE"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250910101417epoutp03150577804d767a14c4641656d15220fb~j5ENnLrDb0946109461epoutp03O
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250910101417epoutp03150577804d767a14c4641656d15220fb~j5ENnLrDb0946109461epoutp03O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757499257;
	bh=7eLWWAJa4ojsN9WdzPCTPzTzNe3wU6h6Zwb0XVEPhx0=;
	h=From:To:Cc:Subject:Date:References:From;
	b=FIvcH7CE9MIPnR+hGKO0gOmKprKI0VMBbvzcP3DvI0ph6bkD38W9627AgDf3aip9q
	 jtDYMGNBrEyHRmLsGtRVbfm9tQHZcXGGvS6cC/gQAGlaLojQOUp/VIUjOAruaFM+BH
	 hlmagz65Tm33giAyi0IJ1T4dqI6sTGPJm/Qf9Yuk=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250910101417epcas5p4de91bd3f700995e1caf72601a004d79f~j5ENQKO3B2882828828epcas5p4x;
	Wed, 10 Sep 2025 10:14:17 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.93]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cMGkc2ZvDz6B9m5; Wed, 10 Sep
	2025 10:14:16 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250910101415epcas5p19735711ac4ae27d63f43f8ca2ae02d3e~j5EL8x2ne0086900869epcas5p1m;
	Wed, 10 Sep 2025 10:14:15 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250910101415epsmtip1c0255321512b6da5c06f31f0fc562103~j5ELeCk2y2243122431epsmtip1N;
	Wed, 10 Sep 2025 10:14:15 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>
Subject: [PATCH v2 00/16] Test patch for parallelizing weriteback
Date: Wed, 10 Sep 2025 15:42:48 +0530
Message-Id: <20250910101304.2588-1-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250910101415epcas5p19735711ac4ae27d63f43f8ca2ae02d3e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250910101415epcas5p19735711ac4ae27d63f43f8ca2ae02d3e
References: <CGME20250910101415epcas5p19735711ac4ae27d63f43f8ca2ae02d3e@epcas5p1.samsung.com>

test patch

Kundan Kumar (16):
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
  writeback: configure the num of writeback contexts between 0 and
    number of online cpus
  writeback: segregated allocation and free of writeback contexts
  writeback: added support to change the number of writebacks using a
    sysfs attribute
  writeback: make default number of writeback threads equal to num cpus

 fs/f2fs/node.c                   |   4 +-
 fs/f2fs/segment.h                |   2 +-
 fs/fs-writeback.c                | 148 ++++++++-----
 fs/fuse/file.c                   |   8 +-
 fs/gfs2/super.c                  |   2 +-
 fs/nfs/internal.h                |   2 +-
 fs/nfs/write.c                   |   4 +-
 fs/super.c                       |  23 ++
 fs/xfs/xfs_super.c               |  13 ++
 include/linux/backing-dev-defs.h |  32 +--
 include/linux/backing-dev.h      |  78 +++++--
 include/linux/fs.h               |   3 +-
 mm/backing-dev.c                 | 354 ++++++++++++++++++++++++-------
 mm/page-writeback.c              |  13 +-
 14 files changed, 521 insertions(+), 165 deletions(-)

-- 
2.25.1

