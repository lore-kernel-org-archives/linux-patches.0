Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043375;
	b=K8uOvd3gEoc8P0HJzfH6X1nAU8h696uSRyW3N9h1ZNFcq0TTDUkQVS6cSYRfdIKEzshj
	 0fJ61IuUH08673hK+ntuvQCz9cH/oT3rGAN0gLT/3PAgbzBObjLf2aHym4WeadefmRPgT
	 +CkT18tLjRT4Fp/kIz4D9OmXN9tUAIBy90tiHOjhndR5w98m8TF2pvQO0aaJx4HdmdL1l
	 6ptiEV4RvwZi9M9MHIUCzLjlzXUxd/7WzXGDL1jdSc6Jiokc86nFt7kDzoXwCzphgsw70
	 ApKkJTKusRIjd+PprQFcJfvbfQtvZvBuN3peaXZVuc85fD9onGaf6AOo6UGyBo1aAzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jNCedxcKklL6hghn7fgvh+Sn00wKaAFpxnjvgJBoiz8=;
	b=nparnv+nxnxCuqfTkM//OOUxcwryP2n3B3+Dj8MvfL+bh6Tz0oENi/2r4MGa6TUnPPs0
	 sQQheRIGfaf6nw1EppjRuOQvP7lE5yvPzsXiEsB3jstoyGTzLsAbAHLTc/mrD0MY4YYik
	 ThNUREmMUCRuFYIXrecTJM9PXhHXFE+0xgcWC+OhHr8/fHV/m8cef99+3gZawx0Vgtqw9
	 JNW60us42ha4M3iLU0YzYNbANFNXAxf2/zUzsQuS/ueHCbd11aVG5bovlxHTeFb+GtAOp
	 xYO+8yd55XKLiO0CkFwk9t34tWScQLrTUc4TzAmn8Zf+DSqvluBybBdMOQ8q8YnMLPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2cepD47x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2EA606A31C;
	Wed, 18 Nov 2026 23:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2cepD47x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA0D1F000C4;
	Wed, 18 Nov 2026 23:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043374;
	bh=jNCedxcKklL6hghn7fgvh+Sn00wKaAFpxnjvgJBoiz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2cepD47xfzf3VzP0cHqrP3ti+nvG3HcQ+Y1zmesjeInXAFxH/arYZTA/VVjWduKl7
	 PEkmHzOdeVCS/fBrHqEXdOxqNed9bd70SnnszP0Fj/OgbPBzJ6VNgX/nuYBJvDJrEa
	 vGsWm9l45C3nG88AYI573agsS3pb0wWsLn8HIRYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Senjin <senjin@hatchling.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0151/2857] fs/ntfs3: fix lseek EINVAL on sparse/compressed files with 64-bit clusters
Date: Wed, 18 Nov 2026 15:19:45 +0100
Message-ID: <20261118150206.779950498@linuxfoundation.org>
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
index 9bf327a7cc7b9..dcc71541f207f 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -905,7 +905,7 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
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



