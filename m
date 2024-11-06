Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3991D5AD7;
	Wed,  6 Nov 2024 12:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895074; cv=none; b=YY04nJTB3SjnZwYiI5XPVJ5R1yHfs754Bt68dqcCwcFqDulpEdBVr5BBlLCTewj3XJHhOplRWeuB6QCjhIysaPfrWzeJ+67R7MMMeJMP+4CC/HkB1tHibEBokZ6XAe8hVZXW6tgUbZ9EevnwvxT2InN8chEofnMp60Hv0qkdP9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895074; c=relaxed/simple;
	bh=FV5oE3pqwXBcgKHZKy4NJw3Yns9bL1VwvTKyCaQcRks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5qypEgK3dRqNMnWvKWw8XX2wAMr5T0ucaVz7oaVXAxm5DkVxygpQHxSxOb+x9UZuE8dp2lzeVDkUsYt1MNUyI/fWbKJkWu1jlJ6cZXKHdbe8f5YkYNteOFB4kFykAYGTN7Y8wZA1ESZXRpV61ppWMp7TUlwJOz3WYbwsXhfbfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFjS/UYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFjS/UYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0402DC4CECD;
	Wed,  6 Nov 2024 12:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895074;
	bh=FV5oE3pqwXBcgKHZKy4NJw3Yns9bL1VwvTKyCaQcRks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFjS/UYL5CdhXn9hyTkyguDkn/HHic22xp8NrHNlLMd1DdYYH/EUMnUEZqD2Rp/BD
	 I1ZZ3BoSoWX8rGy0xzDQeBxSPkH8FxTGOtOd7VfszxKbytw1BdJUBtwVaeqYaJB04q
	 w3E+7Mq2niK48OfJjKbExS4ArGLjyOwKViyNhVHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 089/350] pinctrl: mvebu: Use devm_platform_get_and_ioremap_resource()
Date: Wed,  6 Nov 2024 13:00:17 +0100
Message-ID: <20241106120323.098217407@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 8472f61f2bbe7..2c5032d0def52 100644
--- a/drivers/pinctrl/mvebu/pinctrl-dove.c
+++ b/drivers/pinctrl/mvebu/pinctrl-dove.c
@@ -788,8 +788,7 @@ static int dove_pinctrl_probe(struct platform_device *pdev)
 	}
 	clk_prepare_enable(clk);
 
-	mpp_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base = devm_ioremap_resource(&pdev->dev, mpp_res);
+	base = devm_platform_get_and_ioremap_resource(pdev, 0, &mpp_res);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-- 
2.43.0



