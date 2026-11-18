Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060310;
	b=LulWgwL3FYp5ZfQ2qdG0WjWRqmsLVABDsU/T1zF0puaWt7OdUbWyxFPdahMqZqgkqm/h
	 1ZBbswv5RPWzDWSiPkVthQBzEy9QGLJzB8t946btGYhghDkrUB4WovkPFlEzi/lfIxuzz
	 LHEg+/KH2RFGpO3z4naEQ3mWVA6AYvtyrW5AJ4f6UiqrUI7to2VhMJhqIr1OSuXi14LTQ
	 UG0yqIi4W6dtgWGXnUCbplz4lU+I/+tV/7VqY4yyh4qIP7xy5yhI0eIkZyTObt6ywifM4
	 WHOCtVh4RdqQCMQsKLpkUf10w8Yj3bD0CLYUJZksj/2equ1ksaeWHZGzitWBXcc9QdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E0xzkwtbzZOjSwdNxEdTUoyPFT5rc9Oocs6gJQjBnOk=;
	b=3ccp2KxjepKZnOj4VHgIxdVnDTiRBrfwxJFfxO9ez1DuP0neTxi46FO/IGnZsXrwe+vo
	 /nmq3G8hxYRBXzG84idKXE/hIXcvmjU/9OixLQwf2N710ge5AjMl1oMEpsLjzqKplcALw
	 7YLBvyW34uFMq7FGRQU9M2wRwJReLDH0zH3xZiXU/n817ow0XX6H23AKp2RpJXF8iyQdL
	 nnMqKlp14MH+iL4dJ6Q9SLv80liUr95DjKjf+BEt3BqEBt/WLSFhDcJvSIHS/VTAZduZo
	 ozGY8syqJWaBcoBzQ/2Hpnrd1siJZ34RQp8VaIPbN0JbPsRpJchmTfiIKQil6157n8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ieYAYcT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AF1606A320;
	Thu, 19 Nov 2026 03:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1ieYAYcT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831D61F000C4;
	Thu, 19 Nov 2026 03:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060310;
	bh=E0xzkwtbzZOjSwdNxEdTUoyPFT5rc9Oocs6gJQjBnOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1ieYAYcTY8XeOE8AoCcMbIv8clEpxo4pwYSsFanxjjJ/jTm6ws8QuqkKqF2LhVNFD
	 jkGqCr0AgmlzokpBygCk12dTuwVfCDuAyup3WljA6keN5Sdqhu+xlz+QJhL+kUbBdT
	 WzZpe1094CWQ0aXvgeWlybY3g3EzsGDZ2GIi6bG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Daejun Park <daejun7.park@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1112/1848] xfs: add a flag to convert unwritten extents without allocating blocks
Date: Wed, 18 Nov 2026 15:52:30 +0100
Message-ID: <20261118150005.890844638@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit f3ca3498dfe624f9b604c934263538a3acd55af5 ]

xfs_bmapi_write() with XFS_BMAPI_CONVERT also allocates blocks for
holes and delalloc extents in the range. Add XFS_BMAPI_CONVERT_ONLY for
callers that may only convert already allocated blocks. It stops at a
hole or delalloc extent, and returns -ENOSR if it stops before mapping
anything.

Marked for stable because "xfs: refuse a pNFS LAYOUTCOMMIT of a range
without blocks" needs it.

Suggested-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20261013120359.GB2944@lst.de
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: used a separate conversion-only -ENOSR check because the general zero-mapping error check is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 12 ++++++++++++
 fs/xfs/libxfs/xfs_bmap.h | 10 +++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5483572512edf..124c60176c612 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4304,6 +4304,8 @@ xfs_bmapi_finish(
  * extent state if necessary.  Details behaviour is controlled by the flags
  * parameter.  Only allocates blocks from a single allocation group, to avoid
  * locking problems.
+ * With XFS_BMAPI_CONVERT_ONLY, it stops at a hole or a delalloc extent instead
+ * of allocating blocks, and returns -ENOSR if it stops before mapping anything.
  */
 int
 xfs_bmapi_write(
@@ -4363,6 +4365,8 @@ xfs_bmapi_write(
 	 */
 	ASSERT((flags & (XFS_BMAPI_PREALLOC | XFS_BMAPI_ZERO)) !=
 			(XFS_BMAPI_PREALLOC | XFS_BMAPI_ZERO));
+	ASSERT(!(flags & XFS_BMAPI_CONVERT_ONLY) ||
+	       (flags & XFS_BMAPI_CONVERT));
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
@@ -4412,6 +4416,9 @@ xfs_bmapi_write(
 		 * that we found, if any.
 		 */
 		if (need_alloc || wasdelay) {
+			if (flags & XFS_BMAPI_CONVERT_ONLY)
+				break;
+
 			bma.eof = eof;
 			bma.conv = !!(flags & XFS_BMAPI_CONVERT);
 			bma.wasdel = wasdelay;
@@ -4486,6 +4493,11 @@ xfs_bmapi_write(
 	xfs_bmapi_finish(&bma, whichfork, 0);
 	xfs_bmap_validate_ret(orig_bno, orig_len, orig_flags, orig_mval,
 		orig_nmap, *nmap);
+
+	if (!n && (flags & XFS_BMAPI_CONVERT_ONLY)) {
+		ASSERT(bma.nallocs == 0);
+		return -ENOSR;
+	}
 	return 0;
 error0:
 	xfs_bmapi_finish(&bma, whichfork, error);
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 6747e97a79490..1d68bd3c2863d 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -101,6 +101,13 @@ struct xfs_extent_free_item
 /* Do not update the rmap btree.  Used for reconstructing bmbt from rmapbt. */
 #define XFS_BMAPI_NORMAP	0x2000
 
+/*
+ * Use with XFS_BMAPI_CONVERT to convert unwritten extents without allocating
+ * blocks. Stop at a hole or a delalloc extent: return the mappings found so
+ * far, or -ENOSR if there are none.
+ */
+#define XFS_BMAPI_CONVERT_ONLY	0x4000
+
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
 	{ XFS_BMAPI_METADATA,	"METADATA" }, \
@@ -112,7 +119,8 @@ struct xfs_extent_free_item
 	{ XFS_BMAPI_REMAP,	"REMAP" }, \
 	{ XFS_BMAPI_COWFORK,	"COWFORK" }, \
 	{ XFS_BMAPI_NODISCARD,	"NODISCARD" }, \
-	{ XFS_BMAPI_NORMAP,	"NORMAP" }
+	{ XFS_BMAPI_NORMAP,	"NORMAP" }, \
+	{ XFS_BMAPI_CONVERT_ONLY,	"CONVERT_ONLY" }
 
 
 static inline int xfs_bmapi_aflag(int w)
-- 
2.53.0



