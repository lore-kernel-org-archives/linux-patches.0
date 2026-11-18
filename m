Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046417;
	b=VTMhkFmh9f4Ve/eCCL1uo1i4tiZJpEmQj7iAh4muRRbs7xQ2RU9JLmFEx2g3ly0B96bX
	 YjWTGt3URi3HJOXsBiiPSAuSN+l52No79nUDasBvx97MhRnRSFDrZ6Txja1Ime1fOJmvd
	 VzmBbyaji55a0DX3quitdgCJVyS33mrhPO4ZCABs7yi5dFEGhpKDBSw8nfurKCqAdOcVi
	 IF8KlG9TmYeo0lW05VQ0kSLPU3NIiDV9lsXesIPAkquGzLTshEXZxEG+qpFXKBxNkCWac
	 GgoSH9hbBBTFPEPqBLyf8XiEf/rrD6ENtbGZAUlhMpe4ygJZx9qNj0+OW8qu/WErpBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a8syixx/JBl3Sql4js3e4ueSzK8tMD88gO+tZYR+mXY=;
	b=Bq+6ADKgk6ZxBFfhu3gttfG55uUWaR0g31qSLJXLa++7DRYkB91Fzf2qRV+NHFWPduAG
	 gmwUMjKkTgQYsGmrsTWovRw7bcCJDNSB1vIbGldN/TIsD4qe9HAaqJC9dCW60rCEM2JmC
	 M04fofBisLF2LjSvQVeWPouUkRbVLJCYEgUSpGMOTjNmZDtOazJPoSUUvp9TTLYjmWCgx
	 enhDw7+FOzYU8RsG2R/tFSb4UKNSwhy5G2M3dwe4VdqtPNStLZH8rp7LXCs5A+CI5xN2W
	 j3g/oFCIYNyPWrCzpUd9kANZgRtR3IzuGUZoZ1lsmTf4LBT4AiPyrTGdNijNMoAtYYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LvuzLT+B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F190D606A31C;
	Thu, 19 Nov 2026 00:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LvuzLT+B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55ED11F000C8;
	Thu, 19 Nov 2026 00:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046416;
	bh=a8syixx/JBl3Sql4js3e4ueSzK8tMD88gO+tZYR+mXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LvuzLT+BhedQv00COsvye+OxDxlwmrj/no4Gq6XxkL/uedvYx2IWiN1gO0CkXcdHC
	 BajOGmk04HvcJaGkFSI0XBbu30mS/qA+SVw7T8c2NyaFi/WTarhyXrgAuNrp5ZlCSh
	 gTC9Y2N5bKl8CXWBUtbXbgGThkwu/oqR+670hfL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daejun Park <daejun7.park@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1273/2857] xfs: clamp a pNFS LAYOUTCOMMIT extent before computing its end
Date: Wed, 18 Nov 2026 15:38:27 +0100
Message-ID: <20261118150247.352672557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d74133c3d784d..8ee7ca4201f0e 100644
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



