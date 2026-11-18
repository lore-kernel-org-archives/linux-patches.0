Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051347;
	b=jOv7pE5YXrqZJGV1KvOGTmoDbHMyKW/nCnFrj9AGxNLry6VaoHrXw9YVHUpXsxsPCg2r
	 Ygr3JNHPEYeGSxJDgVl2bPwHjS9rrWnrlbgI2C7AHHA+Gr3UDGQygXYAcK3lfgL/qpHLq
	 FY8h4tjoyzPwWBOMI0fMgq0Nb1+6Iw3S4cDv+Z4WERVl66tF5uWs8ofgDjoEnlPeB9OpH
	 AXX7MHup3MWpuXFebuH0R2+2hDk39J2y3z6OLUZDbAFYrVnJDcdEDWmBaEUX2DgRnLIo6
	 jSjYcDPOkRFEhPcwS9Vt2TFibzOtrreJm801fkQDhTQ6kIKNiSRCSmn/Jghk/AGMInQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4XdjRqAeBqD25K+wyuNQmj49Zd8qV87Bfdr6l7cXul0=;
	b=3PMyUR5hb1U2wCIrmsdrWu4lUe5Ap2xFUw0bETJyRlI70Oi6Oklf1lnwGx4pkAuXYLhY
	 5Izh5RvuS8B5Y42cr9WyKJReZ5Xp6V6hEJ8xZLREm2Rj0y6brnTq81DzD5FnXWEk25IOb
	 0ua7rNjNR2Jeeelry81Vv4P0tNRqu0GzbVhD4glBFdXvkw8AGMj9tV5SP5EYU/UQOy+W5
	 WZLtw4qlHP1+EXUkwLrWlg1OZIt8gBanScoodJvCkmsogOMrlTTjNpWOZlRM5pLDh8nFB
	 3+LAQIp3mQZG/PSKBYJFdDACSgSnh70bV3rNEruwXIJokH+oKst/QGd/gJE93KV9hzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="V/S33Rge";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8C3606A31C;
	Thu, 19 Nov 2026 01:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V/S33Rge
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C070D1F000C4;
	Thu, 19 Nov 2026 01:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051347;
	bh=4XdjRqAeBqD25K+wyuNQmj49Zd8qV87Bfdr6l7cXul0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V/S33RgeT37Pmujy+IbpIWQFmrcx+o2MGh850icYk2LjuXdjTgSKhBuMSl0qRnuR+
	 T4LXTbu3Xyl4tm7kcWE29cpbPS4Qpqz7iHbp0K8ICGAggDLMkBxRjRI1liW/6rYnlt
	 sRLaRNkve2AiknUweaTbbUZFZOVfS6COORLtK6Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Senjin <senjin@hatchling.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0135/2214] fs/ntfs3: fix lseek EINVAL on sparse/compressed files with 64-bit clusters
Date: Wed, 18 Nov 2026 15:30:11 +0100
Message-ID: <20261118150015.599515443@linuxfoundation.org>
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
index 4ba1501119bff..57c931672cdfc 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -863,7 +863,7 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 #ifdef CONFIG_NTFS3_64BIT_CLUSTER
 	if (clusters >= (1ull << (64 - sbi->cluster_bits)))
 		sbi->maxbytes = -1;
-	sbi->maxbytes_sparse = -1;
+	sbi->maxbytes_sparse = MAX_LFS_FILESIZE;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 #else
 	/* Maximum size for sparse file. */
-- 
2.53.0



