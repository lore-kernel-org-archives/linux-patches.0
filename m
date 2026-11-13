Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590379;
	b=V8vvnmP9xy8BF2CYtMpuPFaxLZJbC4HnssAe725PQLB7Q0Yydd0qDmXrBICnGw6WFBFf
	 CPfrY0TMZRkdSGidiW+vcsaPFInaz+On2TUNVi3zfi93JMs9cBt/42pem6fiEVeDlFY5E
	 0VqKwzjs5mzA9wxQvG4eEjuy4F74IwT6r/LPBzAbIOefK9cTUyi9BSVMODY+F7v1FwJLY
	 TWt2Z2D8+EzCmHnDW2E7GzY2oNhlTXjMGiABMhC4lU3DZj7OPQtOCf/0eLJDuSbidXjuK
	 f0J89mSIKO52w+WQPs077ZbBW3/76vDqvQbcLP9ki588wO027JJv7WcUSuF0WTGsqEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590379;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XtSQyrkh3Col2Y24qofBZo4lLbi9G43Qo+6sDeTdrn0=;
	b=ZdIao8RaeA+ytqDb6O9aeqj2HVDzBzCr+K3OUhYB4ukP57njEI+wQsPFJZzu81GlGqVg
	 hkKv9pHBt6IT/ms9/gTuBEfOhb05pns9FJwmxIsVqaeF4QwWluiKK/30iD8nsYJeqhLWe
	 uMc4cGGU20q3iKB0uMComq7SSwZc20uKgEKbL0BXD2Mvbiyf4j+Bob25vtno0haqUkP+7
	 h7Umqe5q8cexPfNIMG3xWUB2f6mOGPIctAjCEFpvyObJEHQ/aUJIPX99Xp2I+wLNPRm3m
	 5iKsqVWQ+iRnlJknW7Ti4hEG0HKjwM6qsvN43e3xm8pTjX1nUYvBdmcHjyW8FdoNdcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s1JgDa+2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF1F606E649;
	Fri, 13 Nov 2026 17:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s1JgDa+2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376791F000C4;
	Fri, 13 Nov 2026 17:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590379;
	bh=XtSQyrkh3Col2Y24qofBZo4lLbi9G43Qo+6sDeTdrn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s1JgDa+2nLymcGL8BC/iJbRYYMdFRntiWmz89j41tXlBoE25v0pHKKGitTtG0obVf
	 xWS3Hzl3ftqKDsjaaVOd3/fcwA7smdAurEZsh2JeddmE4LtCfv6lYVuw5EcldLOIJM
	 nCM7d//3lVeEUNvcVptPqvlzO/5+vqiiub2Rls/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 350/686] block: Return the soft block size for compat BLKBSZGET
Date: Fri, 13 Nov 2026 10:48:03 -0500
Message-ID: <20261113153832.780194357@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 801f904b5af47..c038a4b27b573 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -742,8 +742,8 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
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



