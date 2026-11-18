Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029796;
	b=xzbc/1xUqJVOMtuUHFzPuSGcjS45n6yn1WERUPiBfn4p0UnRSlKCEakMkIUGiqcQaPOi
	 EX15gYqEqQKU5ZAj15MCdozkhDb3i0np9hD/0DBtY/2GJ6KtodqVUWJRuheq8OVo0+cmz
	 xhNrFB03gCxzGPrRg27WfUW5GX3koWZfuqlfHTv76F5DZEXsKJgxuTZ0DmzLD5twHUu5t
	 D4iaGjumNitiHuzTaj/s7HgKcG1uDh3BYHqlrQCYWKtwr82OS6stwt3tkunPkgATkYmKX
	 5wWPDW7tzDNOVr67KEqjOZ8aG5EEBfBhDP7XrP5HpNcLwk9/hVZfpRq3C9g2PRn0Yeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C6duCfcQyovRWswnahzNlchhOM/lImknPOmqfzmfbRQ=;
	b=Yi52cWSnZr8LQwVffPE2ywMeeGA2avMFMxVnIx2yRxgDJlhOHDuQWH1CsJJffX2zmD2Y
	 iqd5egEN+JBRH1mwzw1pFMcz5B2GRVc4dudUAs6bqtNPw79aYBmvQ8VOi4FdxBIDJK6rc
	 fx96S3FoKioH8+jQw4ErkMcQBLd+RkxavQDkjdHOXEydA8Ps2PshQt1auv4Dm5VRDPYs1
	 dYaKJt0TwrYCY6c0kF/Jz360jn2TVBmXbXOJHxsdz+M5Nyr6KnxWZJeeKMmEDXBP4lXqY
	 FPkBC4DLipgX6lAExLzDMiPXEkXWKOM/jiUaPXf+fjLsFtS9/ntCJ2kDoBrEAnaXzuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KVP6lb1O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D26E606A325;
	Wed, 18 Nov 2026 19:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KVP6lb1O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3CD1F000C4;
	Wed, 18 Nov 2026 19:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029796;
	bh=C6duCfcQyovRWswnahzNlchhOM/lImknPOmqfzmfbRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KVP6lb1OSmJRsaTb8OPJisjmUcyKlZGeTLbFJJWgBsGXo0vkKIgLNhdtArjqcVchv
	 UgwCROokVx/OaT22d7GoiNnDK+p1HzvKoOSGfLsoIA5yJD/i3P092Waiq24wZQeFCw
	 d9QxH6fpSOOZhu+9aGxLy7tys8jAlfzZtms4oDC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0478/1756] fs/ntfs3: validate $SDH entry size in ntfs_insert_security
Date: Wed, 18 Nov 2026 15:43:25 +0100
Message-ID: <20261118150027.934843512@linuxfoundation.org>
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
index c9ff8293fea73..1510f2c4ced9c 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -2160,6 +2160,9 @@ int ntfs_insert_security(struct ntfs_sb_info *sbi,
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



