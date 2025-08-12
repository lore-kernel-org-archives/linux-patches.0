Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439BC2D4815;
	Tue, 12 Aug 2025 19:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026145; cv=none; b=kcSpQv3DdrbVOveLCRrIXrkewU/SeQe0IDoqlmRRA+pmpvW/JMGCw76vNMmuoanDUetNCYg/M8iYlThKg97/eo64VF8RdCNaRi6H9WaQFY2ovzlRq6hqPXvo6XdeMUlm2PWzl7mSLMDiKgu4xamPF5kCnprMC9iGOf4iiiqSMsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026145; c=relaxed/simple;
	bh=Zam2YGN8F4Mv7x/1RDnJj6hGdPTvAA/U67GM1vsfaTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h24pjIKhOkfj4vU0MXuFDbdIwbxptQmPgvuLK00slu+29dhq9+53awoKCPEe3zy+HjyhHpU5oyWB6s78g7htVi4Z0PXYJaFk4feSiQK+DcWWI6lmZit9t5c3oy70Se0fR0RiU3A9D376RMvvluWYCg+lBCcH0SQvkG1Kuc3lZJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dzvw4c41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dzvw4c41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A693FC4CEF1;
	Tue, 12 Aug 2025 19:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026145;
	bh=Zam2YGN8F4Mv7x/1RDnJj6hGdPTvAA/U67GM1vsfaTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dzvw4c41ZIwyF0iQYQfDRtgFCOUcExuoslW7ilkpjf5d7y6Mcnerl8FHYU4XmnP4z
	 Gijh3rBiyNdsd0J8BbhYeYf242MzoyKQhmdgExMseR4zI0GUJpW15QePnyXpGxgsmp
	 OfxbU/lYYHxcVGoRIG4iv4oVEDBnZuki99RBI934=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 249/480] dmaengine: mmp: Fix again Wvoid-pointer-to-enum-cast warning
Date: Tue, 12 Aug 2025 19:47:37 +0200
Message-ID: <20250812174407.723962601@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit a0b1589b62e2fcfb112996e0f4d5593bd2edf069 ]

This was fixed and re-introduced.  'type' is an enum, thus cast of
pointer on 64-bit compile test with W=1 causes:

  mmp_tdma.c:644:9: error: cast to smaller integer type 'enum mmp_tdma_type' from 'const void *' [-Werror,-Wvoid-pointer-to-enum-cast]

Fixes: a67ba97dfb30 ("dmaengine: Use device_get_match_data()")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250525-dma-fixes-v1-5-89d06dac9bcb@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mmp_tdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index c8dc504510f1..b7fb843c67a6 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -641,7 +641,7 @@ static int mmp_tdma_probe(struct platform_device *pdev)
 	int chan_num = TDMA_CHANNEL_NUM;
 	struct gen_pool *pool = NULL;
 
-	type = (enum mmp_tdma_type)device_get_match_data(&pdev->dev);
+	type = (kernel_ulong_t)device_get_match_data(&pdev->dev);
 
 	/* always have couple channels */
 	tdev = devm_kzalloc(&pdev->dev, sizeof(*tdev), GFP_KERNEL);
-- 
2.39.5



