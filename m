Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053470;
	b=HoLcDDtrS1KEXMEClLhgNxI76AYVgve86/NtAllu+xTUjPWBhs9O8Q0I/LhnREIPKHLi
	 M2kuZrVDnBTVYNom4OlkSAMyy2hHN/jiS+fqf25tSRvUgoQoahH8fQjMEc+jKBAzkLE6s
	 SQ/9q6xtF4D8XMhUAlrUrwzmO4nMWBYDX6UDGPEnPNWsXLsYFjqQ9IgHworHM5bNlTCBJ
	 hCKhyAbW+H1jaOPDmBl2cBptQSFf8FYIl1TmUYJuoqxhDr6DithG4tvz756WiEjKVHsDN
	 jLIM567UOhnVUjoPSRfxNQY0dRW8dMEAvSXSF2loz4VZmdJWaPe/HuCUctNJ8Fx8V9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=37CUq2gNPxuHEd33GxuAwSmqJrtzN9G+UnDLPVj6Xc4=;
	b=nng0rma5tUyacAobcUr3fwGxUsIXVseWJujMebgWl/XqifZ1zl6Mjq71oPuzUxoCj81w
	 O7ALNwXbaZ10bfSirYciU8NEICHKBFbKCUiitHEynkXK4GRYTjXW/Jl3zy6Au8NMjdBVC
	 csg/JuE15bHWKcUxm5loE6vYTbhWu5m5amktGjgDY6icSew/OvuMjjKNBJOrSLbN0IKFn
	 KdLU/frtq6NuhUV47Ow53XRx1uaAMEBDLoAF8aSFVdWH/2ogduZzG0xcbx+sxS3wNWVxq
	 mUxL7IleIMOA99VVAFuAMnHM2j/46EPRsesstO+72iGlpRWMYSahi1pNXXPQFz4eGMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H5IwuKrO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA09A606A32C;
	Thu, 19 Nov 2026 01:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H5IwuKrO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C03D1F000C4;
	Thu, 19 Nov 2026 01:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053470;
	bh=37CUq2gNPxuHEd33GxuAwSmqJrtzN9G+UnDLPVj6Xc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H5IwuKrOHqcF1cLWo72ZJOvKww3tMcE4nKWQNNr9p/T47Z8ZVukMaIYtWhsiPC0YA
	 PQfWEwAVsBuHuf2rR1LO5aKLVAQzjxLDD3wqB/rkTFFXA0juPlI714tCLFztBjoHIY
	 2hI6FST07RxqW9AE7g2Uadnus5b047Bvbb3SBIY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daejun Park <daejun7.park@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0894/2214] xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end
Date: Wed, 18 Nov 2026 15:42:50 +0100
Message-ID: <20261118150048.050917359@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3a82a13d880c2..7f950cf39e4d4 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -250,9 +250,7 @@ xfs_fs_commit_blocks(
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



