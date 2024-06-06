Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972D01A1881;
	Thu,  6 Jun 2024 14:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683718; cv=none; b=B3i4QZkJR+43Mbxhz2celhp5ccB60O6y/rQu9csItFPbpkaUkC9urUSu1+cYp4hLNgwbM5xECsYo2SkB8PVoSJkPtqAwHJhT/sKBPMLWvng8+a9kjyk+x7TnncaReu8Fcpz67axkjZpmMjmEuCXYod00I7wTKrGpBW2ZLnHrAUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683718; c=relaxed/simple;
	bh=9m3N7kYPcco0AkmI97ufBy1oOWl4tgKpdlHP25xHosQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fn6Cmd7FGdeAxQRF2XetZQs5IjxTrM11A2yhJOv0RtxIZTGyCnRCKTAnDWJ+MZRjsZkP36CumPiI7YR3yU3BmdZceCe9EL2PiQJpu2yjSkQiZsN/jRClNmq9m9hgr5k7BGQRklsmOL8mf+CW1l1ND1BdwigeQgoJC7p1NdhWuVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvxxLumE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvxxLumE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1DAC2BD10;
	Thu,  6 Jun 2024 14:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683718;
	bh=9m3N7kYPcco0AkmI97ufBy1oOWl4tgKpdlHP25xHosQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvxxLumEpUowBj7BgVUI5jfwr2IviP3tAEdv3jjv2UPo6pw9pUSq+3PGstBY7HHBY
	 louzIQ9qdloSlc8PLsLPFEp6vuNdtIAsd5xOdGbhClSsl1fp6zFUepSMxl+3joqVJw
	 SkQgHA6ODrYbB/4eyBbeURlS1DutjbKMK7oZNnQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 616/744] null_blk: Fix the WARNING: modpost: missing MODULE_DESCRIPTION()
Date: Thu,  6 Jun 2024 16:04:48 +0200
Message-ID: <20240606131752.262626510@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cc4dcb951fd24..561706fc2cd8e 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2360,4 +2360,5 @@ module_init(null_init);
 module_exit(null_exit);
 
 MODULE_AUTHOR("Jens Axboe <axboe@kernel.dk>");
+MODULE_DESCRIPTION("multi queue aware block test driver");
 MODULE_LICENSE("GPL");
-- 
2.43.0



