Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C292F2343;
	Tue, 17 Jun 2025 15:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175789; cv=none; b=GdqfWKSuO0kssos/b4bDYEyStufi96XbCj+MAk3NBiUkQYHANQMYp2YKJSXhWBuvfspLQKI08g1huSm0z/yQGvcG1d3oqF3xDp0vH7586qzWmUuejhBOpeA1dIWnfqZNlwkPkSlgm78oyqj8vrdyxfJaUfoaB7NPlHUtiXLZkLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175789; c=relaxed/simple;
	bh=ZqohK1o5zI8Ir4Agq3p5i/vRwnwUjJ69DGXcXu43TmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9BSZr83s8AGH5yvmWmBadCLM7vBW0e0EI0S1e0+JiqsUP4yP2q8O+sqOxjMyN3y70B7J1Ctvg8DBnGd2MqQtPfR3FWkMZqw2VRegfqmhxq8yLBjg72euAxMvtiBsrqihR4GnAna4bAmreFdOvNo1NORUae+fZ5cu7/wQzqgnwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1uvcqK6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1uvcqK6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D57C4CEE3;
	Tue, 17 Jun 2025 15:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175789;
	bh=ZqohK1o5zI8Ir4Agq3p5i/vRwnwUjJ69DGXcXu43TmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1uvcqK6lSWUJ/jIuli32iLXEF6OQFPTF+TXVfhrBjcEa47AhurmqLL5TZbwrNSwH
	 yoqUGoQ8pg+rP3KrI10t05w1MVdoi4vaXjIoKHhQ12hiAUzZs9oikwhjqRgaRulptM
	 YvV3JDKDBgAAjF4ZL0CDjJjXUkEdTVwtpOMQoWwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 213/356] mfd: exynos-lpass: Avoid calling exynos_lpass_disable() twice in exynos_lpass_remove()
Date: Tue, 17 Jun 2025 17:25:28 +0200
Message-ID: <20250617152346.783877018@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1506d8d352b19..5e39d91b728fc 100644
--- a/drivers/mfd/exynos-lpass.c
+++ b/drivers/mfd/exynos-lpass.c
@@ -141,7 +141,6 @@ static int exynos_lpass_remove(struct platform_device *pdev)
 {
 	struct exynos_lpass *lpass = platform_get_drvdata(pdev);
 
-	exynos_lpass_disable(lpass);
 	pm_runtime_disable(&pdev->dev);
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		exynos_lpass_disable(lpass);
-- 
2.39.5



