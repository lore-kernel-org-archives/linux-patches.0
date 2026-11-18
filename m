Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046419;
	b=YGTIOujVN2zEYq3jyHrZY7fNxIrwLKNNt0HH+Va7TpSuAVIRDyBZi3sa+jBK92exw6j+
	 x4c6eqXATpOoUZTBwInuoKF6QATFAdND20C5GagLDQxoa0dDCWZfrPffJ/Add7igAJUXy
	 BrDlhKmN7SzGQ2xDrBDJq1h6fM/MWrD8O4UeJ23cLo62hYfUjwd8gkxtIV7hv22ToW+Ef
	 XFmaGSdC1iG4Au825UjtyETj7rU0RcRS1oNAJIOk6rt+6Qp2y7t4IM456mZXLMGMhzc78
	 t9hM2fmH12jxKkVO/wxa4Hz22R6WGjicmROvHH7LjKNt3HDl3qZsSZssWI8xWZ4YEmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ANmepGEDwE+ntp3iFDZOuJsZtLcax4XoUsGU+7WU7B4=;
	b=bR/dlec+wwHntCEZJJPJhSxAfUW5+dYloiYK7hgsPrQkTq5V1m3OgGqZc399NJEL8RuB
	 ob03AkvLds+3sWNG4k96IyKB0fVukDRJP+kdeOiF4fHLfm4bmy6/z21dKtBWujoO573xT
	 Nbo7d1LcC2m9kzFTZv+yKXhiN4vhaVJLGoSLSvBzun9TEjFgf77z2h+OTVJQ89mQCyYtr
	 I+BxaP1YhlO9kEXh+khXbuFs1BEW84dlOwlmsAzZbg0AxyXU9v5A5WRdpVYdRPSLznHl9
	 xUW7+X0tvK7nCw4VEX5dYHRLnwls4xxOQHRirMbHy2/+K6b/F0SylL3Q5dsCknDDrVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qT2BflHk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A651E606A32A;
	Thu, 19 Nov 2026 00:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qT2BflHk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126221F000C4;
	Thu, 19 Nov 2026 00:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046419;
	bh=ANmepGEDwE+ntp3iFDZOuJsZtLcax4XoUsGU+7WU7B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qT2BflHkoJF0Thf6pmqUsE5JQpvz2xKvfzIrO121iMcWj1xRKtXmJsejMGBPPfnC0
	 2YFEad6HzNTMKzbzRCdAlFwOMrQrRi4bGStEqNWvZKM+03Gjshy1OvXg38+dNabEVG
	 N9ppwaUb19azv3MtPeLagn6EWeseIBwysZXeyTwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Daejun Park <daejun7.park@samsung.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1274/2857] xfs: cap the block count of xfs_iomap_write_direct() at one extent
Date: Wed, 18 Nov 2026 15:38:28 +0100
Message-ID: <20261118150247.388003322@linuxfoundation.org>
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

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit 66d1ce09ebd72709f8d739630c39f440445173fd ]

xfs_iomap_write_direct() reserves blocks for the whole count in an
unsigned int. For a pNFS layout the client chooses that count, and an
RW LAYOUTGET for 16 TiB wraps the reservation and shuts XFS down.

xfs_bmapi_write() maps at most XFS_MAX_BMBT_EXTLEN blocks here, so cap
the count at that. nfsd asks again for the rest. The other callers get
the same mapping as before.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Suggested-by: Christoph Hellwig <hch@lst.de>
Suggested-by: Pankaj Raghav <p.raghav@samsung.com>
Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_iomap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 28a1c19dfdb3a..f2542bac50c35 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -245,6 +245,14 @@ xfs_iomap_write_direct(
 
 	ASSERT(count_fsb > 0);
 
+	/*
+	 * xfs_bmapi_write() maps at most XFS_MAX_BMBT_EXTLEN blocks in one
+	 * mapping, so don't reserve blocks for more. A pNFS layout range
+	 * comes from a client, and its block count may not even fit the
+	 * 32-bit reservation. The caller maps the rest with a later call.
+	 */
+	count_fsb = min_t(xfs_filblks_t, count_fsb, XFS_MAX_BMBT_EXTLEN);
+
 	resaligned = xfs_aligned_fsb_count(offset_fsb, count_fsb,
 					   xfs_get_extsz_hint(ip));
 	if (unlikely(XFS_IS_REALTIME_INODE(ip))) {
-- 
2.53.0



