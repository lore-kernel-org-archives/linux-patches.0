Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037759;
	b=A7Wl1LOi0gPDANFp92iln9jVvlgLcUSOkdLG6a+DBUNkgXkIAg/kdfkDwd0OpCm8zcKZ
	 UdUSOidij4+dI4tSPJxvcgy36PlaKEaONOGy6u5nN+s7kZgrakFs6oLPrsjlf2e9FWXyx
	 6zmvGQDthMI8ePsqiPaN7C+JIvQa/7A0UVEZSvF4+uE8NAIAGSUwIh+YwrsXKF9E2sd/i
	 Gizss1XeiyVgvg7C9KzDTIYc8lve4l2EZSqUV8ZlVTESOFE9rm71IMUSUws6GIzyVmkQ0
	 y2YZj5JxRDikpY5vKYOuPGCj1cBe0Vq5mrRvqZQs0/d2hQusSgYit7km9j3LsgM9k6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037759;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9GeqvtaOYAsq8eMLPrw3IsGG/dqxm32dSMTql9/pmQo=;
	b=yCPV9A+zNl58K5F4L//WGNjzOidi5041SGcoZjyDD6iUp1KPK6hxTLgVWUMkat7TYoUv
	 k9LSPoVPLmRUcXM1rcTF4V3o3hZMtMf4mXA5UjnACFaZvvA9+5RcyUIJKpw1nx6FugjBp
	 on8uwhdTDzT5F05I4EV+vbZzcUD1O6Orny1lboHUvXWg49Q0OyFArcXc35GUrFQoGYOBi
	 vmq4Olx6gLK/gUvwEz+f9TC36EWD1JXHw+K5Vx//lz0x+w+cHdXmfU0QaT2CVroa7J2tE
	 DQDTFjnRKaeQmcDBha8bRXv0RI4wc+2AsVHmVPhuT78SiL9CE1vl+G8jLJxEjiwzQxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LqvR7lwR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54211606A31C;
	Wed, 18 Nov 2026 21:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LqvR7lwR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B04E1F000C4;
	Wed, 18 Nov 2026 21:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037758;
	bh=9GeqvtaOYAsq8eMLPrw3IsGG/dqxm32dSMTql9/pmQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LqvR7lwRfv0ZR2Pl/cBT5b5pGrGOgPuDdjupd2QivLvVBAjqRKabkkhm0wVQpqOcZ
	 N+Gy0gLAsmVFKtLgf9Nn9DykunWnjNupSkjKYBXjSa4XG/5ba7UVkzZwl3Xdf2/o8I
	 XzzcnaGsuzuoWvvJzknNwwKtFsUaSXpx3rUorzP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daejun Park <daejun7.park@samsung.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1507/3318] xfs: clamp the pNFS layout range to the maximum file size
Date: Wed, 18 Nov 2026 15:35:29 +0100
Message-ID: <20261118150406.142542615@linuxfoundation.org>
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

[ Upstream commit 29f3c1be4e554c9dbc66e13333034e0947477cb6 ]

xfs_fs_map_blocks() lets two bad layout ranges through. An offset of
2^63 or more is negative and passes "offset > limit". A length above
the limit, such as NFS4_UINT64_MAX, wraps "offset > limit - length"
and stays unclamped. With NFS4_UINT64_MAX, a read layout is built from
an uninitialized mapping.

Reject a negative offset and one at the limit, and clamp the length.
This needs "xfs: cap the block count of xfs_iomap_write_direct() at one
extent".

Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_pnfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index a222410812ac4..fa027574d6de1 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -168,10 +168,9 @@ xfs_fs_map_blocks(
 	if (!write)
 		limit = max(limit, round_up(i_size_read(inode),
 				     inode->i_sb->s_blocksize));
-	if (offset > limit)
+	if (offset < 0 || offset >= limit)
 		goto out_unlock;
-	if (offset > limit - length)
-		length = limit - offset;
+	length = min_t(u64, length, limit - offset);
 
 	error = filemap_write_and_wait(inode->i_mapping);
 	if (error)
-- 
2.53.0



