Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0BE2D46B3;
	Tue, 12 Aug 2025 18:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022493; cv=none; b=qPDPXeneJgh4HZttB36V5eK4om0U0lRw1BMdQPfF29QtdBYtEPweKAiTTUj07xFy1H1hJkinHuUnEUQncgMvc4ZweEkLJRwlau3Aa3KqFc8+G8UyPd8PRTMZ36RaUBG65UCCDyG+8oIWPjJ+uoG7CfZN4ax4P0np9fxQfWI9bUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022493; c=relaxed/simple;
	bh=o87JD++0ZCPEdE98A+EPLSL81I3OigOHwwfoZs59Q8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pezQvlJ75GsRmxJCE9/ZCwocdeOTACANOKXlxLnBYGVX2BSpNKSvyEproRREqu99jGCP2jfoYOUFh5x5L5wdtmOjhyVbAiEFBfv7KPYmzyv7LuFZtpKclRIugEjNvUbCdX1PTb1M3Nm226ucwx2sRC27QVstrU+ThBJdOTMecig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkAxOsFD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkAxOsFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC07C4CEF1;
	Tue, 12 Aug 2025 18:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022493;
	bh=o87JD++0ZCPEdE98A+EPLSL81I3OigOHwwfoZs59Q8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkAxOsFDYJMltVMxj73GxUvfSepBuEWvveuJXKKTiV1uj9hCGjRWWCQNw0GczXuEb
	 yiOsZo2KxruJ7WMDecYL0ByV7GSHDhRAgBBUyygUK42yv+84RFQwm3Icr/4Cmve9jb
	 CmjKRgk+WSf9dLUWgYsmns3fiRQzDDKj3O+dNg0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 170/369] dmaengine: mmp: Fix again Wvoid-pointer-to-enum-cast warning
Date: Tue, 12 Aug 2025 19:27:47 +0200
Message-ID: <20250812173021.159119808@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b76fe99e1151..f88792049be5 100644
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



