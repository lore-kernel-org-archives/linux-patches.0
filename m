Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045233;
	b=W7/eUHc2kjsfM7Wk3W8yldikc/wuCR0fOCXGXCsEWKS1+Csq72iu3sGwFLafqhpoMB9J
	 T/ltzK8iFeAa2RBVXHGMQa/2u+qvGUzq5qdJg/0tnX0oXEvgLGcyeulyCD9Zaes/K2iRk
	 jrlF1wk6JcmJ/jHvF3Fiy2rjYz0Om1r3wrcDSw4VoQmzNKo78nV2mYXf97Ncx+zWX0OjS
	 OpEgMGVpCSd2n6BD7N9aDnR+cYwPd4suUNIJLfXCu+j6u2rz5yE5Dhxmpvdh4pVuqw/49
	 LQV3bOUyF8osvaYworedm0HaGQ5gi9Mgkuwl8urHiKITGrqiKxax7FOYwcbB7wspz1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=00urwJCVbjBpwQpWcWiyVnkb8WwRAYNOHWdwCWvXY5g=;
	b=w6xNYbwRtzDHSY7/Qswk5p1ZRK2v6sYM04yuj7Ewixhr3sy1vmTHkSXv7r+5NG7s3IwG
	 vmVtEFT2AJ2cXvgYwu2Mj4dCiDimhZGcP1rROjnv+0KuCP5lsFy0+/NIv2rTIsj4/hfjN
	 ZuLMV5l0NRlrQhIDaNNyvVR1Wg+jlEQQGnB//iZ972Xjk6pTA7gaZ16tuYygdwgjdL8xD
	 qfn7YxsKYalDLqsi4Re05WEfPA4TU4Z5+QYFmD8sjrH2ol+XLT+8ytLQxJodIDa1I4Xly
	 UaGn/qN01f1d/sPCfcLtD7WT5OeIppqFj2jdVQgYnrSc/VsoM5IsBLE8YsbCsGkCgrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Np1a2TKT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206DB606A31C;
	Wed, 18 Nov 2026 23:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Np1a2TKT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DAC1F000C4;
	Wed, 18 Nov 2026 23:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045233;
	bh=00urwJCVbjBpwQpWcWiyVnkb8WwRAYNOHWdwCWvXY5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Np1a2TKTXK49UH7iKcH0GVtUo4ELIwLQpcE1rYqC1qDxb0c3aI9uZNseDDVMEG6NI
	 mR84y9mSB301AMpJsDMK05gkL39CTbvWMUM3J6cA01M1+ToYFS+84ME3m5/ePcTSHD
	 84WRO6zzmgg5PXJi8l8jIcatb0gBlMTV/KkLUqGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0851/2857] dm: fix a bug in dm_accept_partial_bio
Date: Wed, 18 Nov 2026 15:31:25 +0100
Message-ID: <20261118150232.211193939@linuxfoundation.org>
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

[ Upstream commit a279804752e6c767b7f9ecbb32a15bdfd2b80aea ]

dm-writecache doesn't work in pmem mode - mkfs.ext4 and the following
fsck.ext4 fail with data corruption reported.

The commit 7dd76d1feec7 ("dm: improve bio splitting and associated IO
accounting") introduced a latent bug in dm_accept_partial_bio - it set
tio->io->sectors = n_sectors;. This is incorrect, according to the
diagram in the source code at dm_accept_partial_bio, it should be the
size of regions 1+2, not the region 2 alone.

The latent bug become real bug with the commit 8b211aaccb91 ("dm: add two
stage requeue mechanism").

dm-writecache in pmem mode is the only target that actually advances bio
with bio_advance and then calls dm_accept_partial_bio (so, the region 1
is non-empty). All the other targets call dm_accept_partial_bio with
region 1 empty, so bug went unnoticed for so long.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 8b211aaccb91 ("dm: add two stage requeue mechanism")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 53acb28f86338..0af19f3116108 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1328,7 +1328,7 @@ void dm_accept_partial_bio(struct bio *bio, unsigned int n_sectors)
 	 * for accounting but it is being reduced so update accordingly.
 	 */
 	dm_io_set_flag(io, DM_IO_WAS_SPLIT);
-	io->sectors = n_sectors;
+	io->sectors = *tio->len_ptr;
 	io->sector_offset = bio_sectors(io->orig_bio);
 }
 EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
-- 
2.53.0



