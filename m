Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4619611705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFC8C433C7;
	Mon, 11 Sep 2023 14:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443333;
	bh=c4cI8ZbK4t/EU8dwkUlZ3exNZqhFw9BkaXEicfIIUcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uUuX3heEwRnvwrBPKCZX0t+3PdaU1GUEhxrcSwy+Lnm3lMY0U8ZDlnuXVzcXxyK1b
	 Jwt30bDCepyXbyZ6QbS3FXYGJUN+LuBiSoaOzyoo6bS4gb/nN3gXa2gtxLa5SCN0Zl
	 s0g6b2+o3Fprw1IxmF/38yKCnHueibbC3VZK1mqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 341/737] md/md-bitmap: remove unnecessary local variable in backlog_store()
Date: Mon, 11 Sep 2023 15:43:20 +0200
Message-ID: <20230911134700.055116392@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit b4d129640f194ffc4cc64c3e97f98ae944c072e8 ]

Local variable is definied first in the beginning of backlog_store(),
there is no need to define it again.

Fixes: 8c13ab115b57 ("md/bitmap: don't set max_write_behind if there is no write mostly device")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20230706083727.608914-2-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index ea226a37b110a..4934d8f0cf11a 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2527,8 +2527,6 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 			mddev_destroy_serial_pool(mddev, NULL, false);
 	} else if (backlog && !mddev->serial_info_pool) {
 		/* serial_info_pool is needed since backlog is not zero */
-		struct md_rdev *rdev;
-
 		rdev_for_each(rdev, mddev)
 			mddev_create_serial_pool(mddev, rdev, false);
 	}
-- 
2.40.1



