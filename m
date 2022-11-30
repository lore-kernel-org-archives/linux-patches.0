Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2510779C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4BCC433D6;
	Wed, 30 Nov 2022 18:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834471;
	bh=T2hPKsWNW7abcrcjLBMijRjZLL8m3qgeJM8HhFt9LdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYuh+OFbfdznMVf/FTJYzJ3X9JG+ejvdwf/mZAMsqkeW0COmPD+afDBRnlOMTi1aj
	 GIOQ6wgNDRCfGQKtsBOr16rIrUUFsa7mXCyVC3XK5nFdFw/8ufjQvrlrWt1ZW7uGci
	 UQUr4ua9WiViQ/1pX/aykCRk2/HVbQz+KUeXyrCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 258/289] dm-integrity: set dma_alignment limit in io_hints
Date: Wed, 30 Nov 2022 19:24:03 +0100
Message-Id: <20221130180549.952398087@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 29aa778bb66795e6a78b1c99beadc83887827868 ]

This device mapper needs bio vectors to be sized and memory aligned to
the logical block size. Set the minimum required queue limit
accordingly.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Link: https://lore.kernel.org/r/20221110184501.2451620-5-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-integrity.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index aaf2472df6e5..e1e7b205573f 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3370,6 +3370,7 @@ static void dm_integrity_io_hints(struct dm_target *ti, struct queue_limits *lim
 		limits->logical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
 		limits->physical_block_size = ic->sectors_per_block << SECTOR_SHIFT;
 		blk_limits_io_min(limits, ic->sectors_per_block << SECTOR_SHIFT);
+		limits->dma_alignment = limits->logical_block_size - 1;
 	}
 }
 
-- 
2.35.1



