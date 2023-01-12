Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F14B749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D29BC433D2;
	Thu, 12 Jan 2023 14:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532252;
	bh=9y31d/OYocyJz7kY47k0aDXhh5D5T9Qvxq6eb55x040=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5YHGvIaDgB8srDi8tcahUWCIIAFVNrKSm1JSbkCXeARt0nNLaoVAocdm7DUEsmVg
	 q+ewKyFQg8z0vBiGHcSQVmgqUqMLJhEC5JQbcnFSTVZ9VMs3TVBDKGjB60/JYmdzhp
	 3HVtX1YYG0VMM30hUuBcu32u7Grjm4zDx46MpBpQ=
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
Subject: [PATCH 5.10 099/783] eventfd: change int to __u64 in eventfd_signal() ifndef CONFIG_EVENTFD
Date: Thu, 12 Jan 2023 14:46:55 +0100
Message-Id: <20230112135528.793388284@linuxfoundation.org>
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
 include/linux/eventfd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -62,7 +62,7 @@ static inline struct eventfd_ctx *eventf
 	return ERR_PTR(-ENOSYS);
 }
 
-static inline int eventfd_signal(struct eventfd_ctx *ctx, int n)
+static inline int eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 {
 	return -ENOSYS;
 }


