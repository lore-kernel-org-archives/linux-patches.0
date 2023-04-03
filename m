Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A32E6FAA
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DB2C433EF;
	Mon,  3 Apr 2023 14:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533014;
	bh=mEBjERivfwzPAjwAhvtJsPGyYdvaT7idA8OjqIELXqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RbNY9FE3rrARUbOZnJkyt3HjX/cogwG/U64mSESHZxthxVaHfHMik5oCSQdfKtmQF
	 JgDNZlil+e+5ecgFUPB+kkYj9fmrrw9/bo1/OM/stbowAXZPLEkC5bA2ruKDPFFo+P
	 QTcXQrMbNN2A/5IkE1oLd9YueBlfyAD6NLRpLx9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 009/187] zonefs: Fix error message in zonefs_file_dio_append()
Date: Mon,  3 Apr 2023 16:07:34 +0200
Message-Id: <20230403140416.337871265@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 88b170088ad2c3e27086fe35769aa49f8a512564 ]

Since the expected write location in a sequential file is always at the
end of the file (append write), when an invalid write append location is
detected in zonefs_file_dio_append(), print the invalid written location
instead of the expected write location.

Fixes: a608da3bd730 ("zonefs: Detect append writes at invalid locations")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/zonefs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
index 738b0e28d74b5..c71cc0fcb3ec8 100644
--- a/fs/zonefs/file.c
+++ b/fs/zonefs/file.c
@@ -426,7 +426,7 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
 		if (bio->bi_iter.bi_sector != wpsector) {
 			zonefs_warn(inode->i_sb,
 				"Corrupted write pointer %llu for zone at %llu\n",
-				wpsector, z->z_sector);
+				bio->bi_iter.bi_sector, z->z_sector);
 			ret = -EIO;
 		}
 	}
-- 
2.39.2



