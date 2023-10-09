Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F53219463
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4BR8bzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24FEC433CC;
	Mon,  9 Oct 2023 13:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857028;
	bh=BRZpQ5VuwgyCKninMK0XinWM21JE3RdLuzRcqsXvkhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I4BR8bzZJZYOrnZ7C2Exem4sMhDWNWSH4qxrn9vqAltAbBOq7iOJdH0R/TIjYnb5S
	 2nZWfBxYftsmxUUo30zH6FlEA6nJnB0JUuXKoZY7LvZixzhZONRWxtxPgvJNmUY+JQ
	 Zb44sIZwltjgkVYi5rg562TQsmZWEL8ySJc10198=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Jia Zhu <zhujia.zj@bytedance.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 072/163] erofs: allow empty device tags in flatdev mode
Date: Mon,  9 Oct 2023 15:00:36 +0200
Message-ID: <20231009130126.040033730@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jingbo Xu <jefflexu@linux.alibaba.com>

[ Upstream commit f939aeea7ab7d96cd321e7ac107f5a070836b66f ]

Device tags aren't actually required in flatdev mode, thus fix mount
failure due to empty device tags in flatdev mode.

Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Fixes: 8b465fecc35a ("erofs: support flattened block device for multi-blob images")
Reviewed-by: Jia Zhu <zhujia.zj@bytedance.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230915082728.56588-1-jefflexu@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 566f68ddfa36e..31a103399412e 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -238,7 +238,7 @@ static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 		return PTR_ERR(ptr);
 	dis = ptr + erofs_blkoff(sb, *pos);
 
-	if (!dif->path) {
+	if (!sbi->devs->flatdev && !dif->path) {
 		if (!dis->tag[0]) {
 			erofs_err(sb, "empty device tag @ pos %llu", *pos);
 			return -EINVAL;
-- 
2.40.1



