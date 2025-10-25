Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03E32580F2;
	Sat, 25 Oct 2025 16:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408910; cv=none; b=Opkghyu0cm/TqbrMKk0uJ1CN0SfZdOVyqZOK154ed+5V9RpDLIa0SU/0Vyd3Ll58XcqOAbOTr8zjPXqkp8Vr+8kMXXIoisB59KlbSjxZRAFOE1f3WSyPVp/ReSoN+skTNdJY5jSV6yxCfU2KaxZgvGjzfTbKw0RbpDwb6LflQp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408910; c=relaxed/simple;
	bh=6nNQtbJ5vYXMplOb3xudC63qPL/Z0j1vsdKDxh0ykmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VXsCdsa5co9AnaMP5qCkrwdFGy0BKR5davOrWAtsnZGtCjh3+wBOER3P33nf53ec2s1u1wRkCz4jU3IlmU5rAGuMjIUFsV0Dt0X9pUBXPmLiRWEYhklLbqRs4eFl4NBC+zP6S7+tl1JcX6E2KJtNdgy3adJbasb09//10oVJVzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gVpE3HMs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gVpE3HMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EA4C113D0;
	Sat, 25 Oct 2025 16:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408910;
	bh=6nNQtbJ5vYXMplOb3xudC63qPL/Z0j1vsdKDxh0ykmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVpE3HMsBNtVoDyN5elVlBzhgonN9hKKkTKL0YVB/LkHrL+G1Tyna49lcx3DI9Rey
	 tJVCzmSUlTy2stJj0wRqSsoCPiHwiOC5KtRTCI+3xCPmYMYJe5TxhLj2osVaM6BTm+
	 mOvHIyyFWqQp0o5Mq4I7W82XSbs/n7TTSPmPNRsqt4mCTVw3dYb2Ec5Be2do0zLEfa
	 fJIPe6ID4+mKcO9zkAT3cb9m6rAnBrGGYDTB77WeEBLkpXVE/eE2bPsWoImsYCNEcn
	 5kDH/7+RUH6QJS5jflRhcx9QDhym7T+BQbplpxSeNkaKoRxLH8kh6yCDrVpDFyggXM
	 t2S+9mQyWvpNQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 6.17-5.15] ntfs3: pretend $Extend records as regular files
Date: Sat, 25 Oct 2025 11:55:56 -0400
Message-ID: <20251025160905.3857885-125-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 4e8011ffec79717e5fdac43a7e79faf811a384b7 ]

Since commit af153bb63a33 ("vfs: catch invalid modes in may_open()")
requires any inode be one of S_IFDIR/S_IFLNK/S_IFREG/S_IFCHR/S_IFBLK/
S_IFIFO/S_IFSOCK type, use S_IFREG for $Extend records.

Reported-by: syzbot <syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=895c23f6917da440ed0d
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes a real bug triggered by VFS invariants: After vfs change
  af153bb63a33 (“vfs: catch invalid modes in may_open()”), inodes must
  have a valid S_IFMT type. ntfs3 could leave $Extend records with an
  invalid/zero mode, causing may_open() to reject or warn on opens. The
  patch makes these records appear as regular files, satisfying the VFS
  type check.
- Small, local, and low-risk change: Only one code path is touched in a
  single file, with a one-line assignment in a narrow case.
  - In the $Extend-specific branch in `ntfs_read_mft()`, the code now
    sets a valid file type: `mode = S_IFREG;` immediately after
    identifying an $Extend record and setting inode ops
    (fs/ntfs3/inode.c:470-474).
  - The mode is then stored into the inode as usual (`inode->i_mode =
    mode;`, fs/ntfs3/inode.c:488), ensuring the inode passes VFS type
    checks.
- Constrained to special metadata records: The branch only triggers when
  the filename references the $Extend MFT record (`fname->home.low ==
  cpu_to_le32(MFT_REC_EXTEND)` and `fname->home.seq ==
  cpu_to_le16(MFT_REC_EXTEND)`, fs/ntfs3/inode.c:470-471). Regular
  files/dirs/symlinks/special devices remain unaffected.
- Preserves ntfs3 behavior while satisfying VFS: The $Extend branch
  still sets only `i_op = &ntfs_file_inode_operations`
  (fs/ntfs3/inode.c:473), unlike the normal regular-file branch which
  also sets `i_fop` and `a_ops` (fs/ntfs3/inode.c:456-465). So $Extend
  records won’t gain full file operations; they simply have a valid
  S_IFMT for VFS. This minimizes behavioral change while fixing the bug.
- No architectural changes or cross-subsystem impact: The patch does not
  alter VFS or broader kernel APIs; it’s contained within ntfs3’s inode
  setup logic.
- Aligns with stable rules:
  - Important bugfix reported by syzbot (Closes: the linked syzkaller
    bug).
  - Minimal change and clear rationale.
  - Low regression risk and limited scope (ntfs3 only).
- Forward/backward compatibility: Even on trees without the may_open()
  enforcement, setting a valid type for these metadata inodes is
  harmless and arguably improves correctness. On trees with
  af153bb63a33, it avoids spurious failures/warnings.

Conclusion: This is a targeted bugfix to comply with VFS invariants and
prevent failures when interacting with $Extend records. It’s safe and
appropriate to backport to stable kernels that include ntfs3 and the
may_open() invariant check.

 fs/ntfs3/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 37cbbee7fa580..b08b009121653 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -471,6 +471,7 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 		   fname->home.seq == cpu_to_le16(MFT_REC_EXTEND)) {
 		/* Records in $Extend are not a files or general directories. */
 		inode->i_op = &ntfs_file_inode_operations;
+		mode = S_IFREG;
 	} else {
 		err = -EINVAL;
 		goto out;
-- 
2.51.0

