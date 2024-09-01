Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C1217DFE7;
	Sun,  1 Sep 2024 16:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209589; cv=none; b=OhSGxWh6i631xTC2aNLa/vfHEtT6yR1yJdI30Sq3ofdHBqu1i5kIMDtxSSa43sv8rpP7JKNLGFYEsjLo/pknzSUyB/wWbdH3Eu457QU9G8NrfLAYdWcvfRtUngSsOXz/ztpTIOmDDlNREY1PZDgSP8XbFVB0GNjEhUb0ID+sTlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209589; c=relaxed/simple;
	bh=pROhkzbO6PoT492l6MOEBffTxFU+xeFtLCq6TWU/pF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2BwzMUk0mzFajseQxY6uA6YnFyHJezgHlMUnUT99kmo0R0xoOdNZjV9WhowxXahLaTbRywnT0xfJkS+CWGvVOO3kX2QnQPtdzrvAilyeSuqBXXi7B3TSkEwN0NsE/HN0rv6bwYlk8Xz8sbinxSKozZrIliRnGV1Yj8xjLKJNuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4iHGj3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4iHGj3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA97AC4CEC3;
	Sun,  1 Sep 2024 16:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209589;
	bh=pROhkzbO6PoT492l6MOEBffTxFU+xeFtLCq6TWU/pF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4iHGj3uFsKMSlorO0qXqiyyeAi3iExUORFk6XvHwrFDa6GBoXL4h9VpD+5fjtFp2
	 MKGpwdEsZxpwD2ylENSFLXGjUHLVnmtqtnf01ncP4HGjFRopv+NItivRBKWSM61ag1
	 jYCCPk8YClXTwILubfKacL4THMAhxwRUYSYU+QfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	David Hunter <david.hunter.linux@gmail.com>
Subject: [PATCH 5.10 083/151] block: use "unsigned long" for blk_validate_block_size().
Date: Sun,  1 Sep 2024 18:17:23 +0200
Message-ID: <20240901160817.242865843@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -59,7 +59,7 @@ struct blk_keyslot_manager;
  */
 #define BLKCG_MAX_POLS		5
 
-static inline int blk_validate_block_size(unsigned int bsize)
+static inline int blk_validate_block_size(unsigned long bsize)
 {
 	if (bsize < 512 || bsize > PAGE_SIZE || !is_power_of_2(bsize))
 		return -EINVAL;


