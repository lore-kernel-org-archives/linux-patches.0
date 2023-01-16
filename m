Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAE06FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D920BC433F0;
	Mon, 16 Jan 2023 17:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888588;
	bh=NgJxwGbS2yK8Y0hMQc7RM8+8aTJJwYQOnIg/mzf4O0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yipO0tKnvx1wtak6jsl5N1CPdsFz6YbGt4rDMjcPtY63AAobI9i8pCcLMVcrvs531
	 DU8VXxyWNCWATGJi2f3JjYolQFxcDlhGxZQD8WKYyj2FeeE8MrJsu+SH14EuN8aFeO
	 RtPC/i9K1mfe7y/yQGRJN/cJpfWXV0PvzFAs08Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Qilong <zhangqilong3@huawei.com>,
	Dylan Yudaken <dylany@fb.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sha Zhengju <handai.szj@taobao.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 063/338] eventfd: change int to __u64 in eventfd_signal() ifndef CONFIG_EVENTFD
Date: Mon, 16 Jan 2023 16:48:56 +0100
Message-Id: <20230116154823.584024126@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit fd4e60bf0ef8eb9edcfa12dda39e8b6ee9060492 ]

Commit ee62c6b2dc93 ("eventfd: change int to __u64 in eventfd_signal()")
forgot to change int to __u64 in the CONFIG_EVENTFD=n stub function.

Link: https://lkml.kernel.org/r/20221124140154.104680-1-zhangqilong3@huawei.com
Fixes: ee62c6b2dc93 ("eventfd: change int to __u64 in eventfd_signal()")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Cc: Dylan Yudaken <dylany@fb.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Sha Zhengju <handai.szj@taobao.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/eventfd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 60b2985e8a18..e05629a35bba 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -57,7 +57,7 @@ static inline struct eventfd_ctx *eventfd_ctx_fdget(int fd)
 	return ERR_PTR(-ENOSYS);
 }
 
-static inline int eventfd_signal(struct eventfd_ctx *ctx, int n)
+static inline int eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 {
 	return -ENOSYS;
 }
-- 
2.35.1



