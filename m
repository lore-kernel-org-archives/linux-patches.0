Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021215;
	b=153WGOqu+qvi3e1B4DKdOkvpmGGIWNPuIeXTzWNTHF/WRhQdEnOKuB1I/RrfymrJC/Gm
	 aOhuF6fr3V9Lpqv2bbbDRZeWiHSeQ/8TgAxbAudz4JAcg69M5uc3b/ivmQgu3dgnvNJN6
	 5Tret3qNLGONuyl3f/BqpOO63iCZWPkLSxcGwFN5nz9c3vOmpgrerNTX1HLU1HmxCDz/o
	 rLfBTZOHB9YL1dcw1oDxp9dj/o8VIINCm3xNbO/cfUwPd7VmKBwfJBeRHWCCAkBta+ger
	 DqbgMCpKjpQXJkBsG5tWEnSX3Uy48hIULqf/7RmPOUq3iMbNDpJEqq2Jdt2mD4EhkaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021215;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CnzUAfezoj9GKcryLrdm3/vuhZ/tKxgib8B2/gD8TrI=;
	b=tOzE7LKQsytIYC1bi71SBuMCslZ16c6WUAdMJ2zyCoXy4pyK0pahug2oaQXS1G3x9LGX
	 qg165AO712eBhI5PGTmiiHgXgtW+UuYy8EonQsVw9zbxiR7Vrlq+Li3WjKaol3UIk33ny
	 rBf5TqiUvtyz6EoDvRcSE2fzH6aw9x32txQP5o6mcZw7jwHPtdV05EcF3hCG4ZsTIDl4n
	 AQwwjMuTJOQ1SmCkcE/2C2QxMUJ+xtEozgr/yrP0SzDk6wJbVSmgmG76M6TAp2zEDjTfh
	 KXWfXBhBCOGoWRJJ+l4i4t0SMH0+L3qoTKKhmQ0kpTC3eydlfGJWOo89SOHIm4txWbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4gjERzZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C7B606A320;
	Wed, 18 Nov 2026 17:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4gjERzZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97041F000C4;
	Wed, 18 Nov 2026 17:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021214;
	bh=CnzUAfezoj9GKcryLrdm3/vuhZ/tKxgib8B2/gD8TrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u4gjERzZCZfhZm+Rzgkt84XRoY2236dicrHJgvNAQ6iRiyi+g0KVrZTqUCng7fJuQ
	 nBHApXBU/MO0mn47O0CJAAr1pjvQvsWLemC3GXq9JUJZNytGAIWGfmL35Ff9V0HJ2b
	 ob+3XK04qYCZQr1cOZp8fElPY2fFDMAgo+J1x5C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2225/2651] ntfs: reject direct I/O reads of encrypted files
Date: Wed, 18 Nov 2026 15:57:45 +0100
Message-ID: <20261118150405.662475952@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

[ Upstream commit b08619bf3c213cd5605d72b363dd3000663c35c1 ]

ntfs_file_read_iter() refuses direct I/O for compressed and WOF
compressed attributes but lets encrypted ones reach iomap_dio_rw().
ntfs_read_iomap_begin_non_resident() has no NInoEncrypted() test, so it
reports IOMAP_MAPPED for the attribute's real clusters and the raw
on-disk ciphertext is copied to the caller.  Buffered reads are refused
by ntfs_read_folio(), but direct I/O never calls it.

Fixes: 9c87959601e8 ("ntfs: update file operations")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index acfce7670248d..dd98cb3ac5e5c 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -475,8 +475,8 @@ static ssize_t ntfs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	if (NVolShutdown(NTFS_SB(sb)))
 		return -EIO;
 
-	if ((NInoCompressed(NTFS_I(vi)) || NInoWofCompressed(NTFS_I(vi))) &&
-	    iocb->ki_flags & IOCB_DIRECT)
+	if ((NInoCompressed(NTFS_I(vi)) || NInoWofCompressed(NTFS_I(vi)) ||
+	     NInoEncrypted(NTFS_I(vi))) && iocb->ki_flags & IOCB_DIRECT)
 		return -EOPNOTSUPP;
 
 	inode_lock_shared(vi);
-- 
2.53.0



