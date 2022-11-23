Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2CC1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:51:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDACDC433D7;
	Wed, 23 Nov 2022 09:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197090;
	bh=xEJqRnBy+vMuDlF4QQzj61BtCttbpIzGhAGRwcpHp58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5rBj096FxlfHIq4U1HHQO2adFcM7yLIreqa6/wtMTv0yG5HObZqUUBxefl4Y+v0C
	 Je/aneYMFBbtYzigtm/FS+DWxSLik5KwUNTcErDq7O+0LqaPjlwyByqluw7rMmOIQQ
	 3VLFov2Q0WX1WBY6zdTKLlmVA4ghgOgNrav0uvLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitrii Tcvetkov <me@demsh.org>,
	Keith Busch <kbusch@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.0 195/314] dm-crypt: provide dma_alignment limit in io_hints
Date: Wed, 23 Nov 2022 09:50:40 +0100
Message-Id: <20221123084634.387022316@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

[ Upstream commit 86e4d3e8d1838ca88fb9267e669c36f6c8f7c6cd ]

This device mapper needs bio vectors to be sized and memory aligned to
the logical block size. Set the minimum required queue limit
accordingly.

Link: https://lore.kernel.org/linux-block/20221101001558.648ee024@xps.demsh.org/
Fixes: b1a000d3b8ec5 ("block: relax direct io memory alignment")
Reportred-by: Eric Biggers <ebiggers@kernel.org>
Reported-by: Dmitrii Tcvetkov <me@demsh.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Link: https://lore.kernel.org/r/20221110184501.2451620-3-kbusch@meta.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-crypt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 159c6806c19b..2653516bcdef 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3630,6 +3630,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	limits->physical_block_size =
 		max_t(unsigned, limits->physical_block_size, cc->sector_size);
 	limits->io_min = max_t(unsigned, limits->io_min, cc->sector_size);
+	limits->dma_alignment = limits->logical_block_size - 1;
 }
 
 static struct target_type crypt_target = {
-- 
2.35.1



