Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30D1147C7F;
	Thu, 13 Jun 2024 12:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280077; cv=none; b=DcElhyTVZ+ALYSCwTXyNhk+9eaCm8X9dwd6fXgb6s9A7aglQeUHulHWrNcPIrXXZnslV1MUZBQ9tB2nXjbKCWz/bW9yDC3pbiPSQ2Aw4Q5AX67ArP89xs1b+hsBVSknaKAycdqcAXsiWLCDcXXZXh5zl2JLDR573wqxRflaCw88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280077; c=relaxed/simple;
	bh=IhRd8QwoJksrXTTkBWbYkfiq5jLVazvxTzvFjttg028=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqckg4XmR2eOGNlFzbkETjRoAVzi3icBuYgI0T0K4ZNmXFmOXB+4US84+kTldJcnMECt1bOrSDsnRkrJNlCtA+ec+xQ3uDg0Cp9daQaXUvVaQI0Zd107muxS20eSB7HKj89quaYWns+L9CGUHojfIxRjmJvg9m/GHAAcWV5uO4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DfIrHd5y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DfIrHd5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EE3C2BBFC;
	Thu, 13 Jun 2024 12:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280077;
	bh=IhRd8QwoJksrXTTkBWbYkfiq5jLVazvxTzvFjttg028=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DfIrHd5ys/ZUKJI/HkaIHzp7x57VL10mXOEEVfzpvlq7KDKnc8n1v9m4/SsawJhqR
	 UZJO0Bf7nfBurKjwI/iUYO1pY4K7BW4q6NXurRULOk/iRS4cEnOn0gYiF98yV3b+A3
	 kBINMK//sl+ZT09wrX1gH+JRGKupSHYCFwFFdWyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 135/202] null_blk: Fix the WARNING: modpost: missing MODULE_DESCRIPTION()
Date: Thu, 13 Jun 2024 13:33:53 +0200
Message-ID: <20240613113232.971587490@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

From: Zhu Yanjun <yanjun.zhu@linux.dev>

[ Upstream commit 9e6727f824edcdb8fdd3e6e8a0862eb49546e1cd ]

No functional changes intended.

Fixes: f2298c0403b0 ("null_blk: multi queue aware block test driver")
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20240506075538.6064-1-yanjun.zhu@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index b6210bf0724d5..218658df77ae5 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1876,4 +1876,5 @@ module_init(null_init);
 module_exit(null_exit);
 
 MODULE_AUTHOR("Jens Axboe <axboe@kernel.dk>");
+MODULE_DESCRIPTION("multi queue aware block test driver");
 MODULE_LICENSE("GPL");
-- 
2.43.0



