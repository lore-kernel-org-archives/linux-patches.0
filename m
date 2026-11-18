Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040043;
	b=RJyZPvBKpaxE0ZF1fqa4YKur0sU82AEIPUtgdHRiToDYlEN7F92n2PR4iK7QEy0VRKVZ
	 +rmy7V2QH/BpN05A+Ahzl6ogRfWntLYb/t41c4dGPTjxrtv0H2svmM/3afnERkK3uPgGb
	 qQy42Fk/lwyXzp3G4OLFLT5RJviP0rikdaeye0PR7szkSOqpH+M/tn/VQF+/6RSuslag/
	 WiOwTcNQj53/OEi6fE1qOeWQNFCmgjZa/dOWmdes6WrKx9U8nT9gW2M5LIoan4LrqL5zS
	 aaJ0qt3MrwbJjXpoD0171voKvYHO3w4sno57Sr5+Abga32uRAus9EZ5aw+zYPqMIwZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M2aemYzIY+gFMTYdyKLkMwVO0E2zJiwF0ZekNxivrms=;
	b=j8qkcp0RdbEjObRjxBQb9eMhQsw1jwD9XemnBI+lF5Rsessl9H1jOlnOLro5zCdObOD8
	 MpkVqvMZGY8erKTpLnkpT3BgrZMdZ1dnaWfDQrsG+4CFwbm6aUmdIglIxkrBeAXOmLaLS
	 SyWJt6Qd34jbw9bXvpPWCltdI1dniUo2YqfzKqiRGI73n3WXQtbcrnoxY6FXNUrl7ASly
	 VHkeSOlKQJGivZJPFFwkIKFUuQX3yvKkcQe5pkLBZNaE8MSoAyaSHjIPVmIAVjO8p7ZcD
	 vyOy4gXYmAz3f4UxFx1uDXkgSzjmeCo5hhP74M7BOL/PQdoR+XOIaxKzDvF+4AHfaqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VvfhYT71;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C00606A31C;
	Wed, 18 Nov 2026 22:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VvfhYT71
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769221F000C4;
	Wed, 18 Nov 2026 22:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040043;
	bh=M2aemYzIY+gFMTYdyKLkMwVO0E2zJiwF0ZekNxivrms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VvfhYT71wpBt83PQp0StF1YBcEh3DhSUhRt4FsAP6co5qqtGv/gBtFrU8dLFHqCsO
	 N0SyiUQFmN8LtVnro0W/7wPFVEFK2JpfqYcDixOIaTEaMABnf/xYU03bH2nU7K7zcy
	 5DDmYk6fAw37Q1KxM792EfF88uKbZLxUNyixpXO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2276/3318] fs/ntfs3: validate EA entry layout against ef->size in ntfs_read_ea
Date: Wed, 18 Nov 2026 15:48:18 +0100
Message-ID: <20261118150430.060816497@linuxfoundation.org>
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
index b36ecc7b9f23b..47cf860e9209d 100644
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



