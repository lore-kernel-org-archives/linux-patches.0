Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045722;
	b=sK4blgWYRMG+bydoSjz7CXAFwBOztRbAXVUl4p+AKLv5HSPPjRPqWPvlffIaDUdrRkAr
	 03z9HtcxFkqMLzm0xBzfpZ/dKYFlU7uvPxPST1LE1oXfhiLlo5NeQ8gHAfjZ/8kjDE41n
	 XPJkDRmiYtyvIh1DVbn0ZvYkJp26cabwszfg4MrADhq2Uf9kEsXhvhsR/NuDEwet2Ux82
	 2cKnRoc7RN9pYaTYQs6pPKSuzqx1EcU2ofThwAjUNLcOacUuA/rE+cRWHk1/qh5ylTaqp
	 3GuJVMA1ajEl4SKkddfV11WZoiNjLkmcQ9RQIFiI1EXyd8gWeudjKLUluVgCsVUfE2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ClOHP2kcC4QtnND5yvLcT5fkcXVf3ZKkdZ22bYQ4cPY=;
	b=AmMw35rcCPj8Qg94/PSHSrnbG1/rrZlcZ5nJYeKxxksoFJRbGMs1o2JQmNVcgK84veq3
	 NHA2SkQVRzRekrxQ62mryi+jdFX5eHh6DPJsQIV1oQgl0gGJBqaI6q5mOjHQxRrbcZe+v
	 FlP6iyaDT2h5xVeqsxM760EylNOEKAPJt40lfcUTuCFARLLR54yRCTSGLSLp7h3aACj6D
	 K5aRP2cvCe3ca1AO4jFo9PrqL1TM36CqkAB2iIzvqv/RFr/ZEZOx8sAm26SWvRZpJuxos
	 E6T0CGb/yl3vViv/CX1TzyUmGrL2Vd+/xNO/rptQwl1rkVFoFzqnU/9Ke8c0/RStKVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oFOAKo21;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB96606A325;
	Wed, 18 Nov 2026 23:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oFOAKo21
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9074E1F000C4;
	Wed, 18 Nov 2026 23:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045722;
	bh=ClOHP2kcC4QtnND5yvLcT5fkcXVf3ZKkdZ22bYQ4cPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFOAKo21F3NZoDM7FXp4nE5FUaF5QxSdyNb02fQ26/0LeRUQTYreSe4PAnPekjhNl
	 wcYa/EY6hVE7VxsGontieTgSt5z0Wk6+S85FMbs94W0wSTtKQAbRtt6ChrGgSvnEAa
	 z+8Uz8NgoubHP7x5o5sWClz06gkUo+KvLgYJhCeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Seongjae Jeong <jsjlee1020@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0988/2857] f2fs: fix submit accounting for IPU writeback
Date: Wed, 18 Nov 2026 15:33:42 +0100
Message-ID: <20261118150237.176467619@linuxfoundation.org>
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

From: Seongjae Jeong <jsjlee1020@gmail.com>

[ Upstream commit 6d1f622b9c069378cdb83088be2b15a9b480b8a3 ]

f2fs_write_cache_pages() uses the submitted count, which is set to
fio.submitted in f2fs_write_single_data_page(), to update nwritten
and decrement wbc->nr_to_write.

In the OPU path, f2fs_submit_page_write() sets fio->submitted to 1.
However, in the IPU path, fio->submitted is never set and remains zero.
As a result, successful IPU writes are not accounted for.
This can cause asynchronous writeback to continue beyond its budget.

Set fio->submitted in f2fs_inplace_write_data() after a page is
successfully merged into a bio or submitted, so that successful
IPU writes are included in the writeback accounting.

Cc: stable@kernel.org
Fixes: d68f735b3bc9 ("f2fs: check io submission more precisely")
Signed-off-by: Seongjae Jeong <jsjlee1020@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 0d002abbec3e7..6f792ebe6f530 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3480,6 +3480,7 @@ int f2fs_inplace_write_data(struct f2fs_io_info *fio)
 	else
 		err = f2fs_submit_page_bio(fio);
 	if (!err) {
+		fio->submitted = 1;
 		f2fs_update_device_state(fio->sbi, fio->ino,
 						fio->new_blkaddr, 1);
 		f2fs_update_iostat(fio->sbi, fio->page->mapping->host,
-- 
2.53.0



