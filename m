Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023081C07DB;
	Tue, 15 Oct 2024 13:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997509; cv=none; b=Lg/D/rbXunZpKBHYZFMkzM76ww+4i98iT4zBeCvDnt+S//xNK2HCAwglnmaPVbDZf1PkoSSJ7uZa7iqHQMUNMtWpBKLitQy3lSqMQPZ2YbPJXjZ35rhFvRyG4nKyX0vxu9jG3VD9PcyGpsyf7G5vv+nM14gGLg1GgzsXP9FfeeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997509; c=relaxed/simple;
	bh=bd2sTVXubid6YmLEmQ3kLbY4FyboBGMYHHFJnfHWNTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2MIeDNTcjoWv05wPW4dUs7kZQm0ObbzchAZsDVeXCDMz1gAWDEksgE91Yw9PNr75dt60fLL2FecGFi6aLfhXDkk/eoBYy46zlbGPbmmNcprk8tYvDGNXDWg81sztH2Inm12neEhURJLh7fXqxx5tmKpzzErNG1spjjxc9YFld8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ge/57FLs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ge/57FLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0D6C4CEC6;
	Tue, 15 Oct 2024 13:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997508;
	bh=bd2sTVXubid6YmLEmQ3kLbY4FyboBGMYHHFJnfHWNTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ge/57FLsyya2Nq5pYaCI68y6BI3KXRLA17LJtikfF3Pfegits3oecWQjAe/Fc9uwF
	 xTu8BZX+LCnCglHaVu1eStILuDfqniOisMDt/+nqfnVcuXl3fJ6Scv9IZpm8T4aDlx
	 4g3hX5m7gJGHPPzNFU4/TyDffazlqp0bkkLOe+2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <frank.li@vivo.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/518] pinctrl: mvebu: Use devm_platform_get_and_ioremap_resource()
Date: Tue, 15 Oct 2024 14:41:16 +0200
Message-ID: <20241015123923.630724195@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



