Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53061C29F;
	Wed,  3 Jan 2024 17:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTjDii/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464E0C433C7;
	Wed,  3 Jan 2024 17:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301263;
	bh=jCRqCEd3uw8C3Frvc6C02muV4II/JO1aYKeBG/EA7Mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTjDii/5Zy7BIl4/M6Sb/GGBzkaCJINNPe9KdkOY9E5O+6CLvvL5XtFHFzn8Org4M
	 R+2NmCJnLdGxUPl9uUA+vEBJmKyXx6fOSiOXYCHjQpwmqYm+hIe8O0aLP7a+Us+HOH
	 9CevhYtFNV94V5w16g5F4iiAnw/xjrUUnxvbbxKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/100] block: renumber QUEUE_FLAG_HW_WC
Date: Wed,  3 Jan 2024 17:55:13 +0100
Message-ID: <20240103164908.719444751@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 02d374f3418df577c850f0cd45c3da9245ead547 ]

For the QUEUE_FLAG_HW_WC to actually work, it needs to have a separate
number from QUEUE_FLAG_FUA, doh.

Fixes: 43c9835b144c ("block: don't allow enabling a cache on devices that don't support it")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20231226081524.180289-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/blkdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 57674b3c58774..07a7eeef47d39 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -565,7 +565,7 @@ struct request_queue {
 #define QUEUE_FLAG_NOXMERGES	9	/* No extended merges */
 #define QUEUE_FLAG_ADD_RANDOM	10	/* Contributes to random pool */
 #define QUEUE_FLAG_SAME_FORCE	12	/* force complete on same CPU */
-#define QUEUE_FLAG_HW_WC	18	/* Write back caching supported */
+#define QUEUE_FLAG_HW_WC	13	/* Write back caching supported */
 #define QUEUE_FLAG_INIT_DONE	14	/* queue is initialized */
 #define QUEUE_FLAG_STABLE_WRITES 15	/* don't modify blks until WB is done */
 #define QUEUE_FLAG_POLL		16	/* IO polling enabled if set */
-- 
2.43.0



