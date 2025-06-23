Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA3725394A;
	Mon, 23 Jun 2025 13:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685908; cv=none; b=MDtoFyCIRQWi8lwl03Q3GI9JIANDM82tp7p4+PRyCZpp0sSUpTvBpK2AnA6FNbaOeo/dFC45bP6GIA2O5PyW3JzZj4CEdWoTeAcAR5xKoxVS7IO9XpkCBPf86KCWViRKUhzxtOrmkRFxdn+Kj6EsZYr/CjAQnRyZ9g2orbztbSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685908; c=relaxed/simple;
	bh=D4qqEygardfpY6CCO34sKz6tRbWIEC1lh21H8u2INAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8ZyUjLg1W0DuSJfXA3fxbdWaxO/kJIAhrb19xAuTMwbYhMuJkuT9ehGHPcSsf4dxs3thgu9D4zOMYLkfoKQ2umGOxu+zQaWxF953VfQ9fQ/7pzXhnc3nrzJTqATBfsRDCsBWAHJvKzHsuz2/OOpB2gayQH1q+YQvAIgP+GS3K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymzNhyR+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymzNhyR+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA809C4CEEA;
	Mon, 23 Jun 2025 13:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685908;
	bh=D4qqEygardfpY6CCO34sKz6tRbWIEC1lh21H8u2INAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymzNhyR+XWAecxPc4uNddO9fgpQvX5a/wW7ttGRSZOaA/xJOswRxQ8kUCv5lEWtVT
	 SFHnrobaIGuDifIei5ea0Fykm081EAFPmQKNqJQ3EjJ7iYhZmuKAmA47veE7DJdpYG
	 GhyViYHnoIuK1g7tA4r1An7Nv2g+luVNSQxDTwFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/355] mfd: exynos-lpass: Avoid calling exynos_lpass_disable() twice in exynos_lpass_remove()
Date: Mon, 23 Jun 2025 15:04:40 +0200
Message-ID: <20250623130629.193677283@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b70b84556eeca5262d290e8619fe0af5b7664a52 ]

exynos_lpass_disable() is called twice in the remove function. Remove
one of these calls.

Fixes: 90f447170c6f ("mfd: exynos-lpass: Add runtime PM support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/74d69e8de10308c9855db6d54155a3de4b11abfd.1745247209.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/exynos-lpass.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/mfd/exynos-lpass.c b/drivers/mfd/exynos-lpass.c
index 99bd0e73c19c3..ffda3445d1c0f 100644
--- a/drivers/mfd/exynos-lpass.c
+++ b/drivers/mfd/exynos-lpass.c
@@ -144,7 +144,6 @@ static int exynos_lpass_remove(struct platform_device *pdev)
 {
 	struct exynos_lpass *lpass = platform_get_drvdata(pdev);
 
-	exynos_lpass_disable(lpass);
 	pm_runtime_disable(&pdev->dev);
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		exynos_lpass_disable(lpass);
-- 
2.39.5



