Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E03999440
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCFAC433CA;
	Tue, 25 Jul 2023 10:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282479;
	bh=W1rBc2J+WGXrSNgXXJbKcIJ7GeX5xt0sqhAXLvxEDsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UHTn8+NB5X6l7lXfjSQ/NAI6OkkfjrFyTSDhKTTKTDwLqzLsaUCLWYLLhs5KyTD3U
	 iRWHNCCPmTz84czWhHPyqHWj5tPzR1xiIe/Z/uLtW1y1bQrkryUabac+C6RukTZwjh
	 PsAhVHXHA6vKbtshgUYXAUzX6X8NHraX+MaIli1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 145/227] fbdev: imxfb: Removed unneeded release_mem_region
Date: Tue, 25 Jul 2023 12:45:12 +0200
Message-ID: <20230725104520.884963034@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 45fcc058a75bf5d65cf4c32da44a252fbe873cd4 ]

Remove unnecessary release_mem_region from the error path to prevent
mem region from being released twice, which could avoid resource leak
or other unexpected issues.

Fixes: b083c22d5114 ("video: fbdev: imxfb: Convert request_mem_region + ioremap to devm_ioremap_resource")
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/imxfb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/video/fbdev/imxfb.c b/drivers/video/fbdev/imxfb.c
index 5fbcb78a9caee..c8b1c73412d36 100644
--- a/drivers/video/fbdev/imxfb.c
+++ b/drivers/video/fbdev/imxfb.c
@@ -1043,7 +1043,6 @@ static int imxfb_probe(struct platform_device *pdev)
 failed_map:
 failed_ioremap:
 failed_getclock:
-	release_mem_region(res->start, resource_size(res));
 failed_of_parse:
 	kfree(info->pseudo_palette);
 failed_init:
-- 
2.39.2



