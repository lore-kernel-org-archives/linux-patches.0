Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064333;
	b=xDYkmur2aYUI5x+d8YRkG3HmToB8tgLl36M4UkjRhg9+iQ4klkeUbSD8ZHmGIclLLN87
	 BVt9SOAVyTqCprF4W4PQmoa0auOTLuMVKivnfC7HDA5Ifnc4eu8qeBjCaNzV35nD6GfUi
	 Uk6sAg6gA3HlcMm30fsqXhTMtRtL3+zpc4Ga3Fb+RgkS5AS1m0nmwh23gHP9DvfR1qHte
	 Skz4UTtN/vphEEQUFN4AYjBXI2cLUCL6ZUz3/RkyDA26nn7NaP+9z+AiNKm8r2WiAGMIT
	 BIkmPeh/coqyXY1vej37A3MuH2qnLPEGPEPzBl8qJipo6GrvF4TOkBLdI0DEVlBu+hQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hal+IcfDvZylkfW1bmi9WzSFQFxuGI95KExG5MEXKOE=;
	b=DB5VSeKW14Zno7WmzuoMpV5Hql6KCTyFXe9/EXliaJHi2sQNL2DrciW9IA9Iy8c6WGH7
	 +T0k5pTz1xUmCIydUdZBG4/6U+BNFWd7DiafU4TQw0COeSRvw8ASlOORj3nU4TNiKhsRp
	 fYwyqVRWlJ4CqSkKfcDtQRazWajBkgMf0U9crpFUDgmOq4C3EviJb8LxuZ2doiM9NwjCH
	 RoIrCkjhYlYhF5H3Wk3qf90W1yXn5Y7s4oIxDvCwUcer+rekKPdPxLPMc1SpCUHaiUQFI
	 fhfYUPOLev/MdyKuQJfIICavPTVfJDmmu2YDDFo9zHW8phza8l1B0DG+2Vb7uJFJxrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cvMCy4Rx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A933F606A336;
	Sat,  7 Nov 2026 15:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cvMCy4Rx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5648F1F0089F;
	Sat,  7 Nov 2026 15:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064332;
	bh=hal+IcfDvZylkfW1bmi9WzSFQFxuGI95KExG5MEXKOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cvMCy4Rx3aDrU73F5PF5tryOpoVPpGnmv0W55quLbFmPI5H4mI+i/UkwO0hQgIn2U
	 keBkzb7iNyYgMcAc9DoOC0KQxEXy9Gc3QgABmCtQxeSZcLladGs5f5ULeyalA3H/yP
	 xUCFfgqWpKXS/HUku8cXy8lP6u0jfXuYUq/6at3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0417/1257] dm-writecache: report I/O error if flush failed
Date: Sat,  7 Nov 2026 08:45:13 -0500
Message-ID: <20261107134951.026386465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 78a6afc2999d26e5a30a56db77db34c22b88f5d5 ]

There was a bug that if writecache_flush fails due to I/O error, the
error is not reported in the FUA bio. This commit fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: opencode:big-pickle
Cc: stable@vger.kernel.org
Fixes: 48debafe4f2f ("dm: add writecache target")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-writecache.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 978646f71f996..5804cbc62a511 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1493,10 +1493,13 @@ static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio
 		}
 	} while (bio->bi_iter.bi_size);
 
-	if (unlikely(bio->bi_opf & REQ_FUA || wc->uncommitted_blocks >= wc->autocommit_blocks))
+	if (unlikely(bio->bi_opf & REQ_FUA || wc->uncommitted_blocks >= wc->autocommit_blocks)) {
 		writecache_flush(wc);
-	else
+		if (writecache_has_error(wc))
+			bio->bi_status = BLK_STS_IOERR;
+	} else {
 		writecache_schedule_autocommit(wc);
+	}
 
 	return WC_MAP_SUBMIT;
 }
-- 
2.53.0



