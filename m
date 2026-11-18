Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055189;
	b=0OW6DxUK2XcQYZSY0tzMF8Nfd1LIok1xPvfrocmhwUAapTz9rC9Hb+5AyLdNx3N6Rk08
	 MEDybgIl5FLNaaUeUMUUqTowi/eF6DRKXJ70k0ejnzy6Dgx/osiU7EMZFFx2gtkB7CX3u
	 bjfQH/vWFZoe8b49cvnB+K88Gz18uuMMiKRUi+HyvXzvuBVJ9162MD16r8lV87eB6IlL3
	 gVpQUvyQM9apJ0FRN20JR+qid6ghfj6+Rg0H6z8lHHtS6oawaVig+VKu+LUkmSZlKmksk
	 DwJFGh1/0hubpULpykLebIcZg+QzrP+MS0lZPE6aSxsClgkoYzpTDTPTAFqdqjE6oRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bUxy7rOuJztU5a4PrhDyenO625Bx9XpXIYPTruKO+f4=;
	b=QJQ3oVNE4h35HDdOCw6yPz4+RfNv2Bg09BIeUat+uo/+SRvkX3ZjdUSODhsfwzbq6eM5
	 CiY0rz9tHwUQV7DtP1Sa5AlvYX9V2uu7TcgO8nrUWe2ya/vka5RKjp2knKATev8LVAFxe
	 64qMaurtGEQYcpkIvaPVex/kKtbCQ1osG0lnZj4kUeEPvwCtImxUhjFO6G9BfzH5sonXf
	 0HaHkD/eWC+gLHCN00NgcU+vhxRUilELQy3Q8iz8HwvwDLPmf9xMBmzGamrRLK5VfjWxf
	 dFKix2RZ+i78lh9WeGPDipRcPWZwEXp5XIN2Yp18ksTCpUiHXEaMlT7SNoUL8BhFmAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TyDwneSP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06E2606A320;
	Thu, 19 Nov 2026 02:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TyDwneSP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0389B1F000C4;
	Thu, 19 Nov 2026 02:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055188;
	bh=bUxy7rOuJztU5a4PrhDyenO625Bx9XpXIYPTruKO+f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TyDwneSPdUXQFvPTmDIdNQN++ijvS13Kd227OinVDMZebj/kWMQ5u4YyaRO24AQO+
	 TFiapgkNXSOjaseJK2tw3t53bOvZImPWGIjBPX/wM0NCyj7g2NpjrB9BpTqVt7pMCH
	 pggV5C7xc1++HIT1kXKseSN0ATmAyzF21aCghfJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1541/2214] fs/ntfs3: validate $SDH entry size in ntfs_insert_security
Date: Wed, 18 Nov 2026 15:53:37 +0100
Message-ID: <20261118150113.799499125@linuxfoundation.org>
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
index cab0679c978c3..31a014dc5b066 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -2153,6 +2153,9 @@ int ntfs_insert_security(struct ntfs_sb_info *sbi,
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



