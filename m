Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045483;
	b=tbPERmh0IxQ2DMO1jkb7mZVUBLbO+Qm2GJLjEFKf+jTK87LRuiMSPEfKN2IwtFiGioAQ
	 fRC395ds6Nn3aYhw1TX+9RTt66jAWXM5CCfVpNfVnGzN5Ot2r3ZQd3zym954qgem5V4D0
	 kidRuBONGOT9e7GfagezTbYvzpQdEDtppjDWudEOIGsCES083VPdX4K1QwxlMeX1Gkpmd
	 p8xl/AMWC8fuj4m4/n0vj0cuKqKmPg6bsPSUffgh8myWRSeOB+NXogOGdfEaZ+p/9KNlS
	 ysD5NQq932oAVcxw6LJ2kJ5keqZSKyBQJnYdUn5pPgacYjIYHxU5eAz3PVnCwhYBcUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ac8GaW5YAtk5vfWXq3CSG1lGMNMwIcEkAQSx5c041cE=;
	b=Klp+HTwXfI0FogkECpUEeZi8LDxF5IvX3iQlBSpjcSzYfLkkjv4FYr4u3v+G6w+EtJ+o
	 svmSB405tO0gkaZ+K2cw1y/KPxDCEKg2W4zQr7VtfYXECKEKNtqpBNhPFw8N+LyOga7nU
	 3Xj5j8TMZ0BUPrb8S30i9xiPbZ9qBVQM9YumNUrYJ/or4kfKb/U2DGp6RCYl0/CdEJlId
	 mEeXnXq5++fapHfETiIxt1ievUa9bBMWJx5a8vggaeuP3pdVbBRSz1y935w7Aa/oSEwTa
	 93efyU+TSbfJa78ZzktI5DVGE+yNZqitYTMvLZfNx+RzWbe2/C5us2Si88AkeUpKrrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Saj2x8gh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3750606A31C;
	Wed, 18 Nov 2026 23:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Saj2x8gh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027961F000C4;
	Wed, 18 Nov 2026 23:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045483;
	bh=Ac8GaW5YAtk5vfWXq3CSG1lGMNMwIcEkAQSx5c041cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Saj2x8ghvfbBMswjhK1QoyEj67RSKLemW0Wn6A20LV90Gtjb0upPIiMeFIyT9zGx/
	 yKgZtPTQyJT7sE+Z+KDLwFmCKC0GypNXzdZy1L4NzMB4Bk34lg6KcJJ/1ZDMy2WYvz
	 lVPqWvNBbA0Hve4RZikNoveN9t/mH2Umdi2sLymg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Andrea Parri <parri.andrea@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0937/2857] iomap: dont lose a fiemap iteration error when emitting the last extent
Date: Wed, 18 Nov 2026 15:32:51 +0100
Message-ID: <20261118150235.338722754@linuxfoundation.org>
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

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 0d0104adc2c8316433b660cdf6d182a09881864f ]

iomap_fiemap() emits extents one behind: iomap_fiemap_iter() flushes the
previous extent and remembers the current one, and the remembered extent
is written with FIEMAP_EXTENT_LAST after the iteration loop.

That final flush overwrites ret, so when ->iomap_begin() fails partway
through the iteration the error is replaced by the result of
iomap_to_fiemap() (zero on success) and iomap_fiemap() returns success
with a truncated extent list whose last entry is wrongly marked as the
last extent in the file.  The pre-iomap_iter code returned the error
from inside the loop, before flushing the pending extent.

Check for the iteration error before flushing the pending extent, so
that real errors are propagated and only a successful iteration emits
the final FIEMAP_EXTENT_LAST extent.  -ENOENT (no mapping) is still not
an error, and the pending extent is still emitted in that case.

Fixes: 7892386d3571 ("iomap: switch iomap_fiemap to use iomap_iter")
Cc: stable@vger.kernel.org # v5.15
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Link: https://patch.msgid.link/250226e33b3b23c6b1714a45dc3c465c2a45cdc0.1790342457.git.parri.andrea@gmail.com
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/fiemap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/iomap/fiemap.c b/fs/iomap/fiemap.c
index 610ca6f1ec9b6..1cf49bac25011 100644
--- a/fs/iomap/fiemap.c
+++ b/fs/iomap/fiemap.c
@@ -80,15 +80,15 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
 	while ((ret = iomap_iter(&iter, ops)) > 0)
 		iter.processed = iomap_fiemap_iter(&iter, fi, &prev);
 
+	/* inode with no (attribute) mapping will give ENOENT */
+	if (ret < 0 && ret != -ENOENT)
+		return ret;
+
 	if (prev.type != IOMAP_HOLE) {
 		ret = iomap_to_fiemap(fi, &prev, FIEMAP_EXTENT_LAST);
 		if (ret < 0)
 			return ret;
 	}
-
-	/* inode with no (attribute) mapping will give ENOENT */
-	if (ret < 0 && ret != -ENOENT)
-		return ret;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(iomap_fiemap);
-- 
2.53.0



