Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065268;
	b=kneZ9fDF7A8qBFWz7xUhkSScM85a+xGYmOA/C8ot0nvFoipODOdoMe9dw7YMKn7GxvXG
	 v3Ji4d+PgmOwE/roCr/RxIr9deM7+9JeyQI0Q/XGAC6paX61o+3moVhC1Cu0bkS066BCB
	 6VXWuHQoi+eQBZdDxHe0RmMVpjyCMaoIvts0JO0oWpjylP57ia7ejp5HxXNvCjwymuLah
	 f6f/+LgPGrStlkUFgwm7HCUzQs/rEI5+Ony5+m4aHzXyLjwHaqOyricXxQjAN/lDyDRmA
	 XgkLYLXd6930psYcWdV5zqk9UGnNo7YYUbT4BwTQFACa2CrbUig4I/fZ6fvCG/2Webw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065268;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vTknceZ8/+cmc0AtK4MW+TBmN5cO4Q57JaBEgewfFu0=;
	b=aEjxmTOzf7MsLkD+ct6Fdg/EVF3lQlsoZbVevg/DGFM33CIeb03Mdwgql07hldicHzlM
	 5tsppfmmhXHebLsnJux0I8LrrMaNZKgRf3AkJ67Gv1KSvT5Prc0T28+qYdmOnsDij4fEf
	 0HXCeQcHF1XD+rRQ+/MZuDQYnEgyn1Klr8lhAIWVcIiYEv4+cNiI1y9lzTKP8thrXHRQ1
	 Ge9+RquGFBjy1OZ2MnCah89qFnoBLgQFQbN/DIo6WtI9hnrEpfovnYUGRAI0Vc50RZNjx
	 jgiUGygBFJ9j6cfMqxlKTNPmjIIaqokL0H2vcRRBlVwQ3Xd51nrJnUqsVkcKya3U8mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J03fDY13;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977D1606A32C;
	Sat,  7 Nov 2026 15:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J03fDY13
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABE81F0089F;
	Sat,  7 Nov 2026 15:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065268;
	bh=vTknceZ8/+cmc0AtK4MW+TBmN5cO4Q57JaBEgewfFu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J03fDY131NJ7fwJFo+IMxuY0ee252KLUCmWG2YayWBL6wO1oXGue8TOuGqI9bIijn
	 63HxjhI2XFa//Q4YPZ7gu7y7Ocm7XRcHzHhyp4fkA5r1aQCXU3P7XNoHX5GwRU/Cau
	 ACNgbhEYAIO/qTwFtnwFZrW33AWc+TPrf0dlvbK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0983/1257] exfat: advance valid_size to EOF for append writes
Date: Sat,  7 Nov 2026 08:54:39 -0500
Message-ID: <20261107135006.512567292@linuxfoundation.org>
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

From: Chi Zhiling <chizhiling@kylinos.cn>

[ Upstream commit b70ab407503706289163dd59f1ac3e942bacc37d ]

For an append write, the write position is recalculated by
generic_write_checks(). Therefore, the write position must be obtained
after generic_write_checks() returns.

Using the original write position to advance valid_size may cause the
valid_size update to be skipped, potentially exposing stale data.

Also move the truncate_pagecache() check below the recalculated
position, so that pos is never read before it is assigned.

Fixes: 11a347fb6cef ("exfat: change to get file size from DataLength")
Cc: stable@vger.kernel.org
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/file.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index a2a9ee1a20048..b30aec858da6c 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -854,8 +854,7 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct exfat_inode_info *ei = EXFAT_I(inode);
-	loff_t pos = iocb->ki_pos;
-	loff_t valid_size;
+	loff_t pos, valid_size;
 	int err;
 
 	if (unlikely(exfat_forced_shutdown(inode->i_sb)))
@@ -863,11 +862,6 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 
 	inode_lock(inode);
 
-	if (pos > i_size_read(inode))
-		truncate_pagecache(inode, i_size_read(inode));
-
-	valid_size = ei->valid_size;
-
 	ret = generic_write_checks(iocb, iter);
 	if (ret <= 0)
 		goto unlock;
@@ -878,6 +872,11 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		goto unlock;
 	}
 
+	pos = iocb->ki_pos;
+	if (pos > i_size_read(inode))
+		truncate_pagecache(inode, i_size_read(inode));
+
+	valid_size = ei->valid_size;
 	if (pos > valid_size) {
 		ret = exfat_extend_valid_size(inode, pos);
 		if (ret < 0 && ret != -ENOSPC) {
@@ -887,6 +886,8 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		}
 		if (ret < 0)
 			goto unlock;
+
+		pos = valid_size;
 	}
 
 	if (iocb->ki_flags & IOCB_DIRECT)
@@ -899,9 +900,6 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 
 	inode_unlock(inode);
 
-	if (pos > valid_size)
-		pos = valid_size;
-
 	if (iocb->ki_pos > pos) {
 		ssize_t err = generic_write_sync(iocb, iocb->ki_pos - pos);
 
-- 
2.53.0



