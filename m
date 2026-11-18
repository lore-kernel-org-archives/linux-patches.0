Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015420;
	b=kGrR0yNRmvgZznsz8H/9kqQDTXWcUzT46e9suX6gkhcFMgdoT4JgnyISfDJoPXrbXPlG
	 QjdZWySrhr8MzwlO+RDzV6h/GMXBAG1IBGECOFvN0ALSLrHcFv/6U/7tVbealMYejytiz
	 rnGvrgI+vNR6Hg4S/mg49eoMDPV6MM3occMcCZQLKGUWLAVnjp9RgFQaTU8NWMfETF7IH
	 NQr36z7QFh9fWckucrgewSnSjlHojN0HvvYZXL4XhNk39lklh/K3DM3l7n9MyhersfxwA
	 e/cMiGKB581/bPTrkUto3VJIFH94m/PA8x5S7Poc6bs11uPHDkkE6BguWsbRriG0aYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CFaE5P8qd+lQUrq75WpgQzWxwvp12StztUIbmfYYIP0=;
	b=kjdAN1REViOCyL7PLBWep5YSt2qG/xe8trh6tnLwrKqM/nWHg9mL5NrXr5osnLi2l2yy
	 t164S8dPOxejtFO8BX/BQcD7mnO1K31U94heP0Pt6dRMgi6FxJ5Gr24cMpL/60doU8GZ0
	 8qZElCQAlPJgVeZeA7EAHiGWEzKnl9WtpGHy6GHoNfl2fSsYASu07wHFbhFMF+4uw3iX4
	 gKu10yXKybZdrcaW+jRXPp9zokqRtcs3/wz/lVpApuhWMnMcN434gPNOVyX6hC2ERPWu2
	 zlpf00d5JT0ZN6oCOXSZcfiMP3JwP5vWk/88jWkKmdErLAWdySe0mq6lxGbi45Avq7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ngpCt3PA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D6B606A331;
	Wed, 18 Nov 2026 15:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ngpCt3PA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BD81F000C4;
	Wed, 18 Nov 2026 15:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015420;
	bh=CFaE5P8qd+lQUrq75WpgQzWxwvp12StztUIbmfYYIP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ngpCt3PAaNd9eGmVA+DUvugmbtqMIQykOPdHAEDCgBMPgA5FGAuEKDDqwP0TUFonH
	 af/xsK1f7/jDAtU1GsV2n+f7BTyUgkfeNHWGYkJLjSLoLvl2FHTLYDu78iVDM/6wOB
	 txHkhjZzx4VzsTA78zBKWEDleOmzRUaCdX0DxbRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0160/2651] fuse: fall back to copy_splice_read() on FOPEN_DIRECT_IO
Date: Wed, 18 Nov 2026 15:23:20 +0100
Message-ID: <20261118150253.614491684@linuxfoundation.org>
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

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 10bd6b32965265688fa277d166ab224de8e86eb2 ]

Yafang Shao reports:

  "After upgrading the kernel from 6.1.y to 6.18.y on production servers,
  some containers failed to read lxcfs data. The root cause is that our
  lxcfs is still at the old v3.0.4, which does not include commit 25982f5
  ("Set the file size to 4k") [0].

  Between 6.1.y and 6.18.y, the FUSE splice_read path was converted from
  generic_file_splice_read() to filemap_splice_read() by commit
  2cb1e08985e3 ("splice: Use filemap_splice_read() instead of
  generic_file_splice_read()"). Unlike generic_file_splice_read(),
  filemap_splice_read() strictly checks i_size and refuses to read from
  zero-size files, which breaks virtual FUSE filesystems like the old
  lxcfs."

Fix by using copy_splice_read() for the FOPEN_DIRECT_IO case, just like the
VFS does for DAX and O_DIRECT files.

Reported-by: Yafang Shao <laoar.shao@gmail.com>
Closes: https://lore.kernel.org/all/20260706025705.58301-1-laoar.shao@gmail.com/
Reported-by: Changyuan Lyu <changyuanl@google.com>
Closes: https://lore.kernel.org/all/20260901213412.1763253-1-changyuanl@google.com/
Fixes: 2cb1e08985e3 ("splice: Use filemap_splice_read() instead of generic_file_splice_read()")
Tested-and-acked-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 7e6eba6e7086f..f51551165e8fe 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1895,7 +1895,10 @@ static ssize_t fuse_splice_read(struct file *in, loff_t *ppos,
 	struct fuse_file *ff = in->private_data;
 
 	/* FOPEN_DIRECT_IO overrides FOPEN_PASSTHROUGH */
-	if (fuse_file_passthrough(ff) && !(ff->open_flags & FOPEN_DIRECT_IO))
+
+	if (ff->open_flags & FOPEN_DIRECT_IO)
+		return copy_splice_read(in, ppos, pipe, len, flags);
+	else if (fuse_file_passthrough(ff))
 		return fuse_passthrough_splice_read(in, ppos, pipe, len, flags);
 	else
 		return filemap_splice_read(in, ppos, pipe, len, flags);
-- 
2.53.0



