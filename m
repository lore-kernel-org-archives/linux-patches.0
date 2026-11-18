Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016081;
	b=1zpVOZhWFaT/WX+2vPDXJjXdnqiMVyS3ygh2/OKUFzlaVbbFughUErTI1Cz4arWfiE1n
	 Vt7S+4K+YRlN4PtdaxnQ7JA+uojb7KBW/1A2lMCyPt5GskNFIkx2xQSE7vzkIYH5SHl+x
	 yLB49H6vdfXM7lLmYmtj+6cfFQ8reXhv6x/NI51P38JTMZzJgXmRMywZJLblQge4J7FgS
	 waeFlx7dPgR7MH3IIf+3kXqUkvKDqoBDvacr+/ciCCUN8LuY++cNmKRbDE9w1Jcs3ZXVs
	 1UpRtfUAVUwfW/5tqVitw0mNUIZeNE+mtfgGU8y49V/uje+AbQKif5UMkqGznaJkYHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X9JOqHu3rlQKIK6+Ktu2yjPhAfBRLSgwhLcg6pgU9AM=;
	b=a6FiFb4WFjftC6hWnxTZixqKeZKhrk1YiXHGq6nCxxaB1tQKJBJ4sdC7Y2rtAuuK85eH
	 3sh7VHI10OOMcS+lCKfWBHDtLqnmyAqRzzV9CcVMLP34mUbPkER9eDpqyuF134Q+IsZaW
	 dOTHSbK5ynCrfrQei4ldCsXnzFa56f95aW0i21EgPMc+TNCnbiDruxqpFD60lSE6hituu
	 jIoAcUjDgjFdgAyY4dQRwX1tfPdTfZkPKYxAcu7v2+H4OrzGQLl8OJZeVcZ6ItbJ9tPyI
	 2Tax/Q9fGxIv8R1/1IG9fmnXB9Hlx8dsjl1VtXEdDcC5ZijKY8XwS57OPue8aqdkrDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dR/Z1rFo";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F220606A331;
	Wed, 18 Nov 2026 15:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dR/Z1rFo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5AF91F000C4;
	Wed, 18 Nov 2026 15:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016081;
	bh=X9JOqHu3rlQKIK6+Ktu2yjPhAfBRLSgwhLcg6pgU9AM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dR/Z1rFofVuMRITs5dGsKjGz2k/5bmnk9orspqsmvf0CqyTYCbV0MKatCI6Y6winr
	 1Ir8xtVAQG2uB40hmNu+A3bAbXzZuZUNL0jU2YuPmOUOlXgV4VqblDxeg3T7XMusOe
	 TmCaM5ZdXU9TT+xSckwieuR8bXYPRcqjx8ttJiN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0402/2651] block: improve aligning down bios in bio_iov_iter_bounce_write
Date: Wed, 18 Nov 2026 15:27:22 +0100
Message-ID: <20261118150302.308898214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 9dd2351aef70512373f79ace94097a32e5ed0f70 ]

Sashiko complained about bio_iov_iter_align_down potentially dropping
bvecs, and thus losing bounce folios.  While losing bio_vecs is real,
bio_iov_iter_bounce_write allocates all segments and thus the entire bio
in multiples of the minsize, thus making the rounding down redundant.

Replace it with a safety rounding down of this_len in case something odd
happens to the greedy folio allocation helper.

Fixes: e7b8b3c5b2a6 ("block: align down bounces bios")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <mkp@kernel.org>
Link: https://patch.msgid.link/20260907074111.721054-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 90104e6abbcf2..0f1aa1d6c638a 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1392,6 +1392,14 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
 		folio = folio_alloc_greedy(GFP_KERNEL, &this_len, minsize);
 		if (!folio)
 			break;
+
+		/*
+		 * Align down the size to the minimum alignment.  In practice
+		 * this should not happen as minsize is expected to be a power
+		 * of two, as is the allocation size, but it offers us a cheap
+		 * extra safety belt.
+		 */
+		this_len &= ~(minsize - 1);
 		bio_add_folio_nofail(bio, folio, this_len, 0);
 
 		if (iter->nofault)
@@ -1419,8 +1427,7 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
 
 	if (!bio->bi_iter.bi_size)
 		return -ENOMEM;
-	return bio_iov_iter_align_down(bio, iter,
-			&bio->bi_io_vec[bio->bi_vcnt - 1], minsize - 1);
+	return 0;
 }
 
 static int bio_iov_iter_bounce_read(struct bio *bio, struct iov_iter *iter,
-- 
2.53.0



