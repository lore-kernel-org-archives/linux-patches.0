Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A55749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40263C433D2;
	Thu, 12 Jan 2023 14:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532243;
	bh=tCnS0SNyFNg54VFaR5gtUmxdFlKvY03hZ1UMaewY9UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bkVcqH2tz+v8T4cZIWBIlPC82gBCvK1K8R/XIFyZCDTG2ZznlzW9EEsHxwSN+b6WQ
	 R6BRmDsducriczeNeufx+MplNdDAuWnleyaTz3GxjS8KLugmO2n7oBU8+Zz0cFX91f
	 No8o1hMwdrPvOsIHOpDGHMxHSjlBjWTXApippjFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/783] fs: sysv: Fix sysv_nblocks() returns wrong value
Date: Thu, 12 Jan 2023 14:46:53 +0100
Message-Id: <20230112135528.691339503@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit e0c49bd2b4d3cd1751491eb2d940bce968ac65e9 ]

sysv_nblocks() returns 'blocks' rather than 'res', which only counting
the number of triple-indirect blocks and causing sysv_getattr() gets a
wrong result.

[AV: this is actually a sysv counterpart of minixfs fix -
0fcd426de9d0 "[PATCH] minix block usage counting fix" in
historical tree; mea culpa, should've thought to check
fs/sysv back then...]

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/sysv/itree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/sysv/itree.c b/fs/sysv/itree.c
index bcb67b0cabe7..31f66053e239 100644
--- a/fs/sysv/itree.c
+++ b/fs/sysv/itree.c
@@ -438,7 +438,7 @@ static unsigned sysv_nblocks(struct super_block *s, loff_t size)
 		res += blocks;
 		direct = 1;
 	}
-	return blocks;
+	return res;
 }
 
 int sysv_getattr(const struct path *path, struct kstat *stat,
-- 
2.35.1



