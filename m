Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590388;
	b=QutpnJiiqrCW/C4fdJ+ThLP67pYsCFtUV9YukC0gvzR28OwDX+7FYipf9GYLjl39I1aJ
	 10AKKYvJ3nRk7cG4wC8iNwpimwyzaPF3sedzJryJQWOoVBtq6nyyUbdECHiNd5RfMl1lH
	 6sQHdcXUxWTZi2De0YgxvH8pKjrXMKsd+971BWBeqZ5o0ekmV7C2GMfMbbEEs7o9Fw0Gs
	 nmf6eZTePNFNaa8v+g+Aowe7xCaP6YglO7EEqQoz/IRm500WHrmGZgfxUj7xgvag2/DId
	 x/RJVoM5rLbImlyp2QKt1Hgz23nL2xnWpiAgpt8JfDkRL2eiivsC4DVjcrRrM7hFUGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mjJnNsVNiwznXJj5wKO5nizgzx4PdgFqPi6bdAAA0+M=;
	b=i7/QKwzzJt8rBTUBwPbPEybVZuO15dmnnOnPYgPP6qVcNAWYD2Pd4JZIGdfElr0HBDZ4
	 fxOMqjVaTOIPChqRhq+UkvP+HKVoM4boUo9DV2QsA/Io0TsppD5YTUgkXLniXVNX7xmeW
	 xT1bhvVnh/6/i8zax/Wt7zzd/naBlb6MYw3uQsPiiHVlkdw8JT741FFZLXxa9IiJt8YkF
	 NijtSbwueLu4BGCPJ41r9zo9OFF/+WG3AogJcTja1OMnkUl6VaNKX+nn1+YsF44VUqQ12
	 QPakSs7J9cRVra7qWfNbflPjWWhFGO7p6gP5Lvo0WuSa9c3I3ZAJ5TedWGHmxUaJDyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oAL7gMQn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A330606B344;
	Fri, 13 Nov 2026 17:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oAL7gMQn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBF31F000C7;
	Fri, 13 Nov 2026 17:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590388;
	bh=mjJnNsVNiwznXJj5wKO5nizgzx4PdgFqPi6bdAAA0+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oAL7gMQnSJUCZ0cwe3kYiZQH91i3zLJclQMtpaYNvw2MBDNEyaWPC6pnSs7uMYT6h
	 ejoIJDa4f2JGrHPtWLr7cW3iYYmxHiqrh/JAp0hP9w0kI6jGllBuhBAVkLKNMK/mZi
	 C4EWtBeHByAZHss9XHq7sPR85jcXwsY+fpL7rhXQ=
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
Subject: [PATCH 6.18 357/686] xfs: cap the block count of xfs_iomap_write_direct() at one extent
Date: Fri, 13 Nov 2026 10:48:10 -0500
Message-ID: <20261113153833.006904732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_iomap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index a1c88df45dd0d..c7dea4242e8bf 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -282,6 +282,14 @@ xfs_iomap_write_direct(
 
 	ASSERT(count_fsb > 0);
 
+	/*
+	 * xfs_bmapi_write() maps at most XFS_MAX_BMBT_EXTLEN blocks in one
+	 * mapping, so don't reserve blocks for more. A pNFS layout range
+	 * comes from a client, and its block count may not even fit the
+	 * 32-bit reservation. The caller maps the rest with a later call.
+	 */
+	count_fsb = min_t(xfs_filblks_t, count_fsb, XFS_MAX_BMBT_EXTLEN);
+
 	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb,
 					   xfs_get_extsz_hint(ip));
 	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
-- 
2.53.0



