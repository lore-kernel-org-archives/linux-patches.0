Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060736;
	b=J2+e46zx3k5VClxmrStcjPJ5UJIOVk9Aq/Bbl/6uEhHxOt/F0W/OZi26+Fd53PBUId53
	 5tyTj+AntjkYrCP4TkOu/AHJUpUc2cpA4ruPq1pRjPtZi5wnd/cKpaav5P0zZOVmq5PDK
	 ja18s1QCRs76Maa3Q5kCoHGaLZJB+1b9jXv9TWtJJFmRC/lVgmmlB1WPkoG9dq0hDCb7T
	 80IwLvCLWIyHlGTZkkOFg4vOPy74AsE4Xfj+SMpERiWHW/cx5eYph22YgCsAxfI7ahqU5
	 Dzu6mzEQdHfMhROrXDaL1twqto+Ig2x/j7Y2M28n2uJwWVFGnHnbWNEfmmW5oat2spw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L/7t2my/OnL9VNaBp559L1LjiwNltDQw8eozh24E9Kw=;
	b=iD4/ZfSUWoIRqSEmBV/1b3G9QsNlQCRqVUpx2Tgrc+nJoQePEds/siEV+WTde1PsAAlW
	 +3M2I7g/nSPvzAbnLAZVimwVuyvlwanaOGL/X8hda56kPyXBRWsShh0XNveSj3yu0xzbV
	 gq/9oWNkvUkvoLUsDm/hk/IYegG8kuZmzeZHGSaza++Ig3rpuCM3rVTC/Hlmo6UyvEpt9
	 5Hy8VXi5SD5gfVNuSiMY8DKZNivJRJzYRHBZhhFyhnCngaV+u6NaxEB+ceEDNrlNkkMvq
	 IX/z4/NyVGZqQsc14Kt5EVKl9kzXOi3/hY7v/9MzpudtX587Zeqfp5ekh2DI2BWy7bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oBZmpjE2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7D8606A320;
	Thu, 19 Nov 2026 03:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oBZmpjE2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BF31F000C4;
	Thu, 19 Nov 2026 03:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060736;
	bh=L/7t2my/OnL9VNaBp559L1LjiwNltDQw8eozh24E9Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oBZmpjE2+eNQSrIXmK52kxhDThMkinspWYy2gCj7xT+A+00xSGTQCRG3TiRIo2tuB
	 1vlOUwd/3OJ54nHlhAhCLlxFltqLwSPB1wnUr+dQc2FpbqTe5lmZ5qWodq1Dl1SRhL
	 IFcZS9mSjXZOrUXX04I5vUPCqWaH1pljXwfnggdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1306/1848] swim: dont call blk_queue_bounce_limit
Date: Wed, 18 Nov 2026 15:55:44 +0100
Message-ID: <20261118150014.158520369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 4c6e5bc8c05f7d9a8da6da8d1811a7577f3f404b ]

m68k doesn't support highmem, so don't bother enabling the block layer
bounce buffer code.  Just for safety throw in a depend on !HIGHMEM.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20210406061725.811389-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 994a778d9665 ("swim: Configure parameter memory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/Kconfig | 2 +-
 drivers/block/swim.c  | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 408c7428cca5e..d8fd44c6ba62e 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -66,7 +66,7 @@ config MAC_FLOPPY
 
 config BLK_DEV_SWIM
 	tristate "Support for SWIM Macintosh floppy"
-	depends on M68K && MAC
+	depends on M68K && MAC && !HIGHMEM
 	help
 	  You should select this option if you want floppy support
 	  and you don't have a II, IIfx, Q900, Q950 or AV series.
diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 2239ed5af368b..b10052eacce77 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -840,8 +840,6 @@ static int swim_floppy_init(struct swim_priv *swd)
 		}
 
 		swd->unit[drive].disk->queue = q;
-		blk_queue_bounce_limit(swd->unit[drive].disk->queue,
-				BLK_BOUNCE_HIGH);
 		swd->unit[drive].disk->queue->queuedata = &swd->unit[drive];
 		swd->unit[drive].swd = swd;
 	}
-- 
2.53.0



