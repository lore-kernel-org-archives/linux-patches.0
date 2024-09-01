Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905F61C68C;
	Sun,  1 Sep 2024 16:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208905; cv=none; b=D+mBzlML1a6SYcmtTe9GOQjH9QpoUnei3kqCHxQoX7puqNtXtLQB4apRI3mgjKkfJZ//DzNva8yz/73G9OCBLWP0FNy6ItNCt6F8vjlW388Fp/ttYFz5grIP5zPZqN/u3PKbdcoFBXlFjXN5LyFEqpQCzX4ANg1B7rXMnIo5t9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208905; c=relaxed/simple;
	bh=LqOB5Zh5+wdJOHuFBgsf3QH3ECfjwCwRebN0JLEg6vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+bTN4mJOBnGuQ4ecbOEbzpJDsfskk8HgxMSjt+KTByvk+fxCTnkwKC5AUuwyySvzfAEVgX355Ank7EChtrOh0p8nHiDdddDDA9nqui5ZXAY/YGMC1FM9u6k3l9SNjjbW7WfOCejp0cwXrQ/DSBZxlQ8zJRko44tptMcF+QP1d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbXD40qX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbXD40qX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F291AC4CEC3;
	Sun,  1 Sep 2024 16:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208905;
	bh=LqOB5Zh5+wdJOHuFBgsf3QH3ECfjwCwRebN0JLEg6vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbXD40qXk1Tc8uOZ85WK6PqPqW1gjsEJUGCSPzJ2/A4RzSP4RKtCaK3J7U7Jju7Jb
	 d2Ctu/eIxoGwUKsj2Za9IujysQLfdGOCpiVUy3/uXV2KlxHZt3iZMuSUaf8EpR/WWU
	 4XS8GAmnLjFW/MjbsGiMWXXvykDxw1o93EkvrJpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	David Hunter <david.hunter.linux@gmail.com>
Subject: [PATCH 5.4 075/134] block: use "unsigned long" for blk_validate_block_size().
Date: Sun,  1 Sep 2024 18:17:01 +0200
Message-ID: <20240901160812.924439564@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -59,7 +59,7 @@ struct blk_stat_callback;
  */
 #define BLKCG_MAX_POLS		5
 
-static inline int blk_validate_block_size(unsigned int bsize)
+static inline int blk_validate_block_size(unsigned long bsize)
 {
 	if (bsize < 512 || bsize > PAGE_SIZE || !is_power_of_2(bsize))
 		return -EINVAL;


