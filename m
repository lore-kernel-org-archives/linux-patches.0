Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A631863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA20C433D2;
	Wed, 28 Dec 2022 15:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240290;
	bh=8olP9H4pT56wyTyOyYx3pjrjeg1CaYZ0m1+8tlLNcbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7BVAUr2sY3ffWlCsis40olrDBsuRyJzIuZH5V088qVf0ghB1HjqwKnL/NmIPny4/
	 AkKgKWhk9NGKzrapurOa5aoGz90y0GZQWSTyzFRHsmDYlp1d2J9oVG+EElqdfw4/1P
	 OyysZYmoXRhcsWtXqQ22BrRwJcj18S4bhRVKHoMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Sven Peter <sven@svenpeter.dev>,
	Hector Martin <marcan@marcan.st>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0093/1146] soc: apple: rtkit: Stop casting function pointer signatures
Date: Wed, 28 Dec 2022 15:27:12 +0100
Message-Id: <20221228144332.669323035@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sven Peter <sven@svenpeter.dev>

[ Upstream commit 5acf07ff25f0c1c44105e6b8ebf88c55a0a04d2f ]

Fixes: 9bd1d9a0d8bb ("soc: apple: Add RTKit IPC library")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/apple/rtkit.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/soc/apple/rtkit.c b/drivers/soc/apple/rtkit.c
index 031ec4aa06d5..8ec74d7539eb 100644
--- a/drivers/soc/apple/rtkit.c
+++ b/drivers/soc/apple/rtkit.c
@@ -926,8 +926,10 @@ int apple_rtkit_wake(struct apple_rtkit *rtk)
 }
 EXPORT_SYMBOL_GPL(apple_rtkit_wake);
 
-static void apple_rtkit_free(struct apple_rtkit *rtk)
+static void apple_rtkit_free(void *data)
 {
+	struct apple_rtkit *rtk = data;
+
 	mbox_free_channel(rtk->mbox_chan);
 	destroy_workqueue(rtk->wq);
 
@@ -950,8 +952,7 @@ struct apple_rtkit *devm_apple_rtkit_init(struct device *dev, void *cookie,
 	if (IS_ERR(rtk))
 		return rtk;
 
-	ret = devm_add_action_or_reset(dev, (void (*)(void *))apple_rtkit_free,
-				       rtk);
+	ret = devm_add_action_or_reset(dev, apple_rtkit_free, rtk);
 	if (ret)
 		return ERR_PTR(ret);
 
-- 
2.35.1



