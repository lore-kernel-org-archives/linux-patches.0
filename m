Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628051F76CE;
	Tue,  3 Dec 2024 15:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240030; cv=none; b=sbRTxWsq1/CqoNoCLjDMswVo+ZBG5Gps81ICzCJK3m0EFRXxrWkn/LCc0OZRBGZfhZNW8C4KQ1L6JhFAUKY86LDjNGaWtlHLIzYhIV5bFBu95xwZ1dREnkdV57PFtFwYhTPWNF6QsuGTVxehDiGiObYzI6bBSHf4y+cvfKBv9QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240030; c=relaxed/simple;
	bh=1O3BT5oXPx8uAOaNSrB+QMyWNf4ZeMbGntQL4Fuz1Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciSahJzM3Lusb8oeRKx+7HXRKwjkNCc80jbmnwCKYH2D3nnb4LtOVPyEy20FPxFo35Dh0aB60Oo3U6wcP03bcr9+Y+DMzS73Miz/QiHihfPfi4p+0qJxPKv/Svx+V9ma+ZevLag+ayMumoy6BCNOVfyVcVSTAo8R7sYvfcx935M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DRB2pwMn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DRB2pwMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B299C4CECF;
	Tue,  3 Dec 2024 15:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240030;
	bh=1O3BT5oXPx8uAOaNSrB+QMyWNf4ZeMbGntQL4Fuz1Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRB2pwMnOLEhaB+iEh2M43LZt1WHTCr6iGr/gEgb8tMt3WrQlQ1OOtiPlCjNirLyT
	 +5QLa+CFa5CjGU1zBmC8bwjCyW3cyzfeZFk6FZ5ThnA8JthNLZW6zKrwwPBPtUICVy
	 b7CYJAVmBBHdeph1mEGApJjZBk/Xf7XXn2BDQEdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 786/817] block: return unsigned int from bdev_io_min
Date: Tue,  3 Dec 2024 15:45:58 +0100
Message-ID: <20241203144026.693706582@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 46fd48ab3ea3eb3bb215684bd66ea3d260b091a9 ]

The underlying limit is defined as an unsigned int, so return that from
bdev_io_min as well.

Fixes: ac481c20ef8f ("block: Topology ioctls")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Link: https://lore.kernel.org/r/20241119072602.1059488-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blkdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a6e42a823b71e..7e35d9ebdc374 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1255,7 +1255,7 @@ static inline unsigned int queue_io_min(const struct request_queue *q)
 	return q->limits.io_min;
 }
 
-static inline int bdev_io_min(struct block_device *bdev)
+static inline unsigned int bdev_io_min(struct block_device *bdev)
 {
 	return queue_io_min(bdev_get_queue(bdev));
 }
-- 
2.43.0



