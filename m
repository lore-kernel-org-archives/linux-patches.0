Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060181;
	b=EVj4BWw+q2UCMvxUSCztce6QH1OigBi5bZ3xWhlUDaI7UI9C6e3J6i4I36Ugkf0gYw0F
	 QQXnus8Xt0Q7ObjDqtMeEGNIT+HHfm32dX9U29n4g1z/OVmRFIWnpeWvM/YwQ2GmEoBMe
	 M7z3vUU0dkOW7HsJdbjkUoN6lVSezVwvlfn0C5q3LygWGuXxAFtklNXYFg5vlLnQeDeff
	 Bg7aEgS2A4f3USoewcH5gX1jnxIgemTv8D7XcDVRXkGe4XOu3DBPL8KHj0cY3lxDfLSBK
	 esUw/6HAg52HkYYGnwRiZC4bsX/ewiuGR3ABDncVv3j5r8b2h1lW3LOg+kp/7WWHy5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nq+fwK6lzbu8VI3tGmVjq7h5//oZFl3kVHYjXaFYVF8=;
	b=yj/4EYjR60TFjxC0pL+sdTV5m5dOXLsA41zJG+A+vwFOsZL4mr5L7ZKJmnEGzAjYfKpr
	 vlubxdBkgNDhXhX6GjV4DL7dbtaSb5n9BsuIgRR9Y2kX8bpKgHLLg2kyQBFjyLuZ0XAHE
	 DZB+puZgDEuNMqkNp7mu7lcLPZwrGkyMoYGTH36H9+yHhaZpsdZZ1bJ3G0++G794js51e
	 UXDhGRUnakoNrjs6ZAOyuWFrAuhJoBWpe39YRtn5sUW1hfs0A4hOsB+/REaF9dkyc5ZEL
	 Q0HnGtRttWRiPDdW//xpMimzQn2L3ccMI7ghKEW6EcAO5L3WFUwE6n06EgdHT+YQsCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yey6Binb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11244606A320;
	Thu, 19 Nov 2026 03:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yey6Binb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2FE1F000C4;
	Thu, 19 Nov 2026 03:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060180;
	bh=nq+fwK6lzbu8VI3tGmVjq7h5//oZFl3kVHYjXaFYVF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yey6BinbBHqcBSDxkP2yHi4JY8l+Ob6qb9voEyBjiEziW/Hf5pCr+hFu6OhvMUgah
	 LaUm8yShKN9O8hSOP02iJlRSMhFveLqXcXDcfAPJCvZm0ataTMrTkzW+iE9fQjP+zu
	 ecImGgkQqaJ1ikamYEmSqUOkHbqwrjChb5kmwBSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Daejun Park <daejun7.park@samsung.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1105/1848] xfs: cap the block count of xfs_iomap_write_direct() at one extent
Date: Wed, 18 Nov 2026 15:52:23 +0100
Message-ID: <20261118150005.569885099@linuxfoundation.org>
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

[ Upstream commit 66d1ce09ebd72709f8d739630c39f440445173fd ]

xfs_iomap_write_direct() reserves blocks for the whole count in an
unsigned int. For a pNFS layout the client chooses that count, and an
RW LAYOUTGET for 16 TiB wraps the reservation and shuts XFS down.

xfs_bmapi_write() maps at most XFS_MAX_BMBT_EXTLEN blocks here, so cap
the count at that. nfsd asks again for the rest. The other callers get
the same mapping as before.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Pankaj Raghav <p.raghav@samsung.com>
Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: Replaced XFS_MAX_BMBT_EXTLEN with the equivalent MAXEXTLEN constant in the expression and comment. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_iomap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index bd5a25f4952d0..2f7cce023c0e8 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -203,6 +203,14 @@ xfs_iomap_write_direct(
 
 	ASSERT(count_fsb > 0);
 
+	/*
+	 * xfs_bmapi_write() maps at most MAXEXTLEN blocks in one
+	 * mapping, so don't reserve blocks for more. A pNFS layout range
+	 * comes from a client, and its block count may not even fit the
+	 * 32-bit reservation. The caller maps the rest with a later call.
+	 */
+	count_fsb = min_t(xfs_filblks_t, count_fsb, MAXEXTLEN);
+
 	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb,
 					   xfs_get_extsz_hint(ip));
 	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
-- 
2.53.0



