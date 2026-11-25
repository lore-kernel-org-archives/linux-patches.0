Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624750;
	b=0h6UzN+TvjQg6npM/RnU/PzxeGHMGUenjC6cCY4W7QyU7iHC7tpjnAimoaohrpq7B9W9
	 eg5s4NEIib+1ZAvWIx8GQ5W+uhznJKgNaQ+xDl1cMHgaFxtwqU6OVKkhPnOF7IPh53wbp
	 DGrdXoGOCfp28L9ee9Uf+VQliNWGklG+Q2bwSHNAtWi6wjFymD9yewH4zy5yMRzvWuzaK
	 3ISPOQnGZ2Vpw4QSOs9vSfiI9pKD7HjVCRD0wzji8IlnKUib/oN1Xh5PqFRaVTHxCPAdc
	 PdXIlNnvlP6q2RwHNpk7GHwP8Fwcm4wr8k6yFjBPg7UDCrtyi6BP9nOTcnee1YMvQRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mOWShob20eVt7RxFG8vSUiKUij4NuyA5BkNMYNzX36o=;
	b=jMJb0a893knF60GvkMLJnnA2O4p0pyYw1LarOJZYpdAYIm8/Un4ePTXPHA7hYDkKrBCt
	 9tstRQJfJ7z8x/0mX4rBIMRf+bPAH+ZK/u08vKYiB0AG2cEb6WK6W9GzbT+J4vCOxN9OL
	 RgAUhhLdRkwsIk3ESwquBgJgylChkesDqLPIeK32X5Av9onjxfu58Mbt1iAcXRRZ/nP7s
	 hQ2svUbxQ096VLn5vSvT+46joPdEfEh4/NJw04e8KyrMnb7xZimsg+F07yHd/yqd1NbSZ
	 XAZqFtdQF4vPiH2xYwHHCGY6bVSOroKOGoUl/DnBvIVBKAvg2idrG1EnCmF7u0dxx+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DaKXtmtm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F77606A336;
	Wed, 25 Nov 2026 16:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DaKXtmtm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15F31F000C4;
	Wed, 25 Nov 2026 16:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624749;
	bh=mOWShob20eVt7RxFG8vSUiKUij4NuyA5BkNMYNzX36o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DaKXtmtmIJ86r2NDHEp5e8G4MES0No/TAgbsKBlPjVAQZX45he+65KOIeCNrKqI9C
	 8it7dVBgorMmHffJ5c+xRnWWhd4tfS2VHif4fb4Y8/I7QUJ3NJr+tlQ7T1GVldKZj+
	 YYbVz+W7B7n45Kxr1SEhuvWVJ7CbUVyP1OMNyMpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 295/816] NFS: honor UTIME_NOW atime with explicit mtime
Date: Wed, 25 Nov 2026 15:30:43 +0100
Message-ID: <20261125143856.034564679@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 2ffcf17d26dabef5793aeadf75a23c595a72be08 ]

When utimensat() requests UTIME_NOW for atime and an explicit mtime,
the VFS sets ATTR_ATIME but not ATTR_ATIME_SET (as it should). The
delegated explicit-mtime path calls nfs_set_timestamps_to_ts(), which
skips atime, but nfs_setattr() then clears ATTR_ATIME, allowing the
syscall to succeed without updating atime.

The delegated explicit-mtime path already updates ctime locally.
The VFS also supplies the requested atime value in ia_atime,
even when ATTR_ATIME_SET is absent.

Check ATTR_ATIME instead of ATTR_ATIME_SET to also apply the
UTIME_NOW atime value supplied by the VFS.

Fixes: aba41e90aade ("NFSv4.2: fix setattr caching of TIME_[MODIFY|ACCESS]_SET when timestamps are delegated")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index a1e65cf3d8c9a..28f7acecb3f82 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -656,7 +656,7 @@ static void nfs_set_timestamps_to_ts(struct inode *inode, struct iattr *attr)
 		inode_maybe_inc_iversion(inode, updated);
 		cache_flags |= NFS_INO_INVALID_CTIME | NFS_INO_INVALID_MTIME;
 	}
-	if (attr->ia_valid & ATTR_ATIME_SET) {
+	if (attr->ia_valid & ATTR_ATIME) {
 		inode_set_atime_to_ts(inode, attr->ia_atime);
 		cache_flags |= NFS_INO_INVALID_ATIME;
 	}
-- 
2.53.0



