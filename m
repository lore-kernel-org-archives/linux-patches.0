Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774134;
	b=PWSnIK10/F9hk0UlHxNLcO6mfFU1+fnVnwAYrIej74wOudCJl3U/w/UXn+APJfLqOKAn
	 VVyVCB0sLwJMV1cQ7/5iChSgXTlvt29LIXUsRRCWv7yveNfEjt2Ib0SROU0o7AL7nW8eV
	 LBeDmjabjGEBxRkCgKOTWT9+M5ZoLB5NngS/zxQrgMffXf4hcDbowaIASs0yjmach3Ck4
	 7S6gDYfMiKDB0cNJ96OsZM/6r3Qa4N5l+yHyKOv/CAqz40yql/V2HZ6YSYgieF0T2ERsh
	 Z9ia6cUpJelYSnoo5WMQN/EfUNjHv33fg55r7LyHp5Jdtc0HLlsb30mBv2pJ3CulscQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hOKsKwXIJRu8nNnIv9KmSsh8tO1KGw01LvghaVqfO1I=;
	b=CxpSlRU93OQlr7lxEzFyUUqW0pG3xm9JBJ2VBw8v6zkyKpp6Zz9b5FMJe1V/h5XX5HA8
	 U/OgTot3ZQkZufB8XONbLNOdwMfgZzT5csuh2ModtGFaT2F1iStyiabDQIEvUJTjA0ZLn
	 /JaVAdh9gs400pHJH8zBrlQcdj2ptGbOdfbFOSSAI6QvyCA48O1qYV1TEGLVmEIP3jybK
	 SaHdDnKFRfOjIVi6kC/tFCVMYyCdXGzflVWXDga4lm5N7HHqPlLq93g6hfRfkSVJY2Pnu
	 ZZl56EwcCNWVKsd1E52ED69/aqEErVci3YAbBU9kxwn2/vuV00826bugnetYvXzkGsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FGnEFY7L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A2A606A31B;
	Fri, 23 Oct 2026 16:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FGnEFY7L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E2E1F01828;
	Fri, 23 Oct 2026 16:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774133;
	bh=hOKsKwXIJRu8nNnIv9KmSsh8tO1KGw01LvghaVqfO1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FGnEFY7LyEKY+E0hw+HjV4IHY8yzN5FSerBu8iZah6aEnTtd8s+WNBHp/usvOT8lV
	 OAm1wTGmCm8fzEPYBamh/+T4DIcOpLu+R9FBVnELOgEzeC1d705kszZcNvSQ3hcvfS
	 62z1TJvVqRdFXNIroDIK23cqBOaRGAC+7FMxlcII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 131/193] xfs: fix zoned write iomap flags assignments
Date: Fri, 23 Oct 2026 18:36:48 +0200
Message-ID: <20261023163717.307039438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 4bc67fc800edcaae8a657e4d2fba12e64e856b9f upstream.

Don't overwrite IOMAP_F_DIRTY with IOMAP_F_ANON_WRITE, but ensure both
flags are set instead.

Note that in practice this is harmless as all zoned writes force a metadata
transaction anyway, but incorrectly assigned flags are still a landmine
that will cause problems at some point.

Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
Fixes: 2e2383405824 ("xfs: implement direct writes to zoned RT devices")
Cc: stable@vger.kernel.org # v6.15
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_aops.c  |    3 +--
 fs/xfs/xfs_iomap.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -616,11 +616,10 @@ xfs_zoned_map_blocks(
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	wpc->iomap.type = IOMAP_MAPPED;
-	wpc->iomap.flags = IOMAP_F_DIRTY;
 	wpc->iomap.bdev = mp->m_rtdev_targp->bt_bdev;
 	wpc->iomap.offset = offset;
 	wpc->iomap.length = XFS_FSB_TO_B(mp, count_fsb);
-	wpc->iomap.flags = IOMAP_F_ANON_WRITE;
+	wpc->iomap.flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
 
 	trace_xfs_zoned_map_blocks(ip, offset, wpc->iomap.length);
 	return 0;
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1078,11 +1078,10 @@ xfs_zoned_direct_write_iomap_begin(
 	}
 
 	iomap->type = IOMAP_MAPPED;
-	iomap->flags = IOMAP_F_DIRTY;
 	iomap->bdev = ip->i_mount->m_rtdev_targp->bt_bdev;
 	iomap->offset = offset;
 	iomap->length = length;
-	iomap->flags = IOMAP_F_ANON_WRITE;
+	iomap->flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
 	return 0;
 }
 


