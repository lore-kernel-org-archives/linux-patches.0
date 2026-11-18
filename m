Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022953;
	b=buaxktJaoZHbtxui1kL/pOoQG8w6efESFsxNuqS76QF0Jkn4b+rRqVgr4udN8wyBRSCD
	 uo2uUsYc0GYKXv1nueV0OVF0CWt+xUDA2VPkNdQeDZEmBKjNzJLlLPvImDXhOin+8ucjt
	 4k/RRkoAm5lXqM3G4MUzGkvhsaqZ3FxSN9SsfqfXiHOiFiVuzLqnL/4XZngHEr8HdmrK5
	 rF01N/UwOYlqrKy4Nygz+EIgIIbydRqDUpieiX7DCxJ1WeDwR9UvQCEvbSRGsV/CC9sNB
	 h6VOOWzt5ox4VbnQ13urP5XDxsRqB6QBCAnKQeEVmJ37cgBQQKYeUTGgl/gH9A32GrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2C+eN8oqcu/VfAcrHj1aQyLpWZfhb59j5ypzZM1NunM=;
	b=cz4CO1myhKhJZYrrJ0bBxEPOgqWkREG3AtlUPKZgz1pmirhWaptSb2SEfBFAXNAVYIFP
	 DDYABl5it5GIk1b2PucvtepV+a2ocbtfZnuHF0GskApfHABnzqwj3o2UEduqhBTVZIPpG
	 5PVD+aRCe9We1kFPzWV4ye+2+trGkGu3lQIOU5yNuHsdfR5zEeNvTGa8xFkIwG9kLhcws
	 EnjNcjSTjGHiGagBVNefarFo2mGLXPk9aCnL3JhpiPyJy0oVCVbtVAiQmjWI5G48npVIk
	 OCM86sqRIT4eSv/n7bup/o9GT1LNrntsjaOmZd8ePdIGvhu342r8zy1/L5h0ibhPIng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lfnNnxGA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A07606A32C;
	Wed, 18 Nov 2026 17:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lfnNnxGA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949A31F000C5;
	Wed, 18 Nov 2026 17:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022953;
	bh=2C+eN8oqcu/VfAcrHj1aQyLpWZfhb59j5ypzZM1NunM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lfnNnxGAoBRg/FP9UtQ9S/gIDIJuB34uzr8cmH4TI0rQ+kUrHTN0o+qGp8TfFNlbH
	 BcQdqDhX1UNp2sgo2RxSPcmDWAA4vc6OnjEoYUGIB77mgX8V+wN2XgBfySgVtZPGSM
	 9psjPD0+3mg5Vs0jWQCVwz6vyQ4h3jTPz2e1A2g8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0197/2151] fuse: fall back to copy_splice_read() on FOPEN_DIRECT_IO
Date: Wed, 18 Nov 2026 15:32:12 +0100
Message-ID: <20261118150128.963310097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index f72d74e3c5f03..dc61efd829cc2 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1828,7 +1828,10 @@ static ssize_t fuse_splice_read(struct file *in, loff_t *ppos,
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



