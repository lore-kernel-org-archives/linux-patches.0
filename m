Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E981FBE0;
	Mon, 11 Dec 2023 18:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzLqGfRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AF1C433C8;
	Mon, 11 Dec 2023 18:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319444;
	bh=wdbdA8W6ia6uNnpf2o6J2FPxs2bBaI9IWkc3JDurlCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzLqGfRT9RtcgQYxAJJUDydtRXEXXyKtpyyy+MUFEZrhPx2fRK/ByJVr7C9zOe8/5
	 BtYSrtM+9tnFCeYpAczXeA6DwXiqxu6oQcd9uxVnnkz2+eybYgndulNc13p+RrjnFu
	 2afaSenVUzYKoZpi3u4Fq2kqgM7fxOgUeETn2kiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/244] mm/damon/sysfs: eliminate potential uninitialized variable warning
Date: Mon, 11 Dec 2023 19:19:30 +0100
Message-ID: <20231211182049.246407681@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 85c2ceaafbd306814a3a4740bf4d95ac26a8b36a ]

The "err" variable is not initialized if damon_target_has_pid(ctx) is
false and sys_target->regions->nr is zero.

Link: https://lkml.kernel.org/r/739e6aaf-a634-4e33-98a8-16546379ec9f@moroto.mountain
Fixes: 0bcd216c4741 ("mm/damon/sysfs: update monitoring target regions for online input commit")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index faaef5098e264..b317f51dcc987 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1172,7 +1172,7 @@ static int damon_sysfs_update_target(struct damon_target *target,
 		struct damon_ctx *ctx,
 		struct damon_sysfs_target *sys_target)
 {
-	int err;
+	int err = 0;
 
 	if (damon_target_has_pid(ctx)) {
 		err = damon_sysfs_update_target_pid(target, sys_target->pid);
-- 
2.42.0



