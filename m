Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B554183CA5;
	Sun,  1 Sep 2024 16:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207711; cv=none; b=e3qJ3WqhZItyH2NWgK9QFVWiB+rNMNaJ/FLzBNgBumfxIbAn6ODvCiiXNYVPhR9M8kym7SaNsYBMDAzxQnkdxbC390SKscz/JJ411+/1nE47Xhs4nLmJf1CJZ1XPA2kOmJET3AMHpMFhaGTDhCiSSmY6n2kCZCZRdOyDdl+uQr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207711; c=relaxed/simple;
	bh=GL47WSxDABkB+Vxd0aUN9yt4V62DR12pEdAfq5N+M40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BiKK3JlyAY1pv7cO5vuA1UEnegYjZdMggZ4Ke2k9SFnDReUzcqDkcHjhQUZp4ZHSlm/6ds7rJP+aT7qrroS2jetl3MIFIc0KgbpHMt+z/Cptv+kbP6XlcXl5WvGvtysKWk40PORJOvJ/XWZwRCRAHT1A6v+AEAeCoTAy9LTa5M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kw+TYj2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kw+TYj2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37C0C4CEC3;
	Sun,  1 Sep 2024 16:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207711;
	bh=GL47WSxDABkB+Vxd0aUN9yt4V62DR12pEdAfq5N+M40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kw+TYj2URf1Fws0ZKjpqoarzHOXuHDyrytz9+HEZTgoDYnYMisNGnP1Wdj22xTEfM
	 r8KxFb/zaNcThhWJXsQCdcclcDVQjwkLE2eNY3+qobNLLzG5i/5w4XwRYtXUjDzuRy
	 bioK4A2c4HZVqQPd/ONwYHt7tNPC+1s3L9+h+V+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	David Hunter <david.hunter.linux@gmail.com>
Subject: [PATCH 4.19 53/98] block: use "unsigned long" for blk_validate_block_size().
Date: Sun,  1 Sep 2024 18:16:23 +0200
Message-ID: <20240901160805.699779829@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

commit 37ae5a0f5287a52cf51242e76ccf198d02ffe495 upstream.

Since lo_simple_ioctl(LOOP_SET_BLOCK_SIZE) and ioctl(NBD_SET_BLKSIZE) pass
user-controlled "unsigned long arg" to blk_validate_block_size(),
"unsigned long" should be used for validation.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/9ecbf057-4375-c2db-ab53-e4cc0dff953d@i-love.sakura.ne.jp
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: David Hunter <david.hunter.linux@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/blkdev.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -56,7 +56,7 @@ struct blk_stat_callback;
  */
 #define BLKCG_MAX_POLS		5
 
-static inline int blk_validate_block_size(unsigned int bsize)
+static inline int blk_validate_block_size(unsigned long bsize)
 {
 	if (bsize < 512 || bsize > PAGE_SIZE || !is_power_of_2(bsize))
 		return -EINVAL;


