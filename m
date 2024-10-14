Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6707C6E6;
	Mon, 14 Oct 2024 15:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918070; cv=none; b=Iew4TWkdxZ6ltEmmglSXXCKTl7dD2ij++8oD+KCDAQNCD1LUAdC8rYwVGS7cjvVqv+yQSOBvGsnl5R+fkAk0zFg5KvIBIL7yN7aTcXLf943899+I2E/DmscbIFZG8cR/UQhUiiMr07GAFteAYWvRd0XWD2FK+5+2ZirS3U1qK8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918070; c=relaxed/simple;
	bh=Osi6VB8yTlkzXLLygzAXlV/zQxNdIXGn9s+2n3ZGyxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7OO/LDxEzkBzrGGFcsrasuZLUDain1uCNzUTzINyX38J+fW9owWY6OXfYPTsKfshNEAImPlQeDFRTYoxCG1v8wQ5ZxTDG2uB66aYXHQepER1DZmRodMsoQ9VWNIIdJV3xmNG/P0Xa6LZM59kGshG8xD81MGQkimahXb30+QVVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgjnZWpE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgjnZWpE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5F7C4CEC3;
	Mon, 14 Oct 2024 15:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918069;
	bh=Osi6VB8yTlkzXLLygzAXlV/zQxNdIXGn9s+2n3ZGyxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgjnZWpEmtOCNIA7rqt0l35Co4PbjMRUyPjlp1DfzU0rA5TpVtIBQ4szxzBic5Zsg
	 ZrCrgjV/5D0567nlueMIlYn79waihklCM0k5BuPduBn44ZLHL2hhR7+nX66cK3YC9z
	 0zFVHLC8J4YTw2FHG6qEGxypfqduKsXgfUhB9B3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 213/798] pinctrl: mvebu: Use devm_platform_get_and_ioremap_resource()
Date: Mon, 14 Oct 2024 16:12:47 +0200
Message-ID: <20241014141226.300016656@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 2d357f25663ddfef47ffe26da21155302153d168 ]

Convert platform_get_resource(), devm_ioremap_resource() to a single
call to devm_platform_get_and_ioremap_resource(), as this is exactly
what this function does.

Signed-off-by: Yangtao Li <frank.li@vivo.com>
Link: https://lore.kernel.org/r/20230704124742.9596-2-frank.li@vivo.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: c25478419f6f ("pinctrl: mvebu: Fix devinit_dove_pinctrl_probe function")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mvebu/pinctrl-dove.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-dove.c b/drivers/pinctrl/mvebu/pinctrl-dove.c
index 545486d98532d..bd74daa9ed666 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -784,8 +784,7 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 	}
 	clk_prepare_enable(clk);
 
-	mpp_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_ioremap_resource(&pdev->dev, mpp_res);
+	base = devm_platform_get_and_ioremap_resource(pdev, 0, &mpp_res);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-- 
2.43.0



