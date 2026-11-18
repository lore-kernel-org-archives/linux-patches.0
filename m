Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053710;
	b=1N58nCjz7ogF0PCjXZhXRsk/zdZLYcgdHFC4PG/yAcypHoNEw+M/c9Ke6rTKqMMH1oAr
	 y2wbUbXCOU962E4ekNh0f+bNZDMLtYu1zr/JuDEUjuvjKlksJNmtKZQRwYaO+Gn54YlrK
	 nAESShf1lORidSyT5mkn6krDw5bTic5pr8ENI4cyyvzYJ5osNm16U1qCHFSZjEsSuinB3
	 Er1tMi//X2wtc27PjnOI6+GEFkukJzKfDs2dCsG0N2wX/3ti4nmxm3xyx5EF90BjmAyNv
	 J5lHacaS98DQdGTPNTJDr76CTNYBNcjlLPCJX3CAHMW6Qjrohf9PK1D+SHKffyxVo6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jxe8kTi/u+T3uYQaCId8EhD/ozHmxwaQKCcUhg/fv1I=;
	b=O210aqyqyr+AhIGAU1DojccoOde2C1Zg9WwUlT38SUl2O2hlikWcozQrTfaTzp7ABsgj
	 Rkrw1L/3boievFwHq9rUBlACYepHpKH252360Y7LWwZO/8qkC3aMJPqJ/jHy4aD7p+AHW
	 gqTg3vj7AdwIVwbbXCjy40HD1hJjAQmjruco1w5tpC9NtRmnK2MtWogiUlKIvNUdOB1s8
	 wb9qHEvQz4G30/NVFpqgzVboNWtpbI3ZPakFKAAKgqO2AczQEDefuCWuda6z3494e8LOv
	 uiWDww/leGXZoUbr6IZfUiq59UYwCe/nSSsUs4HN9Uc3E1AifOps5MG3CfmqXz2E2+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MCfLaVxm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22EB606A31C;
	Thu, 19 Nov 2026 02:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MCfLaVxm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE1C1F000C4;
	Thu, 19 Nov 2026 02:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053709;
	bh=jxe8kTi/u+T3uYQaCId8EhD/ozHmxwaQKCcUhg/fv1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MCfLaVxm7HjARLgzN1d6/opphDLUc97a1Ds9U+0lhxj+YRtHNcHkory+uDqRbDxXs
	 +tuop5DzR5aSDDO95JYXKL2AjbZDltBWkHWxzhvjtdpNeB7+41MAsdJVnaJ1khEROJ
	 anRGkWpcHrMVCxNM3jLcGN6+qv+cC2BZdSlIlM2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuejie Shi <syjcnss@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1014/2214] fs/ntfs3: validate the EA value length in ntfs_read_ea()
Date: Wed, 18 Nov 2026 15:44:50 +0100
Message-ID: <20261118150052.941578499@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c45133934c3ed..078f4abb42ec2 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -145,29 +145,32 @@ static int ntfs_read_ea(struct ntfs_inode *ni, struct EA_FULL **ea,
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



