Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052733;
	b=tOf9Vt6i4/j3VCEA0qM220BgrBCH88K0OWuZrxgVEvwRABd7t1Xc8+4cOPZF2fQvJHJ4
	 sOg+N7v/pxI71kZMBgHt0l0GrAlji+KwrrvYOIzjQ+FY/DwflEoziCkHPvdFMTpXYy2wn
	 w1DLDKI+IGPdOp2GraV9O877X8+N24br12cVG7F6j2UCFHGgMWkjjdBA5egIHch8SHK1+
	 5ODYwJiWEFIJ4B9Ti2xqGvAlIyPuFmMWmtE384W16o6lAslUXkiv7bw3Do33FgN0qRegO
	 V56KDsfZm2doU8lCwx3fRmNYRYJ0yamRbyRWpZ8RRmbYSHI5zgzB1Xz798PT8EHpXSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EVV9mBz92zFLt3Bw6eNChO7FZeWOY54xMP77ahbHrPQ=;
	b=Ocows+o/Fe/rTal5cIQcHLEMrKVr/ACntoe0pNUkhqegRXEhwZCtPiVtgjMThDw+CsSp
	 3Q6YM0cQmKq/5fEiUomC5a3/e2Rm35oavnU0H4yX63dn5sN9RCAXiSjiquML+nZrWcDfe
	 K5cFGeFfa8qGFWbrI8UQfDRi/3mXrGbOojyH8kD14jYzPHVM5/pono32H0AjVThlaKsZa
	 f/VMTYUZWedo21oIhrMQPw90sMZTjsF/AfJoLg35cxqom6AEWOucaBh2CsbA2kRAIykhB
	 nnfBPzH7j7zSJjaeQg72GVFfHGZIMHlqw63aU9m9MNFTmIegQ4ml8Q7RQ5oKiDlMvGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QnL3xib4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D221606A31C;
	Thu, 19 Nov 2026 01:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QnL3xib4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACE61F000C4;
	Thu, 19 Nov 2026 01:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052733;
	bh=EVV9mBz92zFLt3Bw6eNChO7FZeWOY54xMP77ahbHrPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QnL3xib4C9Z77HwqKNKopvIyA4jka8FSISaHMNMWtoZtQDgB52IWkq9NAhAg284Bo
	 433JftLKnpz4b/cpzxjNmLSFtWnh5vJ4cvrIH0Q8Lb9sFYA/F+yCnBqfuJzmZEUXTH
	 sWcSkn9FJoP4Bw5uyQQnGwsLBsBTcIP/+T4rVSvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Seongjae Jeong <jsjlee1020@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0667/2214] f2fs: fix submit accounting for IPU writeback
Date: Wed, 18 Nov 2026 15:39:03 +0100
Message-ID: <20261118150038.519608665@linuxfoundation.org>
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
index f070ec5995a92..01256ad3dfd39 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3631,6 +3631,7 @@ int f2fs_inplace_write_data(struct f2fs_io_info *fio)
 	else
 		err = f2fs_submit_page_bio(fio);
 	if (!err) {
+		fio->submitted = 1;
 		f2fs_update_device_state(fio->sbi, fio->ino,
 						fio->new_blkaddr, 1);
 		f2fs_update_iostat(fio->sbi, fio->io_type, F2FS_BLKSIZE);
-- 
2.53.0



