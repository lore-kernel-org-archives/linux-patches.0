Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740401B29F
	for <patches@lists.linux.dev>; Fri, 15 Sep 2023 21:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YAt8eqD7AwRW7noJ7ot53OuTQiWk3/Uzs5ZyXdvJRXo=; b=ChjtTsEwNBGrcoqmRLmGJI9MF/
	Znds+peolza0YOyDfbzK7sYjlaorMElTJeuVXXemAGZ/77XsGsWLy4LiwZ3aNSzf7NUgvVJJBGbA1
	hmCGMflxN19Oe4EI3C7aKcRcio6PaX5Na8PK1imIjJ8kOMelI0FTQZ7NT+1XpQNn+Vgw+fnPaFQte
	QnhQwpAvQ4HFE39VSr0ZaN5+ixCaC6SXpcaZFxK1+sKdZo2gZoZCYrf8yjGAxoQS9F3QaCqG3cV0Q
	6sPUZ/gg1WftlzkFMKrXlPvvm0+qh0R4kHfYP7ZAlWL+jp2OCGX2QSrXPUFhcQQXub2SKy5eQNaol
	SQVAqgWg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qhGQq-00BQnc-1h;
	Fri, 15 Sep 2023 21:32:56 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: hch@infradead.org,
	djwong@kernel.org,
	dchinner@redhat.com,
	kbusch@kernel.org,
	sagi@grimberg.me,
	axboe@fb.com
Cc: willy@infradead.org,
	brauner@kernel.org,
	hare@suse.de,
	ritesh.list@gmail.com,
	rgoldwyn@suse.com,
	jack@suse.cz,
	ziy@nvidia.com,
	ryan.roberts@arm.com,
	patches@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org,
	p.raghav@samsung.com,
	da.gomez@samsung.com,
	dan.helmick@samsung.com,
	mcgrof@kernel.org
Subject: [RFC v2 10/10] nvme: enable LBS support
Date: Fri, 15 Sep 2023 14:32:54 -0700
Message-Id: <20230915213254.2724586-11-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230915213254.2724586-1-mcgrof@kernel.org>
References: <20230915213254.2724586-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Now that the block device cache allows LBS, and we have buffered-io
support, and we support both buffer-heads and iomap aops on the
block device cache through the inode dynamically, enable support for
LBA formats > PAGE_SIZE.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/nvme/host/core.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index c1f9d8e3ea93..724d3c342344 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1894,9 +1894,6 @@ static bool nvme_lba_shift_supported(struct nvme_ns *ns)
 	if (ns->lba_shift <= PAGE_SHIFT)
 		return true;
 
-	if (IS_ENABLED(CONFIG_BUFFER_HEAD))
-		return false;
-
 	if (ns->lba_shift <= NVME_MAX_SHIFT_SUPPORTED)
 		return true;
 
-- 
2.39.2

