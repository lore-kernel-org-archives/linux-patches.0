Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016779;
	b=n03KDbIVlMuc8dtZ0m6nFCA3pRBQGBl4klSoJP3iFRW0JAkvTdRCprMq9i65xKwq0ESU
	 2nFpbADYNKkVT/XElU6o/bgQ8w9HZTQ7paxm7Hub85jkch9Itm+GqQW5PAy/5zHvIeX5Q
	 jNjfluloNkOMLbcYl4j6VNVNVSuzfMY7IUicFtsVA5rwmLEBBcgqP8EqSfytLA7ZYypH3
	 2w9OwL+w8l0IZka85DDNb3jJQAPa3yXMkp8d5jDpBAipi9nzYq1JyUG2oXUGCgw+Nx9S6
	 FJkiv9GT4gs73ddWQcCvZ+ebrxKsqQmqo6rCn3GAxjRiP0cRL79Kh2LMCKlShXiIv/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016779;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yl/gcvHEWIRDPVJX8P+/1fVuJ8WmhHL9KVThoVsJaIE=;
	b=x5efpWTr4VTIb1X2EdzIwy0hSCKholfK+fMCKxEVtSd2C9gAG9a58LAsGqydQcCA6oWJ
	 35C06nTi9pt6hFndkf2WTY94KmBPhPWCSgRhrQ4UPJsfTRHiRHkVfYlpVm0QsMjuur4xZ
	 A44sZhEQwteqh5IJNOjndStkuCme5ZWODIWty1k84KL2pQSm1D0ygysf94tEOjler0OmV
	 e3WfPp4lAGvicwavWn0Y1leD+lK+fUZrutcSMgsuuyKGaRIa3wOd1vuqbauKs5bkLKKww
	 FSCZpnQmk1MbYod7nHc0gY5kQSf4O9WhaMcQfedlLfu7KIN3w5ptek9082Wn4GMQMNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hPEuNnZx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A45606A31C;
	Wed, 18 Nov 2026 15:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hPEuNnZx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09C21F000C4;
	Wed, 18 Nov 2026 15:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016779;
	bh=yl/gcvHEWIRDPVJX8P+/1fVuJ8WmhHL9KVThoVsJaIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hPEuNnZxnTeIfA4X4bDExKDeNgLywdvy8ZKdmOATQyBZm5+vuTtvN3mMRHlC54IFO
	 0PNDa7NVOokcEzcXndkeymYGYA5NGrWLFb0yoVkxfjDB3lSeQi1bxgoHYv9KZjHHhW
	 C9AIvo9RlIU92YF3tvgC5ARsMeZ2gXciG0Z7oXTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0609/2651] fs/ntfs3: validate EA entry layout against ef->size in ntfs_read_ea
Date: Wed, 18 Nov 2026 15:30:49 +0100
Message-ID: <20261118150309.642104061@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 01e56820ef52d14a5560fb7c0c6f2f75ef6f9393 ]

In ntfs_read_ea(), the ef->size branch only checks that the declared
entry size fits the remaining buffer; unlike the zero-size branch it
never verifies that the entry's own name and value fit inside ef->size.
A crafted image can thus present an in-bounds ef->size with an arbitrary
elength, which find_ea()/ntfs_get_ea() later use as the memcpy length,
reading past the allocation and leaking adjacent heap memory:

  BUG: KASAN: slab-out-of-bounds in ntfs_get_ea (fs/ntfs3/xattr.c:302)
  Read of size 65535 at addr ffff888010770b0f by task exploit/142
   ...
   __asan_memcpy (mm/kasan/shadow.c:105)
   ntfs_get_ea (fs/ntfs3/xattr.c:302)
   ntfs_getxattr (fs/ntfs3/xattr.c:848)
   __vfs_getxattr (fs/xattr.c:446)
   vfs_getxattr (fs/xattr.c:479)
   do_getxattr (fs/xattr.c:808)
   filename_getxattr (fs/xattr.c:837)
   path_getxattrat (fs/xattr.c:876)
   do_syscall_64 (arch/x86/entry/syscall_64.c:94)
  ...
  The buggy address is located 15 bytes inside of
   allocated 20-byte region, cache kmalloc-32

Validate the name/value layout in the ef->size branch too, bounding it
against ef->size, as the zero-size branch validates it against the
buffer.

Fixes: be71b5cba2e6 ("fs/ntfs3: Add attrib operations")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
[almaz.alexandrovich@paragon-software.com: remove duplicate check of need > ea_size]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 3a43a431f3bf4..7b02da27f5db5 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -168,6 +168,8 @@ static int ntfs_read_ea(struct ntfs_inode *ni, struct EA_FULL **ea,
 			ea_size = le32_to_cpu(ef->size);
 			if (ea_size > bytes || packed_size > ea_size)
 				goto out1;
+			if (bytes < offsetof(struct EA_FULL, name))
+				goto out1;
 			continue;
 		}
 
-- 
2.53.0



