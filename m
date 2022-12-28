Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECC01863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D3CC433D2;
	Wed, 28 Dec 2022 15:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239801;
	bh=HYvGODctq/5rLDUBG29sPClg+MD7Rh8TIZ7V34lHyK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GfO+U0811wlZKBiHORPpWv0Sd0vTR6h3sLoQ+bITq96xAsrLCeqmqNSz21oAcWkCp
	 bPcXCRtS0hD4dqiCbxjHypQubqnIi/wb3kkzujJXufW/DcmlQdzIUktpjw/YjkQx1U
	 kyU6/wZ+vtu2YyKZlZLgO5ZEYKMgw8OZOAwO+UMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Sven Peter <sven@svenpeter.dev>,
	Hector Martin <marcan@marcan.st>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0080/1073] soc: apple: sart: Stop casting function pointer signatures
Date: Wed, 28 Dec 2022 15:27:48 +0100
Message-Id: <20221228144330.240339289@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 422d0b860dc223b5dfc6d083697cae258bb5a4a1 ]

Fixes: b170143ae111 ("soc: apple: Add SART driver")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/apple/sart.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/apple/sart.c b/drivers/soc/apple/sart.c
index 83804b16ad03..afa111736899 100644
--- a/drivers/soc/apple/sart.c
+++ b/drivers/soc/apple/sart.c
@@ -164,6 +164,11 @@ static int apple_sart_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static void apple_sart_put_device(void *dev)
+{
+	put_device(dev);
+}
+
 struct apple_sart *devm_apple_sart_get(struct device *dev)
 {
 	struct device_node *sart_node;
@@ -187,7 +192,7 @@ struct apple_sart *devm_apple_sart_get(struct device *dev)
 		return ERR_PTR(-EPROBE_DEFER);
 	}
 
-	ret = devm_add_action_or_reset(dev, (void (*)(void *))put_device,
+	ret = devm_add_action_or_reset(dev, apple_sart_put_device,
 				       &sart_pdev->dev);
 	if (ret)
 		return ERR_PTR(ret);
-- 
2.35.1



