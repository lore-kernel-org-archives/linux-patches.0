Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059725;
	b=QJMrirpKnt9ZUCTtRv6U538AbEtCmrpOJVSCBl5xQqvgXKuwC4baSPAabv+tD7s1QB+1
	 3YWZ+3myANTV6YevB+dv+haORI0b5+ZRK9fWGIgVV3ZVGvcVVPfLIvCmKqR6A0x4Pd9Ue
	 tesvcoJAIp79jFb2mlNXBA+lkEJNO0adhsXOC+UdDLRBDcVjDRuZuyKqdBAbjyCiUH/+O
	 yC7aa1anltF1EfP7CvP3YRw1UhZa3Y7aU27VP/ika1tN5D2Bib8LNJHMIAgI0qkQOFToa
	 yKKrnFXK39vG83+Oj/lw6kJ8MC3uLtwSVCZsrKt14eUmN4Cz9lsMc4SZumRMHsJT/UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sWbHApU2B6WrJGB9SBHzU0diLuJ7eDzydtNMkDq6mKs=;
	b=Y2hC6CiWA7PREIuKfEZVRpHWqzPFglXrAawvDrXuBitO37dmvAz8IaYhSavdDgqKSS0k
	 SfN4cJHq3cj/j4QCQYqUJ+S4BX+WbxQDb21FMJVU18/aLvWRfe3XDxkq79CAPXgQ7FJ9C
	 WhjBAdExGe3fL8FAgZuk7iDssYAOmrpgP2bdzSOW4v/7aArXH1GQn1Br0DpfXa+EDRf5x
	 0z1tPz3XI/d7ZJGuBOU1jiF7JYlMCtWAlYhF4VpqVlTDtAF5vQpTv3LqzAcFCt0VWT75s
	 d6I+t61Vx1D2zwTXFeJlhqaB8sA/V5itnGEPiyK5L04XHkvLG2MeImFXtv6DT4q/Pfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i2k5lhjG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3C3606A325;
	Thu, 19 Nov 2026 03:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i2k5lhjG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D991F000C4;
	Thu, 19 Nov 2026 03:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059724;
	bh=sWbHApU2B6WrJGB9SBHzU0diLuJ7eDzydtNMkDq6mKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i2k5lhjGYLGzEEEy1QyiTx1mmoh1yk2U5chywNLhsSI6tl73VSODASELEmPlRE/4B
	 zKWRhCA7Q2q5KXOHQvN5SQv7p5s2iJl7RHiKI9rG9bXf41uSRGnwmj6PpEjS+f5VUT
	 rIFUGCepnHZlY/133RSUE9qFos4fpCKg5mdimpvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0945/1848] fuse: dont drop destination page cache on a zero byte copy reply
Date: Wed, 18 Nov 2026 15:49:43 +0100
Message-ID: <20261118145956.620834687@linuxfoundation.org>
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

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit f7585e1ce3418ec282485854b3d8d31c6a961e37 ]

__fuse_copy_file_range() clears the destination page cache after the
server replies:

	truncate_inode_pages_range(inode_out->i_mapping,
				   ALIGN_DOWN(pos_out, PAGE_SIZE),
				   ALIGN(pos_out + bytes_copied, PAGE_SIZE) - 1);

A server may legitimately reply that it copied nothing, eg if the source
file turns out to be shorter than the size the kernel has cached for it.

If pos_out is 0 as well, the end of the range is ALIGN(0, PAGE_SIZE) - 1,
which is -1. lend is a uoff_t and truncate_inode_pages_range() takes -1
as its end of file sentinel, so rather than clearing nothing it drops
every folio in the destination mapping.

That is not only a cache drop. truncate_cleanup_folio() calls
folio_cancel_dirty(), and fuse_writeback_range() only wrote back
[pos_out, pos_out + len - 1], so dirty data elsewhere in the destination
file is discarded without ever reaching the server.

Skip the call when the server copied nothing, since there is nothing
stale to clear in that case.

Fixes: 9b46418c40fe ("fuse: copy_file_range should truncate cache")
Cc: stable@vger.kernel.org
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
[ sashal: used outarg.size instead of bytes_copied ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 4a940f3e78914..4e5321e0f825b 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3472,9 +3472,11 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (err)
 		goto out;
 
-	truncate_inode_pages_range(inode_out->i_mapping,
-				   ALIGN_DOWN(pos_out, PAGE_SIZE),
-				   ALIGN(pos_out + outarg.size, PAGE_SIZE) - 1);
+	if (outarg.size)
+		truncate_inode_pages_range(inode_out->i_mapping,
+					   ALIGN_DOWN(pos_out, PAGE_SIZE),
+					   ALIGN(pos_out + outarg.size,
+						 PAGE_SIZE) - 1);
 
 	if (fc->writeback_cache) {
 		fuse_write_update_size(inode_out, pos_out + outarg.size);
-- 
2.53.0



