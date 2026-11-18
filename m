Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021211;
	b=reeP6k+1KimW6ONGnBWpuEu9uFDCa8vgkzC0mpiKTyW/KfXDz0k03Mk3qKjJG5NNl36W
	 uW0gTASmjehXsgQePHXYPvcdX89aeBjIZZvlReEMAHOkHmjdXlJMA7teb3GfriA5cro+2
	 Bxwj2UWXiRNFzLcFumxH06o9HBcAXVSpRjWtvnf33gO7pu4VatcYC9r8ZwjFbFwf4luvS
	 J8xmQFkyl6raEen7LTa3QH+10/aTQv59WsscLX1Jxcr0yg5HNyxV8vwQVhO6tg3O3Gt6C
	 fTu/rpfRg16nFz8/vGSHeVdsfW9kpZ6Xp5/W4qhQEKba/GXsPQDlAkqoycUYjeD1XqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gzj+yA7xiFbHg9CgIZIS3TE/DKDSVzwxtMSm5KGQcvs=;
	b=wnpeBjhPJ+m24NDJt+VY1tpBUF0L8jJ7IdEoKvbIPc3mybSE9u7NYYKRifH3lGPZ2mGL
	 rR9dD3uXxUsGBFYYXedSwFrm05Xt/22T3DgR/fcL+wcGfbTRBKC82XyAdyNAL2slUnKgD
	 2FVJ8NvTEvgHTYR2GW2S/VcdDFZORGbf64MRk3q08ZYKMZIurIRA0I5b/U1JQjCNLRn7n
	 y47iKmw4ZwZ11nxxtgb4XGyppcGo8/XDgva3bUuykHH1MEwPYfCNXF6cAp1MXIy1R7s/v
	 pxw/fBdRN8xc5aA286kVEa+HnTE1ih9P7DTGnsyqu/AnXmpvDpXYS7tvdFsq2sF8cQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="j/3HKDq7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38E1606A325;
	Wed, 18 Nov 2026 17:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j/3HKDq7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA7A1F000C7;
	Wed, 18 Nov 2026 17:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021211;
	bh=gzj+yA7xiFbHg9CgIZIS3TE/DKDSVzwxtMSm5KGQcvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j/3HKDq7Kn8mSg8FhmrUCUSWGhJLVsu+QWTZYxwIUQn65Z1FUzPcBUNppVz/4/oN/
	 ZzNbKAEcYUm9k0zGyIEvC46Fd4jAiIs5SAX1X/ytztqU9WbzOsiR2ByBErM82AyrTR
	 NLAv9i0FDkFYAe1Qh+L0jl7fmm7ElFrk6iyMD7AY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2224/2651] ntfs: do not read ahead encrypted files
Date: Wed, 18 Nov 2026 15:57:44 +0100
Message-ID: <20261118150405.631598864@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

[ Upstream commit 5db65a43ed8bd1a4c0b01a20e494384bc45e4312 ]

ntfs_read_folio() refuses EFS-encrypted files with -EOPNOTSUPP because
decryption is not implemented.  ntfs_readahead() has no NInoEncrypted()
test and passes them to iomap_readahead(), which maps the runlist and
fills the folios with the raw on-disk ciphertext.  The folios are
marked uptodate, so the read that follows never reaches ->read_folio
and returns ciphertext instead of -EOPNOTSUPP.

ntfs_read_locked_inode() sets NInoEncrypted() and NInoNonResident() for
a non-resident encrypted $DATA attribute and rejects the
encrypted-and-compressed combination, so none of the three existing
conditions fires.  read(), mmap(), splice() and fadvise() all populate
the page cache through readahead.

Skipping readahead leaves the folio unpopulated, so the read falls back
to ntfs_read_folio() and gets the intended error.

Fixes: b041ca562526 ("ntfs: update iomap and address space operations")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/aops.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs/aops.c b/fs/ntfs/aops.c
index 517d9a1563e7d..ad781674fef1a 100644
--- a/fs/ntfs/aops.c
+++ b/fs/ntfs/aops.c
@@ -240,10 +240,11 @@ static void ntfs_readahead(struct readahead_control *rac)
 	};
 
 	/*
-	 * Resident files are not cached in the page cache,
-	 * and readahead is not implemented for compressed files.
+	 * Resident files are not cached in the page cache, readahead is not
+	 * implemented for compressed files, and ntfs_read_folio() refuses
+	 * encrypted files because decryption is not implemented.
 	 */
-	if (!NInoNonResident(ni) || NInoCompressed(ni) ||
+	if (!NInoNonResident(ni) || NInoEncrypted(ni) || NInoCompressed(ni) ||
 	    NInoWofCompressed(ni))
 		return;
 	iomap_readahead(&ntfs_read_iomap_ops, &ctx, NULL);
-- 
2.53.0



