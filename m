Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023955;
	b=BPkvH8Uy/dYXOXiS3K9/az3L5ehxDWcIS7t/t2+bc1K0E4e3wcfT9iQuXtBjk5tmch/R
	 Ee3wQL9490KMh59ouoEv6oCebYRTycnY90HjyVSQhr6ACM0sZpGz/zo3JQSpmF/0C3JBE
	 zY4ro8EkB2o5wOOqsDWjGeaciaGyMcN6G9kXb+ps4tlRY0qpTlwR3VneUbDTcbEbgO41B
	 h9MGP5LGSamrGvm2hqdDno/M9u8cbHDQwH2sE/D4yFABWzvvW9LATu1CProYi396X21vv
	 b/fbI9bKXZjscaQ+/0vP9Vk19vUMlhIrrLT4edDSDgi3/OQynP9vz0Zwpeiex1v4O4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rSrJ6JaHI7No5Ua4/YPgK63qQdfTidWEY/VZcMl3eFk=;
	b=CVlpGu/m8mFszG094RBfCV83M0q0T7GjOEh7AyOLuw7Wxq8sUjGqfJX+KR+u75jp9dZp
	 4Rm02yW6pBD1OapeRDTL0h121PaJOQHg7XjjNwnCkf8e977XA09Gp3GoyLm9rSbDDKEMP
	 Kd0YyBWC6mLodeHo9yik+/bzf+jgbFofPsniaqlUbxBC7FYVPtyMxhc2TBPogfCJ4V/21
	 /6SkKBWduv3A770MNI9zx2f6QBKUcbB4O6qMr1zxCSJnZndYeKkC3LQAulwzZaQTz3J+s
	 BOXhroFVbUu74EwCxVfp1I87UsNWvq45d4cBD4ABa6m/FCgesxR/HleyI6WNMXUYjfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="O/klPnai";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580BC606A320;
	Wed, 18 Nov 2026 17:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O/klPnai
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5061D1F000C4;
	Wed, 18 Nov 2026 17:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023954;
	bh=rSrJ6JaHI7No5Ua4/YPgK63qQdfTidWEY/VZcMl3eFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O/klPnaiHPmGosa+5Xzm+ZiNCgaEb3YQeIfOEYy6TDWY/Zq0mUXCw7/GIjeotv2jN
	 93NJ6rDdrRExDILmf1rhHDD7KKni/Lig4XNR9IedoGS75gG6m1WyVXfDDqxi7BUqR2
	 SGXidgVpvtmI8Mf8rk2tej+qZZqxC6q9LqZj835w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0552/2151] fs/ntfs3: validate EA entry layout against ef->size in ntfs_read_ea
Date: Wed, 18 Nov 2026 15:38:07 +0100
Message-ID: <20261118150142.073878619@linuxfoundation.org>
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
index d25de94b878ea..317f56f2c533e 100644
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



