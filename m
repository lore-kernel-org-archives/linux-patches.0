Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E973421660B;
	Thu, 12 Dec 2024 17:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024449; cv=none; b=K3rbMIv9X942Npdv4MQj8IFV/5/4uqE3xwrpQ6Q2mHESPZ6dYbnY3zLXi7UKwBkoOrG9uV4xn8WYRMXvDAdJhgsBGWdgWJbCT3d+8EDi/ZTZLB0w1c6oN6FH1y6ay4eXoSXsVyekO63HrbU2ogo/YPwd0pE7i3SMfx7pWp6YJXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024449; c=relaxed/simple;
	bh=MbHDKlleUe/VyjcTpmzmYRRcPQ1XPDxC5UsWrWBHf8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HyObTJ4fCGxsajLevgg+CSQ7aE3dIrj72lbxHVzU3qHZD31vn+x1EkGu3jTdccScKnhyIXKyGaCSbD6BmadxeuCsUVY72SRV01z2AWNTrkfeKHXBiz66DhQdmvuTZXx1ldt/cIy/3BOFnTWam+h49hTDWlAWwvrgNgyEEVVmQpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKvfLIDL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKvfLIDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9CAC4CED0;
	Thu, 12 Dec 2024 17:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024448;
	bh=MbHDKlleUe/VyjcTpmzmYRRcPQ1XPDxC5UsWrWBHf8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKvfLIDLHiwduhmEhBAEWi7Op6i9nEDj52v+cGyfBiAHEoi9KuSEB8AqSyEsgiZzx
	 NkOwn4htpSJwpU2yYfcTnRjE8UtdWF1qkHjNyxpLJhz/3ve4Tao/A6YbMVWPAs9JyI
	 wVOr93l+Dsi+OSxr9MoAQj3qswZzKXSQbrkloNRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 299/459] block: return unsigned int from bdev_io_min
Date: Thu, 12 Dec 2024 16:00:37 +0100
Message-ID: <20241212144305.452483573@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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
index e5f11dae208dd..7ad4df2c25255 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1468,7 +1468,7 @@ static inline unsigned int queue_io_min(const struct request_queue *q)
 	return q->limits.io_min;
 }
 
-static inline int bdev_io_min(struct block_device *bdev)
+static inline unsigned int bdev_io_min(struct block_device *bdev)
 {
 	return queue_io_min(bdev_get_queue(bdev));
 }
-- 
2.43.0



