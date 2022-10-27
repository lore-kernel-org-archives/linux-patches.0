Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7508486
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAAA0C433C1;
	Thu, 27 Oct 2022 17:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890038;
	bh=erg2YYYSisMjKMbBH9P2d3k543rpzbzGBVKhX/6nhcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wvzPtZ3E9vN+GLlucaErCv6tvHDOyrgTHnplZu7S/zz3G+/PzaTvgrvGBOJ+hzbeb
	 oJ7A79x1uY6vZFX+yb4sYI7KTuDAmnKN4UPwjPeyuYWCaCmgTS59SeRQ8bT7B1fD0B
	 NNY7ARAzuuB1hL6fzCn1h2q0dm6tdJAZf5xciTFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Genjian Zhang <zhanggenjian@kylinos.cn>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 63/94] dm: remove unnecessary assignment statement in alloc_dev()
Date: Thu, 27 Oct 2022 18:55:05 +0200
Message-Id: <20221027165059.705955683@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Genjian Zhang <zhanggenjian@kylinos.cn>

[ Upstream commit 99f4f5bcb975527508eb7a5e3e34bdb91d576746 ]

Fixes: 74fe6ba923949 ("dm: convert to blk_alloc_disk/blk_cleanup_disk")
Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 60549b65c799..b4a2cb5333fc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2065,7 +2065,6 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->minors = 1;
 	md->disk->flags |= GENHD_FL_NO_PART;
 	md->disk->fops = &dm_blk_dops;
-	md->disk->queue = md->queue;
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 
-- 
2.35.1



