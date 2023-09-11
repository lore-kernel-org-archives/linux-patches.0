Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9591170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD74BC433C7;
	Mon, 11 Sep 2023 14:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442591;
	bh=jNwsntOPTASt6w+7Sik8WYy75YVzkby2yOw/No3gDso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hQVn6IJFidZEnRE9L39Cbu/SaETACvppYjhIIytwXeJj/eHVsrNWr4IMGTtMQZW1j
	 fQSBoNIPkHPLRoakO28tdd3mqhbZt+xPSJJ2iDYF8I1cX/bnx0otXIL7pWeyCtcRv/
	 r5O84Tm/SVH6c5QmC/4ZwqLUJ15WbT0BsiJNx/7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Wang <wangzhu9@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 078/737] fbdev: goldfishfb: Do not check 0 for platform_get_irq()
Date: Mon, 11 Sep 2023 15:38:57 +0200
Message-ID: <20230911134652.691487067@linuxfoundation.org>
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

From: Zhu Wang <wangzhu9@huawei.com>

[ Upstream commit 0650d5098f8b6b232cd5ea0e15437fc38f7d63ba ]

Since platform_get_irq() never returned zero, so it need not to check
whether it returned zero, and we use the return error code of
platform_get_irq() to replace the current return error code.

Please refer to the commit a85a6c86c25b ("driver core: platform: Clarify
that IRQ 0 is invalid") to get that platform_get_irq() never returned
zero.

Signed-off-by: Zhu Wang <wangzhu9@huawei.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/goldfishfb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/goldfishfb.c b/drivers/video/fbdev/goldfishfb.c
index 6fa2108fd912d..e41c9fef4a3b6 100644
--- a/drivers/video/fbdev/goldfishfb.c
+++ b/drivers/video/fbdev/goldfishfb.c
@@ -203,8 +203,8 @@ static int goldfish_fb_probe(struct platform_device *pdev)
 	}
 
 	fb->irq = platform_get_irq(pdev, 0);
-	if (fb->irq <= 0) {
-		ret = -ENODEV;
+	if (fb->irq < 0) {
+		ret = fb->irq;
 		goto err_no_irq;
 	}
 
-- 
2.40.1



