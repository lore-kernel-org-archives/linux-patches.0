Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052638;
	b=Guj2+siPtfNezgOu6Es6pyRAzOxQ/gM0EqFIiioV/N6N3DZB65AiAprVRBL+OzNyfIuH
	 vUyX3j5h7CjGAt3ByUKwyf+Wv1Np3mZYjSiv6k8r+wqiv+Pdcg/PdkPVWb9+ZIIRKY9LV
	 pJqzCmAk/c5uvp0DPkFLe9TwIM65eL26+X7NVbY/iGOXog/xLSj7gzr9ilv8ZOmvGh2rT
	 ENe1QUPeiMruD5jEc3azNpMbo5fXsbNEH/ylmt8P0FH9LF+QXcWvWQ1ys3bTkU/kTuLfD
	 Iw3WpWfk0NEECFhR6WmdonrkWYX362C6S5L01mqKyiZLEncgLzIApq2OYdv6mFXEsMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ghfuvYgqo/0PcgFskWTUWe1gBC91FCS8J+Q9aOfROkI=;
	b=3kdy189B1lKdXdk1hhwZMOcruxweBGspm2n9mXRU1zzZeSkdk7V2GoMPi1p/TPziG6R/
	 TJNyLNAbN9qMCc11QDHwkM8blscqkpO4yFC17BKOpvMUfpBTz+Qw3yV8frVwXydVaToyW
	 RSubRCsvBaTVGUJ61dR+PNOwa+Q2rX9RqPd7vZX4NWzVSmtQLwRTXMt2OAbJVwhvjxdBt
	 N5Pnswi/FbbB5oUCZR9EtwXQFPED6ywGlJQFGQx+ZGR71w1tPVV5UJ/SP0/SVlXX9+VtZ
	 /VXEgAar0WLHeLC8+NH2zA3nChyLgP5jJ1mh16B5RpW0GaiNSI/kBlbh9CTUutKAvVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LV7ugYz+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FF8606A320;
	Thu, 19 Nov 2026 01:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LV7ugYz+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D400E1F000C4;
	Thu, 19 Nov 2026 01:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052638;
	bh=ghfuvYgqo/0PcgFskWTUWe1gBC91FCS8J+Q9aOfROkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LV7ugYz+9tnS7kOqNbUjg9F2B4qjt802z2zWqc5R8JbeOtBRps49FRMponX+6+YZZ
	 nRt003GVBwWuFMfOaKqFJBKWJqhkOosS0hnNEHUgMeY7eUKY0ZHAy9u0az7Qvbhxe8
	 giWY6IZMnDZIHSKfuZUk59gaCEFdCAsyxrPT7/4U=
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
Subject: [PATCH 5.15 0628/2214] iomap: dont lose a fiemap iteration error when emitting the last extent
Date: Wed, 18 Nov 2026 15:38:24 +0100
Message-ID: <20261118150036.485933052@linuxfoundation.org>
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
index 66cf267c68ae4..89cc8f3306a5e 100644
--- a/fs/iomap/fiemap.c
+++ b/fs/iomap/fiemap.c
@@ -79,15 +79,15 @@ int iomap_fiemap(struct inode *inode, struct fiemap_extent_info *fi,
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



