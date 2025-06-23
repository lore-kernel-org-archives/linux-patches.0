Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6112222B7;
	Mon, 23 Jun 2025 21:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714091; cv=none; b=QXt9oiRen5xN49L5EW1ImGnEamHSwWCdU4OY+XtmEJ8cOlAfaqnpH9rSqSL+YUoWVq3E0xTEIpvJTAbb9f/p1s72GUC6hzEsbwgKwT544LSwzcEPBABXKgUY03/zi25KtCbckcnv6n+J83mSbLJqYkJfTCcrfjkX23vPZcjL9pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714091; c=relaxed/simple;
	bh=kP835cKUTtODxPz0n4s9/Et+CGzLDbx09heZY11FBXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hd12bKAoD9624mWFHbsJG7ntC0s1/s3/n95uW4hSHx2l7hp/NKFdGNoREbYNrLcbk54UVqZpyUeTWOuXQXBMf7oC/NwbEM1dTm3bSZ6XGzTBIvkhPcPmRfzDLSrfftJB8Bm5bYBljSJlpUW7zpVfXMSPKIckUUmBztlHBa3iUqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vau/BgeA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vau/BgeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3905DC4CEEA;
	Mon, 23 Jun 2025 21:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714091;
	bh=kP835cKUTtODxPz0n4s9/Et+CGzLDbx09heZY11FBXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vau/BgeAWsA9xAYkUDgh/m3sbftDXnt3unhr+OZOqAk5swwvqp/Mf5wSKIoT643XF
	 Ioib3l/kBnnhXi5J7wJZT/d4OhKuJEZdFz/M1G2RUGYt4FV7Ddu9z/3u0XQUELAzib
	 yt/inkMifRkJztkgTK08E3R8eeczF8hZdDUYo1mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 144/508] mfd: exynos-lpass: Avoid calling exynos_lpass_disable() twice in exynos_lpass_remove()
Date: Mon, 23 Jun 2025 15:03:09 +0200
Message-ID: <20250623130648.828804871@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 166cd21088cdd..5ee00f86e39c7 100644
--- a/drivers/mfd/exynos-lpass.c
+++ b/drivers/mfd/exynos-lpass.c
@@ -143,7 +143,6 @@ static int exynos_lpass_remove(struct platform_device *pdev)
 {
 	struct exynos_lpass *lpass = platform_get_drvdata(pdev);
 
-	exynos_lpass_disable(lpass);
 	pm_runtime_disable(&pdev->dev);
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		exynos_lpass_disable(lpass);
-- 
2.39.5



