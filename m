Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048403;
	b=qRAxHKh0aLASfcocah4iqe8K5ZLX+9WZm4R95Fdsud3BCkKKTaZ7/+a3pkVU+EDWe087
	 /lXlcfBoE7ekZ+1gsrO90qj2gHyTT1VI/KFjy73LXx+vStkFnlj26L8oI9x/MuXg9Ecak
	 BIoaivgBpmjJJtknqeEpai0tYK4NWpGMcS2X7EAmw44mVf3CDImLW1tWlrn2XI+eT7YQn
	 /1DVQ6vXEKHu4XD+a0LLX9iH4RECxFGgOgi696S2ODnHJDn0SkoUFtdzAhDU7d1KqPYuU
	 Ta4zZv62oRzBi6rkqiCwsEvzllDy1TAR91Fur930g7uJNG6HUHNsGKYal0ZpGWVWv0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vBm+zfPl/kQMMkn8RxELgtZFWAl2VL/le3PcHBRHrJ0=;
	b=qBVwHf5LnEB8qYbeZjQIoIEy6ngV6WCbcR+VsIsh7KxK2J604TVCCh++SuUYb1OhV2uE
	 cRe9ZqMKxg5adviw8csnu8W8aH9/7JCQBdUy5cArwYAMRYweyZ2EZE22d+MxyIVtAZs8J
	 NAe6PbF9tkeJhAyeAujeJpaCSTHeGwj5yXgvyf+ECf/GO0HdyvJw/whA1Pqwu4iAk1C/M
	 D2kapuPR7e14hWfrK6l4pdp7o/mDoxroLQ1kdztaEa7rOE4AmlZpDmzhbpqMigPuvYKun
	 PAD4dY1TC6hjfnV/SmcYMrSAtdOiThQEpOgwHe/Lm/202F56idpi6CsiywBYtqtNEhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rItp/alf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EA2606A32C;
	Thu, 19 Nov 2026 00:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rItp/alf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E601F000C4;
	Thu, 19 Nov 2026 00:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048403;
	bh=vBm+zfPl/kQMMkn8RxELgtZFWAl2VL/le3PcHBRHrJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rItp/alfrFroJRwv4+xr4SkWOIuccZCIPtus1dAyWLkxeGfBWJvF5WDSipiRwU+1R
	 qzY6VL3NNjCsdF+u9oi7Ai3RniY9WbLWa/qZdwwYSxyYxa9m/yyspsDN2D8civLncz
	 JuTgPiMuTkTArC9PsHqxTUEs6PfNFkIGvUu9Gn2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1981/2857] fs/ntfs3: validate EA entry layout against ef->size in ntfs_read_ea
Date: Wed, 18 Nov 2026 15:50:15 +0100
Message-ID: <20261118150312.711705074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 754839cb85e8e..92f5b4c84b72e 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -167,6 +167,8 @@ static int ntfs_read_ea(struct ntfs_inode *ni, struct EA_FULL **ea,
 			ea_size = le32_to_cpu(ef->size);
 			if (ea_size > bytes || packed_size > ea_size)
 				goto out1;
+			if (bytes < offsetof(struct EA_FULL, name))
+				goto out1;
 			continue;
 		}
 
-- 
2.53.0



