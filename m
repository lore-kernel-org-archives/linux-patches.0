Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060816;
	b=e3DYkWDJ+rAz+v26IyUEUi2TWzoKnEfRtl6VX/ZiNfEMMqHCAVJBRtSZoPreGKzEkGKu
	 aQedB48Cb16h5FmA5y5trlyB7IJn7LNVe+6wf2e10radL7g1Qaa7mdVk8nLQhWy1PPwn+
	 6oHgYOQ8arWAQODHi14zXVdtSrnqqt1EBfdChOkKLZBGZY+Z8pBvV8sW4j5xN+5SduqhR
	 nw351mQCIqcmxjk4LnnTbQkKW76Ofn6hq2/cToX0LwFjICVU/apoC+Yo653YLqZG6zN5l
	 iNkJeIMX/lVwvPHjxXS3opQKjErhAF8hv8OPq9fLor5S94hCOMIgS5IbvD+U2n1BUtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ciA2OXb6Qz4VuRIuJA+2SplQ0kGGcyIKuSmn0RGKr60=;
	b=2NFTbNa3KdvlShJK9k/AJ8iOtbyNFL3z9dkAlqXIBr8P9SRDuriE81S9kB1Mj9ojbnWn
	 J+5VcmJZCi1m5oOJa2j2NsmL9egcsXK5TlildaEb9RwXtnXvfmuNAWy4wa7cVVv0lS8ZJ
	 +zJmKJONEUZxVaWlW0nCSc6f+Y3kQQZ6pz2/bCl2QcMp6r67HjLoO1s0uCx8pmGc1oDYA
	 AC1DSM4blj94VE8I556GogH3x/pnoPLQwHBKEHBvXhPNkIQ/ajD41Lp4kSO/RBiB2tUWa
	 ZVhJQEY4y9U6dEi67I6q/aRVx/eWHLbcN/ob35z6e2yo5QOgjOcwXvC/pOhlabSzF5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JsKUmKev;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF22606A326;
	Sat,  7 Nov 2026 14:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JsKUmKev
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6699E1F0089F;
	Sat,  7 Nov 2026 14:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060815;
	bh=ciA2OXb6Qz4VuRIuJA+2SplQ0kGGcyIKuSmn0RGKr60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JsKUmKevj+aZiATc2xbJLq0Vv1d2ks+UvN/c0HWfZOMLD30dGml3qFbKqPJjPjIP5
	 dmBXt0JZ+/ozHgXFQKJJB1MaEtmZfIZXZRYNOdQ17EwMTAXbnm9wzayIFr7SNy9vYG
	 +KkUxLh8houGZg/Q4IjV1nWyGb1ibz1DHvF/AR4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Senjin <senjin@hatchling.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0206/1536] fs/ntfs3: fix lseek EINVAL on sparse/compressed files with 64-bit clusters
Date: Sat,  7 Nov 2026 08:37:02 -0500
Message-ID: <20261107135003.442276042@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index c7c1896acc2c5..8f30670a56237 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1130,7 +1130,7 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
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



