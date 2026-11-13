Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591172;
	b=Jffxdh7teEv6VXWrqZjRRzl1DXkgf0vtiEYXJ3nc21+h7+t9NE1fgGbDP/ZHJBPDh3P2
	 Oup97UQIdqsCfrD/nHBdQMHAjm3U+42CA+dh3QEIFTLVBZ6o9obDBuT3K/jW4YfGlTGc8
	 FE3XrY1X8LVGaXs3X46j2zn76Xal8ug7PkIwwMedmuZmbSxYZblVcXKlhVbRKnmp29uf9
	 M2rkm6mBJ2DLcnhhrqXoQS9cD6XL6+fwoR41Gc8pWiMhTrOX/FhlJcm7WxiFAv0MeeHyy
	 R9jr5+VE7/QJ83B4mAJbJ7huSAgJ8GIhyGDcExPsmOFQrjlgTFXaebULjxaqQxjy+qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i9c85/l6HWLHXLBuPxqiMoe8r0OnvvmEHmuwtyGlOGk=;
	b=HoSuL6a9LzckENfyT4bMkKLPLTNKYz4h1SeFTJW4joc/0GLq98LxQjyP/ZYloTv+i+F5
	 SfEbmcArxBVADkpMx3QT/rYb+MC2iUNsSY5Qks3OYBi/0g39GljsujRz00cYWXCu4J6VH
	 pZcm6dMZ5LTiLcSq8WUDDmdWRTYKJJGlmXOWQitxY5tHc3V5j5XL452hkkY6yr4STDgAf
	 BhfIwdJxZW2hsG0GR9ztpXtsjU/rmaYoqd6Y512EzRt9FeWy66WtU20T+mX1gH5L4+PrD
	 scDOKe2HYf34VZHrCCf/+BsfdAXrtcLWSMAyeaujZskir36x9l/9CcV8rfJ58FocwNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TtkHCmfY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFF2606C0BA;
	Fri, 13 Nov 2026 17:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TtkHCmfY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40931F000C4;
	Fri, 13 Nov 2026 17:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591172;
	bh=i9c85/l6HWLHXLBuPxqiMoe8r0OnvvmEHmuwtyGlOGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TtkHCmfYyH7+Q2h+kP8wHN6xs51LhBzxbOKh4lUfodYjVwKjTGXssvUpL07179ch1
	 sVUZLpLn+GdQDLkpLFmUFl5ecmj1yL9ktlpJrOFChqWE1vTIJMPRXCtDAHus3gMWiT
	 kttLuCCL+3/h6cngTyoSTmsh/ZrLTntysX4WTtK0=
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
Subject: [PATCH 6.12 312/670] xfs: cap the block count of xfs_iomap_write_direct() at one extent
Date: Fri, 13 Nov 2026 10:47:56 -0500
Message-ID: <20261113153822.479441405@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 3483b3728b7be..afd655d8f2ae4 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -258,6 +258,14 @@ xfs_iomap_write_direct(
 
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



