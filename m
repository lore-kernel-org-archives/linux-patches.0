Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053027;
	b=h5nlFeyQkvCiUlRlVk49AOHIEhqxvJ+Uy2rqp/BkjlogoQmahHrxbNk8RLkH7I/eNcnG
	 ZofP2SsUw26D7xQUF8jk8TQKgQv8vcrhzAqx5J1LHsXBlQx14N+kvRUKFJA3JL6rW1VwO
	 xY7CI0DfsPcr7SBAVSKTImuXGuE/9nuVR/n52rUz3iCLmsXKBh7MQJmo9vD4xDdQii/t+
	 h7xJyCiNkvLOQCPR9Xnr08YFcPqb3HQp5l6peaPr5mdAQEFoelQRm02MnB647TnxRsUeX
	 MKv7v8iEKemsgL9yZfFxk94KX6c7K27yTXqznD8Y0uOBvspWbrYOFnZ6tA0Qg2TBB0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=38XQbdMv6JY9uopZHtZY0ZQRfibgz59MrMb6DPThS8w=;
	b=FBmXS+iTz6tTqvMu5P43wMryN9LqKigrN5BK7NsRJUEyKhyFQ5FSp8vtClS/P+ZmBB2L
	 jjBTOYh/2aF7XvsiIU18OqiCfxoUY89NbU5T+tbhMbhwV3AUIlt1aSxeDDJGuwcOhlKVd
	 SzqelfcvAInDRaTMw8SEVAY0VFmfpimQTriDmVlvB0uHpzfdVz2Vqbvct16TK2jzf7ZWm
	 LafaXAChOAetImcjww5p094S+PsqAZTKSqy9mpRIh+HaNC7ruF0nQXyChEolAUUd9LgX7
	 BJbfALRFlQUAY7YEGDR/YTQOsuqCwavt++pu28uH8TPHH/2XL83S9tHgRhMxZtsJbLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uAZ8O6cq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B783606A31C;
	Thu, 19 Nov 2026 01:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uAZ8O6cq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3191F000C5;
	Thu, 19 Nov 2026 01:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053026;
	bh=38XQbdMv6JY9uopZHtZY0ZQRfibgz59MrMb6DPThS8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uAZ8O6cq3Kr5NXJmHR3H90L17uNzQToEEcFAbSTHx4Sw/mvi9869FO8pALFSVBAoA
	 ahPFHh12TABKeVX8/0hlS9RUGW2GybvasO6Uv/ngf8+1dZqjtfaaejzoTBEtNvrDSe
	 6mj+CZvfr7wF4IowBL1SP+VJRaqHvwo56ThRIuF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0736/2214] ntfs3: fix mapping pairs bounds check for alignment
Date: Wed, 18 Nov 2026 15:40:12 +0100
Message-ID: <20261118150041.270102978@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit f517cae6333121783043d9ba5142b50f5d1cf75b ]

In the UpdateMappingPairs action, the expansion check compares the
unaligned new attribute size with the available record space. The new
size is aligned to an 8-byte boundary before the mapping pairs are
updated, so the check can underestimate the required space by up to
seven bytes.

Use the aligned size in the expansion check to ensure that the
subsequent update cannot exceed the available record space.

Fixes: b46acd6a6a62 ("fs/ntfs3: Add NTFS journal")
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fslog.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 7146cef2963a6..f3a4adf28c72f 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -3441,7 +3441,8 @@ static int do_action(struct ntfs_log *log, struct OPEN_ATTR_ENRTY *oe,
 
 		if (!check_if_attr(rec, lrh) || !attr->non_res ||
 		    aoff < le16_to_cpu(attr->nres.run_off) || aoff > asize ||
-		    (nsize > asize && nsize - asize > record_size - used)) {
+		    (nsize > asize &&
+		     ALIGN(nsize, 8) - asize > record_size - used)) {
 			goto dirty_vol;
 		}
 
-- 
2.53.0



