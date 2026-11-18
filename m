Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032876;
	b=4mTw32KcQpxz0PZmIUaw/KD3eLmGEEpYaIl8RHs/IS5OStl8dD1Ix93WjT1nFfO9cJI+
	 5yvvZrKg4ODUtjR/g5Wvj5dhXq/g207G8kDJqQS+S/VH1EnI2+/o009DMJR+MVLZNH9//
	 s3Bh+0DbIHazzHk0KXUoLlyLlaXSFnpMUY+kzeCtKiAq8M7B96of9dlQcs2L7xuu0fC8j
	 nZttWO2cuxdV/UIUV33f0YMQaN8uTDt4paKiMtigJ5+VwaSPaGDWFZRaCo/i8Nlijke1G
	 6wPi/8ty9kot9p7fjb75bSvyHzpK6otUGqmpEYwEhl4HyXDD1UUcMaT68XYe6l6gSwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032876;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=epkZHM0CrofJOTI0p8O8tqD+yZDDkyY+/gHN6cYTPCc=;
	b=jadKwE0vQbcy7MlJzEsAYvDBuNUMxFFdwLWBLQV93j/dscgLXckCu74cWU2QuBGVSKXb
	 XoaZXvWI4Mzq30nkFnbaNlQn5kOxjnlA+ROW2t4NuzRdqoBzG3m3gLIqfgfdNP5NqcsLZ
	 FTcH0vEwQ+FZ6e2j2egTwMiE3G5Z7tGvkjQZP2cKw8yHotUrJ9c3Jm16NM+HEmevYxhHX
	 sELyS/EbqZnH3f+pWLmhYiGCQ67aAZ+2wZLHyLGfdSQ+mx9G/HieZ9uHDQJCYosXcbIkD
	 HLZT24vK8QqakrUmvE7HaxU546YAFBUfucdReHDuHATJqZxVkMxT9ZVmi4CF/wbzSSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qmDsT65k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBD9606A335;
	Wed, 18 Nov 2026 20:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qmDsT65k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39FB91F000C4;
	Wed, 18 Nov 2026 20:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032875;
	bh=epkZHM0CrofJOTI0p8O8tqD+yZDDkyY+/gHN6cYTPCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qmDsT65kB71sJVA97h6ztmFRbEcRRQGbILVYfFDyacVnLPhUgqwEOYNMtYU+mJ2hm
	 RHf7bwMZeQj5Y/uiyBwJDfr+bWjBGMX9EUD1oDsCkS0h+XHfYpeosWcTZ44iXount8
	 0XBZLme08om3UjskllobazqUV1uNSvrGGXTfWPmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1568/1756] ceph: Convert ceph_move_dirty_page_in_page_array() to move_dirty_folio_in_page_array()
Date: Wed, 18 Nov 2026 16:01:35 +0100
Message-ID: <20261118150112.080432946@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit ad49fe2b3d54fe657756e1dbf0acb5ed9cf5c576 ]

Shorten the name of this internal function by dropping the 'ceph_'
prefix and pass in a folio instead of a page.

Signed-off-by: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Link: https://lore.kernel.org/r/20250217185119.430193-9-willy@infradead.org
Tested-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 7807710d88ad ("ceph: fix writeback_count leak when a bounce page allocation fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index e9fa0b9afcc13..cb791f468d376 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1267,11 +1267,9 @@ bool is_write_congestion_happened(struct ceph_fs_client *fsc)
 		CONGESTION_ON_THRESH(fsc->mount_options->congestion_kb);
 }
 
-static inline
-int ceph_move_dirty_page_in_page_array(struct address_space *mapping,
-					struct writeback_control *wbc,
-					struct ceph_writeback_ctl *ceph_wbc,
-					struct page *page)
+static inline int move_dirty_folio_in_page_array(struct address_space *mapping,
+		struct writeback_control *wbc,
+		struct ceph_writeback_ctl *ceph_wbc, struct folio *folio)
 {
 	struct inode *inode = mapping->host;
 	struct ceph_fs_client *fsc = ceph_inode_to_fs_client(inode);
@@ -1281,7 +1279,7 @@ int ceph_move_dirty_page_in_page_array(struct address_space *mapping,
 	gfp_t gfp_flags = ceph_wbc->locked_pages ? GFP_NOWAIT : GFP_NOFS;
 
 	if (IS_ENCRYPTED(inode)) {
-		pages[index] = fscrypt_encrypt_pagecache_blocks(page,
+		pages[index] = fscrypt_encrypt_pagecache_blocks(&folio->page,
 								PAGE_SIZE,
 								0,
 								gfp_flags);
@@ -1300,7 +1298,7 @@ int ceph_move_dirty_page_in_page_array(struct address_space *mapping,
 			return err;
 		}
 	} else {
-		pages[index] = page;
+		pages[index] = &folio->page;
 	}
 
 	ceph_wbc->locked_pages++;
@@ -1391,8 +1389,8 @@ int ceph_process_folio_batch(struct address_space *mapping,
 
 		fsc->write_congested = is_write_congestion_happened(fsc);
 
-		rc = ceph_move_dirty_page_in_page_array(mapping, wbc,
-							ceph_wbc, &folio->page);
+		rc = move_dirty_folio_in_page_array(mapping, wbc, ceph_wbc,
+				folio);
 		if (rc) {
 			/* Did we just begin a new contiguous op? Nevermind! */
 			if (ceph_wbc->len == 0)
-- 
2.53.0



