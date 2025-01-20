Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA721E0DAC
	for <patches@lists.linux.dev>; Mon, 20 Jan 2025 12:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737377991; cv=none; b=ixQwoioPZOEuLfewoWrrIInEUINyDYnhsLpA/kxY9wfUBoRgO8U02DL2yhQkfZyuf+M1j5Jt9dHdp0tQsWRders0gKA8AnGJrsz+0yYy6hgTNvL66zYr40YXrYYkQ8qJz9rKJg1519IDkuZP9LhuNVKQk6KY9bFjAPE+smkLUts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737377991; c=relaxed/simple;
	bh=O0+0Zri+s/2DueyKTFACsawCn1enHn6tRY8p+PfVw18=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=gArCSyrg6fJKDoXGvSe+UElgIO17tv9ccrvjmL+OF/7Ll5p6l1Vp9jkDTN+TEeGtcalkEOSVrhPRbZrHBFBnSDZYmBkP/CIxMwMIETivA0BXuKhc3l4kWHeeG/MZSOsv6x+YXT/vRG06EdRgvKkALsQkYdXOZ7rWE3WnhbI2690=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G6JZdA29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G6JZdA29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150F6C4CEE1;
	Mon, 20 Jan 2025 12:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737377991;
	bh=O0+0Zri+s/2DueyKTFACsawCn1enHn6tRY8p+PfVw18=;
	h=From:Date:Subject:To:Cc:From;
	b=G6JZdA291903VcvjYxk0sNZ0iYLnsIWGdu+b9Xyy6CpgneOcN9ZUy+gURpchIJa7g
	 /l9QA9dcPz9VPx63lXoyyQouJ3yh89AeqKubCvzLHylK6WZdtHMsk0+blqnWoDoRYf
	 0fKZqJStDLQXRpL3xCzHFxRego1GB2jw+T+LQeBwnNKDZCENfgrzDQ+eoFzl8QX9gn
	 scLQ8ZBRBOSma0bf/JJi/wW10To4hYLQddUWXCLWDszpTNejaXuYLwU1rbTl8RyyJ/
	 1OlvPSiLJMP89VHioMuHc1pkO1ijNc7gzxd77mqc85/rSyD1Ma7yzjqkBX29SLMy/h
	 VxdHXGgievW2Q==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 20 Jan 2025 05:59:44 -0700
Subject: [PATCH] f2fs: Fix format specifier in sanity_check_inode()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-f2fs-fix-wformat-min_inline_xattr_size-v1-1-508cac1474fe@kernel.org>
X-B4-Tracking: v=1; b=H4sIAL9IjmcC/x2N0QrCMAwAf2Xk2UBbV0R/RaSULdWAyyQpOhz79
 5U93sPdrWCkTAa3bgWlLxvP0sCfOhheWZ6EPDaG4EJ0PjgsoRgWXvBXZp1yxYklsbxZKC25Vk3
 Gf8Jr9MN4drHvLwQt9lFq0jG6P7ZtB+TWzhV4AAAA
X-Change-ID: 20250120-f2fs-fix-wformat-min_inline_xattr_size-951cd305447e
To: Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>
Cc: linux-f2fs-devel@lists.sourceforge.net, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2517; i=nathan@kernel.org;
 h=from:subject:message-id; bh=O0+0Zri+s/2DueyKTFACsawCn1enHn6tRY8p+PfVw18=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOl9HkdfNdneFDTXPSN8t1CKr/Pr71T9jSdW36vMTd8RO
 f1RNP/8jlIWBjEuBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjCRF+oM/5QXFe00czgZu/X7
 CYeqVW6XinlWTpIML14zWdrbMt8rZAXDX9l/0oLreJc818lh8I24t+PQSvGChCO5q6c0eeg/WcE
 TzgkA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building for 32-bit platforms, for which 'size_t' is 'unsigned int',
there is a warning due to an incorrect format specifier:

  fs/f2fs/inode.c:320:6: error: format specifies type 'unsigned long' but the argument has type 'unsigned int' [-Werror,-Wformat]
    318 |                 f2fs_warn(sbi, "%s: inode (ino=%lx) has corrupted i_inline_xattr_size: %d, min: %lu, max: %lu",
        |                                                                                                 ~~~
        |                                                                                                 %u
    319 |                           __func__, inode->i_ino, fi->i_inline_xattr_size,
    320 |                           MIN_INLINE_XATTR_SIZE, MAX_INLINE_XATTR_SIZE);
        |                           ^~~~~~~~~~~~~~~~~~~~~
  fs/f2fs/f2fs.h:1855:46: note: expanded from macro 'f2fs_warn'
   1855 |         f2fs_printk(sbi, false, KERN_WARNING fmt, ##__VA_ARGS__)
        |                                              ~~~    ^~~~~~~~~~~
  fs/f2fs/xattr.h:86:31: note: expanded from macro 'MIN_INLINE_XATTR_SIZE'
     86 | #define MIN_INLINE_XATTR_SIZE (sizeof(struct f2fs_xattr_header) / sizeof(__le32))
        |                               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Use the format specifier for 'size_t', '%zu', to resolve the warning.

Fixes: 5c1768b67250 ("f2fs: fix to do sanity check correctly on i_inline_xattr_size")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 fs/f2fs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 7de33da8b3ea..3dd25f64d6f1 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -315,7 +315,7 @@ static bool sanity_check_inode(struct inode *inode, struct page *node_page)
 		f2fs_has_inline_xattr(inode) &&
 		(fi->i_inline_xattr_size < MIN_INLINE_XATTR_SIZE ||
 		fi->i_inline_xattr_size > MAX_INLINE_XATTR_SIZE)) {
-		f2fs_warn(sbi, "%s: inode (ino=%lx) has corrupted i_inline_xattr_size: %d, min: %lu, max: %lu",
+		f2fs_warn(sbi, "%s: inode (ino=%lx) has corrupted i_inline_xattr_size: %d, min: %zu, max: %lu",
 			  __func__, inode->i_ino, fi->i_inline_xattr_size,
 			  MIN_INLINE_XATTR_SIZE, MAX_INLINE_XATTR_SIZE);
 		return false;

---
base-commit: 5c1768b6725049e1fcfc841924d65f2872413000
change-id: 20250120-f2fs-fix-wformat-min_inline_xattr_size-951cd305447e

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

