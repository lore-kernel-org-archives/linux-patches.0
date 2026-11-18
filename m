Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043217;
	b=y4HtGDyToMq6AP1xXNbIJ9F1Wwwzqo+MLQE8h46Rx4DLzo3jV/D3tgdiB7eNlSwWm+UK
	 zRi2wSbdH5t3GO782Bim6uD+W44SXhOeJTVFmVV9L2Itb3T+M7rtVEDB6YZ23BaaIqCNb
	 gtSb2SmUffma2zeUUaiUWmNBHsEVrm2MJsPmQ0tEbxbLEODkzjWTp2rFc/h7VqdTrPajg
	 PgSDTXWVLsqpXInvaXozH3mpMLVVVUQuz1liFmmb3GjOW/04wJnhEGOOt3jZeWsZzuEG9
	 Uo9t5b/zmxgnOOfD2/8ZcF6S9bNymo8fkESPpv6DjPiUWRe13e7aW6bLT/Ly6Aa9gRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043217;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Dm0B1EKXt1RIJMjIFrlORqZXpMt/hVMFVJh1yJiHUk=;
	b=tec2j+5lfYRV21pkDm2ZimyVG+YFBNz0jpJxLGRr5X1v1+JobK21mn7k6Okwle5XsFZe
	 65XNx3pkA8pBR/T0wOSk0F1qGJJidyu/qNnXXl9WFdn6Wf24MSQ9AoFUBQfaIESWr+98A
	 6W9kM8MYQr07qZuOqHPXMgqaJykoeUwc/9JQvqeAP+26lKComw68fyVydk4bJEQr+Gm9P
	 wBklO8Tby3tg9j+gQyoqaBDsV4cYCOcsjy6OwjgruelV89w5pUZBz86l4F1ViZctVry9G
	 PbFFASRTW4he8K83PU7huQUslZL7AX+UP+JR4mwapSTgm7rLsxlRloX2oA+swOvbn6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lR6tGMCh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AF9606A320;
	Wed, 18 Nov 2026 23:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lR6tGMCh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F4A1F000C4;
	Wed, 18 Nov 2026 23:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043217;
	bh=8Dm0B1EKXt1RIJMjIFrlORqZXpMt/hVMFVJh1yJiHUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lR6tGMChUadbP67yvaZItxs/2om3CRiSsUAsebPAAqynrIxihC78/BGQPFOt0d+M4
	 KK5W0UauilImeBNhcozLeQkQUBKdupGaTD3nE6Ez5IJ54vYCXU2ntN/QT2jHG5hv0G
	 uhzn9vHODVwkiNKdYgNethjyN+yVrlkrIa8EnLqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Zhou <yun.zhou@windriver.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0132/2857] ext4: set EXT4_STATE_NO_EXPAND in ext4_evict_inode
Date: Wed, 18 Nov 2026 15:19:26 +0100
Message-ID: <20261118150206.103234965@linuxfoundation.org>
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

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit 2c0e4fb511f97467dafc91b6afb3414100289081 ]

An inode being evicted will never need its extra isize expanded.  Set
EXT4_STATE_NO_EXPAND before ext4_mark_inode_dirty() in ext4_evict_inode()
to make this explicit and prevent any unnecessary work in
ext4_try_to_expand_extra_isize().

This also provides defense-in-depth for the s_writepages_rwsem deadlock
during mount-time orphan cleanup, ensuring the expand path is blocked
for inodes under eviction regardless of how they are reached.

Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260623061903.2148767-2-yun.zhou@windriver.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2739c9a04c8f8..5f0cd1f74b6f2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -278,6 +278,7 @@ void ext4_evict_inode(struct inode *inode)
 	if (ext4_inode_is_fast_symlink(inode))
 		memset(EXT4_I(inode)->i_data, 0, sizeof(EXT4_I(inode)->i_data));
 	inode->i_size = 0;
+	ext4_set_inode_state(inode, EXT4_STATE_NO_EXPAND);
 	err = ext4_mark_inode_dirty(handle, inode);
 	if (err) {
 		ext4_warning(inode->i_sb,
-- 
2.53.0



