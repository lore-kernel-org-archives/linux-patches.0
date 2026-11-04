Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829629;
	b=cRU3FkHi6MRTLOPH9tKEV0TE3KUt8SnrcxKbxocCiZo5YyRd8+FzCsyogws/Cst7dr9N
	 393RUtM6YaJPt3E9gAZ0UabNLA1p9OejC6M7Pj7fg7S/ODl+ellNY+Z0zz8IbQ9TdFPBq
	 I2SS7M/RfNM7NU8oL8xJni3TVMUgbVQw1kFtgYF2C/hA3jo71WmZRC0k0LXMl3UvaCpt8
	 JsT83Q+SYJzZMXd6Wed48qWm7dfgaP6e/QCRwLHHmL4qT9wVJuHTCvIc1+SDFSqKrsIiM
	 zLlgmTiJ+9xJ2J0MgglAB1iSnxaJbQsdcHqGG393RQ3DlD0N1WNmbJUQgEOiyAlhrOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829629;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rcgqKZorAUW0PIdzCNLrYUYNGXaP9/sv6pvOSj2w06U=;
	b=CXOrkWLmzASDmflXLRTVC6YPXwDJxHN91/2D2c7xS1BdkdWQU8OaJ6huhNMJLNWcatgk
	 lLNB4utjFGTPd7ggtED/DarLSfMdGCXQq+HTmGyGAYTf2GLL3JhOSBa3NWvfNZVOS7vmn
	 PoDoqAw9FQYMmjey/wiGSth9KRLWsHClCYbel9vPqQ4vf8jXBvTbu6zSCdyD5ejqTYqxz
	 1zEBZhuHYFkTZ0QpISRYnEDj8AGTqOG8baAehWrtbDpKzH2Oso343G+zdWLnnJHzcMK/E
	 HEQcbAlLExHkMOxFBuSYt+GIIbf09IVZLRcRtfw4B279gVDUlEyBLPKrd/tI3ktkdmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hUfD6jnF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F4B606A84C;
	Wed,  4 Nov 2026 22:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hUfD6jnF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD18F1F000C1;
	Wed,  4 Nov 2026 22:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829629;
	bh=rcgqKZorAUW0PIdzCNLrYUYNGXaP9/sv6pvOSj2w06U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hUfD6jnFtyLak1n3qKyw812Jd3/1AizG+MPdxA5JUbzbihLEO8DFfamOrEIwwtFMJ
	 yCWhp7l2KtixkSvkztFQBb7Dfr6+g85lBmQEsKnskPENFvgxMZrRtVCh5kGuPdQV6m
	 rr8F/Amr8rZKOeP6hd2NQf5d9nZ9mvIQer5sPIKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Senjin <senjin@hatchling.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0244/1005] fs/ntfs3: fix lseek EINVAL on sparse/compressed files with 64-bit clusters
Date: Wed,  4 Nov 2026 15:59:37 -0500
Message-ID: <20261104211050.693214548@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Senjin <senjin@hatchling.org>

[ Upstream commit 789af83e41aef54c1ff1cee16adc27822e0a0d71 ]

When CONFIG_NTFS3_64BIT_CLUSTER is enabled, sbi->maxbytes_sparse is set
to -1. As a signed loff_t this is -1LL, the most negative value. Any
lseek on a sparse or compressed file passes this as maxsize to
vfs_setpos(), which returns -EINVAL whenever offset > maxsize, and
since -1LL is less than any non-negative offset, every seek fails,
including lseek(fd, 0, SEEK_SET).

The intent of -1 here appears to be "no limit" (matching the spirit of
MAX_LFS_FILESIZE assigned to sbi->maxbytes and sb->s_maxbytes in the
same block), but the signed type makes it the minimum instead of the
maximum.

Fix by assigning MAX_LFS_FILESIZE to sbi->maxbytes_sparse in the
64-bit cluster path, consistent with the other two limits set there.

Observed on a 16 TB NTFS volume with 0xFFFFFEFF total clusters compiled
with CONFIG_NTFS3_64BIT_CLUSTER=y. Sequential reads via dd/cp worked
correctly; any lseek call on sparse files returned EINVAL, preventing
archive managers and other tools from random-accessing files on the
volume. The non-64-bit-cluster path correctly sets maxbytes_sparse to
(1ull << (cluster_bits + 32)) - 1, a large positive value.

Signed-off-by: Senjin <senjin@hatchling.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index dc799ebc6c883..74f071ace3ad7 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1176,7 +1176,7 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 #ifdef CONFIG_NTFS3_64BIT_CLUSTER
 	if (clusters >= (1ull << (64 - cluster_bits)))
 		sbi->maxbytes = -1;
-	sbi->maxbytes_sparse = -1;
+	sbi->maxbytes_sparse = MAX_LFS_FILESIZE;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 #else
 	/* Maximum size for sparse file. */
-- 
2.53.0



