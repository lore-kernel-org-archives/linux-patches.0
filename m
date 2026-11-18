Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045236;
	b=qNaG4zv290yNcjflHe851nTSTCQ80Y9C/KFU4yoNXcz2/P6LklcLK5AvQ9stTHOhqg7v
	 xH9Szk7bh848UI+KAdPj/NozKYgOGWO65lqpZgVkZWw3Y+TYzSLRUyEUEJJ3+PJ17F5AN
	 bRr8/Xu8i1LAAKtyTqWCWAXqPjKfRUIbr6l0DpG+lvxxk4UAKURmuVi0JEn2n33dzRsox
	 H4MoLseeFRzDFFoqYjvcmQKXni96mtwPJgTrR5iejr4Oaaj8qBvUmGQj32VG8rD9KNUO8
	 9EUWv1K+TkVUxBhcXA3zDQ4Ov3vrp0qhQBdqgWHIlT64I72UJLg7ZmUE28V+Ia+2uSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RtPF7VCwgpMkklb+BRFiGj2eGNuAItN8gaNmDcQdUA0=;
	b=4JaeEcb7xXiHCBwrRX+8wTnTtEm6AjlyLyBwTKgdfgLgf6kg+PWhyiNBsDBJ6Ymu6Oa3
	 3lM+IhhETEZMtrQc8qvhBAfymomlLiEpGoDBcwK6o7QrQV9S5ZYwp/Abe5Lb1woiVrioH
	 H9I9N4XwRVhfDsWl+khN0uflAxmeBlPdiDhy6rwN2elWrgot1E+0ShYpXImBDMeL6fgmp
	 B+o6rVTOU24E7qnkhenUDRJYTBgEkT6pdIGgCR7s3vZcy0W36MhYpR/oxuCwXP0tNbGl8
	 LMxOy8c288fd1H6x1QRN6+Z2eDtM3N6bm3x0jDhYWjCqQdj4g11YRgLRtwGkTGK1ktg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ft+yEe0X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D22606A31C;
	Wed, 18 Nov 2026 23:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ft+yEe0X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490A61F000C4;
	Wed, 18 Nov 2026 23:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045235;
	bh=RtPF7VCwgpMkklb+BRFiGj2eGNuAItN8gaNmDcQdUA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ft+yEe0Xbc68Xqf2UyX2HWnNlKQCfna8grBjZQoT33H5SSukE7iB+Hd9IO7FUP7Gr
	 hvfLLR2Xr91YsrzHF5oERBXDadWPpmqmS+fX4TbCi2vo58xcBCWswmvmwT3UWfY+xh
	 e9BTRJn7/FxgHl4k19i5FHOs3GW1tZ1rswKv2Q60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0852/2857] dm-writecache: report I/O error if flush failed
Date: Wed, 18 Nov 2026 15:31:26 +0100
Message-ID: <20261118150232.246103772@linuxfoundation.org>
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
index adda032579b9a..0d642b6d953ff 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -1492,10 +1492,13 @@ static enum wc_map_op writecache_map_write(struct dm_writecache *wc, struct bio
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



