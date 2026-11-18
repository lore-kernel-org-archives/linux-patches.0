Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040045;
	b=MCrK+j16hWBc8NSEaupA4sa7zVeSavhydb7aSFvcCB+C+xttyK52K15UVvspkt0GPnS+
	 4rpNsUd9MkdzpDZT702j2Q1bXQbLzpD2PdPpXMjb8KCvUAYjYBLEAXmRy5ELl4cKPthRd
	 SqyWIQkwrp6s0GzcO0yxlpL5WVLxPGteS94iQg0Ej3dhRvqwJ56O79hcnHrEdqEazaPBe
	 flyqX7WFXf1AYnsRtxQ2JeUD9hkOS3ZmLjFCnbzagqVpRa7XcZFatuVQJVoIqeWWfATJI
	 TTgfLb8MTkGgad6Velut+2gFa2Y4uXs27mtW5+sQKUlfl0T5VDXHc0uSiJjcjmJ+Kfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WE1uUzNsQDO5a9X6fUdtSkUTgt7EqEJYl647LalI0cI=;
	b=a3MkmGCtxAlKYpYGTEWJpfZTHgQBsSv+cX33vdg8wYoIhJi5TLfwRM2HM1dp4ALGa/NM
	 Ldgzk5MLt8icgFVfOO3IlOhp26it4PTb89vNrn0j3axMVcmFOhLrfa4lNiMM+rG2pNCoz
	 0396Y+61E6jBmIQVqc4KRmqvJpuwcM2EeymcKOzJXWz6sbpjAFFdC7Md7AsXWyYt5g2yS
	 BvbXsitT5/wTMh/zB2Gd9Ed/ceQBlWlMrSAxBAs76kKQcGoyob5R+tLDTNh2AStKiarcy
	 sgODSwu/GvMZHBwpcwWXSgOZv5cNLP7tGzbejVFG9exSAVHi0zDYauzDRd9lkT9oK7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lemFh4jt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64A5606A31C;
	Wed, 18 Nov 2026 22:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lemFh4jt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3861D1F000C4;
	Wed, 18 Nov 2026 22:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040045;
	bh=WE1uUzNsQDO5a9X6fUdtSkUTgt7EqEJYl647LalI0cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lemFh4jtGROM7agOMZrsSStLsKU5D3I8U/u5gEdqn6XEs6zBiiSTen298btG3SrVs
	 40Ob1cLlKt0SOcyOiHxfJy7sZrRNjBU68eqEbwKDTrDOEj6Q2oRJkgd47ZHfiNr91B
	 g9kYe3Z82TM2eojJJA/zK7WoFSqoXPmFPElKwzBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2277/3318] fs/ntfs3: validate $SDH entry size in ntfs_insert_security
Date: Wed, 18 Nov 2026 15:48:19 +0100
Message-ID: <20261118150430.088630453@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 5b76487f94dacc2884135ce9a7bda61ce7ffa209 ]

ntfs_insert_security() walks the $Secure::$SDH index and reads
e->sec_hdr.size for every entry returned by indx_find()/indx_find_sort().
Those only guarantee the NTFS_DE envelope (e->size), so a crafted $SDH
entry shorter than a full NTFS_DE_SDH at the tail of an index buffer makes
the read of e->sec_hdr.size run past the allocation. Triggerable by an
unprivileged setxattr(2) on a crafted NTFS image.

  BUG: KASAN: slab-out-of-bounds in ntfs_insert_security (fs/ntfs3/fsntfs.c:2148)
  Read of size 4 at addr ffff88800fa1de00 by task exploit/142
   ntfs_insert_security (fs/ntfs3/fsntfs.c:2148)
   ntfs_setxattr (fs/ntfs3/xattr.c:947)
   __vfs_setxattr (fs/xattr.c:223)
   __vfs_setxattr_noperm (fs/xattr.c:257)
   vfs_setxattr (fs/xattr.c:344)
   filename_setxattr (fs/xattr.c:690)
   path_setxattrat (fs/xattr.c:734)
   __x64_sys_setxattr (fs/xattr.c:764)
   [...]
  The buggy address is located 0 bytes to the right of
   allocated 512-byte region [ffff88800fa1dc00, ffff88800fa1de00)

Stop the scan when an entry is too small to hold a SECURITY_HDR.

Fixes: 82cae269cfa9 ("fs/ntfs3: Add initialization of super block")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fsntfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 513c04be1caf8..0722c1befb07e 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -2156,6 +2156,9 @@ int ntfs_insert_security(struct ntfs_sb_info *sbi,
 		goto out;
 
 	while (e) {
+		if (le16_to_cpu(e->de.size) < SIZEOF_SDH_DIRENTRY)
+			break;
+
 		if (le32_to_cpu(e->sec_hdr.size) == new_sec_size) {
 			err = ntfs_read_run_nb(sbi, &ni->file.run,
 					       le64_to_cpu(e->sec_hdr.off),
-- 
2.53.0



