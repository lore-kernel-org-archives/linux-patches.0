Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F8D272E5E;
	Tue,  5 Aug 2025 13:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399546; cv=none; b=PViCYH0h/n6H7jj2oOL4t6Q8z+XFQro3U16SS0+vPfd9JOV/2ON+uPu2ZpDl7vUi8RLKuJJZjuiHI67E6lsuA//qQD47ydyo2fPx5V2RtOits+tVN0WmVWRDj44epYhKgO+7VRgadjJIE5+sYa2+UnOjyowJ5fYsuSr6Sx/hkVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399546; c=relaxed/simple;
	bh=AMs5KUwbQVdPQ9vqFQRkUMqWPoaPmMwK2Vq/nT4s15k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PtEt8gQKfWhN73wjeRepzpHnr5td9qw3IbiOiK1bAzX9rntXM6OE1DnzC16yDA7d+t3KuQgPhsuenjBJpAreWPb/C00LxkgUBjbP/djn9XE4SntTdpCXH7+xMC5vPEkbjAWbc4jUcbd1R8dAMRqw7YrzaxBHl3erAy8KzLgxKZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MzwUOG1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MzwUOG1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE950C4CEF4;
	Tue,  5 Aug 2025 13:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399546;
	bh=AMs5KUwbQVdPQ9vqFQRkUMqWPoaPmMwK2Vq/nT4s15k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MzwUOG1BMm44BLnFZ1LIX9P7KjtZEaEEXeQ5fVjc7FoHv1abV+d1s0W20dvRdTxTP
	 Z9zwATB7EdOifT1vuLVNXwS7hK7BeegXe5R4PWR/J3//wy/2f2mqyR7mYqqfQ0ErqM
	 ZuhSAOapxBcW7F4S7EJeq0an6fEpo8/39JWl9UR40wNIc0XqKlAhbrIszTd1q+Mh5k
	 gXNtqVJUJkyl5RxaT8Wpw8gQSGl+Nh21en4m4OLLQIFSdLGET4HCZ3U0W5y5T0d7Dx
	 dOoCVnFbiuEvOGsL6U2Ajyjh955pOjOE/G65kf8OrFOrbhxovsrAhJxuOt38HjA2qG
	 jGxwd+nsEUfCQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Edward Adam Davis <eadavis@qq.com>,
	syzbot+630f6d40b3ccabc8e96e@syzkaller.appspotmail.com,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	shaggy@kernel.org,
	jack@suse.cz,
	Slava.Dubeyko@ibm.com,
	brauner@kernel.org,
	lorenzo.stoakes@oracle.com,
	jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 6.16-5.4] jfs: Regular file corruption check
Date: Tue,  5 Aug 2025 09:09:44 -0400
Message-Id: <20250805130945.471732-69-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Edward Adam Davis <eadavis@qq.com>

[ Upstream commit 2d04df8116426b6c7b9f8b9b371250f666a2a2fb ]

The reproducer builds a corrupted file on disk with a negative i_size value.
Add a check when opening this file to avoid subsequent operation failures.

Reported-by: syzbot+630f6d40b3ccabc8e96e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=630f6d40b3ccabc8e96e
Tested-by: syzbot+630f6d40b3ccabc8e96e@syzkaller.appspotmail.com
Signed-off-by: Edward Adam Davis <eadavis@qq.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Bug Fix Nature
The commit fixes a **data corruption vulnerability** where a corrupted
JFS filesystem can have regular files with negative `i_size` values.
This is clearly a bug that affects users, as evidenced by:
- The syzbot report indicating this was found through fuzzing
- The potential for subsequent operation failures when accessing such
  corrupted files

## Security and Stability Impact
1. **Prevents kernel crashes/errors**: Without this check, opening a
   file with negative `i_size` can lead to subsequent operation failures
   and potentially undefined behavior when the negative size is used in
   calculations (line 63 checks `inode->i_size == 0`)

2. **Similar to other filesystem protections**: The analysis shows EROFS
   has a similar check (fs/erofs/inode.c:134-137) that returns
   `-EFSCORRUPTED` for negative i_size, indicating this is a recognized
   filesystem corruption pattern that needs protection

## Minimal and Contained Fix
The fix is:
- **Only 3 lines of code** - extremely minimal change
- **Early validation** at file open time - prevents issues before they
  cascade
- **No architectural changes** - just adds a simple validation check
- **No new features** - purely defensive programming
- **Confined to JFS subsystem** - doesn't affect other kernel components

## Low Risk of Regression
- The check only triggers for already-corrupted filesystems (negative
  i_size is never valid for regular files)
- Returns standard `-EIO` error that applications already handle
- Placed before any other operations, minimizing interaction with
  existing code
- Tests confirm the fix works (Tested-by tag from syzbot)

## Stable Tree Criteria Met
This perfectly fits the stable kernel rules:
- Fixes a real bug (filesystem corruption handling)
- Minimal change (3 lines)
- Obviously correct (negative file sizes are invalid)
- Already tested
- No new functionality

The commit prevents potential kernel instability, data corruption
issues, or security vulnerabilities when dealing with corrupted JFS
filesystems, making it an ideal candidate for stable backporting.

 fs/jfs/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/jfs/file.c b/fs/jfs/file.c
index 01b6912e60f8..742cadd1f37e 100644
--- a/fs/jfs/file.c
+++ b/fs/jfs/file.c
@@ -44,6 +44,9 @@ static int jfs_open(struct inode *inode, struct file *file)
 {
 	int rc;
 
+	if (S_ISREG(inode->i_mode) && inode->i_size < 0)
+		return -EIO;
+
 	if ((rc = dquot_file_open(inode, file)))
 		return rc;
 
-- 
2.39.5

