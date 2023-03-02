Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83BB10780
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 23:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=skC96Wt8xxhIMwjo9L+gt44Hnic6JkSNTvyHUyToP4E=; b=K/eQSla3MTHn7M0Rb9rcMYDVlA
	e37q4SAkKhrm7U/RKwrVlRksYjpLSQ7cyFhGajl9HtpsHsUn6N0cRNl0Qv09F6TFF8NJALHGbqV9Y
	MKle2ZzppMMuer2n5cLdK6TEumXDYu//CEasZglQ4GBDSIpbcgf9zrLrspyNLR57fU9TjiN84RzjX
	DJKtgrXnUJH4f9ErONxxluGJkBZMTUgr6znqZikMJYzDqfZ43mgtSToV2ADG2RhlMqjD5DNDGVY4q
	QwjsemBTEGNoJzgAOOd9LwEPm7jsyyl3cLget4EvACCEKtoo27Ivb7ie0zI+m3cji7ZAqVl11QKp8
	lTov+nwA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pXsL9-003j3Q-Dq; Thu, 02 Mar 2023 23:27:59 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: hughd@google.com,
	akpm@linux-foundation.org,
	willy@infradead.org,
	brauner@kernel.org
Cc: linux-mm@kvack.org,
	p.raghav@samsung.com,
	da.gomez@samsung.com,
	a.manzanares@samsung.com,
	dave@stgolabs.net,
	yosryahmed@google.com,
	keescook@chromium.org,
	mcgrof@kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] shmem: update documentation
Date: Thu,  2 Mar 2023 15:27:57 -0800
Message-Id: <20230302232758.888157-6-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230302232758.888157-1-mcgrof@kernel.org>
References: <20230302232758.888157-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Update the docs to reflect a bit better why some folks prefer tmpfs
over ramfs and clarify a bit more about the difference between brd
ramdisks.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 Documentation/filesystems/tmpfs.rst | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/tmpfs.rst b/Documentation/filesystems/tmpfs.rst
index 0408c245785e..e77ebdacadd0 100644
--- a/Documentation/filesystems/tmpfs.rst
+++ b/Documentation/filesystems/tmpfs.rst
@@ -13,14 +13,25 @@ everything stored therein is lost.
 
 tmpfs puts everything into the kernel internal caches and grows and
 shrinks to accommodate the files it contains and is able to swap
-unneeded pages out to swap space. It has maximum size limits which can
-be adjusted on the fly via 'mount -o remount ...'
-
-If you compare it to ramfs (which was the template to create tmpfs)
-you gain swapping and limit checking. Another similar thing is the RAM
-disk (/dev/ram*), which simulates a fixed size hard disk in physical
-RAM, where you have to create an ordinary filesystem on top. Ramdisks
-cannot swap and you do not have the possibility to resize them.
+unneeded pages out to swap space.
+
+tmpfs extends ramfs with a few userspace configurable options listed and
+explained further below, some of which can be reconfigured dynamically on the
+fly using a remount ('mount -o remount ...') of the filesystem. A tmpfs
+filesystem can be resized but it cannot be resized to a size below its current
+usage. tmpfs also supports POSIX ACLs, and extended attributes for the
+trusted.* and security.* namespaces. ramfs does not use swap and you cannot
+modify any parameter for a ramfs filesystem. The size limit of a ramfs
+filesystem is how much memory you have available, and so care must be taken if
+used so to not run out of memory.
+
+An alternative to tmpfs and ramfs is to use brd to create RAM disks
+(/dev/ram*), which allows you to simulate a block device disk in physical RAM.
+To write data you would just then need to create an regular filesystem on top
+this ramdisk. As with ramfs, brd ramdisks cannot swap. brd ramdisks are also
+configured in size at initialization and you cannot dynamically resize them.
+Contrary to brd ramdisks, tmpfs has its own filesystem, it does not rely on the
+block layer at all.
 
 Since tmpfs lives completely in the page cache and on swap, all tmpfs
 pages will be shown as "Shmem" in /proc/meminfo and "Shared" in
-- 
2.39.1

