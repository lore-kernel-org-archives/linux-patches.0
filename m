Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590386;
	b=kxNMWYUoLxeMOLBH0ZgeSSXbwKvH9qe05MbwGI6LcYQbITZmgtD4dKBUpadOuwAbZ7uZ
	 T2/9qcA9GJE6haXVhh7L5Wm57s+DOJAc5NQzPdiULst+9h9sFRmdGr4xl72gGvL6Nr66N
	 ZAZHq8GK5ruGSLI0Q+nj9byREA56hZqjYqUDCDvQm1o4eHDfydJ5pjN0a2VZv0x7r4FvO
	 YJTGjcrK7bkgRQ+Izuo2uh0tkwUvyLqvsh+3DyVFgviDZQOa49bV9yGO+kRGHCL+HSL5X
	 iIQojjqrf1BBm3ZcbzFFlxwdM3whmq5pK1ipN2qzrKYb2a9EkttJhrHmxiTNsUr2I1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=do8S9UoAkrAwKTpO5e2BtehQ8aqJJKBAukRrhO7xZUA=;
	b=kiKkHOCdHB6ZcPEd/s5qzr7umHfMPjrFfC7O0lMcsA3WPErd7Htfp2Jj4vDDNEvrYgNh
	 kOHTUFmfJzcmohiO1+t1frj7/Dt907d7ww238wU395BJ3vg1JQIJMQ0CR1CsBUBq4yN0V
	 CMF2XyFRTcj0X15Z85opDOeXu6UcXANrjTDlKCJqv53A0cDF576WtS3s7rgofeR+bLQMY
	 rhQvcaX6HI3ESgh3Xt9jo/uRWE9E8GpjtrAGH56uJGr7XQNM3EWnvcRJxzrDW1nmF4Fog
	 CSrFpb9Zwrn4IUUWy9cd1rO7cPJJmTb8nITSyoS+nOolmWJMrLUa2B4d84KlRXc4smw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jXAvCYxZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF2D606E660;
	Fri, 13 Nov 2026 17:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jXAvCYxZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DCD1F000C4;
	Fri, 13 Nov 2026 17:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590386;
	bh=do8S9UoAkrAwKTpO5e2BtehQ8aqJJKBAukRrhO7xZUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jXAvCYxZK+/vOfIAElvzMgsL4zEmPm9wtQeQF/KtoJvjrtJAeTw5zxs/Dfz/ossgE
	 xmbN555zLXewj+3QEqeU5wlEUGLK/vd18jfl8u2ZFXPSVK6xv4lnOsHpzgvsyw3MYh
	 wyemG0E3OPUrSdQVVyqspelWyiFcd/EnvaLj5joc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daejun Park <daejun7.park@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 356/686] xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end
Date: Fri, 13 Nov 2026 10:48:09 -0500
Message-ID: <20261113153832.976039945@linuxfoundation.org>
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
index ef08f0f619f70..b880d061ee90c 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -311,9 +311,7 @@ xfs_fs_commit_blocks(
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



