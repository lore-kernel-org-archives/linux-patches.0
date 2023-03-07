Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEB0BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C738BC433AC;
	Tue,  7 Mar 2023 17:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210029;
	bh=6G+VIzKg1PHJBK14HvEtewtSzQQiPdhtE/ZCInoYTrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6Tov8XTmk6W9hi5pqj80KvdcZPv5mq86Ma262jbaS8W38jNcB50eHQK+FoZX6Yhn
	 AKLlHrk4mPeRw46dWVTLgqiMIsVx0ixv6dpDYgDY9FjBNkfGIvUDzLSIm11d91T/Fx
	 KsWEs3IhWkLB8og4s7OHMWpEFEUqTUghiYzMCqE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0409/1001] dm: improve shrinker debug names
Date: Tue,  7 Mar 2023 17:53:01 +0100
Message-Id: <20230307170039.076343049@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit c87791bcc455a91e51ca9800faaacc21c8d67785 ]

Commit e33c267ab70d ("mm: shrinkers: provide shrinkers with names")
chose some fairly bad names for DM's shrinkers.

Fixes: e33c267ab70d ("mm: shrinkers: provide shrinkers with names")
Signed-off-by : Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-bufio.c          | 2 +-
 drivers/md/dm-zoned-metadata.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index bb786c39545ec..19caaf684ee34 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1833,7 +1833,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	c->shrinker.scan_objects = dm_bufio_shrink_scan;
 	c->shrinker.seeks = 1;
 	c->shrinker.batch = 0;
-	r = register_shrinker(&c->shrinker, "md-%s:(%u:%u)", slab_name,
+	r = register_shrinker(&c->shrinker, "dm-bufio:(%u:%u)",
 			      MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
 	if (r)
 		goto bad;
diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 0278482fac94a..c795ea7da7917 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -2945,7 +2945,7 @@ int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
 	zmd->mblk_shrinker.seeks = DEFAULT_SEEKS;
 
 	/* Metadata cache shrinker */
-	ret = register_shrinker(&zmd->mblk_shrinker, "md-meta:(%u:%u)",
+	ret = register_shrinker(&zmd->mblk_shrinker, "dm-zoned-meta:(%u:%u)",
 				MAJOR(dev->bdev->bd_dev),
 				MINOR(dev->bdev->bd_dev));
 	if (ret) {
-- 
2.39.2



