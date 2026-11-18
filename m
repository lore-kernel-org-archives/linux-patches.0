Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033890;
	b=n8lsS9ahwtMkCL/8b887SEwSwBes6COHIf6txNVclDlatUg59Vj3czfJy7rM/MNEq/aQ
	 CCb7+mj97k3n6Z9oxFGRABhKYdysgxDqieAjrLV5uIqdboD6XskRsE3VPvmj/iUN5OFZH
	 RMjF3/VV1Q8kYJ4T4tiXb5cMx92xrJ1ln/8plnxvzc1mVU8qzNzBDCx0+XmdTpkp3zHFm
	 xKhOXGuK2lFQtfPh5VVQvBLrYD3IBMZiIOwwN4N+Ky5o1IEJK1u++qp9bCV/+ufhrUggE
	 oz6us4sG2ebFDleJeUOeQV4eaBsgZON5KxeFkAWvVcc8KOohbq16xoQ5WXM8RM+VQPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033890;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iV9PjCUi5PKidAKbkk4szzLDkXlx2BqTbyK9Q/VWplk=;
	b=suhC7wsWcXeVDUSdkWTyRILl/caa3FHuc+Fb+MNZuZmu8/YgONZNWnmx/hqWsczvIZtZ
	 MZHXzPffKFjSeooMVOZaIPEeGrgXbVTGSakECTtGgqk59bYm6iayYtQiGtTO98cAImwcY
	 JRymARsWsmNPI9RKRlwGUrbpQHmk8F2+Bh/G1E8LxRWbT8VBA8jyhvCE53K0tGKJpGJfe
	 uyh4Mbl6qN/Wp0Oa3RCVCuzjrl5os/HIDTE3UrG/Ixz9QCfJAy4J504QPJrjwbqjN7eYz
	 N/OsjPhO+KHMh6lvgK38brRgu2DjjAedjg8vYgpN5K1EC8j/HsIggLV7YwTvBvusEFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KvAhwF6p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8350606A31C;
	Wed, 18 Nov 2026 20:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KvAhwF6p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472E41F000C4;
	Wed, 18 Nov 2026 20:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033889;
	bh=iV9PjCUi5PKidAKbkk4szzLDkXlx2BqTbyK9Q/VWplk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KvAhwF6phQBbb+cDI26dyPTz8ww6XyoUID3IsWEjv5y7puMR8c+OTbxfOBYGzfGiI
	 7y6pQhS33sSfss4rDrQWBoWY3J4/GZfrP6/E3rjuzmyCW3IYQ94CgKqBKZXoA7jdVN
	 e+BUbUsnyDrBJFHP2kL3dMSNR7kb/ibhFqyQE+ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Senjin <senjin@hatchling.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0176/3318] fs/ntfs3: fix lseek EINVAL on sparse/compressed files with 64-bit clusters
Date: Wed, 18 Nov 2026 15:13:18 +0100
Message-ID: <20261118150319.971259832@linuxfoundation.org>
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
index 3b7731b188302..59270aa34c007 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1123,7 +1123,7 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
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



