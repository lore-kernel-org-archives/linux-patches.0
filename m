Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029793;
	b=ILq0CDEhw4OrykWaBEt/4q15Xs9JDoJiK2KbBNnoVeiQfXf7kT6yaf7NwSaSw/vyM5OM
	 q0uVkUR6lOudi0pQMLm6CmU20tmyLJ0ILv9zH1Bv02ga9eL9G7KzPAB9YgM16SB4+7+j8
	 Bl+2c2H2aJSJBrTIvvzD/gUY1POTc544GHWM5VLSfhIhw2rhm+YP5DSxXKY2PqM1I8VCN
	 MscP7K1PDekXhSsaofCiEcUWOpkBbKWKBUf9PZ9ESbea/QXz3bDUjiYcWWaLL11g61Wke
	 Xrrx+hHqBzeNVk2LrCQJ7DGDyHkk1Yj1LgkTC0kd/NuLwGqGGGIiK8aJgjk3sEfxIow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029793;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1c5ZnObWwpcKRAXprGoK6VIYczujkIRajChtM7RbAOk=;
	b=NpGfW2yKimZydSWCsbPBwIKjA1KkW7h1Sj6UZDuN19uGcxhuJ0HuQ0KQGx5O+rEOGCXv
	 DkMzrYnrDE9kG0TfmDpPc8GlQrwDf5YbGGkrJdKExA73DQznG+Gofbq+8Ys0obLz8rMRo
	 ZtjajIIFtDecyUgLvGsf90ISQHGHvMUA/WBJszFu8FuoCNgAeULfbJ8LwUIRin11IdODT
	 P97i1wxpLMkNhGcSOmAAzhEZrYlyei+Dsd7RUWNHfy5W5WF0Do3IXNd0pY3LcibqIYvpV
	 LgNoe3K5oo4tRCtEhk1VZ8jAPuaf2+PoMXRL2uHqSFtRZAGePp+2PuBi4JI8hkk0jsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UIV/ivIU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDE1606A31C;
	Wed, 18 Nov 2026 19:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UIV/ivIU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB041F000C4;
	Wed, 18 Nov 2026 19:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029793;
	bh=1c5ZnObWwpcKRAXprGoK6VIYczujkIRajChtM7RbAOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UIV/ivIUlozY8rePIv2z/GWJmRGPJMo1QcibSQvfj9/2zFfeX0K2KKFdlxj2JaJOT
	 cjm0GH86LaJg1HlPKuNd++DmpTszMFQ3D42NO/iMqwdwaWT3Fij0hiPDWtNQoQFBXV
	 AZqs1FrdRMG0C6A6t85PtElCR7HqH2mCM73ZTSNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0477/1756] fs/ntfs3: validate EA entry layout against ef->size in ntfs_read_ea
Date: Wed, 18 Nov 2026 15:43:24 +0100
Message-ID: <20261118150027.891947189@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index b37e8d477d3c2..0aef218a9b196 100644
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



