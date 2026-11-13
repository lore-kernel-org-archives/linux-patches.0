Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585670;
	b=p+rgWsLVyX81o03JBs5p3kwTVF3UJXmYnMx0uPEx3Wg7AOgqt+IR5gsaNuv4FpdapFtP
	 nZnBdD+HwOkt8Gt2EW4lgl9OnzsoFgEJ7lBIEZ3429VAB9BiYQQMcMPXpsSDPVPdUFxkT
	 OLumux5u8cCDPRzgMXuvCbUtNuFzGB59EpBoHg18KsbgpYADrBV0BoqI1TvKkPF9SW3uF
	 sY4tq2ySkFZ2Smi0hoTzop5BhwiZ9+VCCUr3tA3mIZsyh3sS+fSg00QFawj3UJa12G7DT
	 SZPeu/ykvCxDELfawgRQc6BjM8RPmvUcLv4sGitlx7sg/L4CZYAWL0qgk5dDUcEYN1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9r8iMV7TjLrAMxdOtjBYzc9A1LFrOyYhlJNaBsWV7Qk=;
	b=rtEf0Lfq311b4oohIlz0dgUaxI6EbUZwB3BsxxJTvOP88D+ZlXweoSMC6chUp3nvvAz9
	 nMdW/7FAprtxFZLpplIGpQ7nw/P6BAWE6SREVb3hljWZj3M4eiyW0jIMTgbWpiC7x5+r5
	 pxjpaybuicl9tyoq7i2w001tx8z3nSammTlJWgCHJr/6rHGsnqM55Abv+MehnHEK8rqNc
	 pILM+X6GCwKE4zqJfkDF71gXgNpya3ckR8by5vI6iHmpk+Arft37KexprFObZ9bJ+LMbP
	 fQRAPVHFVA/XdyLGFo0LKdHUBPAU6YIQG8TIf3UPYElRWF/RVkwi0cQ/IfeVbGzs6wA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b609y93+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9770D606B2DB;
	Fri, 13 Nov 2026 16:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b609y93+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 437471F000C4;
	Fri, 13 Nov 2026 16:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585670;
	bh=9r8iMV7TjLrAMxdOtjBYzc9A1LFrOyYhlJNaBsWV7Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b609y93+RHL5R4gs2RwgAx4gtqYj03UfYLLn6cg23JoJVxfYX/0O86YKZVuOoEs0O
	 scf10/1YnW+/Z/I9BS+piMGCKQdksHFnaptvP46arSSQ2D3sqFKvn+8Ey2GKTeBj14
	 KxkPYkSddUMvK1rzrbJxSrZMPPiB/anrjvt0zllY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 276/507] block: Return the soft block size for compat BLKBSZGET
Date: Fri, 13 Nov 2026 10:49:40 -0500
Message-ID: <20261113153804.209564613@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 57cd1a08717690e5ea01d7ac7a96bb33a2dca117 ]

BLKBSZGET returns the block device's soft block size, while BLKSSZGET
returns its logical sector size. The compat BLKBSZGET_32 handler uses
bdev_logical_block_size(), so it returns the wrong value when these
sizes differ.

For example, on an x86_64 kernel a native query of a RAM or loop device
with 512-byte logical sectors returns the initial soft block size of
4096 bytes, but an i386 process gets 512 bytes. This makes 32-bit
blockdev --getbsz and the BSZ column of --report disagree with native
queries, even without a preceding BLKBSZSET.

Use block_size() as the native handler and the pre-regression compat
handler do, and correct the case comment to describe the soft size.

Fixes: 9b81648cb5e3 ("compat_ioctl: simplify up block/ioctl.c")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20261023153645.37546-1-dennylin0707@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 64b4e6c0f6965..fb2f4b4d2505e 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -835,8 +835,8 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		return compat_put_ulong(argp, bdev_nr_sectors(bdev));
 
 	/* The data is compatible, but the command number is different */
-	case BLKBSZGET_32: /* get the logical block size (cf. BLKSSZGET) */
-		return put_int(argp, bdev_logical_block_size(bdev));
+	case BLKBSZGET_32: /* get the soft block size (cf. BLKSSZGET) */
+		return put_int(argp, block_size(bdev));
 	case BLKBSZSET_32:
 		return blkdev_bszset(file, mode, argp);
 	case BLKGETSIZE64_32:
-- 
2.53.0



