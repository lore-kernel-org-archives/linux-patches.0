Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057388;
	b=2fz3QQmh7WxFCqNZRzepE9S/5YgGJeDKSDSsm0X0NUFGhN2wPgqnRFe7FMRXhsXU7mty
	 CDDZ2ftpXxmCn/2HoPOH9ctia4UA5zNvjT9UtQG9XXVVZ1CaiNbOd74VY3+7h/I2nB/qG
	 7D70waXEtFQkh9500dLvI007jlS/ejJsKAZnwMrCoXza4cy+t3HAvlGZoVsUJuBSpe4Po
	 5ZSrClyNSlAARyyBuSzVKuaWZx9cwsFnJ3/5pqb4Hiev1k267EYSJ1fieIxR7Sz4WDHJ8
	 tTfnVBg8dVYTLOLbsx6gI81TTDaVehUvhNSeyGTp0OvXPHsF+PPqSj8gVvHte1RpAGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5IT/FXzph8jn1OZc+wQXMNR6DwTTZqcE+hLzFEf7qLU=;
	b=elGipEyH8TSuQVo5X8L7/m7SiVcVve8M/zs4cC+ZZTaorNjL49F+otWEt7X8Fhaub3eX
	 S1uh+sPgNr11QzyVfaoG+oswpAJS1CBiB/05H6gsKqDd+0digGfm1zc5Hre1OujboAR/t
	 GgxwGdZcrW1nQBscuVm5I9vQpaYetJcNEkZis0LXOySYHOSDMaYibnGV1gv4G5PHzGCfM
	 B6YvVw19EHfQw/FLNns54QOFHP9HF0yTaYQSV589qQ27SsLzZp1OYRnfXhRJHFpwy9prt
	 fgWCk3bMMSgnrR4bcgPYYuQplIMxc775TGig9in2RwDoP5gTqS4PSN84hUNAt46EMZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oFSteD83;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6AB60A260D;
	Thu, 19 Nov 2026 03:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oFSteD83
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11F61F000C4;
	Thu, 19 Nov 2026 03:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057388;
	bh=5IT/FXzph8jn1OZc+wQXMNR6DwTTZqcE+hLzFEf7qLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFSteD83zYmJI+MJR8zV+iXW84/R9++kz4PETXAifakbGpcL6XGJ/WGoZbxoXWTaV
	 tA5/sp/8cPRCgs2sL0duLcuS0NHwYFLt/XeP3i8POF6LmF2m7I/CIzs7+oE5Sn5gB0
	 rcdsck+veIrQQwycELAN8Vy10uxY8LgnrIyYw7wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0113/1848] ext4: check return value of ext4_get_block() in ext4_load_tail_bh()
Date: Wed, 18 Nov 2026 15:35:51 +0100
Message-ID: <20261118145915.728224896@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 705a3fd3bac167f1dabe3d3bba46cd484c5528dd ]

ext4_load_tail_bh() ignores the return value of ext4_get_block(), so an
I/O or allocation failure is silently discarded. buffer_mapped(bh) stays
false and the function returns NULL, which callers such as
ext4_block_do_zero_range() treat as "nothing to do" and return success.
This can mask real failures during zero-range, truncate, or punch-hole
operations, potentially exposing stale data if the block was not
actually a hole and needed zeroing. So propagate the error to the
callers.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260714080044.4038124-4-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4fafcdd688330..cd35375e483c5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3836,7 +3836,9 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 	}
 	if (!buffer_mapped(bh)) {
 		BUFFER_TRACE(bh, "unmapped");
-		ext4_get_block(inode, iblock, bh, 0);
+		err = ext4_get_block(inode, iblock, bh, 0);
+		if (err < 0)
+			goto unlock;
 		/* unmapped? It's a hole - nothing to do */
 		if (!buffer_mapped(bh)) {
 			BUFFER_TRACE(bh, "still unmapped");
-- 
2.53.0



