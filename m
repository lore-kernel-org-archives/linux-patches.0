Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78111384;
	Thu, 13 Jun 2024 12:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282451; cv=none; b=MoSkImgYyKX/JFHGnbACenWLoPsKa4i2+Hk0C8k9nxxjWslxwb+T4BiANKmvLHD53Ejt40iogmoyIPqJxTHVhRjDXI4Iwo+R5ugspaXFvDk4nPMeaIQYa6Q4rdeHH9VMLyzH/NCtnA3+QtAsFLqpRGwgxkmZt0vHoJEGCtgsa7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282451; c=relaxed/simple;
	bh=KM8DyskE1/pHSx1GiwG/Zs/EsbMy9lVgQiBkYwIzAtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5Ybyz+aDOXjz9SabFJ/J6CRtuMdTfH/vIzGuisaZzJFo996X98X8C8J7AKs/6o50qvHzA4RpEkfP2rUGbwMgKWWuCbd4NRddVR7ZLHdn9nwi5VmN0F8vS3OYQ82zPPUkakaklHFNT/g7R0H1x3szFVe1InNAi/6Af/499DpxHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QY0JA2eP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QY0JA2eP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AFAC2BBFC;
	Thu, 13 Jun 2024 12:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282451;
	bh=KM8DyskE1/pHSx1GiwG/Zs/EsbMy9lVgQiBkYwIzAtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QY0JA2eP4Z3gW1YY36BRwG1NvZAtPzNfa7V/HM01v+haDJOPBdUtXa1bBBQ5+1T+e
	 4D9LD4OyAVld4YrCwI4ueARA7Uqh27Kq7E7vgPnRf3CpClRw4XqPKegiqbEclsezdO
	 N74yLOJ4OjuAaorntmDIXr9aU+tnSxr1UXj/QDt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 280/402] null_blk: Fix the WARNING: modpost: missing MODULE_DESCRIPTION()
Date: Thu, 13 Jun 2024 13:33:57 +0200
Message-ID: <20240613113313.070843804@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/block/null_blk/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 1fe5d33a5798d..ec78d9ad3e9bc 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2053,4 +2053,5 @@ module_init(null_init);
 module_exit(null_exit);
 
 MODULE_AUTHOR("Jens Axboe <axboe@kernel.dk>");
+MODULE_DESCRIPTION("multi queue aware block test driver");
 MODULE_LICENSE("GPL");
-- 
2.43.0



