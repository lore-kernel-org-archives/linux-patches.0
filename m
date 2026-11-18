Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051994;
	b=SzEm+EPaTOthXWVa9lrhFyGwwqu5Sgvj7wy4+n20W4yyheafAf7c2k71Ihaqp+HHI45W
	 CJC5YFg8DmYnuAvUMXNjyyaAmikal8DkLGojApoRfKefLmCQVWM/383SwDcoBPC1FqKgG
	 VP49lqQSfp8pnpFLtKohmvlMnmC6P8bvKO3/23qV/VPEs1pGFVOielKKkrYoCsOmFUbTm
	 eJkiPjb84qfDxiXRLiJliKcdlSLQpOihtgSGM/yIOlNk3LxbhT2GJ0qrKsg5pE4O+iin4
	 43d0QHKl+uCITMhL9kbNcdKqHmbkfKSohMLZBsHtCBbdXHJiOsv26L0qorq+6OZVC5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cde3zSEpUgdjwynXTeiWot4zBCtPjXeT4B4brQxVzig=;
	b=SrdgJQiqvKWp+9x+OqXxbeDS1kPMvdy/kOkMKXRYuTzXkBkBPswY2rM9+yPZCQfk8kL5
	 p8LSR/ew9sV78q23FqPhcSC3KKsQg2Uv2kbxy1vo2h2JI2yKmmEm4gFyeGXW35wX39XOP
	 xv66s9Wm4VlZXA98faQoZRc37aoHLiEyGvfEmRnEN9WnIAhFIecTTVzkt0FJrFY0LgrT8
	 ZMrGM2zw5Y5B8f6h5edXYXH8F6KKJPIjDS9hGecINZnS+0llpcyblmk2IcxjJGUcTUYZ7
	 6qdMgbNJs0h4vv84pvpZxsQVjH2n9/ous3PGhpwwTShHfUIFUCZEDFpsj2C51PScVqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=na7+aRX3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB309606A32A;
	Thu, 19 Nov 2026 01:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=na7+aRX3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1211F000C5;
	Thu, 19 Nov 2026 01:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051993;
	bh=cde3zSEpUgdjwynXTeiWot4zBCtPjXeT4B4brQxVzig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=na7+aRX3jhs9+eT1zkWY9PxkG6RTJRP+m9YGHLYLjulQ8YVGVY3MA6nFycbwdC7zU
	 0NOmCdhKr7ue2Zc77khJ5aKWvsPXlSOqz4qI7KQqmF8vM2RS93xn3DeRNQIjgwd0Qq
	 1SjqBBshpPJ1ns0Gy7liml8FGkq23OuZ3TRR9H/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	DaeMyung Kang <charsyam@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0404/2214] ksmbd: avoid restoring only in-memory EOF after allocation change
Date: Wed, 18 Nov 2026 15:34:40 +0100
Message-ID: <20261118150026.913205425@linuxfoundation.org>
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

From: DaeMyung Kang <charsyam@gmail.com>

[ Upstream commit 9455e920aebe41217cabff3f81e90da4c407fdb6 ]

When SetAllocation requests a size below the allocated block count but
above EOF, ksmbd truncates the file to that size and restores only the
in-memory i_size. The larger EOF remains on disk and reappears after a
reboot. A 3-byte file preallocated to 64 KiB can acquire a 4 KiB EOF
after reducing its allocation to 4 KiB. Extending EOF this way is not
a reliable way to reclaim the preallocation beyond the old EOF either.

Only use this truncate path when the requested allocation is at or below
the observed EOF. A truncate to the existing EOF still lets filesystems
release preallocated blocks beyond EOF. Remove the in-memory-only i_size
restoration. The size check still precedes vfs_truncate() taking the
inode lock, so a concurrent shrink can make the truncate extend EOF;
that race also existed in the original path.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 55fb52cf2518f..13069c375a906 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -5896,24 +5896,17 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 			pr_err("vfs_fallocate is failed : %d\n", rc);
 			return rc;
 		}
-	} else if (alloc_blks < stat.blocks) {
-		loff_t size;
-
+	} else if (alloc_blks < stat.blocks &&
+		   alloc_blks * 512 <= i_size_read(inode)) {
 		/*
-		 * Allocation size could be smaller than original one
-		 * which means allocated blocks in file should be
-		 * deallocated. use truncate to cut out it, but inode
-		 * size is also updated with truncate offset.
-		 * inode size is retained by backup inode size.
+		 * Truncate at or below EOF to discard excess allocation.
+		 * Truncating above EOF would extend the file on disk.
 		 */
-		size = i_size_read(inode);
 		rc = ksmbd_vfs_truncate(work, fp, alloc_blks * 512);
 		if (rc) {
 			pr_err("truncate failed!, err %d\n", rc);
 			return rc;
 		}
-		if (size < alloc_blks * 512)
-			i_size_write(inode, size);
 	}
 	return 0;
 }
-- 
2.53.0



