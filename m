Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057562;
	b=wEFHRaivAnBdo4svMFA0IA/Uo0yIc/Nkr0WeEIngb1gJk4kKlLa7z7uYCbuMJUWGg850
	 88mQbPaacxGr+ZU/O0qC0D6LvV+Iu72UVVdAu/YM00ej3nPjfzTlOOAbQd9BDdxzDYEwl
	 LR16vVqrvo9vzKIhrUNo3ZvV6uJbY49F5S3Ce4GowthL6W/GaGiy58V+Smu7bUvtpg2io
	 tx28rRXUXbEp5+oK/RV6aJkmlrNj38mySs+crsH+bgjDbD/7zHz4AVRkyPrCa45LOL2hJ
	 WH2b0PV4+c7odeyHeZqvBuNzqmEh/p4Q5AIPXf35lfSumEh56fg1X4in0eh/EdQn3KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ToCtpgf65apE5AnJUaF+E82Oq2LEN0MUREksc2EygK8=;
	b=sfxI6mPGoqzKj1dQvLtCXf6/oZ9ieEc9v9a2+0TITcz4OAQMM+Ljpsu+UeK1Ut73IsBa
	 0FT1l1+OTSVL09MO76xD1rXUvzh+AnO4Z0MAQvRbH8dnRVIywXnLVimGhzWsRyBM0+zeL
	 71riDcV61RXjO0eg92obU682dFwqZm4UMc4BP3kebZxKhVDfVXKOP8vNyLVu55DgOOQdV
	 VJglFbg6WDujlJ9X5XSHElJduDpXHYRaxpADWBwFw9neClzlleTB0aPjhZAplb6iNQVZS
	 cb+r8ZUERZn9AFDjNlXnj6/CIb++tSKbud2z3dUSZMI8sX7jZC4gjaK31hxfsa23I5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G6gGOANX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28CC606A31C;
	Thu, 19 Nov 2026 03:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G6gGOANX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F111C1F000C4;
	Thu, 19 Nov 2026 03:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057562;
	bh=ToCtpgf65apE5AnJUaF+E82Oq2LEN0MUREksc2EygK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G6gGOANXEuSo0+N9FVFeLEsC8UHcJeWWoNhtExlwhN4cndqo7T+oweUa7os4YLw87
	 kSXheazNMmSo8gK/c9FVnmgVdADkHqczLJHiiPytNkpXC6AN+H9kMYrX8rs3lHK8pi
	 rysrIb/MX2AK+0l7ZfNQYfeJyXqL3bDWoz77+hJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0173/1848] hfsplus: validate extent record length before writing it back
Date: Wed, 18 Nov 2026 15:36:51 +0100
Message-ID: <20261118145918.810954937@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaming Zhang <r772577952@gmail.com>

[ Upstream commit 627b7865c062ff642c0000f3a4775f1a44b986a4 ]

__hfsplus_ext_write_extent() writes the cached extent record back into a
B-tree node using fd->entrylength as the length, and fd->entrylength is
derived in __hfs_brec_find() from two on-disk values:

	fd->entrylength = len - keylen;

A crafted image can keep both len and keylen valid but make fd->entrylength
negative (keylen > len). __hfsplus_ext_write_extent() doesn't check
fd->entrylength before consuming it, and hfs_bnode_write() takes the length
as u32, so the negative value turns into a huge one. The copy then reads
data past the end of hip->cached_extents, which is only
sizeof(hfsplus_extent_rec) bytes long, and leaks kernel memory into the
image.

Reject an fd->entrylength that does not match sizeof(hfsplus_extent_rec) in
__hfsplus_ext_write_extent(), mirroring the check already performed in
__hfsplus_ext_read_extent().

Link: https://lore.kernel.org/lkml/cbd7003314c530d4f910eacf019ff80adad6687e.camel@dubeyko.com/
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Link: https://lore.kernel.org/r/20260810092422.1691377-1-r772577952@gmail.com
Signed-off-by: Viacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/extents.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/hfsplus/extents.c b/fs/hfsplus/extents.c
index fad1c250f150b..fce00b8c4f223 100644
--- a/fs/hfsplus/extents.c
+++ b/fs/hfsplus/extents.c
@@ -110,6 +110,8 @@ static int __hfsplus_ext_write_extent(struct inode *inode,
 	} else {
 		if (res)
 			return res;
+		if (fd->entrylength != sizeof(hfsplus_extent_rec))
+			return -EIO;
 		hfs_bnode_write(fd->bnode, hip->cached_extents,
 				fd->entryoffset, fd->entrylength);
 		hip->extent_state &= ~HFSPLUS_EXT_DIRTY;
-- 
2.53.0



