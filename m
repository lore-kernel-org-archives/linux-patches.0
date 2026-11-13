Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590605;
	b=iZyBmH9y04xf2CmunxQGOK09MV9gDUvrFT6RB6Sf1ecXTcEvLPwKHh/qJ2pWD0WccX0V
	 vzsuIaib7pI1QggNB0f/6CGIYW+fBrYAB2KCT8RzGa222pevpSZKdAIiby4CS27vZ4+UJ
	 UYuKoVq2DTvhyesX1G8Jp5mgIHJSTopN0YqOb24q0eUDIKS+dbLeAGemP7NKQ3jVJS/Pv
	 RgffISjj9bgCKnl3H60y3uOIz17dEAvVqErOExCIinIlOUC7zHAmUhtMq/cWb5ipw+0rG
	 kBkCC6MN22mwuNFQ83YuDiIfh2ccaawVrKWpscyMlFTtNcD16ek9S7O1H+GTiBrYKfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qod299Ie9MpYH0RfmQa6qA6F0zQ7XSIRoPWHgx1bQeI=;
	b=u6fAYUNU7Iltuan2P6zTYM4gph1mMtBV6dPL4wkbq+9w22oviYV/VY6XHclCzbBgJL9S
	 fkYOLv2VJUgUC6rDaJngBSy2YuDluVA75/ug/ilE8dfujsvCKBKy78azpbPOsfNXHE8cB
	 cugD9ZHPLWz2qT6vd8lfLNDheb3uBs5A7CM1kB59Nr7RYc1m399i0qkbZMsYGZVsI4ppR
	 qGM5I93/znUt4rCMlW2594NYZugtNB2YWdDWgy+u6Gzb4wgZMy5o1o3xtL0QSf28/0Z8o
	 FL3UshBEgYw1XOGc2yHKBmXmgPpRhKrIGng+ucWqAtnKoXyOK3JmC6BuXpBll9jTixg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rqg5RC6P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F666073FFC;
	Fri, 13 Nov 2026 17:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rqg5RC6P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1321F000C4;
	Fri, 13 Nov 2026 17:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590605;
	bh=qod299Ie9MpYH0RfmQa6qA6F0zQ7XSIRoPWHgx1bQeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rqg5RC6P2pOd9MmPBFNv9Urzk3U6iKFhm8E7k4jzEKlF0rrJNX87G5Xu19Y+0yYG/
	 imYesp8sEd695Sq3fZdttMtQhWwQdwBzIXuadJxL9TAYFbuqETx8QsvpEq4JKo3yAq
	 pezEytyZxZYDl1vnf2GCdWLFLg8GHPSl0XATRiec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuejie Shi <syjcnss@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 533/686] fs/ntfs3: validate the EA value length in ntfs_read_ea()
Date: Fri, 13 Nov 2026 10:51:06 -0500
Message-ID: <20261113153839.267608817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Yuejie Shi <syjcnss@gmail.com>

[ Upstream commit 351817226fbf0031c4c63d1f5d7f15c3172312eb ]

ntfs_read_ea() checks the $EA list for consistency, but it only
recomputes the packed size of an entry when the entry's own size field is
zero:

	for (off = 0; off < size; off += ea_size) {
		const struct EA_FULL *ef = Add2Ptr(ea_p, off);
		u32 bytes = size - off;
		...
		if (ef->size) {
			ea_size = le32_to_cpu(ef->size);
			if (ea_size > bytes)
				goto out1;
			continue;              /* <- elength never checked */
		}
		...
		ea_size = ALIGN(struct_size(ef, name,
					    1 + ef->name_len +
						    le16_to_cpu(ef->elength)),
				4);
		if (ea_size > bytes)
			goto out1;
	}

ef->size is non-zero for every entry except the last one, and it is what
ntfs3 itself writes (ntfs_set_ea() stores exactly that aligned packed
size), so in practice elength is not validated at all.  find_ea() then
uses unpacked_ea_size(), which also prefers ea->size when it is set, so
it agrees and hands the entry back.

ntfs_get_ea() copies elength bytes with no further bound of its own:

	len = le16_to_cpu(ea->elength);
	...
	if (len > size) {              /* size is the *caller's* buffer */
		err = -ERANGE;
		...
	}
	memcpy(buffer, ea->name + ea->name_len + 1, len);

so a caller that supplies a large enough buffer receives up to 64 KiB of
whatever follows the small $EA allocation -- straight to userspace via
getxattr(2).

Compute the packed size unconditionally and require it to fit in the
entry.  Hoist the "bytes < offsetof(struct EA_FULL, name)" test above the
ef->size branch as well: name_len and elength were being read there
without it, which is itself a small over-read of the kmalloc'd buffer
when fewer than 8 bytes are left.  The old "bytes < sizeof(ef->size)"
test is subsumed by it.

  # mkntfs image; create /mnt/ntfs/poc with user.ntfs6 set, then rewrite
  # that EA_FULL's elength from 0xf to 0xff00 on the raw device
  mount -t ntfs3 -o ro /dev/vda /mnt/ntfs
  getxattr("/mnt/ntfs/poc", "user.ntfs6", buf, 128 * 1024);

  BUG: KASAN: slab-out-of-bounds in ntfs_get_ea+0x294/0x3e0
  Read of size 65280 at addr ffff0000cca53acf by task xattr_probe/142
   __asan_memcpy+0x3c/0xa0
   ntfs_get_ea+0x294/0x3e0
   ntfs_getxattr+0x284/0x318
   __vfs_getxattr+0x104/0x160
   vfs_getxattr+0x1b4/0x1e0
   do_getxattr+0xcc/0x230
   path_getxattrat+0x184/0x270
   __arm64_sys_getxattr+0x64/0x80
  Allocated by task 142:
   __kmalloc_noprof+0x294/0x668
   ntfs_read_ea+0x1e4/0x420
   ntfs_get_ea+0x2c8/0x3e0
  The buggy address belongs to the object at ffff0000cca53a80
   which belongs to the cache kmalloc-96 of size 96

The object being over-read is the one ntfs_read_ea() just allocated, and
it is 96 bytes.

Entries written by ntfs3 and by Windows set size to the aligned packed
size, so the new test does not reject anything a working filesystem
produces.

Fixes: be71b5cba2e6 ("fs/ntfs3: Add attrib operations")
Cc: stable@vger.kernel.org
Signed-off-by: Yuejie Shi <syjcnss@gmail.com>
[almaz.alexandrovich@paragon-software.com: applied as-is, logic is the same but the code is cleaner]
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
[ sashal: adjusted context on top of c22f91d82cb9, which already validates ef->size ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index 0dbb410d51dfe..03006ff6a296c 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -146,29 +146,32 @@ static int ntfs_read_ea(struct ntfs_inode *ni, struct EA_FULL **ea,
 	for (off = 0; off < size; off += ea_size) {
 		const struct EA_FULL *ef = Add2Ptr(ea_p, off);
 		u32 bytes = size - off;
-		size_t need;
-
-		/* Check if we can use field ea->size. */
-		if (bytes < sizeof(ef->size))
-			goto out1;
+		u32 packed_size;
 
 		/* Check if we can use fields ef->name_len and ef->elength. */
 		if (bytes < offsetof(struct EA_FULL, name))
 			goto out1;
 
-		/* Size needed to hold this record's name and value. */
-		need = struct_size(ef, name,
-				   1 + ef->name_len + le16_to_cpu(ef->elength));
+		/*
+		 * The name and the value have to fit in the entry whether or
+		 * not ef->size is set, because ntfs_get_ea() copies elength
+		 * bytes out of this buffer and checks them only against the
+		 * caller supplied buffer size.
+		 */
+		packed_size =
+			ALIGN(struct_size(ef, name,
+					  1 + ef->name_len +
+						  le16_to_cpu(ef->elength)),
+			      4);
 
 		if (ef->size) {
 			ea_size = le32_to_cpu(ef->size);
-			/* ef->size must fit the list and cover the record. */
-			if (ea_size > bytes || ea_size < need)
+			if (ea_size > bytes || packed_size > ea_size)
 				goto out1;
 			continue;
 		}
 
-		ea_size = ALIGN(need, 4);
+		ea_size = packed_size;
 		if (ea_size > bytes)
 			goto out1;
 	}
-- 
2.53.0



