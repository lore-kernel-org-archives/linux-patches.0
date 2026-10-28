Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213201;
	b=vNdTWXCgxuwRjQ3I8c2qKcUkRu1ow1WC4F8//x38V9WKzUfVnW1gI05XjZx3g7hnpHq5
	 arbTfiwbSh7ZiSjQel9jS9LuaZHAuMbVst9zvaQ3cbDh/f4i3HTaEGWCoxT9T7nU97uQV
	 qsMJL5GtTjFjYEpABf3mX1pk9eU0jhSGoSvT2sGPXGH+/SNQP/ueE94hVaI9AMNumCjq6
	 RwpLmQ9uJcoP/t53s89A4bqOljLPpdAuYLkU9evcOEJpGHdWWCO8bddHC3IsM0teTK+PK
	 SMxnmGiXBLoyknFoyT1MrHMONHlBfRCQuMVKRFTsc1qBkeb2pdiRvKgliTRhTPfEX5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213201;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=weV/xo9+4dGyh9XJRzZJs1v7YHTXiQ1rHEaVvX2aCwU=;
	b=XlBIXpmGK4hPGUngukp8ld9VgMpTlzJOmFX6R4Hyq/OZNjAywFEMqwxSpnPf8Lq8VtdI
	 J5vGUbBhPXf09MQlOm7ExOuKD7UgeFD6L1BorDrfAIDSIc+qBuvI003ryhetaMSgkompA
	 yg0TzY/TqojndYy09GwXgyM7ZyBCm3s2HUkQWVAPn6Ao6j0AhPsE165TvyYWvZgqUhkV0
	 KnGvjbEglpJgDC6VLTNgQDjegCL44RP0wxPG5L8pg1JIz/k1Ck+uE5t2SCsbE8ijUcaTj
	 Rns0LRqn6CtNRA9qST1VF7T78fqlbZssPF6zJ27LeWyNob/1xS1+IL59BixJ4wQlAvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NY8tyI9j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E8F606A31D;
	Wed, 28 Oct 2026 18:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NY8tyI9j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C801F01825;
	Wed, 28 Oct 2026 18:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213200;
	bh=weV/xo9+4dGyh9XJRzZJs1v7YHTXiQ1rHEaVvX2aCwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NY8tyI9jHAvhJYwCVke2v/DUjcTK5M3y9EFvz+R7V2fy0BAqn3DLKSzZ6UgThYiBO
	 1r/98FjpGkerNAwNCFmTBO3Js24sgjUxFnBTMqBcY+4OPLw8DJJnIcrSJf/VhtPEcA
	 O5xHjmb26hF9+cCmLE1HOn4THMWEgMta4I3X0FsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?HE=20WEI=EF=BC=88=E3=82=AE=E3=82=AB=E3=82=AF=EF=BC=89?= <skyexpoc@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Nikita Nagornyi <nagornyi@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0421/1887] fs/ntfs3: fix slab-out-of-bounds write in ni_create_attr_list()
Date: Wed, 28 Oct 2026 17:41:57 +0100
Message-ID: <20261028170508.814668589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HE WEI（ギカク） <skyexpoc@gmail.com>

[ Upstream commit 7c4841e2a62794a3bab7c1ff0540580f387e377f ]

ni_create_attr_list() allocates a fixed buffer of al_aligned(record_size)
(== record_size) bytes and then walks every attribute of the primary MFT
record, writing one ATTR_LIST_ENTRY per attribute and advancing the cursor
by le_size(name_len), with no check against the end of the buffer; the
total size is only computed after the loop.

A minimum-size resident attribute occupies SIZEOF_RESIDENT (0x18 = 24)
bytes on disk, but an unnamed attribute expands to le_size(0) (0x20 = 32)
bytes in the list.  Because the number of attributes in a record is not
bounded (mi_enum_attr() accepts arbitrarily many equal-type, nameless
minimum-size attributes), a crafted record packed with such attributes
produces a list larger than record_size and overflows the heap buffer.

This is reachable from a crafted, loop-mounted NTFS image: opening the file
and adding an attribute (e.g. via setxattr) drives ntfs_set_ea() ->
ni_insert_resident() -> ni_insert_attr() -> ni_ins_attr_ext() ->
ni_create_attr_list().

  BUG: KASAN: slab-out-of-bounds in ni_create_attr_list+0xc48/0x1058
  Write of size 4 at addr ffff000008984c00 by task setfattr/345
   ni_create_attr_list+0xc48/0x1058
   ni_ins_attr_ext+0x510/0x7c0
   ni_insert_attr+0x3f8/0x70c
   ni_insert_resident+0xc8/0x3b0
   ntfs_set_ea+0x66c/0xd28
   ntfs_setxattr+0x4d8/0x5b0
   __arm64_sys_setxattr+0xa4/0x124
  Allocated by task 345:
   ni_create_attr_list+0x188/0x1058
  The buggy address belongs to the cache kmalloc-1k of size 1024
  (the write lands at object+1024).

Size the buffer from the actual attributes instead of assuming a single
record_size is always enough.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Reported-by: HE WEI（ギカク） <skyexpoc@gmail.com>
Signed-off-by: HE WEI（ギカク） <skyexpoc@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Nikita Nagornyi <nagornyi@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index c9d0947651c4e..240983bac9c3c 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -816,10 +816,23 @@ int ni_create_attr_list(struct ntfs_inode *ni)
 	rs = sbi->record_size;
 
 	/*
-	 * Skip estimating exact memory requirement.
-	 * Looks like one record_size is always enough.
+	 * Compute the exact size of the attribute list.  Each attribute in the
+	 * record yields one ATTR_LIST_ENTRY of le_size(name_len) bytes.  The
+	 * minimum on-disk attribute is SIZEOF_RESIDENT (0x18) bytes, but an
+	 * unnamed one expands to le_size(0) (0x20) here, so a record crafted
+	 * with many such attributes needs more than a single record_size; the
+	 * previous fixed kzalloc(record_size) could therefore be overflowed by
+	 * an attacker-controlled record.
 	 */
-	le = kzalloc(al_aligned(rs), GFP_NOFS);
+	lsize = 0;
+	attr = NULL;
+	while ((attr = mi_enum_attr(ni, &ni->mi, attr)))
+		lsize += le_size(attr->name_len);
+
+	if (!lsize)
+		return -EINVAL;
+
+	le = kzalloc(al_aligned(lsize), GFP_NOFS);
 	if (!le) {
 		err = -ENOMEM;
 		goto out;
@@ -831,7 +844,6 @@ int ni_create_attr_list(struct ntfs_inode *ni)
 	attr = NULL;
 	nb = 0;
 	free_b = 0;
-	attr = NULL;
 
 	for (; (attr = mi_enum_attr(ni, &ni->mi, attr)); le = Add2Ptr(le, sz)) {
 		sz = le_size(attr->name_len);
-- 
2.53.0



