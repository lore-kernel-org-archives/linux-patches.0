Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037750;
	b=uuzLwD4NC7l793BiLCHvS37szjneZeqHDzTiLSs3D5UZPga2akh38zqMUjbSXUwnbAtQ
	 TiIWo3h47uQq4fQqw5xOkIJ3GnfQdslfcpswz3UDLqZafgEKYhTYIcqUosTYZcTBGjLge
	 WS/4f73LWfOUf5I27Kx0g2y90dJHLE0GIodaXwHY8TvYGNQZv4TXK/0zM0CG/yU4eUsg8
	 DDwv8yFxVS+o94bNFo27UkRca8zCk8Ike1ul13MaeFOa+c6Exl33CJuN6ePRsMSLmZxFj
	 rIVW8lCKGv9oCAywy41YTm3+7DJRmYn95H/ZWw5v3wfjTFCp+rY1kb0sG9xtvwPKxVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4jEvJ1VDhXVl2j1f+o2TRpozIuOhd/pWq2lwwrVHJ7g=;
	b=BzIxuTd3l0/D3cRml1HzJ3+Lk9Hcku+hXWumpMCy2N75dbvbW4ObeudCYpw0uFRXVIx5
	 FzziokvnFxvdw2HVnNz/Tavb4W6YvKR5qhpoXxcXO9spzGunuIPUTckzfd9zMVgRmQU7E
	 IvrG0bOuyAW4no/HRd9Eu9LCz3sx/vOtH5dB7exy4/MnLYzNKAKNWOsujlDTmhRgbeFfh
	 0HK1hCBcttSJLO5EHqCfz/hjGAv2zlpEArEye6kBD80WNf5DzU7hftnXhoksSqo7fvt9X
	 0qcLZL+4YClwlLmIvJA3L7uDrZ8Rg+gD354/prR/LxKxf7TkL4+kr9+Ywk7NVcNn/3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ksUqjYbI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74736606A325;
	Wed, 18 Nov 2026 21:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ksUqjYbI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77931F000C4;
	Wed, 18 Nov 2026 21:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037750;
	bh=4jEvJ1VDhXVl2j1f+o2TRpozIuOhd/pWq2lwwrVHJ7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ksUqjYbI1u1gvg5JBMFAQoL8hzomKvb0DMpMyR17pni9G7F/UPOLOOBKrnbMpPbDb
	 cx34FvfhkrT9XnmmkYpye6VhBD3ThyiOgBSXUSA4ZAz2qGdYCMff45HkX52zs1DDel
	 PGEVhlV2ozL+XF1G1qsltM/YolkWwFPr/gvmycD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daejun Park <daejun7.park@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1505/3318] xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end
Date: Wed, 18 Nov 2026 15:35:27 +0100
Message-ID: <20261118150406.074933980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit d8c2bc88460f89e543ab3af622fc8f34c7011d71 ]

xfs_fs_commit_blocks() adds the client's length to the offset before it
clamps the end to the file size. A large length wraps the sum and
reaches xfs_iomap_write_unwritten() unclamped. With the previous two
patches the LAYOUTCOMMIT then fails with -EIO and converts nothing.

Clamp the length first.

Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_pnfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index ca3d085a3e781..a222410812ac4 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -302,9 +302,7 @@ xfs_fs_commit_blocks(
 		if (start > size)
 			continue;
 
-		end = start + maps[i].length;
-		if (end > size)
-			end = size;
+		end = start + min_t(u64, maps[i].length, size - start);
 
 		length = end - start;
 		if (!length)
-- 
2.53.0



