Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065090;
	b=dD20p5H4I584dOwQk58yLpCW1xAUKqWtGRqZvVuDOkbqmPLhdQ2AKIOc9ofXSV//89Jy
	 6ytbIpPKT5EJOrPuoyE1nwk+AGvYnVPw92mcw3gqgR4CUSlx8hRZ1SEkFKNNkiYQaRyjs
	 qQVr5BlMT2mwSOGwWmdD3/MqwX/ac/G7LsUKNaHOYj5lse+zt+YFBIAS36MmQhDmrT4KR
	 W6TroirYjCEVvGHBLovUeTntm1X8qECPjPUaHzP1QVPfE1MTjdoBnOA/8ORwtmidB4/We
	 6j+6GhBYLPGY5RkKPCc/szmDR11yULvtk7n2tWn4XNlxwpv8S3xTjWGPzGY+9dZrGig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XX2EZ/k8zxhZWfqw7sUSAFV1rZn8NQTaikqqvMS8ptc=;
	b=GL3gku6FLqn6a1xiMuLSfp3UGAv+m0TzO1PtMhY1z59xxVeVFA2+XyTuDdaQMSNO3z5/
	 bvPvDHjrgRrTAg52Fz1aKD2yRfS/YWxf1GmW8M9UYWgwm2FcUnar7O2u5Yhohm1npNLyE
	 YjOkMozqFl/sxfC33MEE0F4XTTKENf4kAlJa0qmpVQKmJkhc+RG+/isEKRaoIeqJgL5hA
	 jro4w8TViEehG42CBVXI6MxiGOnlE1qVjGF8wjnSxeKysszxB5atFhabq/xl6k70SI+g0
	 EABdiF1Pxwy0ETHzqBR/9y4w/w0ntXU92Y66ncpk/lIgR1zpzyWX1ALqAISQvw2ldTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OLZFiIS9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9873606A32D;
	Sat,  7 Nov 2026 15:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OLZFiIS9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25CCA1F0089F;
	Sat,  7 Nov 2026 15:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065089;
	bh=XX2EZ/k8zxhZWfqw7sUSAFV1rZn8NQTaikqqvMS8ptc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OLZFiIS9NGdJ7aJfW+XYD1xwLpwi3lGqYSS7DaCo2rOubStk70krbYQe/hg9I/85z
	 Bc0lrTe91ZlRfQn2cEpOMaWs05dMGzh3PjltXoBFGuFpnuwFjqrZNtjT+v3mkRMAIC
	 Aao9K3tFWLStf2rso4rrui5dYRhFmDUoEUCcoEpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Seongjae Jeong <jsjlee1020@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0884/1257] f2fs: fix submit accounting for IPU writeback
Date: Sat,  7 Nov 2026 08:53:00 -0500
Message-ID: <20261107135003.734557506@linuxfoundation.org>
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
index 118e7edb600c1..381b0a9875946 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -4268,6 +4268,7 @@ int f2fs_inplace_write_data(struct f2fs_io_info *fio)
 	else
 		err = f2fs_submit_page_bio(fio);
 	if (!err) {
+		fio->submitted = 1;
 		f2fs_update_device_state(fio->sbi, fio->ino,
 						fio->new_blkaddr, 1);
 		f2fs_update_iostat(fio->sbi, fio_inode(fio),
-- 
2.53.0



