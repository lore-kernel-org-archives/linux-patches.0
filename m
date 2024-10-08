Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A21C18F2FA;
	Tue,  8 Oct 2024 13:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392456; cv=none; b=sncg0yUv1j3Idr8TCZBuK/bctUFUlb33nUnXqHSHWKadT9ddodIEb5DHihyNiQjcG7p/hh+MlG3M5aOza5Wo2Eov/jIZ0S/JzeBb/XxV1UcUT0znPn5ScUzXAPLmBZDfMYSDZmZaK55DmXOhJpJ3hgZr98C+pLTuLX1gADY0V4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392456; c=relaxed/simple;
	bh=EzX1pT7obh1XN9wBYP2dD74SUzkikKZyPPICHhm96aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFo1I2ca4i6g7Kvr4lqOe7ILtD3TMrD60ECohMI7R7/UlfJ5oXeGNGZENPk1uaMf+Jak1f4ht54DE+/lW/azAMJO5naE2kFfhqgojWX2ipt0szW/sm7QR8HfCuPG6QqQniegWO8siMc6Xu9yy7N7zRzfkJIHIOnm6Dg+gO4BM2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tguekBts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tguekBts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08C9C4CEC7;
	Tue,  8 Oct 2024 13:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392456;
	bh=EzX1pT7obh1XN9wBYP2dD74SUzkikKZyPPICHhm96aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tguekBtse+28cEfKwIjQh3a0NJc1Xn0r3e8MtZC1y+ZuYkJ+RbWXCJlh6MHzL46DU
	 6jcuS6qihGc0hb95Xwskx5iPUcg6oo5oaeBs1xw+8Lw8Jmw3yIoUlM2dauk0NXdCIL
	 3ysb6QeixzDj+2CPAk39K68Z9I7spwx0Dzfk6qLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Ying Lee <kuan-ying.lee@canonical.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 421/558] scripts/gdb: fix lx-mounts command error
Date: Tue,  8 Oct 2024 14:07:31 +0200
Message-ID: <20241008115718.839988830@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>

commit 4b183f613924ad536be2f8bd12b307e9c5a96bf6 upstream.

(gdb) lx-mounts
      mount          super_block     devname pathname fstype options
Python Exception <class 'gdb.error'>: There is no member named list.
Error occurred in Python: There is no member named list.

We encounter the above issue after commit 2eea9ce4310d ("mounts: keep
list of mounts in an rbtree"). The commit move a mount from list into
rbtree.

So we can instead use rbtree to iterate all mounts information.

Link: https://lkml.kernel.org/r/20240723064902.124154-4-kuan-ying.lee@canonical.com
Fixes: 2eea9ce4310d ("mounts: keep list of mounts in an rbtree")
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gdb/linux/proc.py |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/gdb/linux/proc.py
+++ b/scripts/gdb/linux/proc.py
@@ -18,6 +18,7 @@ from linux import utils
 from linux import tasks
 from linux import lists
 from linux import vfs
+from linux import rbtree
 from struct import *
 
 
@@ -172,8 +173,7 @@ values of that process namespace"""
         gdb.write("{:^18} {:^15} {:>9} {} {} options\n".format(
                   "mount", "super_block", "devname", "pathname", "fstype"))
 
-        for mnt in lists.list_for_each_entry(namespace['list'],
-                                             mount_ptr_type, "mnt_list"):
+        for mnt in rbtree.rb_inorder_for_each_entry(namespace['mounts'], mount_ptr_type, "mnt_node"):
             devname = mnt['mnt_devname'].string()
             devname = devname if devname else "none"
 


